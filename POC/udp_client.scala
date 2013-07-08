import java.net.{InetAddress, DatagramPacket, DatagramSocket}

class udp_client {
  val bufsize = 50
  val port = 4000

  val SMALL_INTEGER_EXT = 97
  val INTEGER_EXT = 98
  val SMALL_TUPLE_EXT = 104
  val ATOM_EXT = 100
  val STRING_EXT = 107
  val LIST_EXT = 108
  val NIL_EXT = 106

  def main() : Unit = {
    println("udp started")
    val sock = new DatagramSocket(port)
    val buf = new Array[Byte](bufsize)
    val packet = new DatagramPacket(buf, bufsize)

    while(true) {
      sock.receive(packet)
      println("received packet from: " + packet.getAddress())
      sock.send(packet)
      println(binary_to_term(packet.getData().toList))
    }
  }

  def client(N : Any) = {
    val sock = new DatagramSocket()
    var buf = new Array[Byte](bufsize)
    val in_buf = new Array[Byte](16)
    var in_packet = new DatagramPacket(in_buf, 16)

    val out = term_to_binary(N)

    val local = InetAddress.getByName("localhost")
    val out_packet = new DatagramPacket(out, out.length, local, port)
    sock.send(out_packet)
    sock.receive(in_packet)
    rep(in_packet)
  }

  def rep(data : DatagramPacket) = {
    for (c <- data.getData if (c != 0))
      println(c)
  }

  def term_to_binary(term : Any) : Array[Byte] = {
    val data : List[Int] = 131 :: construct_term(term)
    data.map(i => i.toByte).toArray
  }

// 131,108,0,0,0,3,107,0,2,97,97,107,0,2,98,98,107,0,2,99,99
// 131,108,0,0,0,3,107,0,2,97,97,107,0,2,98,98,107,0,2,99,99,106

  def construct_term(term : Any) : List[Int] = term match {
    case b : Byte => SMALL_INTEGER_EXT :: b.toInt :: Nil
    case b : Int if ((b >= -128) && (b < 256)) => SMALL_INTEGER_EXT :: b.toInt :: Nil
    case i : Int => INTEGER_EXT :: int_to_bytes(4, i)
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
    val atomString = atom.toString
    val size = int_to_bytes(2, atomString.length - 1)
    size ::: atomString.toList.drop(1).map(char => char.toInt)
  }

  def int_to_bytes(length : Int, value : Int) : List[Int] = {
    Range(0, length).foldLeft(List[Int](), value) {
      (accumulator, _) =>
        val (workingList, remainder) = accumulator
        ((remainder % 256) :: workingList, remainder >>> 8)
    }._1
  }

  def binary_to_term(data : List[Byte]) : Any = {
    val version = data.head
    version match {
      case -125 => extract_term(data.tail)._1
      case _ => ()
    }
  }

  def extract_term(data : List[Byte]) : Tuple2[Any, List[Byte]] = {
    if (data.isEmpty)
      null
    else
      data.head match {
        case SMALL_INTEGER_EXT => getByte(data.tail)
        case INTEGER_EXT => getInteger(data.tail)
        case SMALL_TUPLE_EXT => getTuple(data.tail)
        case ATOM_EXT => getAtom(data.tail)
        case LIST_EXT => getLargeList(data.tail)
        case STRING_EXT => getString(data.tail)
        case _ => (data.head, Nil)
      }
  }

  def getByte(data : List[Byte]) = {
    (data.head : Int, data.tail)
  }

  def byte_to_int(data : List[Byte]) = {
    data.foldLeft(0)((acc, item) => (acc << 8) + item)
  }

  def getInteger(data: List[Byte]) = {
    (byte_to_int(data.take(4)), data.drop(4))
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
    getList(4, data)
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
}
