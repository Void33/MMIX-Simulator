name := "MMixGUI"

version := "1.0"

resolvers += "Typesafe Repositorty" at "http://repo.typesafe.com/typesafe/releases"

libraryDependencies ++= Seq(
  "org.scala-lang" % "scala-swing" % "2.10+",
  "com.typesafe.akka" %% "akka-actor" % "2.3.4"
)
