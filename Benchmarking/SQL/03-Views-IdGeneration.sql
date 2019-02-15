-----------------
--- LOCATIONS ---
-----------------

drop table if exists sta.location_ids;
create table sta.location_ids (
	nr_id	bigserial PRIMARY KEY,
	str_id  varchar
);

insert into sta.location_ids (str_id)
select "ID" from sta."LOCATIONS";

CREATE INDEX location_ids_strid
  ON sta.location_ids
  USING btree
  (str_id COLLATE pg_catalog."default");


--------------
--- THINGS ---
--------------

drop table if exists sta.thing_ids;
create table sta.thing_ids (
	nr_id	bigserial PRIMARY KEY,
	str_id  varchar
);

insert into sta.thing_ids (str_id)
select "ID" from sta."THINGS";

CREATE INDEX thing_ids_strid
  ON sta.thing_ids
  USING btree
  (str_id COLLATE pg_catalog."default");


---------------
--- SENSORS ---
---------------

-- Sensors already have numeric IDs


-----------------
--- OBS_PROPS ---
-----------------

-- ObservedProperties already have numeric IDs


-------------------
--- DATASTREAMS ---
-------------------

drop table if exists sta.datastream_ids;
create table sta.datastream_ids (
	nr_id	bigserial PRIMARY KEY,
	str_id  varchar
);

insert into sta.datastream_ids (str_id)
select "ID" from sta."DATASTREAMS";

CREATE INDEX datastream_ids_strid
  ON sta.datastream_ids
  USING btree
  (str_id COLLATE pg_catalog."default");


----------------
--- FEATURES ---
----------------

drop table if exists sta.feature_ids;
create table sta.feature_ids (
	nr_id	bigserial PRIMARY KEY,
	str_id  varchar
);

insert into sta.feature_ids (str_id)
select "ID" from sta."FEATURES";

CREATE INDEX feature_ids_strid
  ON sta.feature_ids
  USING btree
  (str_id COLLATE pg_catalog."default");


--------------------
--- OBSERVATIONS ---
--------------------

-- Observations already have numeric IDs

