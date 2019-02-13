FROM tomcat:8-jre8-alpine
RUN mkdir /usr/local/tomcat/webapps/sissvoc

WORKDIR "/tmp"
RUN wget -O sissvoc.war https://github.com/SISS/SISSVoc/releases/download/sissvoc-3.6-rc-1/sissvoc-3.6-rc-1.war  

WORKDIR "/usr/local/tomcat/webapps/sissvoc"
RUN unzip /tmp/sissvoc.war

