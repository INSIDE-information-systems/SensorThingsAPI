---------------------
--- sta.make_time ---
---------------------

CREATE OR REPLACE FUNCTION sta.make_time(dt date, tm time without time zone)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
begin
	IF (tm ISNULL) THEN return dt || ' 12:00:00'; END IF;
	return dt || ' ' || tm;
END
$function$
;

---------------------
--- sta.ds_prop   ---
---------------------

CREATE OR REPLACE FUNCTION sta.ds_prop(cdsupport text, supportnom text, cdfractionanalysee text, fraction_analyseenom text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
	DECLARE	
		outstr text;
	BEGIN
		outstr = '{';
		IF ((NOT cdsupport ISNULL) OR (NOT supportnom ISNULL)) 
			THEN 
				outstr = outstr || '"medium": {';
				IF (NOT cdsupport ISNULL) THEN outstr = outstr || '"code": "http://id.eaufrance.fr/sup/' || cdsupport || '"'; END IF;
				IF ((NOT cdsupport ISNULL) AND (NOT supportnom ISNULL)) THEN outstr = outstr || ','; END IF;
				IF (NOT supportnom ISNULL) THEN outstr = outstr || '"label": "' || sta.clean(supportnom) || '"'; END IF;
				outstr = outstr || '},'; 
		END IF;
		IF ((NOT cdfractionanalysee ISNULL) OR (NOT fraction_analyseenom ISNULL)) 
			THEN 
				outstr = outstr || '"fraction": {';
				IF (NOT cdfractionanalysee ISNULL) THEN outstr = outstr || '"code": "http://id.eaufrance.fr/fan/' || cdfractionanalysee || '"'; END IF;
				IF ((NOT cdfractionanalysee ISNULL) AND (NOT fraction_analyseenom ISNULL)) THEN outstr = outstr || ','; END IF;
				IF (NOT fraction_analyseenom ISNULL) THEN outstr = outstr || '"label": "' || sta.clean(fraction_analyseenom) || '"'; END IF;
				outstr = outstr || '},'; 
		END IF;
		outstr = rtrim(outstr, ',') || '}';
		RETURN outstr;
	END
$function$
;


---------------------
--- sta.clean_str ---
---------------------

CREATE OR REPLACE FUNCTION sta.clean(str text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
begin
	IF (str ISNULL) THEN return ''; END IF;
	return regexp_replace(regexp_replace(str, '"', '','g'), '\t', '','g');
END
$function$
;
									 
--------------------
--- sta.foi_prop ---
--------------------

CREATE OR REPLACE FUNCTION sta.foi_prop(finaliteprel text, rpcode text, rpnom text, dateprel text, heureprel text, datefinprel text, heurefinprel text, codecourseau text, libellecourseau text, codeoperationcep text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
	DECLARE	
		outstr text;
	BEGIN
		outstr = '{';
		IF (NOT finaliteprel ISNULL) 
			THEN outstr = outstr || '"purpose": "'|| finaliteprel || '",';
		END IF;
		
		IF ((NOT rpcode ISNULL) OR (NOT rpnom ISNULL)) 
			THEN 
				outstr = outstr || '"responsibleParty": {';
				IF (NOT rpcode ISNULL) THEN outstr = outstr || '"code": "http://id.eaufrance.fr/sup/' || rpcode || '"'; END IF;
				IF ((NOT rpcode ISNULL) AND (NOT rpnom ISNULL)) THEN outstr = outstr || ','; END IF;
				IF (NOT rpnom ISNULL) THEN outstr = outstr || '"name": "' || sta.clean(rpnom) || '"'; END IF;
				outstr = outstr || '},'; 
		END IF;

		IF ((NOT dateprel ISNULL) OR (NOT datefinprel ISNULL)) 
			THEN
			outstr = outstr || '"phenomenonTime": { ';
			IF (NOT dateprel ISNULL) 
				THEN 
					outstr = outstr || '"startdate": "';
					IF (NOT heureprel ISNULL)
						THEN outstr = outstr || dateprel || ' ' || heureprel; 
						ELSE outstr = outstr || dateprel || ' 12:00:00'; 
					END IF;
					outstr = outstr || '", "enddate": "';

					IF (NOT datefinprel ISNULL) 
						THEN 
							IF (NOT heurefinprel ISNULL)
								THEN outstr = outstr || datefinprel || ' ' || heurefinprel; 
								ELSE outstr = outstr || datefinprel || ' 12:00:00'; 
							END IF;
						ELSE
							IF (NOT heureprel ISNULL)
								THEN outstr = outstr || dateprel || ' ' || heureprel; 
								ELSE outstr = outstr || dateprel || ' 12:00:00'; 
							END IF;
					END IF;
			END IF;
			outstr = outstr || '"},'; 
		END IF;
		
		IF ((NOT codecourseau ISNULL) OR (NOT libellecourseau ISNULL)) 
			THEN 
				outstr = outstr || '"sampledFeature": {';
				IF (NOT codecourseau ISNULL) 
					THEN outstr = outstr || '"@id": "http://id.eaufrance.fr/mdo/' || codecourseau || '",'; END IF;
				IF ((NOT codecourseau ISNULL) OR (NOT libellecourseau ISNULL)) 
					THEN outstr = outstr || '"@type": "WFD:WaterBody"'; END IF;
				IF (NOT libellecourseau ISNULL) 
					THEN outstr = outstr || ', "name": "' || sta.clean(libellecourseau) || '"'; END IF;
				outstr = outstr || '},';
		END IF;		
		IF (NOT codeoperationcep ISNULL) 
			THEN outstr = outstr || '"relatedSF": "/Features('|| sta.numeric_id_feature(codeoperationcep)::text || ')",';
		END IF;		
		
		outstr = rtrim(outstr, ',') || '}';
		RETURN outstr;
	END
$function$
;
									 
--------------------
--- sta.obs_param ---
--------------------

CREATE OR REPLACE FUNCTION sta.obs_param(comresultatana text, commentairesana text, incertana text, rdtextraction text, rqana text, comlibelle text, difficulteana text, difanamnemo text, difficulteprel text, difprelmnemo text, cdmethfractionnement text, methnom text, cdmethodeprel text, methprelnom text, insituana  text, insmnemo  text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$

	DECLARE	
		outstr text;
		
	BEGIN
		outstr = '';
		
		outstr = '{';
		IF NOT comresultatana ISNULL 
			THEN outstr = outstr || '"comment": "' || sta.clean(comresultatana) || '",';
		END IF;
		
		IF NOT commentairesana ISNULL 
			THEN outstr = outstr || '"otherComment": "' || sta.clean(commentairesana) || '",';
		END IF;

		IF ((NOT incertana ISNULL) OR (NOT rdtextraction ISNULL)) 
			THEN 
				outstr = outstr || '"analysis": {';
				IF (NOT incertana ISNULL) THEN outstr = outstr || '"uncertainty": ' || incertana || ''; END IF;
				IF ((NOT incertana ISNULL) AND (NOT rdtextraction ISNULL)) THEN outstr = outstr || ','; END IF;
				IF (NOT rdtextraction ISNULL) THEN outstr = outstr || '"yield": ' || rdtextraction || ''; END IF;
				outstr = outstr || '},'; 
		END IF;
		
		IF ((NOT rqana ISNULL) OR (NOT comlibelle ISNULL)) 
			THEN 
				outstr = outstr || '"analysisComment": {';
				IF (NOT rqana ISNULL) THEN outstr = outstr || '"code": "http://id.eaufrance.fr/nsa/155#' || rqana || '"'; END IF;
				IF ((NOT rqana ISNULL) AND (NOT comlibelle ISNULL)) THEN outstr = outstr || ','; END IF;
				IF (NOT comlibelle ISNULL) THEN outstr = outstr || '"label": "' || comlibelle || '"'; END IF;
				outstr = outstr || '},'; 
		END IF;

		IF ((NOT difficulteana ISNULL) OR (NOT difanamnemo ISNULL)) 
			THEN 
				outstr = outstr || '"difficultyAna": {';
				IF (NOT difficulteana ISNULL) THEN outstr = outstr || '"code": "http://id.eaufrance.fr/nsa/43#' || difficulteana || '"'; END IF;
				IF ((NOT difficulteana ISNULL) AND (NOT difanamnemo ISNULL)) THEN outstr = outstr || ','; END IF;
				IF (NOT difanamnemo ISNULL) THEN outstr = outstr || '"label": "' || difanamnemo || '"'; END IF;
				outstr = outstr || '},'; 
		END IF;
		
		IF ((NOT difficulteprel ISNULL) OR (NOT difprelmnemo ISNULL)) 
			THEN 
				outstr = outstr || '"difficultySamp": {';
				IF (NOT difficulteprel ISNULL) THEN outstr = outstr || '"code": "http://id.eaufrance.fr/nsa/67#' || difficulteprel || '"'; END IF;
				IF ((NOT difficulteprel ISNULL) AND (NOT difprelmnemo ISNULL)) THEN outstr = outstr || ','; END IF;
				IF (NOT difprelmnemo ISNULL) THEN outstr = outstr || '"label": "' || difprelmnemo || '"'; END IF;
				outstr = outstr || '},'; 
		END IF;
		
		IF ((NOT cdmethfractionnement ISNULL) OR (NOT methnom ISNULL)) 
			THEN 
				outstr = outstr || '"fractionation": {';
				IF (NOT cdmethfractionnement ISNULL) THEN outstr = outstr || '"code": "http://id.eaufrance.fr/met/' || cdmethfractionnement || '"'; END IF;
				IF ((NOT cdmethfractionnement ISNULL) AND (NOT methnom ISNULL)) THEN outstr = outstr || ','; END IF;
				IF (NOT methnom ISNULL) THEN outstr = outstr || '"label": "' || methnom || '"'; END IF;
				outstr = outstr || '},'; 
		END IF;
		
		IF ((NOT cdmethodeprel ISNULL) OR (NOT methprelnom ISNULL)) 
			THEN 
				outstr = outstr || '"methodSamp": {';
				IF (NOT cdmethodeprel ISNULL) THEN outstr = outstr || '"code": "http://id.eaufrance.fr/met/' || cdmethodeprel || '"'; END IF;
				IF ((NOT cdmethodeprel ISNULL) AND (NOT methprelnom ISNULL)) THEN outstr = outstr || ','; END IF;
				IF (NOT methprelnom ISNULL) THEN outstr = outstr || '"label": "' || methprelnom || '"'; END IF;
				outstr = outstr || '},'; 
		END IF;
		
		IF ((NOT insituana ISNULL) OR (NOT insmnemo ISNULL)) 
			THEN 
				outstr = outstr || '"resultAcquisitionSource": {';
				IF (NOT insituana ISNULL) THEN outstr = outstr || '"code": "http://id.eaufrance.fr/met/' || insituana || '"'; END IF;
				IF ((NOT insituana ISNULL) AND (NOT insmnemo ISNULL)) THEN outstr = outstr || ','; END IF;
				IF (NOT insmnemo ISNULL) THEN outstr = outstr || '"label": "' || insmnemo || '"'; END IF;
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
			
			-- codemasseeau: WFD:WaterBody (wfd waterbody code)
			  -- http://id.eaufrance.fr/cea/' || codemasseeau
			-- codesousbassin: WFD:RiverBasin (wfd sub-unit code)
			  -- http://id.eaufrance.fr/cea/' || codesousbassin
			-- codebassin: WFD:RiverBasin (wfd river basin district code)
			  -- http://id.eaufrance.fr/cea/' || codebassin
			-- codecommune: http://data.ign.fr/def/geofla#Commune
			  -- http://id.insee.fr/geo/commune/' || codecommune
			-- codedepartement: http://data.ign.fr/def/geofla#Departement
			  -- http://id.insee.fr/geo/departement/' || codedepartement			       
			-- coderegion: http://data.ign.fr/def/geofla#Region
			  -- http://id.insee.fr/geo/region/' || coderegion					      
			-- codecourseau: HY_Waterbody (river segment)
			  -- http://id.eaufrance.fr/mdo/' || codecourseau					       

			
			
			IF ((NOT codemasseeau ISNULL) OR (NOT codeeumasseeau ISNULL) OR (NOT libellemasseeau ISNULL) OR 
				(NOT codesousbassin ISNULL) OR (NOT libellesousbassin ISNULL) OR 
				(NOT codebassin ISNULL) OR (NOT codeeubassin ISNULL) OR (NOT libellebassin ISNULL)) OR
				(NOT codecommune ISNULL) OR (NOT libellecommune ISNULL) OR
				(NOT codedepartement ISNULL) OR (NOT libelledepartement ISNULL) OR
				(NOT coderegion ISNULL) OR (NOT libelleregion ISNULL) OR
				(NOT codecourseau ISNULL) OR (NOT libellecourseau ISNULL)
 
				THEN 
					outstr = outstr || ', "related": [';
					IF ((NOT codemasseeau ISNULL) OR (NOT codeeumasseeau ISNULL) OR (NOT libellemasseeau ISNULL))
						THEN
							outstr = outstr || '{';
							IF (NOT codemasseeau ISNULL) THEN outstr = outstr || '"@id": "http://id.eaufrance.fr/cea/' || codemasseeau || '",'; END IF;
							IF ((NOT codemasseeau ISNULL) OR ((NOT codeeumasseeau ISNULL) OR (NOT libellemasseeau ISNULL))) THEN outstr = outstr || '"@type": "HY_Waterbody"'; END IF;
							IF (NOT codeeumasseeau ISNULL) THEN outstr = outstr || ', "EUcode": "' || codeeumasseeau || '"'; END IF;
							IF (NOT libellemasseeau ISNULL) THEN outstr = outstr || ', "name": "' || sta.clean(libellemasseeau) || '"'; END IF;
							outstr = outstr || '},';
						END IF;			
						
					IF ((NOT codesousbassin ISNULL) OR (NOT libellesousbassin ISNULL))
						THEN
							outstr = outstr || '{';
							IF (NOT codesousbassin ISNULL) THEN outstr = outstr || '"@id": "http://id.eaufrance.fr/cea/' || codesousbassin || '",'; END IF;
							IF ((NOT codesousbassin ISNULL) OR ((NOT codeeumasseeau ISNULL) OR (NOT libellesousbassin ISNULL))) THEN outstr = outstr || '"@type": "WFD:RiverBasin"'; END IF;
							IF (NOT libellesousbassin ISNULL) THEN outstr = outstr || ', "name": "' || sta.clean(libellesousbassin) || '"'; END IF;
							outstr = outstr || '},';
						END IF;							

					IF ((NOT codebassin ISNULL) OR (NOT codeeubassin ISNULL) OR (NOT libellebassin ISNULL))
						THEN
							outstr = outstr || '{';
							IF (NOT codebassin ISNULL) THEN outstr = outstr || '"@id": "http://id.eaufrance.fr/cea/' || codebassin || '",'; END IF;
							IF ((NOT codebassin ISNULL) OR ((NOT codeeubassin ISNULL) OR (NOT libellebassin ISNULL))) THEN outstr = outstr || '"@type": "WFD:RiverBasin"'; END IF;
							IF (NOT codeeubassin ISNULL) THEN outstr = outstr || ', "EUcode": "' || codeeubassin || '"'; END IF;
							IF (NOT libellebassin ISNULL) THEN outstr = outstr || ', "name": "' || sta.clean(libellebassin) || '"'; END IF;
							outstr = outstr || '},';
						END IF;						
						
						IF ((NOT codecommune ISNULL) OR (NOT libellecommune ISNULL)) 
							THEN 
							outstr = outstr || '{';
								IF (NOT codecommune ISNULL) 
									THEN outstr = outstr || '"@id": "http://id.insee.fr/geo/commune/' || codecommune || '",'; END IF;
								IF ((NOT codecommune ISNULL) OR (NOT libellecommune ISNULL)) 
									THEN outstr = outstr || '"@type": "http://data.ign.fr/def/geofla#Commune"'; END IF;
								IF (NOT libellecommune ISNULL) THEN outstr = outstr || ', "name": "' || sta.clean(libellecommune) || '"'; END IF;
								outstr = outstr || '},';
						END IF;
						
						IF ((NOT codedepartement ISNULL) OR (NOT libelledepartement ISNULL)) 
							THEN 
							outstr = outstr || '{';
								IF (NOT codedepartement ISNULL) 
									THEN outstr = outstr || '"@id": "http://id.insee.fr/geo/departement/' || codedepartement || '",'; END IF;
								IF ((NOT codedepartement ISNULL) OR (NOT libelledepartement ISNULL)) 
									THEN outstr = outstr || '"@type": "http://data.ign.fr/def/geofla#Departement"'; END IF;
								IF (NOT libelledepartement ISNULL) THEN outstr = outstr || ', "name": "' || sta.clean(libelledepartement) || '"'; END IF;
								outstr = outstr || '},';
						END IF;						

						IF ((NOT coderegion ISNULL) OR (NOT libelleregion ISNULL)) 
							THEN 
							outstr = outstr || '{';
								IF (NOT coderegion ISNULL) 
									THEN outstr = outstr || '"@id": "http://id.insee.fr/geo/region/' || coderegion || '",'; END IF;
								IF ((NOT coderegion ISNULL) OR (NOT libelleregion ISNULL)) 
									THEN outstr = outstr || '"@type": "http://data.ign.fr/def/geofla#Region"'; END IF;
								IF (NOT libelleregion ISNULL) THEN outstr = outstr || ', "name": "' || sta.clean(libelleregion) || '"'; END IF;
								outstr = outstr || '},';
						END IF;						

						IF ((NOT codecourseau ISNULL) OR (NOT libellecourseau ISNULL)) 
							THEN 
							outstr = outstr || '{';
								IF (NOT codecourseau ISNULL) 
									THEN outstr = outstr || '"@id": "http://id.eaufrance.fr/mdo/' || codecourseau || '",'; END IF;
								IF ((NOT codecourseau ISNULL) OR (NOT libellecourseau ISNULL)) 
									THEN outstr = outstr || '"@type": "WFD:WaterBody"'; END IF;
								IF (NOT libellecourseau ISNULL) THEN outstr = outstr || ', "name": "' || sta.clean(libellecourseau) || '"'; END IF;
								outstr = outstr || '},';
						END IF;							
					
					outstr = btrim(outstr,',') || ']';
			END IF;			
			
			
			outstr = outstr || '}';
    END LOOP;
		CLOSE cur_stat;
	RETURN outstr;
END

$function$
;
