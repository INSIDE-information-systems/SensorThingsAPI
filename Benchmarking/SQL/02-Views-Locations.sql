-- Materialized View: sta."LOCATIONS"

DROP MATERIALIZED VIEW sta."LOCATIONS";

-- Correct order: longitude, latitude
CREATE MATERIALIZED VIEW sta."LOCATIONS" AS 
 SELECT stat.codestation AS "ID",
    stat.libellestation AS "DESCRIPTION",
    'application/vnd.geo+json'::text AS "ENCODING_TYPE",
    ((('{"type":"Point","coordinates":['::text || stat.longitude) || ','::text) || stat.latitude) || ']}'::text AS "LOCATION",
    st_geomfromtext(((('POINT('::text || stat.longitude) || ' '::text) || stat.latitude) || ')'::text) AS "GEOM",
    stat.libellestation AS "NAME",
    NULL::bigint AS "GEN_FOI_ID",
    NULL::text AS "PROPERTIES"
   FROM referentiel_interne.station_full stat
WITH DATA;

