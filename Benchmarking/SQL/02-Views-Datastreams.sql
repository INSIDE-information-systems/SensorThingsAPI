-- Materialized View: sta."DATASTREAMS"

DROP MATERIALIZED VIEW sta."DATASTREAMS";

CREATE MATERIALIZED VIEW sta."DATASTREAMS" AS 
 SELECT (((((base.insituana::text || base.cdunitemesure::text) || base.cdfractionanalysee::text) || base.cdsupport::integer) || base.cdparametre::text) || base.cdmethana::text) || base.cdstationmesureeauxsurface::text AS "ID",
    (((((((('Measurement of '::text || par.libellelong::text) || ' in '::text) || support.nom::text) || ' on '::text) || fraction_analysee.nom::text) || ' at '::text) || sta.libellestation::text) || ' with method '::text) || mana.nom AS "DESCRIPTION",
    'http://www.opengis.net/def/observationType/OGC-OM/2.0/OM_Measurement'::text AS "OBSERVATION_TYPE",
    (base.mindateprel || ' '::text) || base.minheureprel AS "PHENOMENON_TIME_START",
    (base.maxdateprel || ' '::text) || base.maxheureprel AS "PHENOMENON_TIME_END",
    lpad(base.cdmethana::text, 4, '0'::text) || base.insituana::text AS "SENSOR_ID",
    base.cdparametre AS "OBS_PROPERTY_ID",
    base.cdstationmesureeauxsurface AS "THING_ID",
    unite.symbole AS "UNIT_NAME",
    unite.symbole AS "UNIT_SYMBOL",
    unite.code AS "UNIT_DEFINITION",
    (((((((('Measurement of '::text || par.libellelong::text) || ' in '::text) || support.nom::text) || ' on '::text) || fraction_analysee.nom::text) || ' at '::text) || sta.libellestation::text) || ' with method '::text) || mana.nom AS "NAME",
    st_geomfromtext(((('POINT('::text || sta.latitude) || ' '::text) || sta.longitude) || ')'::text) AS "OBSERVED_AREA",
    ((((((('{ "medium": { "code": '::text || base.cdsupport::text) || ', "label": "'::text) || support.nom::text) || '" }, "fraction": { "code": '::text) || base.cdfractionanalysee::text) || ', "label": "'::text) || fraction_analysee.nom::text) || '" }	}'::text AS "PROPERTIES"
   FROM sta.dsbase base
     LEFT JOIN referentiel_interne.station_full sta ON base.cdstationmesureeauxsurface::text = sta.codestation::text
     LEFT JOIN referentiel.support ON base.cdsupport::text = support.code::text
     LEFT JOIN referentiel.fraction_analysee ON base.cdfractionanalysee::text = fraction_analysee.code::text
     LEFT JOIN referentiel.unite ON unite.code::text = base.cdunitemesure::text
     LEFT JOIN referentiel.methode mana ON mana.code::text = base.cdmethana::text
     LEFT JOIN referentiel.parametre par ON base.cdparametre::text = par.code::text
WITH DATA;

