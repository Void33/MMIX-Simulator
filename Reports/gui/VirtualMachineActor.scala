package com.steveedmans.mmix.actors

import java.net.{InetAddress, DatagramPacket, DatagramSocket}

import akka.actor.{Actor, ActorLogging}
import com.steveedmans.mmix.panels.MainStatePanel.RecordStatement
import com.steveedmans.mmix.panels.MemoryPanel.{RefreshTable, StartNewSetOfUpdates}
import com.steveedmans.mmix.panels.ProcessNextActor.Automate
import com.steveedmans.mmix.panels.{RegisterPanel, ConsolePanel, ControlsPanel, MemoryPanel, MainStatePanel}
import com.steveedmans.mmix.Utilities

object VirtualMachineActor {
  case class SendData(data : Any)
  case object ProcessNextStatement

  private object Udp_Client {
    val bufsize = 50
    val port = 4000

    val SMALL_INTEGER_EXT = 97
    val INTEGER_EXT = 98
    val SMALL_TUPLE_EXT = 104
    val SMALL_BIG_EXT = 110
    val ATOM_EXT = 100
    val STRING_EXT = 107
    val LIST_EXT = 108
    val NIL_EXT = 106

    val PROCESS_NEXT = Symbol("ProcessNext")

    def term_to_binary(term : Any) : Array[Byte] = {
      val data : List[Int] = 131 :: construct_term(term)
      data.map(i => i.toByte).toArray
    }

    def construct_term(term : Any) : List[Int] = term match {
      case b : Byte => SMALL_INTEGER_EXT :: b.toInt :: Nil
      case b : Int if (b >= -128) && (b < 256) => SMALL_INTEGER_EXT :: b :: Nil
      case i : Int => INTEGER_EXT :: int_to_bytes(4, i)
      case l : Long => SMALL_BIG_EXT :: 8 :: 0 :: long_to_bytes(l)
      case atom : Symbol => ATOM_EXT :: symbol_to_bytes(atom)
      case list : List[_] => LIST_EXT :: list_to_bytes(list)
      case tup : Product =>  SMALL_TUPLE_EXT :: tuple_to_bytes(tup)
      case str : String =>  STRING_EXT :: string_to_bytes(str)
    }

    def list_to_bytes(value : List[_]) : List[Int] = {
      val (data, size) = value.foldRight(List[Int](), 0){
        (value, results : (List[Int], Int)) => (construct_term(value) ::: results._1, results._2 + 1)
      }
      int_to_bytes(4, size) ::: data ::: List[Int](NIL_EXT)
    }

    def string_to_bytes(value : String) : List[Int] = {
      int_to_bytes(2, value.length) ::: value.toCharArray.map(c => c.toInt).toList
    }

    def tuple_to_bytes(tuple : Product) : List[Int] = {
      tuple.productArity :: tuple.productIterator.foldRight(List[Int]()) {
        (value, results : List[Int]) => construct_term(value) ::: results
      }
    }

    def symbol_to_bytes(atom : Symbol) : List[Int] = {
      val atomString = atom.toString()
      val size = int_to_bytes(2, atomString.length - 1)
      size ::: atomString.toList.drop(1).map(char => char.toInt)
    }

    def long_to_bytes(value : Long) : List[Int] = {
      Range(0, 8).foldLeft(List[Int](), value) {
        (accumulator, _) =>
          val (workingList, remainder) = accumulator
          val next_acc = (remainder % 256).toInt
          (next_acc :: workingList, remainder >>> 8)
      }._1.reverse
    }

    def int_to_bytes(length : Int, value : Int) : List[Int] = {
      Range(0, length).foldLeft(List[Int](), value) {
        (accumulator, _) =>
          val (workingList, remainder) = accumulator
          ((remainder % 256) :: workingList, remainder >>> 8)
      }._1
    }

    def binary_to_term(data : List[Byte]) : Tuple2[Any, List[Byte]] = {
      val version = data.head
      version match {
        case -125 => extract_term(data.tail)
        case _ => (Symbol("UNKNOWN"), List.empty)
      }
    }

    def extract_term(data : List[Byte]) : Tuple2[Any, List[Byte]] = {
      if (data.isEmpty)
        null
      else
        data.head match {
          case SMALL_INTEGER_EXT => getByte(data.tail)
          case INTEGER_EXT => getInteger(data.tail)
          case SMALL_BIG_EXT => getLong(data.tail)
          case SMALL_TUPLE_EXT => getTuple(data.tail)
          case ATOM_EXT => getAtom(data.tail)
          case LIST_EXT => getLargeList(data.tail)
          case STRING_EXT => getString(data.tail)
          case NIL_EXT => (List(), data.tail)
          case unknown =>
            println(s"Unknown Ext - $unknown")
            (data.head, Nil)
        }
    }

    def getByte(data : List[Byte]) = {
      (data.head : Int, data.tail)
    }

    def byte_to_int(data : List[Byte]) = {
      data.foldLeft(0)((acc, item) => {
        val unsigned_item = if (item < 0) 256 + item else item
        (acc << 8) + unsigned_item
      })
    }

    def getInteger(data: List[Byte]) = {
      (byte_to_int(data.take(4)), data.drop(4))
    }

    def getLong(data: List[Byte]) : Tuple2[Long, List[Byte]] = {
      val size = data.head
      val sign = data.tail.head
      val (bits_plus, rest) = data.splitAt(size+2)
      val bits = bits_plus.drop(2)
      (Utilities.hex2dec(bits.foldRight("")((item, acc) => {
        val item_hex = Utilities.byte2hex(item)
        acc + item_hex
      })).toLong, rest)
    }

