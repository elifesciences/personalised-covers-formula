#!/bin/bash
set -e

curl "https://api.elifesciences.org/subjects?per-page=100" | jq -r .items[].id | sort | tee expected.txt

echo "Checking letter format"
cd salt/personalised-covers/data/formats/letter
diff <(ls -1 | sed -e 's/.jpg$//g') ../../../../../expected.txt
cd -

echo "Checking letter format"
cd salt/personalised-covers/data/formats/letter
diff <(ls -1 | sed -e 's/.jpg$//g') ../../../../../expected.txt
cd -
