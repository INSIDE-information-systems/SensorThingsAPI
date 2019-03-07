CREATE MATERIALIZED VIEW sta."CE_OBSERVATIONS"
TABLESPACE pg_default
AS SELECT sta.numeric_id_obs('CE_' || obs.id) AS "ID",
        (obs.dateprel || ' 12:00:00')::date AS "PHENOMENON_TIME_START",
        (obs.dateprel || ' 12:00:00')::date AS "PHENOMENON_TIME_END",
        CASE WHEN obs.dateparenv IS NULL 
						THEN (obs.dateprel || ' 12:00:00')::date
            ELSE sta.make_time(obs.dateparenv, obs.heureparenv)::date
        END AS "RESULT_TIME",
    obs.rsparenv AS "RESULT_NUMBER",
    obs.rsparenv::text AS "RESULT_STRING",
    '[{ "nameOfMeasure": "DQ_Status", "DQ_Result": { "code": "http://id.eaufrance.fr/nsa/446#' || obs.statutparen || '", "label": "' || stat.mnemo || '", "comment": "' || stat.libelle || '"} }, { "nameOfMeasure": "DQ_Qualification", "DQ_Result": { "code": "http://id.eaufrance.fr/nsa/414#' || obs.qualparenv || '", "label": "' || qual.mnemo || '", "comment": "' || qual.libelle || '" } } ]' AS "RESULT_QUALITY",
    NULL::date AS "VALID_TIME_START",
    NULL::date AS "VALID_TIME_END",
    null::text AS "PARAMETERS",
   sta.numeric_id_datastream(lpad(obs.cdunitemesure, 5, '0') || 
			lpad(obs.cdparametre, 5, '0') || lpad(obs.cdmethode, 5, '0') || lpad(obs.cdstationmesureeauxsurface, 8, '0')) AS "DATASTREAM_ID",
    sta.numeric_id_feature('CE_' || obs.codeoperationcep) AS "FEATURE_ID",
    0 AS "RESULT_TYPE",
    NULL::text AS "RESULT_JSON",
    NULL::boolean AS "RESULT_BOOLEAN",
    NULL::bigint AS "MULTI_DATASTREAM_ID"
   FROM physicochimie.condition_environnementale obs
     LEFT JOIN referentiel.statut_analyse stat ON obs.statutparen::text = stat.code::text
     LEFT JOIN referentiel.qualification qual ON obs.qualparenv::text = qual.code::text
WHERE obs.cdprelevement IS NOT NULL; 
