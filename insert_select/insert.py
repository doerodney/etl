import argparse
import datetime
import sys
import sqlite3


def create_dest_table(rows, columns, conn, cur):
	pass


def create_source_table(rows, columns, conn, cur):
	table_name = 'source'
	
	# delete the table if it exists.
	drop_sql = 'drop table if exists %s;' % table_name
	
	
	create_sql = 'create table %s(' % table_name
	pkey sql = '  source_id integer autoincrement primary key,'
	column_sql_list = [
		get_column_name(i) for i in range(columns)
	]	
	final_sql = ');'
	
	sql = '%s, %s, %s' % (create_sql, ','.join(column_sql_list)', final_sql)

	


def get_column_name(index):
	name = 'column%d' % index
	return name
	

def load_source_table(rows, columns, conn, cur):
	pass


def insert_into_dest_table(rows, columns, conn, cur):
	pass


def run_test(rows, columns, conn, cur):
    start = datetime.datetime.now()
    process_date = str(datetime.date.today())

    cur.close()
    conn.close()

    end = datetime.datetime.now()
    duration_ms = int(1000 * (end - start).total_seconds())
    print('Processed %d changed rows and %d new rows in %d milliseconds.' % (count_changed_rows, count_new_rows, duration_ms))

def main():
	"""
	Creates and loads a table of specified number of rows and columns.
	"""	
	parser = argparse.ArgumentParser()
	parser.add_argument('--rows', dest='rows', type=int, default=10, help='Count of rows to generate')
	parser.add_argument('--columns', dest='columns', type=int, default=4, help='Count of columns to generate')
	args = parser.parse_args()
	print('rows: %d, columns: %d' % (args.rows, args.columns))
	
	database_file = 'insert_test.sqlite3'
	conn = None
	cur = None

	try:
		conn = sqlite3.connect(database_file)
	except:
		print('Cannot open connection to %s' % database_file)
		for msg in sys.exc_info():
				print(msg)

	try:
		cur = conn.cursor()
	except:
		print('Cannot creaate cursor.')
		for msg in sys.exc_info():
				print(msg)

	run_test(rows, columns, conn, cur)
	cur.close()
  conn.close()

		
if __name__ == '__main__':
    main()







