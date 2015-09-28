package com.steveedmans.mmix.panels

import akka.actor.{Actor, Props, ActorSystem}
import com.steveedmans.mmix.{MMixFile, GuiEvent, GUIProgressEventHandler}

import scala.collection.SortedMap
import scala.swing._
import com.steveedmans.mmix.Utilities._
import java.awt.Color

class HexString(val s : String) {
  def hex = java.lang.Long.parseLong(s, 16)
}

object MemoryPanel {
  val BLOCK_SIZE : Int = 4
  val td = Map.empty[String, String]

  case class NewProgram(file : MMixFile) extends GuiEvent
  case class UpdateAddress(address : Long, value : Byte) extends GuiEvent
  case object StartNewSetOfUpdates extends GuiEvent
  case object RefreshTable extends GuiEvent

  implicit def str2hex(str: String) : HexString = new HexString(str)
  // 16 hex digits for a memory address

  def mem_address(address : Long) : String = {
    "%016X".format(address)
  }

  def mem_contents(value : Int) : String = {
    "%02X".format(value.toByte)
  }
}

class MemoryPanel(system: ActorSystem) extends ScrollPane with GUIProgressEventHandler {
  import MemoryPanel._

  val worker = createWorkerActor()

  lazy val data = new BoxPanel(orientation = Orientation.Vertical)
  var memory : Map[String, String] = Map.empty
  var main_memory = SortedMap[Long, Int]()
  var updated_locations : List[Long] = List.empty
  var panel_content = getContent()
  data.contents ++= panel_content
  preferredSize = new Dimension(100, 200)
  minimumSize = new Dimension(100, 200)
  border = Swing.CompoundBorder(Swing.EmptyBorder(5), Swing.LineBorder(java.awt.Color.BLACK))
  viewportView = data

  def reset(memory : Map[String, String]) = {
    println(s"About to set the memory to $memory")
  }

  def extract_blocks(memory : Map[String, String]): List[SortedMap[Long, Int]] = {
    val blocks = get_blocks(main_memory, List())
    blocks
  }

  def getContent() : List[Component] = {
    val blocks = extract_blocks(memory).reverse
    val final_column = BLOCK_SIZE + 1
    val table = new Table(blocks.length, BLOCK_SIZE + 2) {
      rowHeight = 25
      autoResizeMode = Table.AutoResizeMode.Off
      showGrid = true
      gridColor = new Color(150, 150, 150)

      override def rendererComponent(isSelected: Boolean, hasFocus : Boolean, row : Int, column: Int) : Component = {
        val data_row = blocks(row)
        val block_start = data_row.head._1
        val address = block_start + column - 1
        new Label {
          text = column match {
            case 0 =>
              mem_address(block_start)
            case _ if column == final_column =>
              data_row.values.map(b => {
                if (b >= 32 && b <= 127)
                  b.toChar
                else
                  '.'
              }).mkString
            case _ if data_row.contains(block_start + column - 1) =>
              mem_contents(data_row(address))
            case _ => ""
          }
          xAlignment = Alignment.Center
          if (hasFocus) {
            opaque = true
            if ((column == final_column) || (column == 0)) {
              val addresses = block_start to block_start + 3
              background = if (addresses.exists(updated_locations.contains(_))) Color.GREEN else Color.cyan
            }
            else
              background = if (updated_locations.contains(address)) Color.GREEN else Color.cyan
          } else {
            if (isSelected) {
              if ((column == final_column) || (column == 0)) {
                val addresses = block_start to block_start + 3
                background = if (addresses.exists(updated_locations.contains(_))) Color.GREEN else Color.cyan
              }
              else
                background = if (updated_locations.contains(address)) Color.GREEN else Color.cyan
              opaque = true
            } else {
              background = Color.GREEN
              if ((column == final_column) || (column == 0)) {
                val addresses = block_start to block_start + 3
                opaque = addresses.exists(updated_locations.contains(_))
              }
              else
                opaque = updated_locations.contains(address)
            }
          }
        }
      }
    }
    val model = table.peer.getColumnModel
    model.getColumn(0).setPreferredWidth(140)
    for (counter <- 0 until BLOCK_SIZE) {
      model.getColumn(counter + 1).setPreferredWidth(20)
    }
    table.peer.getColumnModel.getColumn(final_column).setPreferredWidth(10 * BLOCK_SIZE)

    List(table)
  }

  def to_main_memory(blocks : Map[String, String]) : SortedMap[Long, Int] = {
    blocks.foldLeft(SortedMap[Long, Int]())((acc, block) => {
      block match {
        case (start_location, data) =>
          process_block(hex2dec(start_location).toLong, data, acc)
        case _ =>
          acc
      }
    })
  }

  def process_block(start_location : Long, data : String, old_map : SortedMap[Long, Int]) = {
    val as_int = hex2bytes(data)
    as_int.view.zipWithIndex.foldLeft(old_map)((acc, item) => {
      item match {
        case (value, index) =>
          val location = start_location + index
          acc + (location -> value)
        case _ =>
          acc
      }
    })
  }

  def get_blocks(memory : SortedMap[Long, Int], blocks : List[SortedMap[Long, Int]]) : List[SortedMap[Long, Int]] = {
    memory match {
      case _ if memory.size > 0 =>
        val (next_block, remaining) = get_block(memory)
        get_blocks(remaining, next_block :: blocks)
      case _ => blocks
    }
  }
  def get_block(memory : SortedMap[Long, Int]) = {
    val block_data = memory.take(BLOCK_SIZE)
    val block_start= block_data.head._1
    val data = block_data.filter {
      case (cell, value) =>
        (cell - block_start) < BLOCK_SIZE
    }
    (data, memory.drop(data.size))
  }

  def createWorkerActor() = {
    val guiUpdateActor = system.actorOf(
      Props(new MemoryUpdateActor(this)), name = "memoryUpdateActor")
  }

  override def handleGuiProgressEvent(event: GuiEvent): Unit = {
    event match {
      case NewProgram(file) =>
        main_memory = to_main_memory(file.MemoryBlocks)
        refreshTable()
      case UpdateAddress(location, value) =>
        main_memory += (location -> value)
        updated_locations = updated_locations.::(location)
      case StartNewSetOfUpdates =>
        updated_locations = List.empty
      case RefreshTable =>
        refreshTable()
    }
  }

  def refreshTable() {
    val contents = getContent()
    data.contents --= panel_content
    panel_content = contents
    data.contents ++= panel_content
    data.revalidate()
    data.repaint()
  }

  class MemoryUpdateActor(handler: GUIProgressEventHandler) extends Actor {
    def receive = {
      case msg : GuiEvent =>
        handler.handleGuiProgressEvent(msg)
    }
  }
}
