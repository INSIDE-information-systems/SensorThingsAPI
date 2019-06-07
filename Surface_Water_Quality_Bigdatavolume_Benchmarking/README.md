# Intro

In order to assure that the Fraunhofer FROST implementation together with the underlying PostgreSQL DB meet BRGM's performance requirements, further benchmarking activities are being undertaken. For this purpose, the French Fairy DB has been transformed to the requirements of FROST, and creative queries are being formulated to mimic the spectrum of real-world requirements and thus gauge system response times.

# SQL
For the transformation of the Fairy Data to the FROST database structures, materialized views were created.
A first set of base views were created for features requiring complex join structures. Based on these as required, materialized views were created for the basic FROST database tables. The content of these views was then copied to the tables from a FROST deployment, whereby the data was reindexed to remove the string values coming from some of the referenced codes in the source data (the views rely on a concatenation of code strings as ids).

# API endpoints
- BRGM end endPoint
  - http://sensorthings-wq.brgm-rec.fr/FROST-Server/v1.0

- Fraunhofer IOSB
  - The FROST deployment is available at:
https://brgm.docker01.ilt-dmz.iosb.fraunhofer.de/v1.0/
  - Viewer at:
https://wg-brgm.docker01.ilt-dmz.iosb.fraunhofer.de/servlet/is/101/

# API querying
## Nice example for time series:
- Station La Dordogne à Cenac: http://sensorthings-wq.brgm-rec.fr/FROST-Server/v1.0/Things(11949)
- All Datastreams for this Station: http://sensorthings-wq.brgm-rec.fr/FROST-Server/v1.0/Things(11949)/Datastreams
- All Datastreams measuring Nitrates for this station:
  - By ObservedProperty id: http://sensorthings-wq.brgm-rec.fr/FROST-Server/v1.0/Things%2811949%29/Datastreams?$filter=ObservedProperties/id+eq+1340
  
  - By ObservedProperty name : [http://sensorthings-wq.brgm-rec.fr/FROST-Server/v1.0/Things%2811949%29/Datastreams?$filter=ObservedProperties/name+eq+'Nitrates'](http://sensorthings-wq.brgm-rec.fr/FROST-Server/v1.0/Things%2811949%29/Datastreams?$filter=ObservedProperties/name+eq+%27Nitrates%27)
  
  - By ObservedProperty definition [http://sensorthings-wq.brgm-rec.fr/FROST-Server/v1.0/Things%2811949%29/Datastreams?$filter=ObservedProperties/definition+eq+'http://id.eaufrance.fr/par/Nitrates'](http://sensorthings-wq.brgm-rec.fr/FROST-Server/v1.0/Things%2811949%29/Datastreams?$filter=ObservedProperties/definition+eq+%27http://id.eaufrance.fr/par/Nitrates%27)
  
- Measurement of Nitrates in Eau on Phase aqueuse de l'eau (filtrée, centrifugée...) at La Dordogne à Cenac with method Méthode inconnue:
  [Direct Link](http://sensorthings-wq.brgm-rec.fr/FROST-Server/v1.0/Datastreams%286024103%29/Observations)
- Measurement of Nitrates in Eau on Phase aqueuse de l'eau (filtrée, centrifugée...) at La Dordogne à Cenac with method Méthode spécifique:
  [Direct Link](http://sensorthings-wq.brgm-rec.fr/FROST-Server/v1.0/Datastreams%286024442%29/Observations)
- Measurement of Nitrates in Eau on Phase aqueuse de l'eau (filtrée, centrifugée...) at La Dordogne à Cenac with method Qualité de l'eau - Dosage des ions fluorure,chlorure,nitrite,orthophosphate,bromure,nitrate et sulfate dissous,par chromatographie des ions en phase liquide - Partie 1: méthode applicable pour les eaux faiblement contaminées (NF EN ISO 10304-1 -Juin 1995):
  [Direct Link](http://sensorthings-wq.brgm-rec.fr/FROST-Server/v1.0/Datastreams%286024434%29/Observations)
- Measurement of Nitrites in Eau on Eau brute at La Dordogne à Cenac with method Méthode inconnue:
  [Direct Link](http://sensorthings-wq.brgm-rec.fr/FROST-Server/v1.0/Datastreams%286024102%29/Observations)

## wiki
More example will be added there

# Target

Should support the requirements of French surface water quality database (more than 130 000 000 observations)
- http://www.naiades.eaufrance.fr/acces-donnees#/physicochimie
- Example: http://www.naiades.eaufrance.fr/acces-donnees#/physicochimie/resultats?debut=14-02-2016&fin=14-02-2019&stations=03052338
