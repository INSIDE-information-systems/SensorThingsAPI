-- Materialized View: sta."CE_FEATURES"

DROP MATERIALIZED VIEW sta."CE_FEATURES";

-- Correct order: longitude, latitude
CREATE MATERIALIZED VIEW sta."CE_FEATURES" AS 
 SELECT sta.numeric_id_feature('CE_' || foi.codeoperationcep) AS "ID",
    'Water Sample from ' || sta.libellestation || ' taken on ' || foi.maxdateprel || ' at ' || foi.maxheureprel AS "DESCRIPTION",
    foi.codeoperationcep AS "NAME",
    'application/vnd.geo+json' AS "ENCODING",
    '{"type":"Point","coordinates":[' || sta.longitude || ',' || sta.latitude || ']}' AS "FEATURE",
    st_geomfromtext('POINT(' || sta.longitude || ' ' || sta.latitude || ')') AS "GEOM",
    sta.ce_foi_prop(foi.mindateprel, foi.minheureprel, foi.maxdateprel, foi.maxheureprel, sta.codecourseau::text, sta.libellecourseau::text) AS "PROPERTIES"
   FROM sta.ce_foibase foi
LEFT JOIN referentiel_interne.station_full sta ON foi.cdstationmesureeauxsurface = sta.codestation;
