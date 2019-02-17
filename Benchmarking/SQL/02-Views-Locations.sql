-- Materialized View: sta."LOCATIONS"

DROP MATERIALIZED VIEW sta."LOCATIONS";

-- Correct order: longitude, latitude
	 
CREATE MATERIALIZED VIEW sta."LOCATIONS"
AS SELECT stat.codestation AS "ID",
    sta.clean(stat.libellestation) AS "DESCRIPTION",
    'application/vnd.geo+json'::text AS "ENCODING_TYPE",
    '{"type":"Point","coordinates":[' || stat.longitude || ',' || stat.latitude || ']}' AS "LOCATION",
    st_geomfromtext('POINT(' || stat.longitude || ' ' || stat.latitude || ')') AS "GEOM",
    sta.clean(stat.libellestation) AS "NAME",
    NULL::bigint AS "GEN_FOI_ID",
    NULL::text AS "PROPERTIES"
   FROM referentiel_interne.station_full stat;	

