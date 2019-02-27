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
DROP MATERIALIZED VIEW sta.senbase cascade;

CREATE MATERIALIZED VIEW sta.senbase
AS SELECT analyse_physicochimie.cdmethana
   FROM physicochimie.analyse_physicochimie
   WHERE NOT pc.cdprelevement is NULL
  GROUP BY analyse_physicochimie.cdmethana;
  
-- base view for the creation of OBS_PROPERTIES
DROP MATERIALIZED VIEW sta.propbase cascade;

CREATE MATERIALIZED VIEW sta.propbase
AS SELECT analyse_physicochimie.cdparametre
   FROM physicochimie.analyse_physicochimie
   WHERE NOT pc.cdprelevement is NULL
GROUP BY analyse_physicochimie.cdparametre;

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










