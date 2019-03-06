-- Materialized View: sta."THINGS_LOCATIONS"

DROP MATERIALIZED VIEW sta."THINGS_LOCATIONS";

CREATE MATERIALIZED VIEW sta."THINGS_LOCATIONS" AS 
 SELECT stat.cdstationmesureeauxsurface AS "THING_ID",
    stat.cdstationmesureeauxsurface AS "LOCATION_ID"
   FROM sta.thgbase stat;

