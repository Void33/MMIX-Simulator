package com.steveedmans.mmix

import scala.io.Source

sealed trait MMixFile {
  def MemoryBlocks : Map[String, String]
  def Memory : List[(Long, List[Byte])]
  def Registers : List[(Any, Long)]
}

object MMixFile {

  def openFile(fileName : String) : MMixFile = {
    val file = readFile(fileName)
    val (numBlocks, rest) = Utilities.nextChar4(file)
    val bs = List.fill(numBlocks)(0)

    val (regs_data, regs_code) = bs.foldLeft((rest, List[(String, String)]())){
      (a, b) => {
        val (c, d) = a
        val (e, f, g) = readBlock(c)
        val h = (f, g) :: d
        (e, h)
      }
    }

    val (numRegs, rest_r) = Utilities.nextChar4(regs_data)

    val bsr = List.fill(numRegs)(0)

    val (remaining, regs) = bsr.foldLeft(rest_r, List[(Byte, Long)]()){
      (a, b) => {
        val (c, d) = a
        val (e, f, g) = readRegister(c)
        val h = (f, g) :: d
        (e, h)
      }
    }

    new MMixFileImpl(regs_code, regs)
  }

  private def readRegister(data: List[Byte]) : (List[Byte], Byte, Long) = {
    val reg = data.head
    val (value, remaining) = Utilities.nextChar8(data.tail)
    (remaining, reg, value)
  }

  private def readBlock(data : List[Byte]) : (List[Byte], String, String) = {
    val (address, s1) = Utilities.nextChar8Hex(data)
    val (size, s2)    = Utilities.nextChar4(s1)
    val (code_list, rest) = s2.splitAt(size)
    val code = Utilities.bytes2hex(code_list)
    (rest, address, code)
  }

  private def readFile(fileName : String) = {
    Source.fromFile(fileName).map(_.toByte).toList
  }

  private class MMixFileImpl(code : List[(String, String)], registers : List[(Byte, Long)]) extends MMixFile {
    override def toString = {
      s"MMIX File with Code = $code & Registers = $registers"
    }

    override def MemoryBlocks: Map[String, String] = {
      code.toMap[String, String]
    }

    override def Memory : List[(Long, List[Byte])] = {
      code map {
        case (address, memory) => BlockOfMemory(address, memory)
      }
    }

    def BlockOfMemory(address : String, memory : String) : (Long, List[Byte]) = {
      //val start_address = Integer.parseInt(address, 16)
      val start_address = Utilities.hex2dec(address).toLong
      val memory_list = Utilities.hex2bytes(memory)
      (start_address, memory_list)
    }

    override def Registers : List[(Any, Long)] = {
      registers
    }
  }
}
