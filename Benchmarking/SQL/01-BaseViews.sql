-- base view for the creation of DATASTREAMS
DROP MATERIALIZED VIEW sta.dsbase cascade;

CREATE MATERIALIZED VIEW sta.dsbase
AS SELECT pc.cdstationmesureeauxsurface,
    pc.cdmethana,
    pc.cdparametre,
    pc.cdsupport,
    pc.cdfractionanalysee,
    pc.cdunitemesure,
    min(pc.dateprel) AS mindateprel,
    max(pc.dateprel) AS maxdateprel,
    min(pc.heureprel) AS minheureprel,
    max(pc.heureprel) AS maxheureprel,
    min(pc.dateana) AS mindateana,
    max(pc.dateana) AS maxdateana,
    min(pc.heureana) AS minheureana,
    max(pc.heureana) AS maxheureana
   FROM physicochimie.analyse_physicochimie pc
   WHERE NOT pc.cdprelevement is NULL
  GROUP BY pc.cdstationmesureeauxsurface, pc.cdmethana, pc.cdparametre, pc.cdsupport, pc.cdfractionanalysee, pc.cdunitemesure;

-- base view for the creation of FEATURES
DROP MATERIALIZED VIEW sta.foibase cascade;

CREATE MATERIALIZED VIEW sta.foibase
AS SELECT pc.cdprelevement,
    pc.preleveur,
    pc.finaliteprel,
    pc.dateprel,
    pc.heureprel,
    pc.datefinprel,
    pc.heurefinprel,
    pc.cdstationmesureeauxsurface
   FROM physicochimie.analyse_physicochimie pc
   WHERE NOT pc.cdprelevement is NULL
  GROUP BY pc.cdprelevement, pc.preleveur, pc.finaliteprel, pc.dateprel, pc.heureprel, pc.datefinprel, pc.heurefinprel, pc.cdstationmesureeauxsurface;-- base view for the creation of SENSORS

-- base view for the creation of SENSORS, for both analyse_physicochimie & condition_environnementale
DROP MATERIALIZED VIEW sta.senbase cascade;

CREATE MATERIALIZED VIEW sta.senbase
AS 
with meths as (  
	SELECT pc.cdmethana meth
		FROM physicochimie.analyse_physicochimie pc
		WHERE NOT pc.cdprelevement IS NULL
		GROUP BY pc.cdmethana
		
	UNION  
		
	SELECT ce.cdmethode meth
		FROM physicochimie.condition_environnementale ce
		WHERE NOT ce.cdprelevement IS NULL
		GROUP BY ce.cdmethode  
)
select distinct meth from meths WHERE NOT meth IS NULL;	  
  
-- base view for the creation of OBS_PROPERTIES, for both analyse_physicochimie & condition_environnementale
DROP MATERIALIZED VIEW sta.propbase cascade;

CREATE MATERIALIZED VIEW sta.propbase AS with props as (  
	SELECT pc.cdparametre prop
		FROM physicochimie.analyse_physicochimie pc
		WHERE NOT pc.cdprelevement IS NULL
		GROUP BY pc.cdparametre		
		
	UNION  
		
	SELECT ce.cdparametre prop
		FROM physicochimie.condition_environnementale ce
		WHERE NOT ce.cdprelevement is NULL
		GROUP BY ce.cdparametre
		
)
select distinct prop from props WHERE NOT prop IS NULL;	

-- base view for the creation of THINGS
DROP MATERIALIZED VIEW sta.thgbase cascade;

CREATE MATERIALIZED VIEW sta.thgbase
AS SELECT analyse_physicochimie.cdstationmesureeauxsurface 
   FROM physicochimie.analyse_physicochimie
   WHERE NOT pc.cdprelevement is NULL
GROUP BY analyse_physicochimie.cdstationmesureeauxsurface;  

-- base view for linking multiple networks to a station (THINGS)
DROP MATERIALIZED VIEW sta.sta_net cascade;

CREATE MATERIALIZED VIEW sta.sta_net
AS SELECT stat.cdstationmesureeauxsurface,
    stat.codesandrerdd,
    net.libelle
   FROM physicochimie.analyse_physicochimie stat
     JOIN referentiel.reseau net ON stat.codesandrerdd::text = net.code::text
  WHERE NOT stat.codesandrerdd IS NULL AND  NOT pc.cdprelevement is NULL
  GROUP BY stat.cdstationmesureeauxsurface, stat.codesandrerdd, net.libelle;










