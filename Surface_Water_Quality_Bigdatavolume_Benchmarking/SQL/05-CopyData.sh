#!/bin/bash
#
# run as user postgres directly on the database machine

while true
do
  echo "Running query..."
  psql <<EOF
insert into sensorthings."OBSERVATIONS" (
		"ID",
		"PHENOMENON_TIME_START",
		"PHENOMENON_TIME_END",
		"RESULT_TIME",
		"RESULT_NUMBER",
		"RESULT_STRING",
		"RESULT_QUALITY",
		"VALID_TIME_START",
		"VALID_TIME_END",
		"PARAMETERS",
		"DATASTREAM_ID",
		"FEATURE_ID",
		"RESULT_TYPE",
		"RESULT_JSON",
		"RESULT_BOOLEAN")
	select
		"ID",
		"PHENOMENON_TIME_START",
		"PHENOMENON_TIME_END",
		"RESULT_TIME",
		"RESULT_NUMBER",
		"RESULT_STRING",
		"RESULT_QUALITY",
		"VALID_TIME_START",
		"VALID_TIME_END",
		"PARAMETERS"::json,
		"DATASTREAM_ID",
		"FEATURE_ID",
		"RESULT_TYPE",
		"RESULT_JSON",
		"RESULT_BOOLEAN"
    from sta."OBSERVATIONS" mt
	where mt."ID" > (select coalesce(max("ID"), 0) from sensorthings."OBSERVATIONS")
	order by mt."ID" asc
	limit 500000;
EOF
  echo "Sleeping..."
  sleep 5
done
