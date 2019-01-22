import argparse
import datetime
import random
import sys
import sqlite3


def create_dest_table(rows, columns, conn, cur):
    pass

  
def create_source_table(rows, columns, conn, cur):
    table_name = get_source_table_name()
    success = create_table(table_name, columns, conn, cur)
    print('Create table %s success: %s' % (table_name, str(success)) ) 

    
def create_table(table_name, column_count, conn, cur, drop_if_exists=False):
    success = True
    id_column = '%s_id' % table_name
    
    # drops the table if it exists.
    drop_sql = 'drop table if exists %s;' % table_name
    try:
        cur.execute(drop_sql)
        conn.commit()
        
    except sqlite3.Error as e:
        print(e)
        print(drop_sql)
        print('Cannot drop table %s.' % table_name)
        success = False
        
    if success:
        # creates the table.
        create_sql = 'create table %s(\n' % table_name
        pkey_sql = '  %s integer not null primary key autoincrement,\n' % id_column
        column_sql_list = [
            '  %s numeric not null' % get_column_name(i) for i in range(column_count)
        ]   
        final_sql = '\n);'

        sql = '%s%s%s%s' % (create_sql, pkey_sql, ',\n'.join(column_sql_list), final_sql)

        try:
            cur.execute(sql)
            conn.commit()
            
        except sqlite3.Error as e:
            print(e)
            print(sql)
            print('Cannot create table %s.' % table_name)
            success = False

    return success

def get_column_name(index):
    name = 'column%d' % index
    return name


def get_source_table_name():
    name = 'source'
    return name


def load_source_table(row_count, column_count, conn, cur):
    start = datetime.datetime.now()

    insert_sql = 'insert into %s' % get_source_table_name()
    column_list = [get_column_name(i) for i in range(column_count)]
    column_list_sql = str(tuple(column_list))
    values_list = []
    for _ in range(row_count):
        values = str(tuple([random.randint(0, 100) for _ in range(column_count)]))
        values_list.append(values)

    values_list_sql = ',\n'.join(values_list)

    sql = '''
    %s
    %s
    values
    %s;''' % (insert_sql, column_list_sql, values_list_sql)

    print(sql)

    end = datetime.datetime.now()
    duration_ms = int(1000 * (end - start).total_seconds())
    print('Processed in %d milliseconds.' % duration_ms)


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







