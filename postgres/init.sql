create table feed (
    lat varchar,
    lng varchar,
    "date" varchar,
    ttf varchar,
    sats varchar,
    "collarId" varchar,
    "positionId" varchar primary key,
    "serialId" varchar,
    alt varchar,
    hdop varchar,
    temp varchar,
    name varchar
);

create role followit nologin;
grant insert on feed to followit;

create role consumer nologin;
grant select, delete on feed to consumer;
