-- Materialized View: sta."OBSERVATIONS"

DROP MATERIALIZED VIEW sta."OBSERVATIONS";

CREATE MATERIALIZED VIEW sta."OBSERVATIONS" AS 
 SELECT obs.id::bigint AS "ID",
		CASE
				WHEN obs.heureprel IS NULL THEN (obs.dateprel || ' 12:00:00')::date
				ELSE (obs.dateprel || ' ' || obs.heureprel)::date
		END AS "PHENOMENON_TIME_START",
		CASE
				WHEN obs.datefinprel IS NULL THEN
				CASE
						WHEN obs.heureprel IS NULL THEN (obs.dateprel || ' 12:00:00')::date
						ELSE (obs.dateprel || ' ' || obs.heureprel)::date
				END
				ELSE
				CASE
						WHEN obs.heurefinprel IS NULL THEN (obs.datefinprel || ' 12:00:00')::date
						ELSE (obs.datefinprel || ' ' || obs.heurefinprel)::date
				END
		END AS "PHENOMENON_TIME_END",				
		CASE
				WHEN obs.dateana IS NULL THEN NULL::date
				ELSE
				CASE
						WHEN obs.heureana IS NULL THEN (obs.dateana || ' 12:00:00')::date
						ELSE (obs.dateana || ' ' || obs.heureana)::date
				END
		END AS "RESULT_TIME",
    obs.rsana AS "RESULT_NUMBER",
    obs.rsana::text AS "RESULT_STRING",
    '[{ "nameOfMeasure": "DQ_Status", "DQ_Result": { "code": "http://id.eaufrance.fr/nsa/446#' || obs.statutana || '", "label": "' || stat.mnemo || '", "comment": "' || stat.libelle || '"} }, { "nameOfMeasure": "DQ_Qualification", "DQ_Result": { "code": "http://id.eaufrance.fr/nsa/414#' || obs.qualana || '", "label": "' || qual.mnemo || '", "comment": "' || qual.libelle || '" } } ]' AS "RESULT_QUALITY",
    NULL::date AS "VALID_TIME_START",
    NULL::date AS "VALID_TIME_END",
    sta.obs_param(obs.comresultatana, obs.commentairesana, obs.incertana::text, obs.rdtextraction::text, obs.rqana::text, com.mnemo::text, obs.difficulteana::text, difana.mnemo::text, obs.difficulteprel::text, difprel.mnemo::text, obs.cdmethfractionnement::text, meth.nom, obs.cdmethodeprel::text, methprel.nom, obs.insituana, ins.mnemo) AS "PARAMETERS",
    obs.cdunitemesure || obs.cdfractionanalysee || obs.cdsupport || obs.cdparametre || obs.cdmethana || obs.cdstationmesureeauxsurface AS "DATASTREAM_ID",
    obs.cdprelevement || '-' || obs.cdstationmesureeauxsurface AS "FEATURE_ID", 
    obs.insituana,
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
		 LEFT JOIN referentiel.analyse_in_situ_laboratoire ins ON obs.insituana = ins.code
  WHERE obs.cdprelevement IS NOT null;

-- Index: sta."OBS_ID"
-- DROP INDEX sta."OBS_ID";

CREATE INDEX "OBS_ID"
  ON sta."OBSERVATIONS"
  USING btree
  ("ID");

