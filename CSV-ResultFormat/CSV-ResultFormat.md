# CSV ResultFormat

In order to make STA data more accessible, it would be valuable to provide a simple CSV result format.
Since many users still like to work with data in spreadsheet applications, a CSV result format would help convincing people to use STA.

https://github.com/INSIDE-information-systems/SensorThingsAPI/issues/3


## Single Table

ResultFormat=CSV for single-table queries is mostly self-explanatory. 
The header line contains the direct field names, with each further line having the data of one entity.
Navigation links are omitted.

Tricky parts are how to handle:

- the "properties" field: This is a complex property with an unknown set of fields.
  The only way to deal with this is to include the JSON as is.
  Proper encoding to CSV needs to happen, since JSON contains both double quotes and commas, same as CSV, but this is covered by [RFC 4180](https://tools.ietf.org/html/rfc4180) which defines that double quotes are quoted with a double quote.
- Datastream/unitOfMeasurement: This is a complex property with three defined fields. 
  The best way seems to be to split this field into three CSV columns: `unitOfMeasurement/name,unitOfMeasurement/symbol,unitOfMeasurement/definition`

For example:

    id,name,unitOfMeasurement/name,unitOfMeasurement/symbol,unitOfMeasurement/definition
    1,My Datastream,degree celcius,°C,ucum:Cel
    2,My other Datastream,degree celcius,°C,ucum:Cel

The format returned when fetching a list of entities, or a single entitiy can be the same.


## $expand

Single table results are a nice start of course, but the power of the SensorThings API lies in its advanced features.
One of the great features is $expand, that allows multi-table results.


### with single cardinality

Expanding relations with a cardinality of 1, such as Observation->Datastream or Datastream->Thing is easy.
The fields of the expanded EntityType are added to the header, prefixed with the expanded with the navigation link name.

    id,result,phenomenonTime,Datastream/id,Datastream/name
    1,2.9,2005-08-03T23:00:00.000Z,1,My Datastream
    2,2.8,2005-08-03T23:01:00.000Z,1,My Datastream

This will duplicate some data, but the data would also be duplicated in the normal result format.


### single expand with many cardinality

A very common expand is to request Datastreams, with their Observations expanded, or Things, with Datastreams, with Observations.
In a CSV format, this will duplicate the row for the primary table, for each item in the expanded table.

    id,name,Observations/id,Observations/result,Observations/phenomenonTime
    1,My Datastream,1,2.9,2005-08-03T23:00:00.000Z
    1,My Datastream,2,2.8,2005-08-03T23:01:00.000Z


### multiple expands with many cardinality

There are three situations where an entity can have two or more expands with a cardinality of many: 

1. `v1.1/Things?$expand=Locations,Datastreams,HistoricalLocations`
2. `v1.1/Locations?$expand=Things,HistoricalLocations`
3. `v1.1/MultiDatastreams?$expand=ObservedProperties,Observations`

The Tasking Core specification adds TaskingCapabilities to Things, which adds a fourth expand to Thing entities.

Furthermore, these expands with cardinality many may appear begind other expands:

    v1.1/HistoricalLocations?$expand=Thing($expand=Locations,Datastreams)

This would lead to very complex rules for defining what data should go in each row of the CSV output.
Therefore expands with a cardinality of many are restricted to a single chain.
All other expands must be of cardinality one, or have a `$top=1` parameter, turning it into an expand with a cardinality of 1.
Having a non-allowed set of expands will lead to a HTTP 400 Bad Request error.

Allowed examples:

    v1.1/Things?$expand=Datastreams
    v1.1/Things?$expand=Datastreams($expand=Observations)
    v1.1/Things?$expand=Datastreams($expand=ObservedProperty,Observations)
    v1.1/Things?$expand=Datastreams,Locations($top=1)
    v1.1/Datastreams?$expand=ObservedProperty,Observations($expand=FeatureOfInterest)

Disallowed examples:

    v1.1/Things?$expand=Datastreams,Locations
    v1.1/Datastreams?$expand=Observations,Thing($expand=Locations)


## MultiDatastreams

MultiDatastreams bring their own set of complications:

- `MultiDatastreams/unitsOfMeasurement` is an array of objects, each with 3 fields
- `MultiDatastreams/multiObservationDataTypes` is an array of strings
- `MultiDatastreams/ObservedProperties` is a navigationList with cardinality many
- `MultiDatastreams/Observations/result` is an array

These four arrays/lists are of the same length for any given MultiDatastream, but may be of different length for the next MultiDatastream.
Furthermore, the order of the items in these lists is important.

Options for dealing with MultiDatastreams are:

- Not allow MultiDatastreams in the CSV resultFormat (avoids the problem)
- Encoding the unitsOfMeasurement, multiObservationDataTypes, ObservedProperties and Observations/result sets as json arrays in a single CSV line
- Returning a line for each entry in unitsOfMeasurement, multiObservationDataTypes, ObservedProperties and Observations/result

The last option essentially breaks Observations of a MultiDatastream back into normal Observations.




