-- Materialized View: sta."THINGS"
DROP MATERIALIZED VIEW sta."THINGS";

CREATE MATERIALIZED VIEW sta."THINGS" AS 
 SELECT stat.codestation AS "ID",
    sta.clean(stat.libellestation) AS "DESCRIPTION",
    sta.thg_prop(stat.codestation) AS "PROPERTIES",
    sta.clean(stat.libellestation) AS "NAME"
   FROM referentiel_interne.station_full stat;

