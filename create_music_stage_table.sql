--create staged data table
drop table if exists s_music;

create table s_music(
    id integer not null primary key autoincrement,
    composer text not null,
    title text not null,
    duration text not null
);


