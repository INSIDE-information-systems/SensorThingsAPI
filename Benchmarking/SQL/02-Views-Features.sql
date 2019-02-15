-- Materialized View: sta."FEATURES"

DROP MATERIALIZED VIEW sta."FEATURES";

-- Correct order: longitude, latitude
CREATE MATERIALIZED VIEW sta."FEATURES" AS 
 SELECT (samp.cdprelevement::text || '-'::text) || samp.cdstationmesureeauxsurface::text AS "ID",
    (((('Water Sample from '::text || sta.libellestation::text) || ' taken on '::text) || samp.dateprel) || ' at '::text) || samp.heureprel AS "DESCRIPTION",
    (((('Water Sample from '::text || sta.libellestation::text) || ' taken on '::text) || samp.dateprel) || ' at '::text) || samp.heureprel AS "NAME",
    'application/vnd.geo+json'::text AS "ENCODING",
    ((('{"type":"Point","coordinates":['::text || sta.longitude) || ','::text) || sta.latitude) || ']}'::text AS "FEATURE",
    st_geomfromtext(((('POINT('::text || sta.longitude) || ' '::text) || sta.latitude) || ')'::text) AS "GEOM",
    ((((((((((((((('{ "purpose": "'::text || samp.finaliteprel::text) || '", "responsibleParty": { "code": "'::text) || rp.code::text) || '", "name": "'::text) || rp.nom::text) || '"}, "phenomenonTime": { "startdate": "'::text) || samp.dateprel) || samp.heureprel) || '", "enddate": "'::text) || samp.datefinprel) || samp.heurefinprel) || '"}, "sampledFeature": { "code": "'::text) || sta.codecourseau::text) || '", "name": "'::text) || sta.libellecourseau::text) || '" } }'::text AS "PROPERTIES"
   FROM sta.sampbase samp
     LEFT JOIN referentiel.intervenant rp ON samp.preleveur::text = rp.code::text -- added left
     LEFT JOIN referentiel_interne.station_full sta ON samp.cdstationmesureeauxsurface::text = sta.codestation::text -- added left
  WHERE NOT samp.cdprelevement IS NULL
WITH DATA;

CREATE UNIQUE INDEX mv_pk_foi
  ON sta."FEATURES"
  USING btree
  ("ID" COLLATE pg_catalog."default");

