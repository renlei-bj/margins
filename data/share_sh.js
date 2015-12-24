// Insert json data to the specific collection,

var data = cat(param_data_file );
var records = JSON.parse(data );
var collection = db.getCollection(param_collection_name );

for(var key in records )
{
    var record = records[key];
    record.date = key;
    record.code = param_code;
    collection.insert(record );
}

collection.ensureIndex({"date": -1} );
collection.ensureIndex({"code": 1} );
collection.ensureIndex({"code": 1, "date": -1 } );
