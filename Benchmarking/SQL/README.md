# Database Views
For the transformation of the Fairy Data to the FROST database structures, materialized views were created. 
A first set of base views were created for features requiring complex join structures (01-baseviews.sql):
- dsbase: base view for the creation of DATASTREAMS from pc
- propbase: base view for the creation of OBS_PROPERTIES from pc and ce
- foibase: base view for the creation of FEATURES from pc
- senbase: base view for the creation of SENSORS from pc and ce
- sta_net: base view for linking multiple networks to a station (THINGS) from pc
- thgbase: base view for the creation of THINGS, LOCATIONS, THINGS_LOCATIONS from pc and ce

Some additional view were required for the provision of environmental conditions (01-BaseViews_CE.sql):
- ce_dsbase: base view for the creation of DATASTREAMS from ce
- ce_foibase: base view for the creation of FEATURES from ce

In addition, several pl/sql functions were created for the creation of the JSON structures required under the properties attribute (01-Functions.sql):
- foi_prop: JSON properties for FEATURES
- obs_prop: JSON properties for OBSERVSTIONS
- thg_prop: JSON properties for THINGS
- ds_prop: JSON properties for DATASTREAMS
- sta_nets: JSON object containing the list of networks for a station (THINGS)
- clean: filter to remove tabs and " characters that cause issues with the JSON encoding

Based on these as required, materialized views were created for the basic FROST database tables, whereby string ids where utilized for all tables other than SENSORS and OBS_PROPERTIES (bigint):
- DATASTREAMS: 02-Views-Datastreams.sql
  - id: lpad(pc.cdunitemesure, 5, '0') || lpad(pc.cdfractionanalysee, 3, '0') || lpad(pc.cdsupport, 3, '0') || 
			lpad(pc.cdparametre, 5, '0') || lpad(pc.cdmethana, 5, '0') || lpad(pc.cdstationmesureeauxsurface, 8, '0')
- CE_DATASTREAMS: 02-Views-CE_Datastreams.sql
  - id: lpad(ce.cdunitemesure, 5, '0') || 
			lpad(ce.cdparametre, 5, '0') || lpad(ce.cdmethode, 5, '0') || lpad(ce.cdstationmesureeauxsurface, 8, '0')
- FEATURES: 02-Views-Features.sql
  - id: pc.cdprelevement || lpad(pc.cdstationmesureeauxsurface, 8, '0') 
  - note: didn't pad cdprelevement as defined 100 char long, should be unique this way
- CE_FEATURES: 02-Views-CE_Features.sql
  - id: ce.codeoperationcep
- LOCATIONS: 02-Views-Locations.sql
  - id: pc.cdstationmesureeauxsurface
- OBS_PROPERTIES: 02-Views-ObsProperties.sql
  - id: pc.cdparametre::bigint
- OBSERVATIONS: 02-Views-Observations.sql
  - id: pc.id::bigint
- SENSORS: 02-Views-Sensors.sql
  - id: pc.cdmethana::bigint
- THINGS: 02-Views-Things.sql
  - id: pc.cdstationmesureeauxsurface
- THINGS_LOCATIONS: 02-Views-ThingsLocations.sql
  - id: pc.cdstationmesureeauxsurface


Based on these materialized views, new numeric ids are generated from the string ids (03-Views-IdGeneration.sql):
- sta.location_ids
- sta.thing_ids
- sta.datastream_ids
- sta.feature_ids

Sensors, ObservedProperties and Observations already have numeric ids. (TODO: CHECK!)

From these generated IDs, and the materialized views, the data is copied into FROST tables(04-CopyData.sql).

## Updates ~17.2.19
- Added clean to all libelles
- removed insituana from DS and SENSORS IDs
- changed SENSORS and OBS_PROPERTIES, OBSERVATIONS IDs to numeric (taken from source DB, works!) - these should be maintained, as necessary for other links (either URIs to codelists, or related observations)
- moved all related features to "related" in THINGS
- filter on obsProps and thgs so only props or stations provided with observations (SENSORS was already filtered)
- added URI prefixes all over
- added insituana to OBS, also fixed (fixing) Phenomenon-time-end

