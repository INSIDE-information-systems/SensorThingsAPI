--------------
--- THINGS ---
--------------

drop table if exists sta.thing_ids;
create table sta.thing_ids (
	nr_id	bigserial PRIMARY KEY,
	str_id  varchar
);

-- Insert not necessary if using function below
--insert into sta.thing_ids (str_id)
--select "ID" from sta."THINGS";

CREATE INDEX thing_ids_strid
  ON sta.thing_ids(str_id);

CREATE OR REPLACE FUNCTION sta.numeric_id_thing(id_text text)
 RETURNS bigint
 LANGUAGE plpgsql
AS $function$ 	
	declare id_number int8;
	begin
		select nr_id into id_number from sta.thing_ids where str_id=id_text;
		IF NOT FOUND THEN
    		insert into sta.thing_ids (str_id) values (id_text) returning nr_id into id_number;
		END IF;
		return id_number;
	end
 $function$
;

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

-- Insert not necessary if using function below
--insert into sta.datastream_ids (str_id)
--select "ID" from sta."DATASTREAMS";

CREATE INDEX datastream_ids_strid
  ON sta.datastream_ids(str_id);

CREATE OR REPLACE FUNCTION sta.numeric_id_datastream(id_text text)
 RETURNS bigint
 LANGUAGE plpgsql
AS $function$ 	
	declare id_number int8;
	begin
		select nr_id into id_number from sta.datastream_ids where str_id=id_text;
		IF NOT FOUND THEN
    		insert into sta.datastream_ids (str_id) values (id_text) returning nr_id into id_number;
		END IF;
		return id_number;
	end
 $function$
;


----------------
--- FEATURES ---
----------------

drop table if exists sta.feature_ids;
create table sta.feature_ids (
	nr_id	bigserial PRIMARY KEY,
	str_id  varchar
);

-- Insert not necessary if using function below
--insert into sta.feature_ids (str_id)
--select "ID" from sta."FEATURES";

CREATE INDEX feature_ids_strid
  ON sta.feature_ids(str_id);


CREATE OR REPLACE FUNCTION sta.numeric_id_feature(id_text text)
 RETURNS bigint
 LANGUAGE plpgsql
AS $function$ 	
	declare id_number int8;
	begin
		select nr_id into id_number from sta.feature_ids where str_id=id_text;
		IF NOT FOUND THEN
    		insert into sta.feature_ids (str_id) values (id_text) returning nr_id into id_number;
		END IF;
		return id_number;
	end
 $function$
;


--------------------
--- OBSERVATIONS ---
--------------------

-- Observations already have numeric IDs


-----------------
--- LOCATIONS ---
-----------------
-- KS: Superfluous, as LOCATIONS:THINGS are 1:1, thus always been reusing the same base tables for both
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

CREATE OR REPLACE FUNCTION sta.numeric_id_location(id_text text)
 RETURNS bigint
 LANGUAGE plpgsql
AS $function$ 	
	declare id_number int8;
	begin
		select nr_id into id_number from sta.location_ids where str_id=id_text;
		IF NOT FOUND THEN
    		insert into sta.location_ids (str_id) values (id_text) returning nr_id into id_number;
		END IF;
		return id_number;
	end
 $function$
;

