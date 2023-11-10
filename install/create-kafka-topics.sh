echo "${_group}Creating additional Kafka topics ..."

# NOTE: This step relies on `kafka` being available from the previous `snuba-api bootstrap` step
# XXX(BYK): We cannot use auto.create.topics as Confluence and Apache hates it now (and makes it very hard to enable)
EXISTING_KAFKA_TOPICS=$($dcr -T kafka kafka-topics --list --zookeeper zookeeper:2181 2>/dev/null)
KAFKA_TOPIC_WITH_HIGH_PARTITION="ingest-transactions ingest-events"
NEEDED_KAFKA_TOPICS="ingest-attachments ingest-replay-recordings profiles ingest-occurrences ingest-metrics ingest-performance-metrics"
for topic in $NEEDED_KAFKA_TOPICS; do
  if ! echo "$EXISTING_KAFKA_TOPICS" | grep -qE "(^| )$topic( |$)"; then
    $dcr kafka kafka-topics --create --topic $topic --zookeeper zookeeper:2181 --replication-factor 2 --partitions 20
    echo ""
  fi
done
for topic in $KAFKA_TOPIC_WITH_HIGH_PARTITION; do
  if ! echo "$EXISTING_KAFKA_TOPICS" | grep -qE "(^| )$topic( |$)"; then
    $dcr kafka kafka-topics --create --topic $topic --zookeeper zookeeper:2181 --replication-factor 2 --partitions 100
    echo ""
  fi
done

echo "${_endgroup}"
