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
  Proper encoding to CSV needs to happen, since JSON contains both double quotes and commas, same as CSV, but this is covered by RFC 4180 (https://tools.ietf.org/html/rfc4180).
  Double quotes are quoted with a double quote.
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

There are three situations where an entity can have two expands with a cardinality of many: 

1. `Things?$expand=Locations,Datastreams,HistoricalLocations`
2. `Locations?$expand=Things,HistoricalLocations`
3. `MultiDatastreams?$expand=ObservedProperties,Observations`

The Tasking Core specification adds TaskingCapabilities to Things, but this does not change much.

Furthermore, these expands with cardinality many may appear begind other expands:

    HistoricalLocations?$expand=Thing($expand=Locations,Datastreams)

This would lead to very complex rules for defining what data should go in each row of the CSV output.
Therefore it seems best to limit $expand to a single item with a cardinality of many, on the top-level only, unless the $expand has a `$top=1` parameter, turning it into an expand with a cardinality of 1. This to allow the fetching of Things, with Datastreams, and the main Location. Thus the HistoricalLocations example above is not allowed in the CSV resultFormat. (TODO: Specify error code)


## MultiDatastreams

MultiDatastreams bring their own set of complications:

- `MultiDatastreams/unitsOfMeasurement` is an array of objects, each with 3 fields
- `MultiDatastreams/ObservedProperties` is a navigationList with cardinality many
- `MultiDatastreams/Observations/result` is an array

These three arrays/lists are of the same length for any given MultiDatastream, but may be of different length for the next MultiDatastream.
Furthermore, the order of the items in these lists is important.



