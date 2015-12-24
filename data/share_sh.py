import sys
sys.path.append('/home/renlei/work/stock/tushare' )
import tushare as ts

# This program accept 4 parameters:
# python3 index_sh.py <start_date> <end_date> <data_file> <share_code>
start = sys.argv[1]
end = sys.argv[2]
data_file = sys.argv[3]
code = sys.argv[4]

results = ts.get_hist_data(code, start=start, end=end )
results.to_json(data_file, orient='index' )
