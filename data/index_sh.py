import sys
sys.path.append('/home/renlei/work/stock/tushare' )
import tushare as ts

# This program accept 3 parameters:
# python3 index_sh.py <start_date> <end_date> <data_file>
start = sys.argv[1]
end = sys.argv[2]
data_file = sys.argv[3]

results = ts.get_hist_data('sh', start=start, end=end )
results.to_json(data_file, orient='index' )
