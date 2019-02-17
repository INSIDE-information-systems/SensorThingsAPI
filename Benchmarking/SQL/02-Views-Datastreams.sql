-- Materialized View: sta."DATASTREAMS"

DROP MATERIALIZED VIEW sta."DATASTREAMS";

CREATE MATERIALIZED VIEW sta."DATASTREAMS" AS 
 SELECT lpad(base.cdunitemesure, 5, '0') || lpad(base.cdfractionanalysee, 3, '0') || lpad(base.cdsupport, 3, '0') || 
			lpad(base.cdparametre, 5, '0') || lpad(base.cdmethana, 5, '0') || lpad(base.cdstationmesureeauxsurface, 8, '0') AS "ID",
    par.libellelong || ' in ' || support.nom || ' on ' || fraction_analysee.nom || ' at ' || sta.libellestation || ' with method ' || mana.nom AS "DESCRIPTION",
    'http://www.opengis.net/def/observationType/OGC-OM/2.0/OM_Measurement' AS "OBSERVATION_TYPE",
    (base.mindateprel || ' ') || base.minheureprel AS "PHENOMENON_TIME_START",
    (base.maxdateprel || ' ') || base.maxheureprel AS "PHENOMENON_TIME_END",
    base.cdmethana AS "SENSOR_ID",
    base.cdparametre AS "OBS_PROPERTY_ID",
    base.cdstationmesureeauxsurface AS "THING_ID",
    unite.symbole AS "UNIT_NAME",
    unite.symbole AS "UNIT_SYMBOL",
    'http://id.eaufrance.fr/urf/' || base.cdunitemesure AS "UNIT_DEFINITION",
    par.libellelong || ' in ' || support.nom || ' on ' || fraction_analysee.nom || ' at ' || sta.libellestation || ' with method ' || mana.nom AS "NAME",
    st_geomfromtext('POINT(' || sta.latitude || ' ' || sta.longitude || ')') AS "OBSERVED_AREA",
    sta.ds_prop(base.cdsupport, support.nom, base.cdfractionanalysee, fraction_analysee.nom) AS "PROPERTIES"
   FROM sta.dsbase base
     LEFT JOIN referentiel_interne.station_full sta ON base.cdstationmesureeauxsurface = sta.codestation
     LEFT JOIN referentiel.support ON base.cdsupport = support.code
     LEFT JOIN referentiel.fraction_analysee ON base.cdfractionanalysee = fraction_analysee.code
     LEFT JOIN referentiel.unite ON unite.code = base.cdunitemesure
     LEFT JOIN referentiel.methode mana ON mana.code = base.cdmethana
     LEFT JOIN referentiel.parametre par ON base.cdparametre = par.code;

