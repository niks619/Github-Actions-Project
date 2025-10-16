# Use an official OpenJDK runtime as a parent image
FROM openjdk:8-jre-alpine

# Set environment variables for AppDynamics

ENV APPDYNAMICS_AGENT_ACCOUNT_NAME="account-name" \
    APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY="access-ky" \
    APPDYNAMICS_CONTROLLER_HOST_NAME="controller-name" \
    APPDYNAMICS_CONTROLLER_PORT="443" \
    APPDYNAMICS_CONTROLLER_SSL_ENABLED="true" \
    APPDYNAMICS_AGENT_APPLICATION_NAME="SampleApp-JAVA" \
    APPDYNAMICS_AGENT_TIER_NAME="SampleTier" \
    APPDYNAMICS_AGENT_NODE_NAME="SampleNode"

# Install bash and unzip
RUN apk update && apk add --no-cache bash unzip curl



# Set the working directory to /app
WORKDIR /app
# Download Agents and Unzip
RUN curl -L -o /tmp/AppServerAgent.zip "https://download-files.appdynamics.com/download-file/java-jdk8/25.6.0.37159/AppServerAgent-1.8-25.6.0.37159.zip?Expires=1755000440&Signature=TYrop-eypUVdzm6ewE4BooCA7eCgzGttDkeFyyc5n55k9y43cPkddrITNo0mi9BsYpz1WXQBOvo4JFSW13wiLWlewFxEa6iw7MYewVaznJIc10oXNgNXfHAJYtlD4tSC-xjaWRdH-DFgF3j4ur7QYxigCbVctWrG5HYj38i5~m-MhEv7mjQ5kta25t0UxrzGqFXIgc~2rVcgcydkXqaEWM8lybL2bn3rk8eQoEOdMkV5XlzF-4kt4LTbKNqWaYSXvlqkvFZ4hgkvT4qxZpTZUbOpbpXlJ13OzMF1KGnZOnT8OGdVkJSZMYH8OUqJ9IvQ-SYlMnPXJGc3xco~ry7ehA__&Key-Pair-Id=APKAI6PWCU7XQZAIYFCA" \
    && unzip /tmp/AppServerAgent.zip -d /opt/appdynamics \
    && rm /tmp/AppServerAgent.zip


# Copy the fat jar into the container at /app
COPY /target/docker-java-app-example.jar /app

# Make port 8080 available to the world outside this container
EXPOSE 8080

# Set JAVA_OPTS to include AppDynamics agent
ENV JAVA_OPTS="-javaagent:/opt/appdynamics/javaagent.jar"  
# Run the application
CMD ["sh", "-c", "java $JAVA_OPTS -jar docker-java-app-example.jar"]
