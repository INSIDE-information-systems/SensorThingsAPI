-- Materialized View: sta."OBS_PROPERTIES"

DROP MATERIALIZED VIEW sta."OBS_PROPERTIES";

CREATE MATERIALIZED VIEW sta."OBS_PROPERTIES" AS 
 SELECT parametre.code::bigint AS "ID",
    sta.clean(parametre.libellelong) AS "NAME",
    sta.clean(parametre.libellelong) AS "DEFINITION",
    sta.clean(parametre.libellelong) AS "DESCRIPTION",
    NULL::text AS "PROPERTIES"
   FROM referentiel.parametre;


-- Index: sta.mv_pk_obsprop
-- DROP INDEX sta.mv_pk_obsprop;

CREATE UNIQUE INDEX mv_pk_obsprop
  ON sta."OBS_PROPERTIES"
  USING btree
  ("ID");

