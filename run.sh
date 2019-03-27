#!/bin/bash
export JAVA_HOME=/opt/jre-home
export M2_HOME=/opt/maven
export MAVEN_HOME=/opt/maven

export PATH=$PATH:$MAVEN_HOME/bin:$JAVA_HOME/bin:.
echo -e "Executing build from directory:" && pwd
mvn --version
java -version

echo -e "Running Tomee"
mvn tomee:run