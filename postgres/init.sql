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
create or replace function feed_null_if_empty() returns trigger language plpgsql
as $$
begin
    new.lat := nullif(old.lat::varchar, '');
    new.lng := nullif(old.lng::varchar, '');
    new."date" := nullif(old."date"::varchar, '');
    new.ttf := nullif(old.ttf::varchar, '');
    new.sats := nullif(old.sats::varchar, '');
    new."actX" := nullif(old."actX"::varchar, '');
    new."actY" := nullif(old."actY"::varchar, '');
    new."actZ" := nullif(old."actZ"::varchar, '');
    new."collarId" := nullif(old."collarId"::varchar, '');
    new."positionId" := nullif(old."positionId"::varchar, '');
    new."serialId" := nullif(old."serialId"::varchar, '');
    new.alt := nullif(old.alt::varchar, '');
    new."N2d3d" := nullif(old."N2d3d"::varchar, '');
    new.hdop := nullif(old.hdop::varchar, '');
    new.temp := nullif(old.temp::varchar, '');
    new.name := nullif(old.name::varchar, '');
    new.power := nullif(old.power::varchar, '');
    return new;
end;
$$;
create or replace trigger feed_null_if_empty
    before insert or update on feed
    for each row
    execute procedure feed_null_if_empty();

create role followit nologin;
grant insert on feed to followit;

create role consumer nologin;
grant select, delete on feed to consumer;
commit;
