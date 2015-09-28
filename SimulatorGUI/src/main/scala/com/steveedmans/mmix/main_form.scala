package com.steveedmans.mmix

import akka.actor.ActorSystem
import com.steveedmans.mmix.panels._
import scala.swing._
import scala.swing.BorderPanel.Position._
import scala.swing.event.WindowClosing

object main_form extends SimpleSwingApplication {
  val system = ActorSystem("MMixGui")
  def top = new MainFrame {
    title = "MMix Simulator"
    preferredSize = new Dimension(1200, 700)
    minimumSize = new Dimension(1200, 700)
    lazy val mainPanel = new BorderPanel {
      lazy val left = new RegisterPanel(system)
      layout(left) = West
      lazy val memory = new MemoryPanel(system)
      lazy val console = new ConsolePanel(system)
      lazy val state = new MainStatePanel(system)
      lazy val controls = new ControlsPanel(system)
      lazy val rightPanel = new BoxPanel(orientation = Orientation.Vertical) {
        contents += memory
        contents += console
        contents += state
        contents += controls
      }
      layout(rightPanel) = Center
    }
    contents = mainPanel
    listenTo(mainPanel)
    reactions += {
      case WindowClosing(_) => system.shutdown()
    }
  }
}
