package org.stairwaybook.scells

import akka.actor.{Props, ActorRef, Actor, ActorSystem}
import swing._
import event.ButtonClicked

trait GUIProgressEventHandler {
  def handleGuiProgressEvent(event: GuiEvent)
}

abstract class GuiEvent

case class GuiProgressEvent(val percentage: Int) extends GuiEvent
object ProcessingFinished extends GuiEvent

object SwingAkkaGUI extends SimpleSwingApplication with GUIProgressEventHandler {

  lazy val processItButton = new Button {text = "Process it"}
  lazy val progressBar = new ProgressBar() {min = 0; max = 100}

  def top = new MainFrame {
    title = "Swing GUI with Akka actors"

    contents = new BoxPanel(Orientation.Horizontal) {
      contents += processItButton
      contents += progressBar
      contents += new CheckBox(text = "another GUI element")
    }

    val workerActor = createActorSystemWithWorkerActor()

    listenTo(processItButton)

    reactions += {
      case ButtonClicked(b) => {
        processItButton.enabled = false
        processItButton.text = "Processing"
        workerActor ! "Start"
      }
    }
  }

  def handleGuiProgressEvent(event: GuiEvent) {
    event match {
      case progress: GuiProgressEvent  => Swing.onEDT{
        progressBar.value = progress.percentage
      }
      case ProcessingFinished => Swing.onEDT{
        processItButton.text = "Process it"
        processItButton.enabled = true
      }
    }

  }

  def createActorSystemWithWorkerActor():ActorRef = {
    def system = ActorSystem("ActorSystem")

    val guiUpdateActor = system.actorOf(
      Props[GUIUpdateActor].withCreator(new GUIUpdateActor(this)), name = "guiUpdateActor")

    val workerActor = system.actorOf(
      Props[WorkerActor].withCreator(new WorkerActor(guiUpdateActor)), name = "workerActor")

    workerActor
  }

  class GUIUpdateActor(val gui:GUIProgressEventHandler) extends Actor {
    def receive = {
      case event: GuiEvent => gui.handleGuiProgressEvent(event)
    }
  }

  class WorkerActor(val guiUpdateActor: ActorRef) extends Actor {
    def receive = {
      case "Start" => {
        for (percentDone <- 0 to 100) {
            Thread.sleep(50)
            guiUpdateActor ! GuiProgressEvent(percentDone)
        }
      }
      guiUpdateActor ! ProcessingFinished
    }
  }
}