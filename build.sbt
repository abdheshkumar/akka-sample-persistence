organization := "com.typesafe.akka.samples"
name := "akka-sample-persistence-scala"

scalaVersion := "2.12.8"
libraryDependencies ++= Seq(
  "com.typesafe.akka"          %% "akka-persistence" % "2.5.23",
  "org.iq80.leveldb"            % "leveldb"          % "0.7",
  "org.fusesource.leveldbjni"   % "leveldbjni-all"   % "1.8",
  "com.typesafe.akka" %% "akka-slf4j" % "2.5.23",
  "com.typesafe.akka" %% "akka-persistence-cassandra" % "0.99",
  "ch.qos.logback" % "logback-classic" % "1.2.3",
  "com.lihaoyi" %% "upickle" % "0.7.5"
)

licenses := Seq(("CC0", url("http://creativecommons.org/publicdomain/zero/1.0")))
