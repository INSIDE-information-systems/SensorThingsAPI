# Database Views
For the transformation of the Fairy Data to the FROST database structures, materialized views were created. 
A first set of base views were created for features requiring complex join structures (01-baseviews.sql):
- dsbase: base view for the creation of DATASTREAMS
- sampbase: base view for the creation of FEATURES
- senbase: base view for the creation of SENSORS
- sta_net: base view for linking multiple networks to a station (THINGS)

Based on these as required, materialized views were created for the basic FROST database tables:
- DATASTREAMS: 02-Views-Datastreams.sql
- FEATURES: 02-Views-Features.sql
- LOCATIONS: 02-Views-Locations.sql
- OBS_PROPERTIES: 02-Views-ObsProperties.sql
- OBSERVATIONS: 02-Views-Observations.sql
- SENSORS: 02-Views-Sensors.sql
- THINGS: 02-Views-Things.sql
- THINGS_LOCATIONS: 02-Views-ThingsLocations.sql

Based on these materialized views, new numeric ids are generated from the string ids (03-Views-IdGeneration.sql):
- sta.location_ids
- sta.thing_ids
- sta.datastream_ids
- sta.feature_ids

Sensors, ObservedProperties and Observations already have numeric ids. (TODO: CHECK!)


In addition, several pl/sql functions were created for the creation of the JSON structures required under the properties attribute:
- obs_prop: JSON properties for OBSERVSTIONS
- thg_prop: JSON properties for THINGS
- sta_nets: JSON object containing the list of networks for a station (THINGS)
- clean_str: filter to remove tabs and " characters that cause issues with the JSON encoding



