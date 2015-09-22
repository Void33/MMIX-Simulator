package com.steveedmans.mmix.panels

import java.awt.Color
import java.util.Date

import com.steveedmans.mmix.panels.MainStatePanel.UpdateMainStateRegisters

import scala.collection.mutable.Map
import akka.actor.{ActorLogging, ActorSystem, Actor, Props}
import com.steveedmans.mmix.{Utilities, GuiEvent, GUIProgressEventHandler}

import scala.swing._

object RegisterPanel {
  case class FullRegisterSet(registers : List[(Any, Long)]) extends GuiEvent
  case class UpdatedRegisters(registers : List[(Any, Long)]) extends GuiEvent

  def createRegister(key : Any, value : Long, modified : Date) : Register = {
    (key, value) match {
      case (sym : Symbol, value : Long) => Register(SystemRegister(sym), value, modified)
      case (reg : Int, value : Long) => Register(UserRegister(reg), value, modified)
    }
  }

  sealed trait RegisterType {
    def key : String
  }

  case class SystemRegister(name : Symbol) extends RegisterType {
    def key : String = name.name
  }
  case class UserRegister(value : Long) extends RegisterType {
    def key : String = Utilities.byte2hex(value.toByte).toUpperCase
  }

  case class Register(registerType : RegisterType, var value : Long, var modifiedDate : Date) {
    def key : String = {
      registerType.key
    }

    def getValue : String = {
      Utilities.long2hex(value)
    }
  }
}

class RegisterPanel(system: ActorSystem) extends ScrollPane with GUIProgressEventHandler {
  import RegisterPanel._
  val worker = createWorkerActor()

  lazy val panel = new BoxPanel(orientation = Orientation.Vertical)
  var panel_content = createTable()
  panel.contents ++= panel_content
  viewportView = panel
  preferredSize = new Dimension(240, 10)
  var data : scala.collection.mutable.Map[String, Register] = Map.empty
  var data_keys : Array[Register] = _

  def createTable() : List[Component] = {
    val table = new Table(290, 2) {
      rowHeight = 20
      showGrid = true
      gridColor = new Color(150, 150, 150)

      override def rendererComponent(isSelected: Boolean, hasFocus : Boolean, row : Int, column: Int) : Component = {
        val last_modified = data_keys match {
          case dk if dk != null => if (data_keys.size > 0) data_keys(0).modifiedDate else new Date()
          case _ => new Date()
        }
        new Label {
          text = (row, column) match {
            case (0, 0) => "Reg"
            case (0, 1) => "Val"
            case (row : Int, 0) if row <= data.size =>
              data_keys(row - 1).key
            case (row : Int, 1) if row <= data.size =>
              data_keys(row -1).getValue.toUpperCase
            case _ => ""
          }
          xAlignment = Alignment.Center
          background = (row, data.size) match {
            case (r, s) if (r > 0) && (s > 0) && (r <= s) => if (data_keys(row - 1).modifiedDate == last_modified) Color.green else Color.cyan
            case _ => Color.cyan
          }
          opaque = (hasFocus, isSelected, data.size) match {
            case (true, _, _) => true
            case (_, true, _) => true
            case (_, _, s) if (row > 0) && (s > 0) && (row <= s) => data_keys(row - 1).modifiedDate == last_modified
            case _ => false
          }
        }
      }
    }
    val model = table.peer.getColumnModel
    val col0 = model.getColumn(0)
    col0.setPreferredWidth(60)
    col0.setHeaderValue("Reg")
    val col1 = model.getColumn(1)
    col1.setPreferredWidth(160)
    col1.setHeaderValue("Val")
    List(table)
  }

  def createWorkerActor() = {
    system.actorOf(Props(new RegistersUpdateActor(this)), name = "registersUpdateActor")
  }

  override def handleGuiProgressEvent(event: GuiEvent): Unit = {
    event match {
      case FullRegisterSet(registers) =>
        set_registers(registers)
      case UpdatedRegisters(registers) =>
        update_registers(registers)
      case _ =>
        println("Handle Registers Gui Event")
    }
  }

  def split_registers(registers: List[Tuple2[Any, Long]]) = {
    registers.partition(kvp => {
      kvp match {
        case ('rA, _) => false
        case _         => true
      }
    })
  }

  def set_registers(registers: List[Tuple2[Any, Long]]) = {
    val (user_regs, main_state_regs) = split_registers(registers)
    update_main_state(main_state_regs)
    val regs = convertToListOfRegisters(user_regs)
    data_keys = regs.sortWith(sort_register).toArray
    data = scala.collection.mutable.Map() ++ regs.map({ rr => (rr.key, rr) }).toMap
    panel.revalidate()
    panel.repaint()
  }
  
  def update_registers(regs : List[Tuple2[Any, Long]]) = {
    val today = new java.util.Date()
    val (user_regs, main_state_regs) = split_registers(regs)
    update_main_state(main_state_regs)
    convertToListOfRegisters(user_regs).foreach(reg => {
      val ev = data(reg.key)
      val nv = ev.copy(modifiedDate = today, value = reg.value)
      data(reg.key) = nv
    })
    data_keys = data.map(_._2).toList.sortWith(sort_register).toArray
    panel.revalidate()
    panel.repaint()
  }

  def update_main_state(ms_registers : List[Tuple2[Any, Long]]) = {
    system.actorSelection("/user/mainStateUpdateActor") ! UpdateMainStateRegisters(ms_registers)
  }

  def convertToListOfRegisters(registers : List[(Any, Long)]) : List[Register] = {
    val today = new java.util.Date()
    registers map { case (k, v) =>
      RegisterPanel.createRegister(k, v, today)
    }
  }

  def sort_register(r1: Register, r2: Register) = {
    (r2.registerType, r1.registerType) match {
      case (sr : SystemRegister, _ : UserRegister) if sr.key == "pc" => false
      case (_ : SystemRegister, _ : UserRegister) => true
      case (_ : UserRegister, sr : SystemRegister) if sr.key == "pc" => true
      case (_ : UserRegister, _ : SystemRegister) => false
      case (v1 : SystemRegister, v2 : SystemRegister) =>
        v1.name.name.compareTo(v2.name.name) > 0
      case (v1 : UserRegister, v2 : UserRegister) =>
        val v1T = Utilities.byte2hex(v1.value.toByte).toUpperCase
        val v2T = Utilities.byte2hex(v2.value.toByte).toUpperCase
        v2T.compareTo(v1T) > 0
    }
  }

  def sort_updated_registers(r1: Register, r2: Register) = {
    r1.modifiedDate.compareTo(r2.modifiedDate) match {
      case diff if diff == 0 =>
        sort_register(r1, r2)
      case diff => diff > 0
    }
  }

  class RegistersUpdateActor(handler: GUIProgressEventHandler) extends Actor with ActorLogging {
    import RegisterPanel._
    def receive = {
      case frs : FullRegisterSet =>
        handler.handleGuiProgressEvent(frs)
      case ur : UpdatedRegisters =>
        handler.handleGuiProgressEvent(ur)
      case msg =>
        log.info(s"WE HAVE A MESSAGE $msg")
    }
  }
}
