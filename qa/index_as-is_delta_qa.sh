#!/bin/bash

nohup /usr/share/logstash/bin/logstash -f as-is_delta_qa.conf --path.data delta --path.settings settings 2> /dev/null &
