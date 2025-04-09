## **Kafka Topic Creator Job**

### Configuration

#### Environment Variables

The Kubernetes Job requires the following environment variables:

*   `**KAFKA_BROKERS**`: The address of your Kafka brokers (e.g., `kafka-broker:9092`).
*   `**KAFKA_TOPICS**`: A comma-separated list of topics to create, where each topic is specified in the format `topic_name:partitions:replication_factor` (e.g., `topic1:3:2,topic2:2:3`).
*   `**USE_SSL**`: Set to `true` if SSL should be used for Kafka communication (default is `false`).

### Kubernetes Job Configuration

Here is the Kubernetes Job definition file `kafka-topic-creator-job.yaml`:

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: kafka-topic-creator
spec:
  template:
    spec:
      containers:
      - name: kafka-topic-creator
        image: myusername/my-kafka-topic-creator:latest  # Replace with your Docker image name
        env:
        - name: KAFKA_BROKERS
          value: "kafka-broker:9092"  # Replace with your Kafka broker address
        - name: KAFKA_TOPICS
          value: "topic1:3:2,topic2:2:3"  # Replace with your list of topics
        - name: USE_SSL
          value: "true"  # Set to "true" if you want to use SSL
      restartPolicy: OnFailure
  backoffLimit: 4
```