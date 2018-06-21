--Slowly-changing dimension ETL demo using Sqlite3

--create staged data table
drop table if exists s_music;

create table s_music(
	id integer not null primary key autoincrement,
	composer text not null,
	title text not null,
	duration text not null
);

--create dimension table
drop table if exists d_music;

create table d_music(
	dim_music_id integer not null primary key autoincrement,
	composer text not null,
	title text not null,
	duration text not null,
    created text not null,
	modified text
);

--insert some rows into stage data.
insert into s_music (composer, title, duration)
values
('Tchaikovsky', 'Nocturne in F', '5:31'),
('J.S. Bach', 'Air on a G String', '5:10'),
('Chopin', 'Ballade No. 1', '8:19'),
('Pachelbel', 'Canon in D', '5:10'),
('Debussy', 'Claire de Lune', '4:46'),
('Janacek', 'Idyl for Strings', '5:38')


--Discover new records in staged data table that are NOT 
--in the dimension table.
select composer, title, duration from s_music
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
	where d.modified is null;  --only want active dimension rows

--Do the same as above a different way...
--Discover new records in staged data table that are NOT 
--in the dimension table, and insert them into the dimension.
--This does the same thing with a left join in lieu of except.
insert into d_music (composer, title, duration, created)
select 
	s.composer,
	s.title,
	s.duration,
	datetime('now')
from s_music s
left join d_music d
on d.composer = s.composer
and d.title = s.title
and d.duration = s.duration
where d.composer is null  --because of failed left join
and d.modified is null  --only want active dimension rows

--The postgres query plan for both of these tactics does not show a clear
--advantage to either approach.


--Update a row in staged data.	
update s_music set duration = '5:12' where title = 'Air on a G String';

--Discover rows that must be modified in the dimension table.
select composer, title, duration from d_music
except
select
	d.composer,
	d.title,
	d.duration
	from s_music s
	inner join d_music d on 
	s.composer = d.composer and
	s.title = d.title and
	s.duration = d. duration
	where d.modified is null;

--Handle modified content.
update d_music set modified = datetime('now') where dim_music_id in
(
	select 
		d.dim_music_id	 
	from d_music d
	left join s_music s on d.title = s.title 
	and d.composer = s.composer 
	and d.duration = s.duration
	where s.composer is null -- because of failed left join
	and d.modified is null  -- to detect active rows  
) 

-- Insert new rows into staged data. 
insert into s_music (composer, title, duration)
values
('Beethoven', 'Moonlight Sonata', '6:38'),
('Mendelssohn', 'Songs Without Words', '2:54'),
('Tchaikovsky', 'Swan Lake (excerpt)', '7:11'),
('Beethoven', 'Pathetique Sonata', '5:16'),
('Prokofiev', 'Romeo and Juliet', '3:42'),
('Saint-Saens', 'Aquarium', '2:13'),
('The Cranberries', 'Linger', '4:35');


update d_music
set modified = datetime('now')
from d_music 
select composer, title, duration
except
select
	d.composer,
	d.title,
	d.duration
	from s_music s
	inner join d_music d on 
	s.composer = d.composer and
	s.title = d.title and
	s.duration = d. duration
	where d.modified is null;

--Update a row in the dimension data.
update d_music set modified = date('now') where
composer = 'J.S. Bach' and  
title = 'Air on a G String' and 
duration = '5:10';

--Insert the new row in the dimension table.
insert into d_music (composer, title, duration)
values
('J.S. Bach', 'Air on a G String', '5:12');


	
update s_music set duration = '5:12' where title = 'Air on a G String'
	
--Discover rows that must be added to the dimension table.
insert into d_music (composer, title, duration)
values
select composer, title, duration from s_music
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
	
--Add a row in the dimension table data.
insert into d_music (composer, title, duration)
values
('J.S. Bach', 'Air on a G String', '5:12');


--Discover rows that have been deleted from staging.
select composer, title, duration from d_music
where modified is null
except
select composer, title, duration from s_music s;

--Add content to staged data.
insert into s_music (composer, title, duration)
values
('Tchaikovsky', 'Nocturne in F', '5:31'),
('J.S. Bach', 'Air on a G String', '5:10'),
('Chopin', 'Ballade No. 1', '8:19'),
('Pachelbel', 'Canon in D', '5:10'),
('Debussy', 'Claire de Lune', '4:46'),
('Janacek', 'Idyl for Strings', '5:38')

--Add staged content to dimension using an anti-join
--implemented with a left joi..
insert into d_music (composer, title, duration, created)
select
	s.composer,
	s.title,
	s.duration,
	datetime('now')
from s_music s
left join d_music d
on d.composer = s.composer
and d.title = s.title
and d.duration = s.duration
where d.composer is null
and d.modified is null


--Change a value in the staged data.
update s_music set duration = '5:12' where title = 'Air on a G String';

--Identify the dimension content that must be changed.
select
	d.dim_music_id
	,s.composer
	,s.title
	,s.duration
from d_music d
left join s_music s on d.title = s.title
and d.composer = s.composer
and d.duration = s.duration
where s.composer is null
and d.modified is null;

--Identify only the dimension identifier for the row(s) that must be deactivated. 
select
	d.dim_music_id
from d_music d
left join s_music s on d.title = s.title
and d.composer = s.composer
and d.duration = s.duration
where s.composer is null
and d.modified is null;

--Deactivate the row(s).
update d_music set modified = datetime('now') where dim_music_id in
(
	select
		d.dim_music_id
	from d_music d
	left join s_music s on d.title = s.title
	and d.composer = s.composer
	and d.duration = s.duration
	where s.composer is null
	and d.modified is null
)

--insert the new content into the dimension.
insert into d_music (composer, title, duration, created)
select
	s.composer,
	s.title,
	s.duration,
	datetime('now')
from s_music s
left join d_music d
on d.composer = s.composer
and d.title = s.title
and d.duration = s.duration
where d.composer is null
and d.modified is null
insert into s_music (composer, title, duration)
values
('Beethoven', 'Moonlight Sonata', '6:38'),
('Mendelssohn', 'Songs Without Words', '2:54'),
('Tchaikovsky', 'Swan Lake (excerpt)', '7:11'),
('Beethoven', 'Pathetique Sonata', '5:16'),
('Prokofiev', 'Romeo and Juliet', '3:42'),
('Saint-Saens', 'Aquarium', '2:13'),
('The Cranberries', 'Linger', '4:35');

update s_music set duration = '5:12' where title = 'Air on a G String';

insert into d_music (composer, title, duration, created)
select
	s.composer,
	s.title,
	s.duration,
	datetime('now')
from s_music s
left join d_music d
on d.composer = s.composer
and d.title = s.title
and d.duration = s.duration
where d.composer is null
and d.modified is null

 
