--Left join demo
--Handle modified content:
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

--Handle new content:
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

--Insert new staged content:
insert into s_music (composer, title, duration)
values
('Tchaikovsky', 'Nocturne in F', '5:31'),
('J.S. Bach', 'Air on a G String', '5:10'),
('Chopin', 'Ballade No. 1', '8:19'),
('Pachelbel', 'Canon in D', '5:10'),
('Debussy', 'Claire de Lune', '4:46'),
('Janacek', 'Idyl for Strings', '5:38')


--Handle modified content:
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

--Handle new content:
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

--Update staged data content:
update s_music set duration = '5:12' where title = 'Air on a G String';

--Handle modified content:
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

--Handle new content:
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

--Handle modified content:
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

--Handle new content:
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