-- Materialized View: sta."FEATURES"

DROP MATERIALIZED VIEW sta."FEATURES";

-- Correct order: longitude, latitude
CREATE MATERIALIZED VIEW sta."FEATURES" AS 
 SELECT sta.numeric_id_feature(foi.cdprelevement || '-' || lpad(foi.cdstationmesureeauxsurface, 8, '0')) AS "ID",
    'Water Sample from ' || sta.libellestation || ' taken on ' || foi.dateprel || ' at ' || foi.heureprel AS "DESCRIPTION",
    'Water Sample from ' || sta.libellestation || ' taken on ' || foi.dateprel || ' at ' || foi.heureprel AS "NAME",
    'application/vnd.geo+json' AS "ENCODING",
    '{"type":"Point","coordinates":[' || sta.longitude || ',' || sta.latitude || ']}' AS "FEATURE",
    st_geomfromtext('POINT(' || sta.longitude || ' ' || sta.latitude || ')') AS "GEOM",
    sta.foi_prop(foi.finaliteprel::text, rp.code::text, rp.nom::text, foi.dateprel::text, foi.heureprel::text, foi.datefinprel::text, foi.heurefinprel::text, sta.codecourseau::text, sta.libellecourseau::text, foi.codeoperationcep::text) AS "PROPERTIES"
   FROM sta.foibase foi
     LEFT JOIN referentiel.intervenant rp ON foi.preleveur = rp.code -- added left
     LEFT JOIN referentiel_interne.station_full sta ON foi.cdstationmesureeauxsurface = sta.codestation -- added left
  WHERE NOT foi.cdprelevement IS NULL;

CREATE UNIQUE INDEX mv_pk_foi
  ON sta."FEATURES" ("ID");

