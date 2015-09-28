package com.steveedmans.mmix.panels

import akka.actor.{Props, ActorLogging, Actor, ActorSystem}
import com.steveedmans.mmix.panels.ConsolePanel.{ClearPanel, DisplayText}
import com.steveedmans.mmix.{GuiEvent, GUIProgressEventHandler}
import scala.swing.GridBagPanel.Fill
import scala.swing._
import scala.swing.BorderPanel.Position._

object ConsolePanel {
  case class DisplayText(txt : String) extends GuiEvent
  case object ClearPanel extends GuiEvent
}

class ConsolePanel(system: ActorSystem) extends BorderPanel with GUIProgressEventHandler {
  val worker = createWorkerActor()
  preferredSize = new Dimension(100, 200)
  minimumSize = new Dimension(100, 200)

  lazy val lbl = new Label {
    text = "Console Input "
    border = Swing.EmptyBorder(5,5,5,5)
  }

  lazy val user_input = new TextField

  lazy val labeled_field = new GridBagPanel {
    val c = new Constraints
    layout(lbl) = c
    c.weightx = 2.0
    c.fill = Fill.Horizontal
    layout(user_input) = c
  }

  lazy val console = new TextArea {
    editable = false
    border = Swing.CompoundBorder(Swing.EmptyBorder(5), Swing.LineBorder(java.awt.Color.BLACK))
  }

  val scroller = new ScrollPane(console)

  layout(labeled_field) = South
  layout(scroller) = Center

  override def handleGuiProgressEvent(event: GuiEvent): Unit = {
    event match {
      case DisplayText(txt) =>
        val new_text = console.text + txt
        console.text = new_text
      case ClearPanel =>
        console.text = ""
    }
  }

  def createWorkerActor() = {
    val guiUpdateActor = system.actorOf(
      Props(new ConsoleUpdateActor(this)), name = "consoleUpdateActor")
  }

  class ConsoleUpdateActor(handler: GUIProgressEventHandler) extends Actor with ActorLogging {
    def receive = {
      case msg : GuiEvent => handler.handleGuiProgressEvent(msg)
      case msg =>
        log.debug(s"WE HAVE A MESSAGE $msg")
    }
  }
}
