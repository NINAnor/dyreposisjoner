begin;
create table feed (
    lat numeric(8, 6) not null,
    lng numeric(9, 6) not null,
    "date" timestamp with time zone not null,
    ttf smallint,
    sats smallint,
    "actX" varchar,
    "actY" varchar,
    "actZ" varchar,
    "collarId" integer not null,
    "positionId" integer primary key,
    "serialId" varchar not null,
    alt varchar,
    "N2d3d" varchar,
    hdop real,
    temp varchar,
    name varchar,
    power real
);

create role followit nologin;
grant insert on feed to followit;

create role consumer nologin;
grant select, delete on feed to consumer;
commit;
