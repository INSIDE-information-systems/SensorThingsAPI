# Intro

In order to assure that the Fraunhofer FROST implementation together with the underlying PostgreSQL DB meet BRGM's performance requirements, further benchmarking activities are being undertaken. For this purpose, the French Fairy DB has been transformed to the requirements of FROST, and creative queries are being formulated to mimic the spectrum of real-world requirements and thus gauge system response times.

For the transformation of the Fairy Data to the FROST database structures, materialized views were created. 
A first set of base views were created for features requiring complex join structures:
- dsbase: base view for the creation of DATASTREAMS
- sampbase: base view for the creation of FEATURES
- senbase: base view for the creation of SENSORS
- sta_net: base view for linking multiple networks to a station (THINGS)

Based on these as required, materialized views were created for the basic FROST database tables:
- DATASTREAMS
- FEATURES
- LOCATIONS
- OBS_PROPERTIES
- OBSERVATIONS
- SENSORS
- THINGS
- THINGS_LOCATIONS






