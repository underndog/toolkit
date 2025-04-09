# Use an official OpenJDK image as a base (Kafka is a Java application)
FROM openjdk:8-jre-alpine

# Install dependencies (curl, bash, and Kafka tools)
RUN apk add --no-cache bash curl

# Install Kafka client tools
RUN curl -sSL https://archive.apache.org/dist/kafka/2.8.0/kafka_2.13-2.8.0.tgz -o kafka.tgz && \
    tar -xvzf kafka.tgz && \
    mv kafka_2.13-2.8.0 /opt/kafka && \
    rm kafka.tgz

# Set environment variables
ENV KAFKA_HOME=/opt/kafka
ENV PATH="${KAFKA_HOME}/bin:${PATH}"

# Copy the topic creation script into the container
COPY create-kafka-topic.sh /usr/local/bin/create-kafka-topic.sh
RUN chmod +x /usr/local/bin/create-kafka-topic.sh

# Set the entrypoint to run the script
ENTRYPOINT ["/usr/local/bin/create-kafka-topic.sh"]
