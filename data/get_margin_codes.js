db.d_margin_codes.drop();

var code_list = db.f_margin_details_sh.distinct("code" ).sort({"code" : 1 } );
for(var i in code_list )
{
    print(code_list[i] );
}
