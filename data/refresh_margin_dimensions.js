db.d_margin_codes.drop();

var code_list = db.f_margin_details_sh.distinct("code" ).sort({"code" : 1 } );
for(var i in code_list )
{
    db.d_margin_codes.insert({"code": code_list[i] } );
}

db.d_margin_dates.drop();

var date_list = db.f_margin_details_sh.distinct("date" ).sort({"date" : 1 } );
for(var i in date_list )
{
    db.d_margin_dates.insert({"date": date_list[i] } );
}

db.d_margin_codes.ensureIndex({"code": 1 } );
db.d_margin_dates.ensureIndex({"date": 1 } );
