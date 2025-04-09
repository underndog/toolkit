#!/bin/bash

# Ensure that required environment variables are passed
if [ -z "$KAFKA_BROKERS" ] || [ -z "$KAFKA_TOPICS" ]; then
  echo "ERROR: Missing required environment variables. Make sure you provide KAFKA_BROKERS and KAFKA_TOPICS."
  exit 1
fi

# Check if SSL should be used
SECURITY_PROTOCOL_OPTION=""
if [ "$USE_SSL" == "true" ]; then
  SECURITY_PROTOCOL_OPTION="--security-protocol SSL"
  echo "Using SSL for Kafka connection..."
else
  echo "Not using SSL for Kafka connection..."
fi

# Iterate over each topic in the comma-separated KAFKA_TOPICS variable
IFS=',' read -r -a topics <<< "$KAFKA_TOPICS"

for topic in "${topics[@]}"; do
  # Parse topic configuration (assuming format: topic_name:partitions:replication_factor)
  IFS=':' read -r name partitions replication_factor <<< "$topic"

  if [ -z "$name" ] || [ -z "$partitions" ] || [ -z "$replication_factor" ]; then
    echo "ERROR: Invalid topic configuration for topic $topic. Expected format: topic_name:partitions:replication_factor."
    exit 1
  fi

  # Check if the topic already exists
  echo "Checking if Kafka topic $name exists..."
  topic_exists=$($KAFKA_HOME/bin/kafka-topics.sh --bootstrap-server "$KAFKA_BROKERS" --describe --topic "$name" $SECURITY_PROTOCOL_OPTION 2>/dev/null)

  if [ -n "$topic_exists" ]; then
    echo "Kafka topic $name already exists, skipping creation."
  else
    # Create the Kafka topic if it does not exist
    echo "Creating Kafka topic $name with $partitions partitions and $replication_factor replication factor on brokers $KAFKA_BROKERS"
    $KAFKA_HOME/bin/kafka-topics.sh --create --bootstrap-server "$KAFKA_BROKERS" \
      --replication-factor "$replication_factor" \
      --partitions "$partitions" \
      --topic "$name" \
      $SECURITY_PROTOCOL_OPTION

    echo "Kafka topic $name created successfully!"
  fi
done
