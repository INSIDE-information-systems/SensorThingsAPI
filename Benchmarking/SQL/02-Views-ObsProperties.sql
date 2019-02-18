-- Materialized View: sta."OBS_PROPERTIES"

DROP MATERIALIZED VIEW sta."OBS_PROPERTIES";

CREATE MATERIALIZED VIEW sta."OBS_PROPERTIES" AS 
 SELECT par.code::bigint AS "ID",
    sta.clean(par.libellelong) AS "NAME",
    sta.clean(par.libellelong) AS "DEFINITION",
    sta.clean(par.libellelong) AS "DESCRIPTION",
    NULL::text AS "PROPERTIES"
   from sta.propbase base
   	left join referentiel.parametre par on par.code = base.cdparametre
   where base.cdparametre is not NULL;


-- Index: sta.mv_pk_obsprop
-- DROP INDEX sta.mv_pk_obsprop;

CREATE UNIQUE INDEX mv_pk_obsprop
  ON sta."OBS_PROPERTIES"
  USING btree
  ("ID");

