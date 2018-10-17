--Create a diskspace.sqlite3 database file...
--Create stage table:
drop table if exists s_diskspace;

create table s_diskspace(
    stg_id integer not null primary key autoincrement,
    name text text not null,
    disk_path text not null,
    capacity integer not null,
    free_space integer not null
);


--Create dimension table:
drop table if exists d_diskspace;

create table d_diskspace(
    dim_id integer not null primary key autoincrement,
    stg_id integer not null,
    name text text not null,
    disk_path text not null,
    capacity integer not null,
    free_space integer not null,
    created text not null,
    modified text
);

--Add new values to staged data: 
insert into s_diskspace (name, disk_path, capacity, free_space)
values
('orange', 'C:\', 10, 9),
('orange', 'D:\', 10, 8),
('orange', 'E:\', 10, 7)

--Discover new data in stage table that must be added to the dimension:
select 
    s.stg_id, 
    s.name, 
    s.disk_path, 
    s.capacity, 
    s.free_space 
from s_diskspace s
left join d_diskspace d on
s.name = d.name and 
s.disk_path = d.disk_path and
s.capacity = d.capacity and 
s.free_space = d.free_space
where d.name is null;
 
 --Add new data to the dimension:
 insert into d_diskspace (stg_id, name, disk_path, capacity, free_space, created)
 select 
    s.stg_id, 
    s.name, 
    s.disk_path, 
    s.capacity, 
    s.free_space,
    datetime('now') 
from s_diskspace s
left join d_diskspace d on
s.name = d.name and 
s.disk_path = d.disk_path and
s.capacity = d.capacity and 
s.free_space = d.free_space
where d.name is null;

--Update information in the staged data:
delete from s_diskspace;

insert into s_diskspace (name, disk_path, capacity, free_space)
values
('orange', 'C:\', 10, 6),
('orange', 'D:\', 10, 8),
('orange', 'E:\', 10, 7),
('blue', 'C:\', 10, 10);

--Deactivate the rows in the dimension that have changed:
update d_diskspace set modified = datetime('now') where dim_id in (
    select d.dim_id
    from d_diskspace d
    left join s_diskspace s on 
    s.name = d.name and 
    s.disk_path = d.disk_path and
    s.capacity = d.capacity and 
    s.free_space = d.free_space
    where d.modified is null
    and s.name is null
);

--Add new data to the dimension:
 insert into d_diskspace (stg_id, name, disk_path, capacity, free_space, created)
 select 
    s.stg_id, 
    s.name, 
    s.disk_path, 
    s.capacity, 
    s.free_space,
    datetime('now') 
from s_diskspace s
left join d_diskspace d on
s.name = d.name and 
s.disk_path = d.disk_path and
s.capacity = d.capacity and 
s.free_space = d.free_space
where modified is null and 
d.name is null;

--Add new staged data:
delete from s_diskspace;

insert into s_diskspace (name, disk_path, capacity, free_space)
values
('orange', 'C:\', 10, 5),
('orange', 'D:\', 10, 7),
--('orange', 'E:\', 10, 7),
('blue', 'C:\', 10, 9),
('blue', 'D:\', 10, 10),
('blue', 'E:\', 10, 10),
('green', 'C:\', 10, 10);


--Deactivate the rows in the dimension that have changed:
update d_diskspace set modified = datetime('now') where dim_id in (
    select d.dim_id
    from d_diskspace d
    left join s_diskspace s on 
    s.name = d.name and 
    s.disk_path = d.disk_path and
    s.capacity = d.capacity and 
    s.free_space = d.free_space
    where d.modified is null
    and s.name is null
);

--Add new data to the dimension:
 insert into d_diskspace (stg_id, name, disk_path, capacity, free_space, created)
 select 
    s.stg_id, 
    s.name, 
    s.disk_path, 
    s.capacity, 
    s.free_space,
    datetime('now') 
from s_diskspace s
left join d_diskspace d on
s.name = d.name and 
s.disk_path = d.disk_path and
s.capacity = d.capacity and 
s.free_space = d.free_space
where modified is null and 
d.name is null;
