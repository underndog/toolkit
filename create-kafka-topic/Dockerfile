# Use an official OpenJDK image as a base (Kafka is a Java application)
FROM openjdk:8-jre-alpine

# Install dependencies (curl, bash)
RUN apk add --no-cache bash curl

# Install Kafka client tools (now downloading Kafka 4.0.0)
RUN wget https://dlcdn.apache.org/kafka/4.0.0/kafka_2.13-4.0.0.tgz -O kafka.tgz && \
    tar -xvzf kafka.tgz && \
    mv kafka_2.13-4.0.0 /opt/kafka && \
    rm kafka.tgz

# Set environment variables
ENV KAFKA_HOME=/opt/kafka
ENV PATH="${KAFKA_HOME}/bin:${PATH}"

# Copy the topic creation script into the container
COPY create-kafka-topic.sh /usr/local/bin/create-kafka-topic.sh
RUN chmod +x /usr/local/bin/create-kafka-topic.sh

# Set the entrypoint to run the script
ENTRYPOINT ["/usr/local/bin/create-kafka-topic.sh"]
