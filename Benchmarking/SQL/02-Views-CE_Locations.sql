drop MATERIALIZED VIEW sta."CE_LOCATIONS"

CREATE MATERIALIZED VIEW sta."CE_LOCATIONS"
AS SELECT stat.codestation AS "ID",
    sta.clean(stat.libellestation) AS "DESCRIPTION",
    'application/vnd.geo+json'::text AS "ENCODING_TYPE",
    '{"type":"Point","coordinates":[' || stat.longitude || ',' || stat.latitude || ']}' AS "LOCATION",
    st_geomfromtext('POINT(' || stat.longitude || ' ' || stat.latitude || ')') AS "GEOM",
    sta.clean(stat.libellestation) AS "NAME",
    NULL::bigint AS "GEN_FOI_ID",
    NULL::text AS "PROPERTIES"
FROM sta.ce_thgbase base
left join referentiel_interne.station_full stat ON stat.codestation = base.cdstationmesureeauxsurface
