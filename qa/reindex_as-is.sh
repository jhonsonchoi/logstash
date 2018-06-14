

json="
{
  \"source\": {
    \"index\": \"qa-enuri-main\",
    \"size\": 10000
  },
  \"dest\": {
    \"index\": \"$1\"
  }
}
"

curl -X POST "100.100.100.111:9200/_reindex" -H 'Content-Type: application/json' -d "$json"

