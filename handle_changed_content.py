import datetime
import sys
import sqlite3

def run(event, context):
    start = datetime.datetime.now()
    process_date = str(datetime.date.today())

    # Discovers rows that must be modified in the dimension.
    select_dim_rows_to_modify_sql = '''
    select composer, title, duration from d_music where modified is null
    except
    select
        d.composer,
        d.title,
        d.duration
    from d_music d
    inner join s_music s on
    s.composer = d.composer and
    s.title = d.title and
    s.duration = d. duration
    where d.modified is null;
    '''

    # Discover rows that must be added to the dimension.
    select_dim_rows_to_add_sql = '''
    select
        composer,
        title,
        duration
    from s_music
    except
    select
    d.composer,
    d.title,
    d.duration
    from d_music d
    inner join s_music s on
    s.composer = d.composer and
    s.title = d.title and
    s.duration = d.duration
    where d.modified is null;
    '''

    modify_sql = '''
    update d_music set modified=date('now')
    where composer = ? and title = ? and duration = ? and modified is null
    '''

    insert_sql = '''
    insert into d_music (composer, title, duration, created) values (?, ?, ?, ?)
    '''
    database_file = 'music.sqlite3'
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
        print('Cannot open cursor to execute query.')
        for msg in sys.exc_info():
            print(msg)

    composer = None
    title = None
    duration = None

    count_changed_rows = 0
    count_new_rows = 0

    try:
        # Query rows in dimension that should get a modified date.
        cur.execute(select_dim_rows_to_modify_sql)
    except:
        print('Cannot execute selection of dimension rows to modify.')
        for msg in sys.exc_info():
            print(msg)

    changed_rows = cur.fetchall()
    count_changed_rows = len(changed_rows)
    if count_changed_rows > 0:
        for row in changed_rows:
            composer, title, duration = row
            cur.execute(modify_sql, (composer, title, duration))

        conn.commit()

    try:
        # Query rows to add to dimension from staging.
        cur.execute(select_dim_rows_to_add_sql)
    except:
        print('Cannot execute selection of dimension rows to add.')
        for msg in sys.exc_info():
            print(msg)

    new_rows = cur.fetchall()
    count_new_rows = len(new_rows)

    if count_new_rows > 0:
        for row in new_rows:
            composer, title, duration = row
            cur.execute(insert_sql, (composer, title, duration, process_date))

        conn.commit()

    cur.close()
    conn.close()

    end = datetime.datetime.now()
    duration_ms = int(1000 * (end - start).total_seconds())
    print('Processed %d changed rows and %d new rows in %d milliseconds.' % (count_changed_rows, count_new_rows, duration_ms))

if __name__ == '__main__':
    run(event={}, context={})






