create table feed (
    id integer primary key generated always as identity,
    lat varchar,
    lng varchar,
    "date" varchar,
    ttf varchar,
    sats varchar,
    "collarId" varchar,
    "positionId" varchar,
    "serialId" varchar,
    alt varchar,
    hdop varchar,
    temp varchar,
    name varchar
);

create role followit nologin;
grant insert on feed to followit;
grant usage, select on sequence feed_id_seq to followit;

create role consumer nologin;
grant select, delete on feed to consumer;
grant usage, select on sequence feed_id_seq to consumer;
