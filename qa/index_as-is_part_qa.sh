#!/bin/bash

export MOD_NO=$1
#export INDEX_POSTFIX=`(date -u +"%Y.%m.%d.%H.%M")`

nohup /usr/share/logstash/bin/logstash --pipeline.unsafe_shutdown -f as-is_part_qa.conf --path.data $2 --path.settings settings 2> /dev/null &
