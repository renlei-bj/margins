#!/bin/bash

####################################################
# This is the main program
# It does not need arguments
####################################################

set -x

# some global variables
. ./global_env.sh

# calculate the date of start
seconds=$(expr 600 \* 86400 + 86400)
now=$(date +%s )
start_second=$(expr $now - $seconds )
start_date=$(date -d @$start_second +%Y-%m-%d )
end_date=$(date +%Y-%m-%d )

# start to get historical data
# steps:
# 1. get the margins data
# 2. get the market index data
# 3. get the margin details data
# 4. make the new dimensions on codes and days

# the following function is the function for all above 4 steps.
# it accepts 8 parameters:
# 1. collection name
# 2. share code
# 3. mongo latest script name
# 4. start date
# 5. end date
# 6. python program name
# 7. data file name
# 8. mongo insert script name
# for one query, the window width is equal to or smaller than 10 days

function get_data()  {
    local latest_date=$(mongo --quiet --eval "var param_collection_name = \"$1\"; var param_code = \"$2\"; var param_start_date = \"$4\";" stock $3 )

    if [ "$latest_date" == "undefined" ]; then
        latest_date=$4
    fi

    local temp_second=$(date -d $latest_date +%s )
    local temp_second_2=$(expr $temp_second + 86400 )
    latest_date=$(date -d @$temp_second_2 +%Y-%m-%d )

    if [ "$latest_date" \< "$5" ]; then
        python3 $6 $latest_date $5 $7 $2
        mongo --quiet --eval "var param_collection_name = \"$1\"; var param_code = \"$2\"; var param_data_file = \"$7\";" stock $8
    fi
}

# steps start
final_end=$(expr $now + 864000 )
temp_end=$(expr $start_second + 864000 )
while [ $temp_end -lt $final_end ]; do
    temp_end_date=$(date -d @$temp_end +%Y-%m-%d )
    get_data $collection_margins_sh sh  $js_latest  $start_date $temp_end_date  $py_margins_sh  $data_margins_sh    $js_margins_sh
    get_data $collection_index_sh   sh  $js_latest  $start_date $temp_end_date  $py_index_sh    $data_index_sh  $js_index_sh
    get_data $collection_margin_details_sh  sh  $js_latest  $start_date $temp_end_date  $py_margin_details_sh   $data_margin_details_sh $js_margin_details_sh
    temp_end=$(expr $temp_end + 864000 )
done;

mongo --quiet stock refresh_margin_dimensions.js

# now for each share, get its historical data
share_list=$(mongo --quiet stock get_margin_codes.js )
for share in $share_list; do
    get_data $collection_shares_sh  $share  $js_share_latest    $start_date $end_date   $py_share_sh    $data_share_sh  $js_share_sh
done
exit 0
