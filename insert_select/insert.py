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
    
    
    create_sql = 'create table %s(\n' % table_name
    pkey_sql = '  %s integer autoincrement primary key,\n' % get_source_table_id_column_name()
    column_sql_list = [
        '  %s numeric not null' % get_column_name(i) for i in range(columns)
    ]   
    final_sql = '\n);'
    
    sql = '%s%s%s%s' % (create_sql, pkey_sql, ',\n'.join(column_sql_list), final_sql)
    
    print(sql)
    

def get_column_name(index):
    name = 'column%d' % index
    return name


def get_source_table_id_column_name():
    name = 'source_id'
    return name


def load_source_table(rows, columns, conn, cur):
    pass


def insert_into_dest_table(rows, columns, conn, cur):
    pass


def run_test(rows, columns, conn, cur):
    start = datetime.datetime.now()
    process_date = str(datetime.date.today())

    create_source_table(rows, columns, conn, cur)
    load_source_table(rows, columns, conn, cur)

    end = datetime.datetime.now()
    duration_ms = int(1000 * (end - start).total_seconds())
    print('Processed in %d milliseconds.' % duration_ms)

                                                
def main():
    """
    Creates and loads a table of specified number of rows and columns.
    """ 
    parser = argparse.ArgumentParser()
    parser.add_argument('--rows', dest='rows', type=int, default=10, help='Count of rows to generate')
    parser.add_argument('--columns', dest='columns', type=int, default=4, help='Count of columns to generate')
    args = parser.parse_args()
    print('rows: %d, columns: %d' % (args.rows, args.columns))
    
    database_file = './insert_test.sqlite3'
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

    run_test(args.rows, args.columns, conn, cur)
    cur.close()
    conn.close()

        
if __name__ == '__main__':
    main()







