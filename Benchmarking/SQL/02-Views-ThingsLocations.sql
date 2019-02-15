-- Materialized View: sta."THINGS_LOCATIONS"

DROP MATERIALIZED VIEW sta."THINGS_LOCATIONS";

CREATE MATERIALIZED VIEW sta."THINGS_LOCATIONS" AS 
 SELECT stat.codestation AS "THING_ID",
    stat.codestation AS "LOCATION_ID"
   FROM referentiel_interne.station_full stat
WITH DATA;

