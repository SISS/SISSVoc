FROM tomcat:8-jre8
ENV SISSVOC_VERSION ${SISSVOC_VERSION:-3.6-rc-3}

RUN mkdir /usr/local/tomcat/webapps/sissvoc

WORKDIR "/tmp"
RUN wget -O sissvoc.war https://github.com/SISS/SISSVoc/releases/download/sissvoc-${SISSVOC_VERSION}/sissvoc.war  

WORKDIR "/usr/local/tomcat/webapps/sissvoc"
RUN unzip /tmp/sissvoc.war

