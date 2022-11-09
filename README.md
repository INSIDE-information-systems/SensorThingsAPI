# Intro

Work on OGC SensorThing API Part 1: Sensing for Environmental Data.
Contribution to the standard, maturation of a reference implementation (FROST) and help to foster its implementations in various domains.

- First on [V1 - OGC 15-078r6](http://docs.opengeospatial.org/is/15-078r6/15-078r6.html), then on [V 1.1 - OGC 18-088](https://www.ogc.org/standards/sensorthings)
- Link to the overall standard page (includes Part 2: Tasking Core): <http://www.opengeospatial.org/standards/sensorthings>

# Sensor Things and Water Data

## French Surface and ground water quantity prototype

A first prototype of OGC SensorThing API utilizing Fraunhofer FROST was deployed (2018) on snapshots of two timeseries oriented databases of the French Water Information System. Prototypes consolidated in 2020 to be dynamically fed (no data snapshot anymore) from either BRGM field sensors or French hydrometry service (SCHAPI) webservices (thus also using the API in Write mode).

- Data scope 
  - French national groundwater level monitoring - base d'observation brute du niveau d'eau souterraine (BRGM)
  - French national river height/flow monitoring - suivi hydrométrie (SCHAPI)

- Work further described here: <https://github.com/INSIDE-information-systems/SensorThingsAPI/tree/master/Surface_Ground_Water_Quantity_Prototype> with API endPoints.

- Data flows in Fraunhofer WebGenesis client: <https://wg-brgm.k8s.ilt-dmz.iosb.fraunhofer.de/servlet/is/110/>
  
- A light weight web client started during a hackathon (DanubeHack) was also configured in a ProofOfConcept style to access SensoThings API endpoints.

## Benchmarking performances on French surface water quality database

In order to assure that the Fraunhofer FROST implementation together with the underlying PostgreSQL DB meet BRGM and French Biodiversity Office (OFB) performance requirements, further benchmarking activities are being undertaken.
For this purpose, the French WaterNymph (Naïades) DB content was used (more than 130 000 000 observations).
was mapped to ST API data model to feed Fraunhofer FROST. Creative client queries were formulated to mimic the spectrum of real-world requirements, gauge system response times and tailor the system to compete with the BigData cluster used at that time to expose those observations.

- Work further described here: <https://github.com/INSIDE-information-systems/SensorThingsAPI/tree/master/Surface_Water_Quality_Bigdatavolume_Benchmarking> with API endPoints.

- Data flows in Fraunhofer WebGenesis client: <https://wg-brgm.k8s.ilt-dmz.iosb.fraunhofer.de/servlet/is/110/>

## USGS work

Surface water quantity, and quality. Ground water quantity.

- API Endpoint <https://labs.waterdata.usgs.gov/sta/v1.1/>

- Detailed discussion here: <https://github.com/FraunhoferIOSB/FROST-Server/discussions/611>

- Data flows in Fraunhofer WebGenesis client <https://api4inspire.k8s.ilt-dmz.iosb.fraunhofer.de/servlet/is/199/> (14000 stations, give it some time to load them :) ).
  
## BGS work

Ground water level, conductivity, salinity, …

- API endpoint, documentation, code, vidéo: <https://sensors.bgs.ac.uk/>

- Data flows in Fraunhofer WebGenesis client <https://wg-brgm.k8s.ilt-dmz.iosb.fraunhofer.de/servlet/is/193/>

# Sensor Things and Soils

## French polluted soils information system

A SensorThings pattern for Soil profiles and samples has been defined for the French polluted soils information system.
See the presentation done at OGC TC in Toulouse November 2019 (SensorThings SWG session): <https://external.opengeospatial.org/twiki_public/pub/GeoScienceDWG/WebHome/STA_for_Soils.pptx>

## INRAE (French Agronomic Institute) work

- on the French DONESOL database: <https://www.agro-bordeaux.fr/wp-content/uploads/2021/06/3_IGCS_2021_Christine_LEBAS_Clement_LATTELAIS_interoperabilite_donesol_diffusion.pdf>

- UMR SAS (Rennes): <https://github.com/Mario-35/api-sensorthing>
  
# Sensor Things and Marine waters

Other SensorThings pattern are being worked on with French Marine Agency (IFREMER) for

- Floats/buoys acquiring observations at various depths (thus varying Z observation)

  - Generic viewer: <https://sensorthings.geomatys.com/ifremer-webui>

  - Direct link to a Agro float: <https://sensorthings.geomatys.com/ifremer-webui/#/result;serviceUrl=https:%2F%2Fsensorthings.geomatys.com%2Fexamind%2FWS%2Fsts%2Fdefault;locationId=argo-2902402;location=argo-2902402>
  
- Bio (taxa) and chemical observations in Marine waters: WorkInProgress

# Sensor Things and Earth's critical zone

The French Research Infrastructure OZCAR working on the [Earth's critical zone](https://en.wikipedia.org/wiki/Earth's_critical_zone) is currently finalizing guidelines on how to implement SensorThings API Part 1: Sensing: <https://github.com/theia-ozcar-is/sensorthings-guidelines/>

# Endorsment as INSPIRE download service

During the [API4INSPIRE](https://datacoveeu.github.io/API4INSPIRE/) project and important effort was made to have OGC SensorThings API Part 1 officially allowed as an INSPIRE download service for Observations.

- https://inspire.ec.europa.eu/good-practice/ogc-sensorthings-api-inspire-download-service>
  