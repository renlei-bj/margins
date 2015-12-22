// Check the specific collection,
// Will delete the documents that earlier than the param_date.
// And return the latest date in this collection.
// Will return:
//     undefined,     if the collection is not existing;
//     undefined,     if the documents do not contain "date";
//     a date string, the date of the latest data.

var collection = db.getCollection(param_collection_name );
if( collection.exists() != null )
{
    collection.remove({"date": {"$lt": new Date(param_start_date ) } } );
    var cursor = collection.find().sort({"date": -1} ).limit(1);
    if(cursor.hasNext() )
    {
        var date = cursor.next();
        print(date.date );
    }
}
else
{
    print("undefined" );
}
