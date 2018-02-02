--create staged data table
create table s_music(
	id integer not null primary key autoincrement,
	composer text not null,
	title text not null,
	duration text not null
);

--create dimension table
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
('Janacek', 'Idyl for Strings', '5:38'),
('Beethoven', 'Moonlight Sonata', '6:38'),
('Mendelssohn', 'Songs Without Words', '2:54'),
('Tchaikovsky', 'Swan Lake (excerpt)', '7:11'),
('Beethoven', 'Pathetique Sonata', '5:16'),
('Prokofiev', 'Romeo and Juliet', '3:42'),
('Saint-Saens', 'Aquarium', '2:13'),
('The Cranberries', 'Linger', '4:35');

--Discover new records in staged data table that are NOT 
--in the dimension table.
insert into d_music (composer, title, duration)
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

update d_music
set modified = date('now')
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


 
