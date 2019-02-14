# Intro
Implementation of OGC SensorThing API for Environmental Data / Implementation du standard OGC SensorThings API pour les données environnementales
OGC SensorThings API Part 1: Sensing is implemented (OGC 15-078r6) : http://www.opengeospatial.org/standards/sensorthings

# Prototype
A first prototype of OGC SensorThing API utilizing Fraunhofer FROST was deployed on snapshots of two timeseries oriented databases / déploiement sur deux photos de bases du SIE
- French national groundwater level monitoring / base d'observation brute du niveau d'eau souterraine (BRGM)
- French national river height/flow monitoring / suivi hydrométrie (SCHAPI)

A light weight web client started during a hackathon (DanubeHack) was configured in a ProofOfConcept style to access SensoThings API endpoints
Un client web léger créé dans le cadre d'un hackathon (DanubeHack) a été configuré pour en mode preuve de concept pour accéder au endpoints SensorThings API déployés

# Benchmarking
In order to assure that the Fraunhofer FROST implementation together with the underlying PostgreSQL DB meet BRGM's performance requirements, further benchmarking activities are being undertaken. For this purpose, the French Fairy DB has been transformed to the requirements of FROST, and creative queries are being formulated to mimic the spectrum of real-world requirements and thus gauge system response times.

