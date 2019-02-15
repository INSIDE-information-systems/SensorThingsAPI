-- Materialized View: sta."THINGS"

DROP MATERIALIZED VIEW sta."THINGS";

CREATE MATERIALIZED VIEW sta."THINGS" AS 
 SELECT stat.codestation AS "ID",
    stat.libellestation AS "DESCRIPTION",
    sta.thg_prop(stat.codestation::text) AS "PROPERTIES",
    stat.libellestation AS "NAME"
   FROM referentiel_interne.station_full stat
WITH DATA;

