// Insert json data to the specific collection,

var data = cat(param_data_file );
var records = JSON.parse(data );
var collection = db.getCollection(param_collection_name );

for(var key in records )
{
    var record = records[key];
    record.date = record.opDate;
    collection.insert(record );
}

collection.ensureIndex({"date": -1} );
