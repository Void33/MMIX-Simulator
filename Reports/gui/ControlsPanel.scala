package com.steveedmans.mmix.panels

import akka.actor._
import com.steveedmans.mmix.actors.VirtualMachineActor
import com.steveedmans.mmix.panels.ConsolePanel.ClearPanel
import com.steveedmans.mmix.panels.MainStatePanel.ResetMainState
import com.steveedmans.mmix.{GUIProgressEventHandler, MMixFile, GuiEvent}

import scala.swing.event.ButtonClicked
import scala.swing.{Swing, Orientation, BoxPanel, Button, FileChooser}

object ControlsPanel {
  case class GuiProgressEvent(percentage: Int) extends GuiEvent
  object ProcessingFinished extends GuiEvent
  case object ProgramFinished extends GuiEvent
  case object ProgramReady extends GuiEvent
}

class ControlsPanel(system: ActorSystem) extends BoxPanel(orientation = Orientation.Horizontal) with GUIProgressEventHandler {
  import ControlsPanel._
  import ProcessNextActor._

  val worker = createActorSystemWithWorkerActor()

  lazy val resetSimulator = new Button {
    text = "Reset Simulator"
  }
  listenTo(resetSimulator)
  contents += resetSimulator
  lazy val loadProgram = new Button {text = "Load Program"}
  listenTo(loadProgram)
  contents += loadProgram
  lazy val resetProgram = new Button {text = "Reset Program"}
  listenTo(resetProgram)
  contents += resetProgram
  lazy val processNext = new Button {text = "Process Next"}
  listenTo(processNext)
  contents += processNext
  lazy val automation = new Button {text = "Start"}
  listenTo(automation)
  contents += automation

  reactions += {
    case m : ButtonClicked if m.source == resetSimulator => println("RESET SIMULATOR")
    case m : ButtonClicked if m.source == loadProgram => loadProgramFile()
    case m : ButtonClicked if m.source == resetProgram => resetProgramAction()
    case m : ButtonClicked if m.source == processNext => processNextAction()
    case m : ButtonClicked if m.source == automation => toggleAutomation()
    case m : ButtonClicked => println("A button has been pressed")
  }

  def resetProgramAction() = {
    worker ! Stop
  }

  def toggleAutomation() = {
    automation.text match {
      case "Start" => Swing.onEDT {
        automation.text = "Stop"
        worker ! StartAutomation
      }
      case _ => Swing.onEDT {
        automation.text = "Start"
        worker ! StopAutomation
      }
    }
  }

  def loadProgramFile() = {
    var mmixFile = new FileChooser()
    if (mmixFile.showOpenDialog(this) == FileChooser.Result.Approve) {
      val file = MMixFile.openFile(mmixFile.selectedFile.getAbsolutePath)
      system.actorSelection("/user/memoryUpdateActor") ! MemoryPanel.NewProgram(file)
      system.actorSelection("/user/mainStateUpdateActor") ! ResetMainState
      system.actorSelection("/user/consoleUpdateActor") ! ClearPanel
      worker ! LoadProgram(file)
    }

    println(s"Load Program Pressed")
  }

  def handleGuiProgressEvent(event: GuiEvent) {
    event match {
      case GuiProgressEvent(pct) => println(pct)
      case ProcessingFinished => Swing.onEDT{
        processNext.enabled = true
      }
      case FinishProcessing => Swing.onEDT {
        processNext.enabled = true
      }
      case ProgramFinished => Swing.onEDT {
        processNext.enabled = false
        automation.text = "Start"
        worker ! StopAutomation
      }
      case ProgramReady => Swing.onEDT {
        processNext.enabled = true
      }
    }
  }

  def processNextAction() = {
    worker ! ProcessNext
  }

  def createActorSystemWithWorkerActor():ActorRef = {
    val guiUpdateActor = system.actorOf(
      Props(new GUIUpdateActor(this)), name = "controlsUpdateActor")

    val vmActor = system.actorOf(Props[VirtualMachineActor], "vmActor")

    val workerActor = system.actorOf(
      Props(new WorkerActor(guiUpdateActor, vmActor)), name = "workerActor")

    workerActor
  }

  class GUIUpdateActor(val gui:GUIProgressEventHandler) extends Actor {
    def receive = {
      case event: GuiEvent => gui.handleGuiProgressEvent(event)
    }
  }
}

class WorkerActor(val guiUpdateActor: ActorRef, val vmActor : ActorRef) extends Actor with ActorLogging {
  import ProcessNextActor._
  import VirtualMachineActor._
  import AutomationState._
  import scala.concurrent.duration._
  import context.dispatcher

  var currentState = STOPPED

  def receive = {
    case ProcessNext =>
      log.info("Processing Next Statement")
      vmActor ! SendData(Symbol("process_next"))
    case LoadProgram(file) =>
      log.info(s"LOAD PROGRAM")
      vmActor ! SendData((Symbol("program"), file.Memory))
      vmActor ! SendData((Symbol("registers"), file.Registers))
      vmActor ! SendData(Symbol("get_all_registers"))
      guiUpdateActor ! ControlsPanel.ProgramReady
    case Stop =>
      log.info("Stopping the Virtual Machine")
      vmActor ! SendData(Symbol("stop"))
    case StartAutomation =>
      log.info("Start Automation")
      currentState = RUNNING
      log.info("Processing Next Statement")
      vmActor ! SendData(Symbol("process_next"))
    case StopAutomation =>
      log.info("Stop Automation")
      currentState = STOPPED
    case Automate =>
      currentState match {
        case RUNNING =>
          context.system.scheduler.scheduleOnce(250 millis, self, ProcessNext)
        case STOPPED =>
          log.info("We are not automating so we ignore this")
      }
    case msg =>
      log.info(s"We have received an unknown message $msg")
  }
}

object AutomationState extends Enumeration {
  type AutomationState = Value
  val RUNNING, STOPPED = Value
}

object ProcessNextActor {
  case object ProcessNext
  case class LoadProgram(program : MMixFile)
  case object Stop
  case object StartAutomation
  case object StopAutomation
  case object Automate
  case object FinishProcessing extends GuiEvent
}
