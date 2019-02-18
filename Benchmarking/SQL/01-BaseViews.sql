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
  GROUP BY pc.cdstationmesureeauxsurface, pc.cdmethana, pc.cdparametre, pc.cdsupport, pc.cdfractionanalysee, pc.cdunitemesure;

-- base view for the creation of FEATURES
DROP MATERIALIZED VIEW sta.sampbase cascade;

CREATE MATERIALIZED VIEW sta.sampbase
AS SELECT pc.cdprelevement,
    pc.preleveur,
        CASE
            WHEN pc.finaliteprel IS NULL THEN 'Unknown'::character varying
            ELSE pc.finaliteprel
        END AS finaliteprel,
    pc.dateprel,
    pc.heureprel,
        CASE
            WHEN pc.datefinprel IS NULL THEN 'Unknown'::text
            ELSE pc.datefinprel::text
        END AS datefinprel,
        CASE
            WHEN pc.heurefinprel IS NULL THEN 'Unknown'::text
            ELSE pc.heurefinprel::text
        END AS heurefinprel,
    pc.cdstationmesureeauxsurface
   FROM physicochimie.analyse_physicochimie pc
  GROUP BY pc.cdprelevement, pc.preleveur, pc.finaliteprel, pc.dateprel, pc.heureprel, pc.datefinprel, pc.heurefinprel, pc.cdstationmesureeauxsurface;

-- base view for the creation of SENSORS
DROP MATERIALIZED VIEW sta.senbase cascade;

CREATE MATERIALIZED VIEW sta.senbase
AS SELECT analyse_physicochimie.cdmethana
   FROM physicochimie.analyse_physicochimie
  GROUP BY analyse_physicochimie.cdmethana;
  
-- base view for the creation of OBS_PROPERTIES
DROP MATERIALIZED VIEW sta.propbase cascade;

CREATE MATERIALIZED VIEW sta.propbase
AS SELECT analyse_physicochimie.cdparametre
   FROM physicochimie.analyse_physicochimie
GROUP BY analyse_physicochimie.cdparametre;

  

-- base view for linking multiple networks to a station (THINGS)
DROP MATERIALIZED VIEW sta.sta_net cascade;

CREATE MATERIALIZED VIEW sta.sta_net
AS SELECT stat.cdstationmesureeauxsurface,
    stat.codesandrerdd,
    net.libelle
   FROM physicochimie.analyse_physicochimie stat
     JOIN referentiel.reseau net ON stat.codesandrerdd::text = net.code::text
  WHERE NOT stat.codesandrerdd IS NULL
  GROUP BY stat.cdstationmesureeauxsurface, stat.codesandrerdd, net.libelle;










