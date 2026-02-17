# Use official Tomcat 9 image with Java 8
FROM tomcat:9.0-jdk8-openjdk

# Copy a sample WAR file into the webapps directory for deployment
COPY webapps/sample.war /usr/local/tomcat/webapps/

# Expose the default Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
