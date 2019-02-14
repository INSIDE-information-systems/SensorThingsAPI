# Database Views
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
