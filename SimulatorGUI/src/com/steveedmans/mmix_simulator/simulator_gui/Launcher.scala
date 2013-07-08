package com.steveedmans.mmix_simulator.simulator_gui

/**
 * This singleton will determine whether or not this application is running
 * on a Mac and if it is then it will make sure that the menus
 * are all Mac compliant.  The code is based on a Java example written by Itay Maman and found at
 * http://javadots.blogspot.co.uk/2010/09/making-your-swing-app-macosx-compliant.html
 * User: Steve Edmans
 */

object Launcher extends App {
  private def macSetup(appName : String) = {
    val os = System.getProperty("os.name").toLowerCase
    val isMac = os.startsWith("mac os x")
    if (isMac) {
//    if (System.getProperty("os name").toLowerCase.startsWith("mac os x")) {
      System.setProperty("apple.laf.useScreenMenuBar", "true")
      System.setProperty("com.apple.mrj.application.apple.menu.about.name", appName)
    }
  }

  override def main(args : Array[String]) = {
    macSetup("MMIX Simulator")
    MMIXSimulator.startup(args)
  }
}
