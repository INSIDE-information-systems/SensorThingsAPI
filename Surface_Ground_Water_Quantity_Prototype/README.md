# Intro
Prototype implementation of OGC SensorThing API for Environmental Data / Implementation du standard OGC SensorThings API pour les données environnementales
OGC SensorThings API Part 1: Sensing is implemented (OGC 15-078r6) : http://www.opengeospatial.org/standards/sensorthings

It is deployed on 2 live monitoring systems
- French national groundwater quantity monitoring using GPRS sensors (groundwater level, temperature, conductivity) (BRGM)
- French national river height/flow monitoring (SCHAPI)

A light weight web client started during a hackathon (DanubeHack) was configured in a ProofOfConcept style to access SensoThings API endpoints. It is not maintained.
A better demonstration of what is possible with those flows in a viewer is avaiblable in Fraunhofer IOSB WebGenesis


# API
- Ground water: http://sensorthings.brgm-rec.fr/SensorThingsGroundWater/v1.1

- River monitoring : https://iddata.eaufrance.fr/api/stapiHydrometry

# requêtage des API
see requests example in the wiki / voir les exemples de requêtes dans le wiki

https://github.com/INSIDE-information-systems/SensorThingsAPI/wiki

# Client
https://wg-brgm.docker01.ilt-dmz.iosb.fraunhofer.de/servlet/is/101/
