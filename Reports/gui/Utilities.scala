package com.steveedmans.mmix

abstract class GuiEvent

trait GUIProgressEventHandler {
  def handleGuiProgressEvent(event: GuiEvent)
}

object Utilities {

  def fromChar4(original : List[Byte]) : Int = {
    original.foldLeft(0){
      (a,b) =>
        val next_val = if (b < 0) 256 + b else b
        a * 256 + next_val
    }
  }

  def fromChar8(original : List[Byte]) : Long = {
    original.foldLeft(0 : Long){
      (a,b) =>
        val next_val : Long = if (b < 0) 256 + b else b
        val new_acc : Long = a * 256 + next_val
        new_acc
    }
  }

  def nextChar4(start : List[Byte]) : (Int, List[Byte]) = {
    val (next, rest) = start.splitAt(4)
    (fromChar4(next), rest)
  }

  def nextChar8(start : List[Byte]) : (Long, List[Byte]) = {
    val (next, rest) = start.splitAt(8)
    (fromChar8(next), rest)
  }

  def nextChar4Hex(start : List[Byte]) : (String, List[Byte]) = {
    val (next, rest) = start.splitAt(4)
    (bytes2hex(next), rest)
  }

// From https://gist.github.com/tmyymmt/3721117

  def hex2bytes(hex: String): List[Byte] = {
    if(hex.contains(" ")){
      hex.split(" ").map(Integer.parseInt(_, 16).toByte).toList
    } else if(hex.contains("-")){
      hex.split("-").map(Integer.parseInt(_, 16).toByte).toList
    } else {
      hex.sliding(2,2).toArray.map(Integer.parseInt(_, 16).toByte).toList
    }
  }

  def bytes2hex(bytes: List[Byte], sep: Option[String] = None): String = {
    sep match {
      case None =>  bytes.map("%02x".format(_)).mkString
      case _ =>  bytes.map("%02x".format(_)).mkString(sep.get)
    }
  }

  def byte2hex(byte: Byte) : String = {
    bytes2hex(List(byte))
  }

  def hex2dec(hex: String): BigInt = {
    hex.toLowerCase().toList.map(
      "0123456789abcdef".indexOf(_)).map(
        BigInt(_)).reduceLeft( _ * 16 + _)
  }

  def int2hex(num : Int) : String = {
    import scala.math._
    if (num == 0) {
      bytes2hex(List(0,0,0,0))
    } else {
      bytes2hex(Range(0, 4).foldLeft(List[Byte](), num) {
        (accumulator, _) =>
          val (workingList, remainder) = accumulator
          ((remainder % 256).toByte :: workingList, remainder >>> 8)
      }._1)
    }
  }

  def long2hex(num : Long) : String = {
    import scala.math._
    if (num == 0) {
      bytes2hex(List(0,0,0,0,0,0,0,0))
    } else {
      bytes2hex(Range(0, 8).foldLeft(List[Byte](), num) {
        (accumulator, _) =>
          val (workingList, remainder) = accumulator
          ((remainder % 256).toByte :: workingList, remainder >>> 8)
      }._1)
    }
  }
}
