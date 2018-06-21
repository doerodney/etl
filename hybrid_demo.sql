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

--Insert new staged content:
insert into s_music (composer, title, duration)
values
('Tchaikovsky', 'Nocturne in F', '5:31'),
('J.S. Bach', 'Air on a G String', '5:10'),
('Chopin', 'Ballade No. 1', '8:19'),
('Pachelbel', 'Canon in D', '5:10'),
('Debussy', 'Claire de Lune', '4:46'),
('Janacek', 'Idyl for Strings', '5:38')

--Handle active modified content:  (left join is one way to do an anti-join)
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

--Handle new content:  (inner join with except is another way to do an anti-join)
insert into d_music (composer, title, duration, created)
select composer, title, duration, datetime('now') as created from
(
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
        where d.modified is null
) as x

--Update staged data content:
update s_music set duration = '5:12' where title = 'Air on a G String';

--Handle active modified content:

--Handle new content:

--Update staged data content:
update s_music set duration = '5:10' where title = 'Air on a G String';

--Add new staged content:
insert into s_music (composer, title, duration)
values
('Beethoven', 'Moonlight Sonata', '6:38'),
('Mendelssohn', 'Songs Without Words', '2:54'),
('Tchaikovsky', 'Swan Lake (excerpt)', '7:11'),
('Beethoven', 'Pathetique Sonata', '5:16'),
('Prokofiev', 'Romeo and Juliet', '3:42'),
('Saint-Saens', 'Aquarium', '2:13'),
('The Cranberries', 'Linger', '4:35')

--Handle active modified content:

--Handle new content:
