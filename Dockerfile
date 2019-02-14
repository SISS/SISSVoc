FROM tomcat:8-jre8
RUN mkdir /usr/local/tomcat/webapps/sissvoc

WORKDIR "/tmp"
RUN wget -O sissvoc.war https://github.com/SISS/SISSVoc/releases/download/sissvoc-3.6-rc-2/sissvoc.war  

WORKDIR "/usr/local/tomcat/webapps/sissvoc"
RUN unzip /tmp/sissvoc.war