    def getTuple(data : List[Byte]) = {
      val (items_as_list, remaining) = getList(1, data)
      items_as_list match {
        case a1 :: Nil => ((a1), remaining)
        case a1 :: a2 :: Nil => ((a1, a2), remaining)
        case a1 :: a2 :: a3 :: Nil => ((a1, a2, a3), remaining)
        case a1 :: a2 :: a3 :: a4 :: Nil => ((a1, a2, a3, a4), remaining)
        case _ => throw new IllegalArgumentException("Invalid length Tuple")
      }
    }

    def getString(data : List[Byte]) = {
      val len = byte_to_int(data.take(2))
      (data.drop(2).take(len).map(b => b.asInstanceOf[Char]).mkString, data.drop(len + 2))
    }

    def getLargeList(data : List[Byte]) = {
      val (accumulated_term, remaining) = getList(4, data)
      if (remaining.head == NIL_EXT)
        (accumulated_term, remaining.tail)
      else {
        println("SHOULD NOT GET HERE!")
        (accumulated_term, remaining)
      }
    }

    def getList(size : Int, data : List[Byte]) = {
      val (result, remainingData) = Range(0, byte_to_int(data.take(size))).foldLeft(List[Any](), data.drop(size)) {
        (accumulator, _) =>
          val(item, remainingData) = extract_term(accumulator._2)
          (item :: accumulator._1, remainingData)
      }
      (result.reverse, remainingData)
    }

    def getAtom(data : List[Byte]) = {
      val (result, remainingData) = getString(data)
      (Symbol(result), remainingData)
    }

    def receive_packet(socket: DatagramSocket): Any = {
      val in_buf = new Array[Byte](5000)
      var in_packet = new DatagramPacket(in_buf, in_buf.length)

      socket.receive(in_packet)
      val (term, remaining) = binary_to_term(in_buf.toList)
      term
    }
  }
}

class VirtualMachineActor extends Actor with ActorLogging {
  import VirtualMachineActor._

  val sock = new DatagramSocket()
  var buf = new Array[Byte](Udp_Client.bufsize)
  val in_buf = new Array[Byte](5000)
  var in_packet = new DatagramPacket(in_buf, in_buf.length)
  val local = InetAddress.getByName("localhost")

  def receive = {
    case ProcessNextStatement =>
      log.debug("PROCESS NEXT STATEMENT")
      val out = Udp_Client.term_to_binary(Udp_Client.PROCESS_NEXT)
      val out_packet = new DatagramPacket(out, out.length, local, Udp_Client.port)
      sock.send(out_packet)
    case SendData(data) =>
      log.debug(s"SEND DATA $data")
      val out = Udp_Client.term_to_binary(data)
      val out_packet = new DatagramPacket(out, out.length, local, Udp_Client.port)
      sock.send(out_packet)
      handle_response(Udp_Client.receive_packet(sock))
  }

  def handle_message(message : Any) = {
    message match {
      case ('display, txt : String) =>
        context.actorSelection("/user/consoleUpdateActor") ! ConsolePanel.DisplayText(txt)
      case 'halt =>
        context.actorSelection("/user/controlsUpdateActor") ! ControlsPanel.ProgramFinished
      case ('memory_change, changes : List[Tuple2[Any, Integer]]) =>
        changes.foreach {
          case (location: Integer, value) =>
            context.actorSelection("/user/memoryUpdateActor") ! MemoryPanel.UpdateAddress(location.toLong, value.byteValue)
          case (location: Long, value) =>
            context.actorSelection("/user/memoryUpdateActor") ! MemoryPanel.UpdateAddress(location, value.byteValue)
        }
        log.debug("Update memory locations")
      case msg =>
        log.debug(msg.toString)
    }
  }

  def convert_to_long(orignal_list : List[Tuple2[Any, Any]]) : List[Tuple2[Any, Long]] = {
    orignal_list.map {
      case (reg, value: Integer) =>
        (reg, value.longValue())
      case (reg, value: Long) =>
        (reg, value)
    }
  }

  def handle_response(response : Any) = {
    response match {
      case 'finished =>
        log.debug("FINISHED")
      case ('all_registers , registers : List[Tuple2[Any, Any]]) =>
        log.debug(s"ALL REGISTERS RETURNED SIZE = ${registers.size}")
        context.actorSelection("/user/registersUpdateActor") ! RegisterPanel.FullRegisterSet(convert_to_long(registers))
      case ('updates , (statement : String, registers : List[Tuple2[Any, Any]], messages : List[Any])) =>
        log.debug(s"REGISTERS UPDATES RETURNED SIZE = ${registers.size}")
        log.debug(s"THE NUMBER OF ADDITION MESSAGES ARE = ${messages.size}")
        log.debug(s"The command executed was $statement")
        context.actorSelection("/user/mainStateUpdateActor") ! RecordStatement(statement)
        context.actorSelection("/user/memoryUpdateActor") ! StartNewSetOfUpdates
        context.actorSelection("/user/registersUpdateActor") ! RegisterPanel.UpdatedRegisters(convert_to_long(registers))
        messages.foreach(handle_message)
        if (messages.count(_ == 'halt) == 0)
          context.actorSelection("/user/workerActor") ! Automate
        context.actorSelection("/user/memoryUpdateActor") ! RefreshTable
      case _ =>
        log.debug(s"UNKNOWN RESPONSE $response")
    }
  }
}
