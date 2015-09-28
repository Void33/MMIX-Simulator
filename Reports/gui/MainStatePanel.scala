package com.steveedmans.mmix.panels

import java.awt.Color

import akka.actor.{ActorLogging, Actor, Props, ActorSystem}
import com.steveedmans.mmix.panels.MainStatePanel.{UpdateMainStateRegisters, ResetMainState, RecordStatement}
import com.steveedmans.mmix.{GuiEvent, GUIProgressEventHandler}

import scala.collection.BitSet
import scala.swing.BorderPanel.Position._
import scala.swing._
import scala.util.Random

object MainStatePanel {
  case class RecordStatement(statement : String) extends GuiEvent
  case class UpdateMainStateRegisters(registers : List[Tuple2[Any, Long]]) extends GuiEvent
  case object ResetMainState extends GuiEvent
}

class MainStatePanel (system: ActorSystem) extends BorderPanel with GUIProgressEventHandler {
  val worker = createWorkerActor()
  preferredSize = new Dimension(100, 200)
  minimumSize = new Dimension(100, 200)

  lazy val console = new TextArea {
    editable = false
    border = Swing.EmptyBorder(5)
  }

  lazy val divide_check = new CheckBox("Integer Divide Check")
  lazy val overflow = new CheckBox("Integer Overflow")
  lazy val fix_to_float = new CheckBox("Fix to Float Overflow")
  lazy val invalid = new CheckBox("Invalid Operation")
  lazy val floating_overflow = new CheckBox("Floating Overflow")
  lazy val underflow = new CheckBox("Floating Underflow")
  lazy val zero = new CheckBox("Division by Zero")
  lazy val Inexact = new CheckBox("Floating Inexact")

  lazy val arithmetic_flags = new GridPanel(4, 2) {
    contents += divide_check
    contents += floating_overflow
    contents += overflow
    contents += underflow
    contents += fix_to_float
    contents += zero
    contents += invalid
    contents += Inexact
  }

  val scroller = new ScrollPane(console)

  var statements = List.empty[String]

  layout(scroller) = Center
  layout(arithmetic_flags) = East

  override def handleGuiProgressEvent(event: GuiEvent): Unit = {
    event match {
      case RecordStatement(statement) =>
        statements = statement.toUpperCase :: statements.take(299)
        console.text = statements.mkString("\n")
      case ResetMainState =>
        console.text = ""
        statements = List.empty[String]
      case UpdateMainStateRegisters(registers) =>
        update_state(registers)
      case msg =>
        println(s"MAIN STATE PANEL EVENT HANDLER HAS RECEIVED A MESSAGE $msg")
    }
  }

  def update_state(registers : List[Tuple2[Any, Long]]) = {
    registers.foreach {
      case ('rA, value) => update_arithmetic_state(value)
      case _ => //Ignore
    }
  }

  def update_arithmetic_state(value : Long) = {
    Range(0,8).foldLeft(value){(acc, indx) =>
      indx match {
        case 0 => Inexact.selected = ((acc % 2) == 1)
        case 1 => zero.selected = ((acc % 2) == 1)
        case 2 => underflow.selected = ((acc % 2) == 1)
        case 3 => floating_overflow.selected = ((acc % 2) == 1)
        case 4 => invalid.selected = ((acc % 2) == 1)
        case 5 => fix_to_float.selected = ((acc % 2) == 1)
        case 6 => overflow.selected = ((acc % 2) == 1)
        case 7 => divide_check.selected = ((acc % 2) == 1)
      }
      acc / 2
    }
  }

  def createWorkerActor() = {
    val guiUpdateActor = system.actorOf(
      Props(new MainStatePanelUpdateActor(this)), name = "mainStateUpdateActor")
  }

  class MainStatePanelUpdateActor(handler: GUIProgressEventHandler) extends Actor with ActorLogging {
    def receive = {
      case msg : GuiEvent => handler.handleGuiProgressEvent(msg)
      case msg =>
        log.debug(s"MAIN STATE PANEL HAS RECEIVED A MESSAGE $msg")
    }
  }
}
