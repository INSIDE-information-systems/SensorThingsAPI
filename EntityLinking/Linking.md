# Linking

We need a way to link between various objects, internal and external. 
Since the SensorThings API v1.x does not have special fields for links, the links will have to go in the properties field that each entity type has.

## Internal

Optimally, internal links are formatted in a way that FROST can easily detect the links. This makes it possible for FROST to generate absolute URLs 
for these links, and allow searching and expanding of the links.

Internal links need:
- The entity id of the target entity
- The entity type of the target entity
- The name of the link

### Using special property names

The SensorThings API uses a special @ notation for internal properties:
- Entity ids in STA are labelled @iot.id
- Navigation links are <TargetEntityType>@iot.navigationLink
- Counts for navigation links are <TargetEntityType>@iot.count
- Nextlinks are @iot.nextLink

We could introduce something similar. When linking to another Entitiy, add an entry to the properties map like:

    "linkName@<Target Type>.iot.id": <Target Entity Id>
    "building@Thing.iot.id": 45
    "sensorType@Sensor.iot.id": 16
    "aggregateFor@Datastream.iot.id": "123e4567-e89b-12d3-a456-426655440000"

The server could operate on these, for instance by adding a navigationLink when returning the properties:

    GET v1.0/Things(1)
    {
        "properties" : {
            "building@Thing.iot.id": 45,
            "building@iot.navigationLink": "http://example.org/FROST-Server/v1.0/Things(45)
        }
    }

The server could support $expand on these entities, and maybe $filter:

    GET v1.0/Things(1)?$expand=properties/building
    {
        "properties" : {
            "building@Thing.iot.id": 45,
            "building": { <expanded Thing> }
        }
    }

Of course, when the server adds new data to the properties, care has to be taken when editing the Entitiy and storing it again, since that expanded entity or that navigationLink should not be pushed back into the properties field, though the server could detect the fact that there already is a property starting with `building@` and thus remove any other `building` properties.


