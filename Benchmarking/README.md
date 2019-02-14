# Intro

In order to assure that the Fraunhofer FROST implementation together with the underlying PostgreSQL DB meet BRGM's performance requirements, further benchmarking activities are being undertaken. For this purpose, the French Fairy DB has been transformed to the requirements of FROST, and creative queries are being formulated to mimic the spectrum of real-world requirements and thus gauge system response times.

# SQL
For the transformation of the Fairy Data to the FROST database structures, materialized views were created. 
A first set of base views were created for features requiring complex join structures. Based on these as required, materialized views were created for the basic FROST database tables. The content of these views was then copied to the tables from a FROST deployment, whereby the data was reindexed to remove the string values coming from some of the referenced codes in the source data (the views rely on a concatenation of code strings as ids).

# FROSTie

The FROST deployment is available at:
https://brgm.docker01.ilt-dmz.iosb.fraunhofer.de/v1.0/

Viewer at:
https://wg-brgm.docker01.ilt-dmz.iosb.fraunhofer.de/servlet/is/101/

## Nice example for time series:
- Measurement of Nitrates in Eau on Phase aqueuse de l'eau (filtrée, centrifugée...) at La Dordogne à Cenac with method Méthode inconnue
- Measurement of Nitrates in Eau on Phase aqueuse de l'eau (filtrée, centrifugée...) at La Dordogne à Cenac with method Méthode spécifique
- Measurement of Nitrates in Eau on Phase aqueuse de l'eau (filtrée, centrifugée...) at La Dordogne à Cenac with method Qualité de l'eau - Dosage des ions fluorure,chlorure,nitrite,orthophosphate,bromure,nitrate et sulfate dissous,par chromatographie des ions en phase liquide - Partie 1: méthode applicable pour les eaux faiblement contaminées (NF EN ISO 10304-1 -Juin 1995)
- Measurement of Nitrites in Eau on Eau brute at La Dordogne à Cenac with method Méthode inconnue
- Measurement of Nitrites in Eau on Phase aqueuse de l'eau (filtrée, centrifugée...) at La Dordogne à Cenac with method Méthode inconnue
- Measurement of Nitrites in Eau on Phase aqueuse de l'eau (filtrée, centrifugée...) at La Dordogne à Cenac with method Qualité de l'eau - Détermination de paramètres sélectionnés par des systèmes d'analyse discrète - Partie 1 : ammonium, nitrate, nitrite, chlorure, orthophosphate, sulfate et silicate par détection photométrique (NF ISO 15923-1 Janvier 2014 )


# Target

Should support the requirements of:
- http://www.naiades.eaufrance.fr/acces-donnees#/physicochimie
- Example: http://www.naiades.eaufrance.fr/acces-donnees#/physicochimie/resultats?debut=14-02-2016&fin=14-02-2019&stations=03052338