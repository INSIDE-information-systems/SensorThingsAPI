-----------------
--- LOCATIONS ---
-----------------

insert into sensorthings."LOCATIONS"
	select "ID", "DESCRIPTION", "ENCODING_TYPE", "LOCATION", ST_Force2D(ST_SetSRID(ST_GeomFromGeoJSON("LOCATION"), 4326)) as "GEOM", "NAME", "GEN_FOI_ID", "PROPERTIES"::json
    from sta."LOCATIONS" mt;


--------------
--- THINGS ---
--------------

insert into sensorthings."THINGS"
	select "ID", "DESCRIPTION", "PROPERTIES"::json, "NAME"
    from sta."THINGS" mt;


------------------------
--- THINGS_LOCATIONS ---
------------------------

insert into sensorthings."THINGS_LOCATIONS"
	select "THING_ID", "LOCATION_ID"
    from sta."THINGS_LOCATIONS" mt;


---------------
--- SENSORS ---
---------------

insert into sensorthings."SENSORS"
	select "ID", "DESCRIPTION", "ENCODING_TYPE", "METADATA", "NAME", "PROPERTIES"::json
    from sta."SENSORS" mt;


-----------------
--- OBS_PROPS ---
-----------------

insert into sensorthings."OBS_PROPERTIES"
	select "ID", "NAME", "DEFINITION", "DESCRIPTION", "PROPERTIES"::json
    from sta."OBS_PROPERTIES" mt;


-------------------
--- DATASTREAMS ---
-------------------

insert into sensorthings."DATASTREAMS" (
		"ID",
		"DESCRIPTION",
		"OBSERVATION_TYPE",
		"PHENOMENON_TIME_START",
		"PHENOMENON_TIME_END",
		"SENSOR_ID",
		"OBS_PROPERTY_ID",
		"THING_ID",
		"UNIT_NAME",
		"UNIT_SYMBOL",
		"UNIT_DEFINITION",
		"NAME",
		"OBSERVED_AREA",
		"PROPERTIES")
	select
		"ID", 
		"DESCRIPTION",
		"OBSERVATION_TYPE",
		"PHENOMENON_TIME_START",
		"PHENOMENON_TIME_END",
		"SENSOR_ID",
		"OBS_PROPERTY_ID",
		"THING_ID",
		"UNIT_NAME",
		"UNIT_SYMBOL",
		"UNIT_DEFINITION",
		"NAME",
		ST_SetSRID("OBSERVED_AREA", 4326),
		"PROPERTIES"::json
    from sta."DATASTREAMS";

insert into sensorthings."DATASTREAMS" (
		"ID",
		"DESCRIPTION",
		"OBSERVATION_TYPE",
		"PHENOMENON_TIME_START",
		"PHENOMENON_TIME_END",
		"SENSOR_ID",
		"OBS_PROPERTY_ID",
		"THING_ID",
		"UNIT_NAME",
		"UNIT_SYMBOL",
		"UNIT_DEFINITION",
		"NAME",
		"OBSERVED_AREA",
		"PROPERTIES")
	select
		"ID", 
		"DESCRIPTION",
		"OBSERVATION_TYPE",
		"PHENOMENON_TIME_START",
		"PHENOMENON_TIME_END",
		"SENSOR_ID",
		"OBS_PROPERTY_ID",
		"THING_ID",
		"UNIT_NAME",
		"UNIT_SYMBOL",
		"UNIT_DEFINITION",
		"NAME",
		ST_SetSRID("OBSERVED_AREA", 4326),
		"PROPERTIES"::json
    from sta."CE_DATASTREAMS";



----------------
--- FEATURES ---
----------------

insert into sensorthings."FEATURES" (
		"ID",
		"DESCRIPTION",
		"ENCODING_TYPE",
		"FEATURE",
		"GEOM",
		"NAME",
		"PROPERTIES")
	select "ID",
		"DESCRIPTION",
		"ENCODING",
		"FEATURE",
		ST_SetSRID("GEOM", 4326) as "GEOM",
		"NAME",
		"PROPERTIES"::json
    from sta."FEATURES";

insert into sensorthings."FEATURES" (
		"ID",
		"DESCRIPTION",
		"ENCODING_TYPE",
		"FEATURE",
		"GEOM",
		"NAME",
		"PROPERTIES")
	select "ID",
		"DESCRIPTION",
		"ENCODING",
		"FEATURE",
		ST_SetSRID("GEOM", 4326) as "GEOM",
		"NAME",
		"PROPERTIES"::json
    from sta."CE_FEATURES";


--------------------
--- OBSERVATIONS ---
--------------------

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
    from sta."CE_OBSERVATIONS";


-- Since importing all observations in one go is problematic, this query is meant to be run in a loop until it no longer has anything to do.
-- It copies 500k entires at a time.

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




