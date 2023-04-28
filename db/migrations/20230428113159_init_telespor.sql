-- migrate:up

create role telespor nologin;
create role telespor_consumer nologin;

create schema telespor;
grant usage on schema telespor to telespor, telespor_consumer;

create table telespor.feed (
    "positionId" integer primary key generated always as identity,
    lat real,
    lng real,
    "IndividualNo" varchar,
    "SeqNo" smallint,
    "Temp" smallint,
    "ServerArrival" timestamp with time zone,
    "NetworkOperator" smallint,
    "SignalLevel" smallint,
    "COG" smallint,
    "SOG" int,
    "Timestamp" timestamp with time zone,
    "UnitNo" int,
    "BatteryVoltage" real,
    unique ("IndividualNo", "Timestamp", "SeqNo")
);

create table telespor.feed_input (
    geometry geometry(point, 4326),
    properties jsonb,
    type varchar
);

create function telespor.feed_input() returns trigger language plpgsql
as $$
begin
    if new.type != 'Feature' then
        raise exception 'GeoJSON type % not supported', new.type;
    end if;
    insert into telespor.feed values (
       default,
       st_y(new.geometry),
       st_x(new.geometry),
       new.properties -> 'IndividualNo',
       (new.properties -> 'SeqNo')::smallint,
       (new.properties -> 'Temp')::smallint,
       (new.properties -> 'ServerArrival')::varchar::timestamp with time zone,
       (new.properties -> 'NetworkOperator')::smallint,
       (new.properties -> 'SignalLevel')::smallint,
       (new.properties -> 'COG')::smallint,
       (new.properties -> 'SOG')::int,
       (new.properties -> 'Timestamp')::varchar::timestamp with time zone,
       (new.properties -> 'UnitNo')::int,
       (new.properties -> 'BatteryVoltage')::real
    );
    return null;
exception
    when others then
        raise exception using
            errcode = sqlstate,
            message = sqlerrm,
            detail = new;
end;
$$;
create or replace trigger feed_input
    before insert on telespor.feed_input
    for each row
    execute procedure telespor.feed_input();

grant insert on telespor.feed, telespor.feed_input to telespor;
grant select, delete on telespor.feed to telespor_consumer;

-- migrate:down

