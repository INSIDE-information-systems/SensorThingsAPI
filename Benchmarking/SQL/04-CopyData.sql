-----------------
--- LOCATIONS ---
-----------------

insert into sensorthings."LOCATIONS"
	select ids.nr_id, "DESCRIPTION", "ENCODING_TYPE", "LOCATION", ST_Force2D(ST_SetSRID(ST_GeomFromGeoJSON("LOCATION"), 4326)) as "GEOM", "NAME", "GEN_FOI_ID", "PROPERTIES"
    from sta."LOCATIONS" mt
    inner join sta.location_ids as ids on mt."ID" = ids.str_id;


--------------
--- THINGS ---
--------------

insert into sensorthings."THINGS"
	select ids.nr_id, "DESCRIPTION", "PROPERTIES", "NAME"
    from sta."THINGS" mt
    inner join sta.location_ids as ids on mt."ID" = ids.str_id;


------------------------
--- THINGS_LOCATIONS ---
------------------------

insert into sensorthings."THINGS_LOCATIONS"
	select tids.nr_id, lids.nr_id
    from sta."THINGS_LOCATIONS" mt
    inner join sta.location_ids as lids on mt."LOCATION_ID" = lids.str_id
    inner join sta.thing_ids as tids on mt."THING_ID" = tids.str_id;


---------------
--- SENSORS ---
---------------

insert into sensorthings."SENSORS"
	select ids.nr_id, "DESCRIPTION", "ENCODING_TYPE", "METADATA", "NAME", "PROPERTIES"
    from sta."SENSORS" mt
    inner join sta.sensor_ids as ids on mt."ID" = ids.str_id;


-----------------
--- OBS_PROPS ---
-----------------

insert into sensorthings."OBS_PROPERTIES"
	select ids.nr_id, "NAME", "DEFINITION", "DESCRIPTION", "PROPERTIES"
    from sta."OBS_PROPERTIES" mt
    inner join sta.obsprop_ids as ids on mt."ID" = ids.str_id;


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
		ids.nr_id, 
		"DESCRIPTION",
		"OBSERVATION_TYPE",
		"PHENOMENON_TIME_START"::timestamptz,
		"PHENOMENON_TIME_END"::timestamptz,
		sids.nr_id, -- "SENSOR_ID"
		opids.nr_id, -- "OBS_PROPERTY_ID",
		tids.nr_id, -- "THING_ID",
		"UNIT_NAME",
		"UNIT_SYMBOL",
		"UNIT_DEFINITION",
		"NAME",
		ST_SetSRID("OBSERVED_AREA", 4326),
		"PROPERTIES"
    from sta."DATASTREAMS" mt
    inner join sta.datastream_ids as ids on mt."ID" = ids.str_id
    inner join sta.thing_ids as tids on mt."THING_ID" = tids.str_id
    inner join sta.sensor_ids as sids on mt."SENSOR_ID" = sids.str_id
    inner join sta.obsprop_ids as opids on mt."OBS_PROPERTY_ID" = opids.str_id;



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
	select ids.nr_id,
		"DESCRIPTION",
		"ENCODING",
		"FEATURE",
		ST_SetSRID("GEOM", 4326) as "GEOM",
		"NAME",
		"PROPERTIES"
    from sta."FEATURES" mt
    inner join sta.feature_ids as ids on mt."ID" = ids.str_id;


--------------------
--- OBSERVATIONS ---
--------------------

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
		"PARAMETERS",
		dids.nr_id, -- "DATASTREAM_ID",
		fids.nr_id, -- "FEATURE_ID",
		"RESULT_TYPE",
		"RESULT_JSON",
		"RESULT_BOOLEAN"
    from sta."OBSERVATIONS" mt
	left join sta.datastream_ids as dids on mt."DATASTREAM_ID" = dids.str_id
    left join sta.feature_ids as fids on mt."FEATURE_ID" = fids.str_id
	where mt."ID" > (select coalesce(max("ID"), 0) from sensorthings."OBSERVATIONS")
	order by mt."ID" asc
	limit 500000;


-- insert into sensorthings."OBSERVATIONS" ("ID", "PHENOMENON_TIME_START", "PHENOMENON_TIME_END", "RESULT_TIME", "RESULT_NUMBER", "RESULT_STRING", "RESULT_QUALITY", "VALID_TIME_START", "VALID_TIME_END", "PARAMETERS", "DATASTREAM_ID","FEATURE_ID", "RESULT_TYPE", "RESULT_JSON", "RESULT_BOOLEAN") select "ID", "PHENOMENON_TIME_START", "PHENOMENON_TIME_END", "RESULT_TIME", "RESULT_NUMBER", "RESULT_STRING", "RESULT_QUALITY", "VALID_TIME_START", "VALID_TIME_END", "PARAMETERS", dids.nr_id, fids.nr_id, "RESULT_TYPE", "RESULT_JSON", "RESULT_BOOLEAN" from sta."OBSERVATIONS" mt left join sta.datastream_ids as dids on mt."DATASTREAM_ID" = dids.str_id left join sta.feature_ids as fids on mt."FEATURE_ID" = fids.str_id where mt."ID" > (select coalesce(max("ID"), 0) from sensorthings."OBSERVATIONS") order by mt."ID" asc limit 500000;





