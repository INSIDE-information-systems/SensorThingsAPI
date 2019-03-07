-- Materialized View: sta."THINGS_LOCATIONS"

DROP MATERIALIZED VIEW sta."THINGS_LOCATIONS";

CREATE MATERIALIZED VIEW sta."THINGS_LOCATIONS" AS 
 SELECT sta.numeric_id_thing(stat.cdstationmesureeauxsurface) AS "THING_ID",
    sta.numeric_id_thing(stat.cdstationmesureeauxsurface) AS "LOCATION_ID"
FROM sta.thgbase stat;

