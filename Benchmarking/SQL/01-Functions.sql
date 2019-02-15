---------------------
--- sta.clean_str ---
---------------------

CREATE OR REPLACE FUNCTION sta.clean_str(str text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$

DECLARE	
begin

	return regexp_replace(regexp_replace(str, '"', '','g'), '\t', '','g');

END

$function$
;

--------------------
--- sta.obs_prop ---
--------------------

CREATE OR REPLACE FUNCTION sta.obs_prop(comresultatana text, commentairesana text, incertana text, rdtextraction text, rqana text, comlibelle text, difficulteana text, difanamnemo text, difficulteprel text, difprelmnemo text, cdmethfractionnement text, methnom text, cdmethodeprel text, methprelnom text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$

	DECLARE	
		outstr text;
		
	BEGIN
		outstr = '';
		
		outstr = '{';
		IF NOT comresultatana ISNULL 
			THEN outstr = outstr || '"comment": "' || comresultatana || '",';
		END IF;
		
		IF NOT commentairesana ISNULL 
			THEN outstr = outstr || '"otherComment": "' || commentairesana || '",';
		END IF;

		IF ((NOT incertana ISNULL) OR (NOT rdtextraction ISNULL)) 
			THEN 
				outstr = outstr || '"analysis": {';
				IF (NOT incertana ISNULL) THEN outstr = outstr || '"uncertainty": "' || incertana || '"'; END IF;
				IF ((NOT incertana ISNULL) AND (NOT rdtextraction ISNULL)) THEN outstr = outstr || ','; END IF;
				IF (NOT rdtextraction ISNULL) THEN outstr = outstr || '"yield": "' || rdtextraction || '"'; END IF;
				outstr = outstr || '},'; 
		END IF;
		
		IF ((NOT rqana ISNULL) OR (NOT comlibelle ISNULL)) 
			THEN 
				outstr = outstr || '"analysisComment": {';
				IF (NOT rqana ISNULL) THEN outstr = outstr || '"code": "' || rqana || '"'; END IF;
				IF ((NOT rqana ISNULL) AND (NOT comlibelle ISNULL)) THEN outstr = outstr || ','; END IF;
				IF (NOT comlibelle ISNULL) THEN outstr = outstr || '"label": "' || comlibelle || '"'; END IF;
				outstr = outstr || '},'; 
		END IF;

		IF ((NOT difficulteana ISNULL) OR (NOT difanamnemo ISNULL)) 
			THEN 
				outstr = outstr || '"difficultyAna": {';
				IF (NOT difficulteana ISNULL) THEN outstr = outstr || '"code": "' || difficulteana || '"'; END IF;
				IF ((NOT difficulteana ISNULL) AND (NOT difanamnemo ISNULL)) THEN outstr = outstr || ','; END IF;
				IF (NOT difanamnemo ISNULL) THEN outstr = outstr || '"label": "' || difanamnemo || '"'; END IF;
				outstr = outstr || '},'; 
		END IF;
		
		IF ((NOT difficulteprel ISNULL) OR (NOT difprelmnemo ISNULL)) 
			THEN 
				outstr = outstr || '"difficultySamp": {';
				IF (NOT difficulteprel ISNULL) THEN outstr = outstr || '"code": "' || difficulteprel || '"'; END IF;
				IF ((NOT difficulteprel ISNULL) AND (NOT difprelmnemo ISNULL)) THEN outstr = outstr || ','; END IF;
				IF (NOT difprelmnemo ISNULL) THEN outstr = outstr || '"label": "' || difprelmnemo || '"'; END IF;
				outstr = outstr || '},'; 
		END IF;
		
		IF ((NOT cdmethfractionnement ISNULL) OR (NOT methnom ISNULL)) 
			THEN 
				outstr = outstr || '"fractionation": {';
				IF (NOT cdmethfractionnement ISNULL) THEN outstr = outstr || '"code": "' || cdmethfractionnement || '"'; END IF;
				IF ((NOT cdmethfractionnement ISNULL) AND (NOT methnom ISNULL)) THEN outstr = outstr || ','; END IF;
				IF (NOT methnom ISNULL) THEN outstr = outstr || '"label": "' || methnom || '"'; END IF;
				outstr = outstr || '},'; 
		END IF;
		
		IF ((NOT cdmethodeprel ISNULL) OR (NOT methprelnom ISNULL)) 
			THEN 
				outstr = outstr || '"methodSamp": {';
				IF (NOT cdmethodeprel ISNULL) THEN outstr = outstr || '"code": "' || cdmethodeprel || '"'; END IF;
				IF ((NOT cdmethodeprel ISNULL) AND (NOT methprelnom ISNULL)) THEN outstr = outstr || ','; END IF;
				IF (NOT methprelnom ISNULL) THEN outstr = outstr || '"label": "' || methprelnom || '"'; END IF;
				outstr = outstr || '},'; 
		END IF;

		outstr = rtrim(outstr, ',') || '}';

		RETURN outstr;
	END

$function$
;


--------------------
--- sta.sta_nets ---
--------------------

CREATE OR REPLACE FUNCTION sta.sta_nets(stat text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$

	DECLARE	
		outstr text;
		net text;
		netlib text;
		cur CURSOR(stat text) FOR SELECT codesandrerdd, libelle FROM sta.sta_net where cdstationmesureeauxsurface = stat and not codesandrerdd isnull;
BEGIN
	outstr = '';
	--RAISE NOTICE 'before open on (%)', stat;
	OPEN cur(stat);
    LOOP
      FETCH cur INTO net, netlib;
			EXIT WHEN NOT FOUND;
			--raise notice 'sta (%) net: (%)', stat, net;
			outstr = outstr || '{ "code": "'  || net || '", "libelle": "' || netlib ||'"},';
			--raise notice 'outstr (%)', outstr;
    END LOOP;
		CLOSE cur;
	IF ( length(outstr) > 2) THEN 
		RETURN '[' || btrim(outstr,',') || ']';
	ELSE
		RETURN null;
	END IF;
END

$function$
;


--------------------
--- sta.thg_prop ---
--------------------

CREATE OR REPLACE FUNCTION sta.thg_prop(statcode text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$

	DECLARE	
		outstr text;
		datemiseenservice text;
		datemisehorsservice text;
		codecommune text;
		libellecommune text;
		codedepartement text;
		libelledepartement text;
		coderegion text;
		libelleregion text;
		codecourseau text;
		libellecourseau text;
		altitude text;
		pointkilometrique text;
		codemasseeau text;
		codeeumasseeau text;
		libellemasseeau text;
		codesousbassin text;
		libellesousbassin text;
		codebassin text;
		codeeubassin text;
		libellebassin text;
		networks text;

		cur_stat CURSOR(statcode text) FOR SELECT stat.datemiseenservice, stat.datemisehorsservice, stat.codecommune, stat.libellecommune, stat.codedepartement, stat.libelledepartement, stat.coderegion, stat.libelleregion, stat.codecourseau, stat.libellecourseau, stat.altitude, stat.pointkilometrique, stat.codemasseeau, stat.codeeumasseeau, stat.libellemasseeau, stat.codesousbassin, stat.libellesousbassin, stat.codebassin, stat.codeeubassin, stat.libellebassin FROM referentiel_interne.station_full stat where codestation = statcode;
		
BEGIN
	outstr = '';
	OPEN cur_stat(statcode);
    LOOP
      FETCH cur_stat INTO datemiseenservice, datemisehorsservice, codecommune, libellecommune, codedepartement, libelledepartement, coderegion, libelleregion, codecourseau, libellecourseau, altitude, pointkilometrique, codemasseeau, codeeumasseeau, libellemasseeau, codesousbassin, libellesousbassin, codebassin, codeeubassin, libellebassin;
			EXIT WHEN NOT FOUND;
			outstr = '{ "beginTime": "' || datemiseenservice || '"';
			IF NOT datemisehorsservice ISNULL 
				THEN outstr = outstr || ', "endTime": "' || datemisehorsservice || '"';
			END IF;

			IF ((NOT codecommune ISNULL) OR (NOT libellecommune ISNULL)) 
				THEN 
					outstr = outstr || ', "commune": {';
					IF (NOT codecommune ISNULL) THEN outstr = outstr || '"code": "' || codecommune || '"'; END IF;
					IF ((NOT codecommune ISNULL) AND (NOT libellecommune ISNULL)) THEN outstr = outstr || ','; END IF;
					IF (NOT libellecommune ISNULL) THEN outstr = outstr || '"label": "' || libellecommune || '"'; END IF;
					outstr = outstr || '}';
			END IF;

			IF ((NOT codedepartement ISNULL) OR (NOT libelledepartement ISNULL)) 
				THEN 
					outstr = outstr || ', "departement": {';
					IF (NOT codedepartement ISNULL) THEN outstr = outstr || '"code": "' || codedepartement || '"'; END IF;
					IF ((NOT codedepartement ISNULL) AND (NOT libelledepartement ISNULL)) THEN outstr = outstr || ','; END IF;
					IF (NOT libelledepartement ISNULL) THEN outstr = outstr || '"label": "' || libelledepartement || '"'; END IF;
					outstr = outstr || '}';
			END IF;
	
			IF ((NOT coderegion ISNULL) OR (NOT libelleregion ISNULL)) 
				THEN 
					outstr = outstr || ', "region": {';
					IF (NOT coderegion ISNULL) THEN outstr = outstr || '"code": "' || coderegion || '"'; END IF;
					IF ((NOT coderegion ISNULL) AND (NOT libelleregion ISNULL)) THEN outstr = outstr || ','; END IF;
					IF (NOT libelleregion ISNULL) THEN outstr = outstr || '"label": "' || libelleregion || '"'; END IF;
					outstr = outstr || '}';
			END IF;

			IF ((NOT codecourseau ISNULL) OR (NOT libellecourseau ISNULL)) 
				THEN 
					outstr = outstr || ', "courseau": {';
					IF (NOT codecourseau ISNULL) THEN outstr = outstr || '"code": "' || codecourseau || '"'; END IF;
					IF ((NOT codecourseau ISNULL) AND (NOT libellecourseau ISNULL)) THEN outstr = outstr || ','; END IF;
					IF (NOT libellecourseau ISNULL) THEN outstr = outstr || '"label": "' || libellecourseau || '"'; END IF;
					outstr = outstr || '}';
			END IF;

			IF ((NOT altitude ISNULL) OR (NOT pointkilometrique ISNULL)) 
				THEN 
					outstr = outstr || ', "altitude": {';
					IF (NOT altitude ISNULL) THEN outstr = outstr || '"height": ' || altitude || ''; END IF;
					IF ((NOT altitude ISNULL) AND (NOT pointkilometrique ISNULL)) THEN outstr = outstr || ','; END IF;
					IF (NOT pointkilometrique ISNULL) THEN outstr = outstr || '"srs": "' || pointkilometrique || '"'; END IF;
					outstr = outstr || '}';
			END IF;
			
			networks = sta.sta_nets(statcode);
			IF (NOT networks ISNULL)
				THEN 
					outstr = outstr || ', "network": ' || networks;
			END IF;
			
			IF ((NOT codemasseeau ISNULL) OR (NOT codeeumasseeau ISNULL) OR (NOT libellemasseeau ISNULL) OR (NOT codesousbassin ISNULL) OR (NOT libellesousbassin ISNULL) OR (NOT codebassin ISNULL) OR (NOT codeeubassin ISNULL) OR (NOT libellebassin ISNULL)) 
				THEN 
					outstr = outstr || ', "relatedFeature": [';
					IF ((NOT codemasseeau ISNULL) OR (NOT codeeumasseeau ISNULL) OR (NOT libellemasseeau ISNULL))
						THEN
							outstr = outstr || '{';
							IF (NOT codemasseeau ISNULL) THEN outstr = outstr || '"code": "' || codemasseeau || '"'; END IF;
							IF ((NOT codemasseeau ISNULL) AND (NOT codeeumasseeau ISNULL)) THEN outstr = outstr || ','; END IF;
							IF (NOT codeeumasseeau ISNULL) THEN outstr = outstr || '"EUcode": "' || codeeumasseeau || '"'; END IF;
							IF (((NOT codemasseeau ISNULL) OR (NOT codeeumasseeau ISNULL)) AND (NOT libellemasseeau ISNULL)) THEN outstr = outstr || ','; END IF;
							IF (NOT libellemasseeau ISNULL) THEN outstr = outstr || '"label": "' || libellemasseeau || '"'; END IF;
							outstr = outstr || '}';
						END IF;			
					outstr = outstr || ']';
			END IF;			
			
			
			outstr = outstr || '}';
    END LOOP;
		CLOSE cur_stat;
	RETURN outstr;
END

$function$
;

