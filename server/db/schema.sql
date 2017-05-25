drop table if exists entries;

create table entries (
    id integer primary key autoincrement,
    filename string not null,
    title string not null,
    url string not null,
    datetime integer not null
    );
