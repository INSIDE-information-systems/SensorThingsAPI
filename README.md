# Intro
Implementation of OGC SensorThing API for Environmental Data / Implementation du standard OGC SensorThings API pour les données environnementales
OGC SensorThings API Part 1: Sensing is implemented (OGC 15-078r6) : http://www.opengeospatial.org/standards/sensorthings

It was deployed on snapshots of two timeseries oriented databases / déploiement sur deux photos de bases du SIE
- French national groundwater level monitoring / base d'observation brute du niveau d'eau souterraine (BRGM)
- French national river height/flow monitoring / suivi hydrométrie (SCHAPI)

A light weight web client started during a hackathon (DanubeHack) was configured in a ProofOfConcept style to access SensoThings API endpoints
Un client web léger créé dans le cadre d'un hackathon (DanubeHack) a été configuré pour en mode preuve de concept pour accéder au endpoints SensorThings API déployés

# API
http://sensorthings.brgm-rec.fr/SensorThingsGroundWater/v1.0

http://sensorthings.brgm-rec.fr/SensorThingsFlood/v1.0

# requêtage des API
see requests example in the wiki / voir les exemples de requêtes dans le wiki

https://github.com/INSIDE-information-systems/SensorThingsAPI/wiki

# Client
Please be patient with the client as both client and server are proof of concept style, no production mode intended on those.
Soyez patient avec le client car à la fois client et serveur sotn des déploiement en mode preuve de concept. Ils ne sont pas des déploiements de production

http://sensorthings.brgm-rec.fr/SensorThingsGroundWaterViewer/map.html
http://sensorthings.brgm-rec.fr/SensorThingsFloodViewer/map.html

Both clients follow the same rationale / les clients utilisent la même logique
- Locations
- Things
- Datastreams
- Observations
