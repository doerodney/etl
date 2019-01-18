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

