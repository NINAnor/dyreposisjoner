begin;
create table feed (
    lat varchar,
    lng varchar,
    "date" varchar,
    ttf varchar,
    sats varchar,
    "actX" varchar,
    "actY" varchar,
    "actZ" varchar,
    "collarId" varchar,
    "positionId" integer primary key,
    "serialId" varchar,
    alt varchar,
    "N2d3d" varchar,
    hdop varchar,
    temp varchar,
    name varchar,
    power varchar
);

create role followit nologin;
grant insert on feed to followit;

create role consumer nologin;
grant select, delete on feed to consumer;
commit;
