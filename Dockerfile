FROM tomcat:9.0-jdk8-openjdk

COPY webapps/sample.war /usr/local/tomcat/webapps/

EXPOSE 8080

CMD ["catalina.sh", "run"]
