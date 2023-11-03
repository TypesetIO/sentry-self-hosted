echo "${_group}Creating additional Kafka topics ..."

# NOTE: This step relies on `kafka` being available from the previous `snuba-api bootstrap` step
# XXX(BYK): We cannot use auto.create.topics as Confluence and Apache hates it now (and makes it very hard to enable)
EXISTING_KAFKA_TOPICS=$($dcr -T kafka kafka-topics --list --bootstrap-server kafka-1:9092,kafka-2:9092,kafka-3:9092 2>/dev/null)
NEEDED_KAFKA_TOPICS="ingest-attachments ingest-transactions ingest-events ingest-replay-recordings profiles ingest-occurrences ingest-metrics ingest-performance-metrics"
for topic in $NEEDED_KAFKA_TOPICS; do
  if ! echo "$EXISTING_KAFKA_TOPICS" | grep -qE "(^| )$topic( |$)"; then
    $dcr kafka kafka-topics --create --topic $topic --bootstrap-server kafka-1:9092,kafka-2:9092,kafka-3:9092
    echo ""
  fi
done

echo "${_endgroup}"
