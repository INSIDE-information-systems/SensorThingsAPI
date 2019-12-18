# Linking

We need a way to link between various objects, internal and external. 
Since the SensorThings API v1.x does not have special fields for links, the links will have to go in the properties field that each entity type has.

## Internal links

To be funktional, internal links need:
- The entity id of the target entity
- The entity type of the target entity
- The name of the link

Furthermore, they need to be formatted in a way that the server can easily detect the links.
This makes it possible for FROST to generate absolute URLs for these links, and allow searching and expanding of the links.

### Using special property names

The SensorThings API uses a special @ notation for internal properties:
- Entity ids in STA are labelled @iot.id
- Navigation links are <TargetEntityType>@iot.navigationLink
- Counts for navigation links are <TargetEntityType>@iot.count
- Nextlinks are @iot.nextLink

We could introduce something similar. When linking to another Entitiy, add an entry to the properties map like:

    "<linkName>@<Target Type>.iot.id": <Target Entity Id>
    "building@Thing.iot.id": 45
    "sensorType@Sensor.iot.id": 16
    "aggregateFor@Datastream.iot.id": "123e4567-e89b-12d3-a456-426655440000"

The server can operate on these, for instance by adding a navigationLink when returning the properties:

    GET v1.0/Things(1)
    {
        "properties" : {
            "building@Thing.iot.id": 45,
            "building@iot.navigationLink": "http://example.org/FROST-Server/v1.0/Things(45)
        }
    }

The server can support $expand on these entities, including the full target entity next to the link:

    GET v1.0/Things(1)?$expand=properties/building
    {
        "properties" : {
            "building@Thing.iot.id": 45,
            "building": { <expanded Thing> }
        }
    }

When updating or creating entities, if there is a property of the type `<linkName>@<Target Type>.iot.id` then the property `<linkName>` and all other properties starting with `<linkName>@` will be removed by the server before storing the properties.


### Registering & announcing links

The behaviour described above can be exposed by a server without the server knowing in advance which links exist.
When formatting the results of a request, the server can iterate through the properties, and generate any required navigationLinks and expands.
To enable efficient filtering on these properties, the server will need to know which links (may) exist before fetching data from the database.
Pre-registering the existing links on the server will also allow the server to announce the existence of those links, and their semantics, to clients.
It also makes it possible for the server to generate back-links from the entities that are linked to, but the details for that still need to be specified.

Pre-registered links are announced in the `serverSettings` part of the server root document.

    {
      "serverSettings": {
        "conformance": [
          "<our requirement class uri>"
        ],
        "<our requirement class uri>": {
          "registeredLinks": {
            "<sourceType>/properties/<linkName>": {
              "targetType": "<targetType>",
              "description": "A human readable description of the link"
            }
          }
        }
      }
    }

By specifying the full path, links do not have to be top-level entries in the properties object, but can be nested deeper.
For example: `"Thing/properties/links/building@Thing": "The building a room is part of."`

## Open issues

Some things are not specified yet and are in need of discussion:

- Cardinality many-to-many: 




