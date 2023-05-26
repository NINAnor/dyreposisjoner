-- migrate:up

create or replace function telespor.feed_input() returns trigger language plpgsql
as $$
begin
    if new.type != 'Feature' then
        raise exception 'GeoJSON type % not supported', new.type;
    end if;
    insert into telespor.feed values (
       default,
       st_y(new.geometry),
       st_x(new.geometry),
       new.properties ->> 'IndividualNo',
       (new.properties ->> 'SeqNo')::smallint,
       (new.properties ->> 'Temp')::smallint,
       (new.properties ->> 'ServerArrival')::varchar::timestamp with time zone,
       (new.properties ->> 'NetworkOperator')::smallint,
       (new.properties ->> 'SignalLevel')::smallint,
       (new.properties ->> 'COG')::smallint,
       (new.properties ->> 'SOG')::int,
       (new.properties ->> 'Timestamp')::varchar::timestamp with time zone,
       (new.properties ->> 'UnitNo')::int,
       (new.properties ->> 'BatteryVoltage')::real
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

-- migrate:down

