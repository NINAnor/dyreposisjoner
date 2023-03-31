-- migrate:up

create table feed_input (
    lat varchar,
    lng varchar,
    "date" varchar,
    ttf varchar,
    sats varchar,
    "actX" varchar,
    "actY" varchar,
    "actZ" varchar,
    "collarId" varchar,
    "positionId" varchar,
    "serialId" varchar,
    alt varchar,
    "N2d3d" varchar,
    hdop varchar,
    temp varchar,
    name varchar,
    power varchar
);
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
create or replace function feed_input() returns trigger language plpgsql
as $$
begin
    insert into feed values (
        nullif(new.lat, '')::numeric(8, 6),
        nullif(new.lng, '')::numeric(8, 6),
        nullif(new."date", '')::timestamp with time zone,
        nullif(new.ttf, '')::smallint,
        nullif(new.sats, '')::smallint,
        nullif(new."actX", ''),
        nullif(new."actY", ''),
        nullif(new."actZ", ''),
        nullif(new."collarId", '')::integer,
        nullif(new."positionId", '')::integer,
        nullif(new."serialId", ''),
        nullif(new.alt, ''),
        nullif(new."N2d3d", ''),
        nullif(new.hdop, '')::real,
        nullif(new.temp, ''),
        nullif(new.name, ''),
        nullif(new.power, '')::real
    );
    return null;
end;
$$;
create or replace trigger feed_input
    before insert on feed_input
    for each row
    execute procedure feed_input();

create role followit nologin;
grant insert on feed, feed_input to followit;

create role consumer nologin;
grant select, delete on feed to consumer;

-- migrate:down

