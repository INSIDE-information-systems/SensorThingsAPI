-- Materialized View: sta."SENSORS"

DROP MATERIALIZED VIEW sta."SENSORS";

-- TODO: id should only be from cdmethana, not insituana
CREATE MATERIALIZED VIEW sta."SENSORS" AS 
 SELECT base.cdmethana::bigint AS "ID",
    sta.clean(mana.nom) AS "DESCRIPTION",
    'application/vnd.geo+json'::text AS "ENCODING_TYPE",
    sta.clean(mana.nom) AS "METADATA",
    sta.clean(mana.nom) AS "NAME",
    '{"namespace": "Sandre", "type":"INSPIRE", "responsibleParty":{"organisationName": "Sandre"}}' AS "PROPERTIES"
   FROM sta.senbase base
     LEFT JOIN referentiel.methode mana ON mana.code::text = base.cdmethana::text
  WHERE base.cdmethana IS NOT NULL;

-- Index: sta.mv_pk_sensor
-- DROP INDEX sta.mv_pk_sensor;

CREATE UNIQUE INDEX mv_pk_sensor
  ON sta."SENSORS"("ID"); 


