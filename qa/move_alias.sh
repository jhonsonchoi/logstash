
from=$1
to=$2

json="
{
    \"actions\" : [
        { \"remove\" : { \"index\" : \"$from\", \"alias\" : \"qa-enuri-main\" } },
        { \"add\" : { \"index\" : \"$to\", \"alias\" : \"qa-enuri-main\" } }
    ]
}
"

curl -X POST "100.100.100.111:9200/_aliases" -H 'Content-Type: application/json' -d "$json"
