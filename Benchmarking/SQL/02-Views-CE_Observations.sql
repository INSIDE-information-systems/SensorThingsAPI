CREATE MATERIALIZED VIEW sta."CE_OBSERVATIONS"
AS SELECT sta.numeric_id_obs('CE_'::text || obs.id) AS "ID",
    (obs.dateprel || ' 12:00:00'::text)::timestamp with time zone AS "PHENOMENON_TIME_START",
    (obs.dateprel || ' 12:00:00'::text)::timestamp with time zone AS "PHENOMENON_TIME_END",
        CASE
            WHEN obs.dateparenv IS NULL THEN (obs.dateprel || ' 12:00:00'::text)::timestamp with time zone
            ELSE sta.make_time(obs.dateparenv, obs.heureparenv)
        END AS "RESULT_TIME",
    regexp_replace(obs.rsparenv::text, '\,'::text, '.'::text)::double precision AS "RESULT_NUMBER",
    obs.rsparenv::text AS "RESULT_STRING",
    ((((((((((('[{ "nameOfMeasure": "DQ_Status", "DQ_Result": { "code": "http://id.eaufrance.fr/nsa/446#'::text || obs.statutparen::text) || '", "label": "'::text) || stat.mnemo::text) || '", "comment": "'::text) || stat.libelle::text) || '"} }, { "nameOfMeasure": "DQ_Qualification", "DQ_Result": { "code": "http://id.eaufrance.fr/nsa/414#'::text) || obs.qualparenv::text) || '", "label": "'::text) || qual.mnemo::text) || '", "comment": "'::text) || qual.libelle::text) || '" } } ]'::text AS "RESULT_QUALITY",
    NULL::timestamp with time zone AS "VALID_TIME_START",
    NULL::timestamp with time zone AS "VALID_TIME_END",
    NULL::text AS "PARAMETERS",
    sta.numeric_id_datastream(((lpad(obs.cdunitemesure::text, 5, '0'::text) || lpad(obs.cdparametre::text, 5, '0'::text)) || lpad(obs.cdmethode::text, 5, '0'::text)) || lpad(obs.cdstationmesureeauxsurface::text, 8, '0'::text)) AS "DATASTREAM_ID",
    sta.numeric_id_feature('CE_'::text || obs.codeoperationcep::text) AS "FEATURE_ID",
    0 AS "RESULT_TYPE",
    NULL::text AS "RESULT_JSON",
    NULL::boolean AS "RESULT_BOOLEAN",
    NULL::bigint AS "MULTI_DATASTREAM_ID"
   FROM physicochimie.condition_environnementale obs
     LEFT JOIN referentiel.statut_analyse stat ON obs.statutparen::text = stat.code::text
     LEFT JOIN referentiel.qualification qual ON obs.qualparenv::text = qual.code::text
  WHERE obs.cdprelevement IS NOT NULL;
