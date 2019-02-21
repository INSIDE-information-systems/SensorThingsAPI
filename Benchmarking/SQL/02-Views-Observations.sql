-- Materialized View: sta."OBSERVATIONS"

DROP MATERIALIZED VIEW sta."OBSERVATIONS";

CREATE MATERIALIZED VIEW sta."OBSERVATIONS" AS 
 SELECT obs.id AS "ID",
        CASE
            WHEN obs.heureprel IS NULL THEN obs.dateprel
            ELSE ((obs.dateprel || ' '::text) || obs.heureprel)::date
        END AS "PHENOMENON_TIME_START",
        CASE
            WHEN obs.datefinprel IS NULL THEN 
				CASE
		            WHEN obs.heureprel IS NULL THEN obs.dateprel
		            ELSE ((obs.dateprel || ' '::text) || obs.heureprel)::date
		        END
            ELSE
            CASE
                WHEN obs.heurefinprel IS NULL THEN obs.datefinprel
                ELSE ((obs.datefinprel || ' '::text) || obs.heurefinprel)::date
            END
        END AS "PHENOMENON_TIME_END",
        CASE
            WHEN obs.dateana IS NULL THEN NULL::date
            ELSE
            CASE
                WHEN obs.heureana IS NULL THEN obs.dateana
                ELSE ((obs.dateana || ' '::text) || obs.heureana)::date
            END
        END AS "RESULT_TIME",
    obs.rsana AS "RESULT_NUMBER",
    obs.rsana::text AS "RESULT_STRING",
    ((((((((((('[{ "nameOfMeasure": "DQ_Status", "DQ_Result": { "code": "'::text || obs.statutana::text) || '", "label": "'::text) || stat.mnemo::text) || '", "comment": "'::text) || stat.libelle::text) || '"} }, { "nameOfMeasure": "DQ_Qualification", "DQ_Result": { "code": "'::text) || obs.qualana::text) || '", "label": "'::text) || qual.mnemo::text) || '", "comment": "'::text) || qual.libelle::text) || '" } } ]'::text AS "RESULT_QUALITY",
    NULL::date AS "VALID_TIME_START",
    NULL::date AS "VALID_TIME_END",
    sta.obs_prop(obs.comresultatana, obs.commentairesana, obs.incertana::text, obs.rdtextraction::text, obs.rqana::text, com.libelle::text, obs.difficulteana::text, difana.mnemo::text, obs.difficulteprel::text, difprel.mnemo::text, obs.cdmethfractionnement::text, meth.nom, obs.cdmethodeprel::text, methprel.nom) AS "PARAMETERS",
    (((((obs.insituana::text || obs.cdunitemesure::text) || obs.cdfractionanalysee::text) || obs.cdsupport::text) || obs.cdparametre::text) || obs.cdmethana::text) || obs.cdstationmesureeauxsurface::text AS "DATASTREAM_ID",
    (obs.cdprelevement::text || '-'::text) || obs.cdstationmesureeauxsurface::text AS "FEATURE_ID",
    0 AS "RESULT_TYPE",
    NULL::text AS "RESULT_JSON",
    NULL::boolean AS "RESULT_BOOLEAN",
    NULL::bigint AS "MULTI_DATASTREAM_ID"
   FROM physicochimie.analyse_physicochimie obs
     LEFT JOIN referentiel.statut_analyse stat ON obs.statutana::text = stat.code::text
     LEFT JOIN referentiel.qualification qual ON obs.qualana::text = qual.code::text
     LEFT JOIN referentiel.code_remarque com ON obs.rqana::text = com.code::text
     LEFT JOIN referentiel.difficulte_analyse difana ON obs.difficulteana::text = difana.code::text
     LEFT JOIN referentiel.difficulte_prelevement difprel ON obs.difficulteana::text = difprel.code::text
     LEFT JOIN referentiel.methode meth ON obs.cdmethfractionnement::text = meth.code::text
     LEFT JOIN referentiel.methode methprel ON methprel.code::text = obs.cdmethodeprel::text
  WHERE obs.cdprelevement IS NOT NULL
WITH DATA;

-- Index: sta."OBS_ID"
-- DROP INDEX sta."OBS_ID";

CREATE INDEX "OBS_ID"
  ON sta."OBSERVATIONS"
  USING btree
  ("ID");

