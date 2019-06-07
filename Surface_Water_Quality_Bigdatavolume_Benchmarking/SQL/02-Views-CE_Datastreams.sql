-- Materialized View: sta."CE_DATASTREAMS"

drop MATERIALIZED VIEW sta."CE_DATASTREAMS";

CREATE MATERIALIZED VIEW sta."CE_DATASTREAMS" AS 
 SELECT sta.numeric_id_datastream(lpad(base.cdunitemesure, 5, '0') || 
			lpad(base.cdparametre, 5, '0') || lpad(base.cdmethode, 5, '0') || lpad(base.cdstationmesureeauxsurface, 8, '0')) AS "ID",
    sta.clean(par.libellelong) || ' at ' || sta.clean(sta.libellestation) || ' with method ' || sta.clean(mana.nom) AS "DESCRIPTION",
    'http://www.opengis.net/def/observationType/OGC-OM/2.0/OM_Measurement' AS "OBSERVATION_TYPE",
    sta.make_time(base.mindateprel, base.minheureprel)::timestamp with time zone AS "PHENOMENON_TIME_START",
    sta.make_time(base.maxdateprel, base.maxheureprel)::timestamp with time zone AS "PHENOMENON_TIME_END",
    base.cdmethode::bigint AS "SENSOR_ID",
    base.cdparametre::bigint AS "OBS_PROPERTY_ID",
    sta.numeric_id_thing(base.cdstationmesureeauxsurface) AS "THING_ID",
    unite.symbole AS "UNIT_NAME",
    unite.symbole AS "UNIT_SYMBOL",
    'http://id.eaufrance.fr/urf/' || base.cdunitemesure AS "UNIT_DEFINITION",
    sta.clean(par.libellelong) || ' at ' || sta.clean(sta.libellestation) || ' with method ' || sta.clean(mana.nom) AS "NAME",
    st_geomfromtext('POINT(' || sta.latitude || ' ' || sta.longitude || ')') AS "OBSERVED_AREA",
    '{"processType":"http://inspire.ec.europa.eu/codelist/ProcessTypeValue/process", "resultNature":"http://inspire.ec.europa.eu/codelist/ResultNatureValue/primary"}' AS "PROPERTIES"
   FROM sta.ce_dsbase base
     LEFT JOIN referentiel_interne.station_full sta ON base.cdstationmesureeauxsurface = sta.codestation
     LEFT JOIN referentiel.unite ON unite.code = base.cdunitemesure
     LEFT JOIN referentiel.methode mana ON mana.code = base.cdmethode
     LEFT JOIN referentiel.parametre par ON base.cdparametre = par.code
where not base.mindateprel is null;
