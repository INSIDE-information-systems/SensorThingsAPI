-- Materialized View: sta."SENSORS"

DROP MATERIALIZED VIEW sta."SENSORS";

CREATE MATERIALIZED VIEW sta."SENSORS" AS 
 SELECT lpad(base.cdmethana::text, 4, '0'::text) || base.insituana::text AS "ID",
    (mana.nom || ' '::text) || insitu.libelle::text AS "DESCRIPTION",
    'application/vnd.geo+json'::text AS "ENCODING_TYPE",
    (mana.nom || ' '::text) || insitu.libelle::text AS "METADATA",
    (mana.nom || ' '::text) || insitu.libelle::text AS "NAME",
    '{"namespace": "BRGM", "type":"INSPIRE", "responsibleParty":{"organisationName": "BRGM"}}'::text AS "PROPERTIES"
   FROM sta.senbase base
     LEFT JOIN referentiel.analyse_in_situ_laboratoire insitu ON base.insituana::text = insitu.code::text
     LEFT JOIN referentiel.methode mana ON mana.code::text = base.cdmethana::text
WITH DATA;

-- Index: sta.mv_pk_sensor
-- DROP INDEX sta.mv_pk_sensor;

CREATE UNIQUE INDEX mv_pk_sensor
  ON sta."SENSORS"
  USING btree
  ("ID" COLLATE pg_catalog."default");


