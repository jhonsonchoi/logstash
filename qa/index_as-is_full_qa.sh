#!/bin/bash

export INDEX_POSTFIX=`(date -u +"%Y.%m.%d.%H.%M")`

for task in 0 1 2 3 4 5; do {
 ./index_as-is_part_qa.sh $task mod_no_$task
} done

echo done
