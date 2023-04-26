-- migrate:up

create schema followit;

alter user consumer rename to followit_consumer;

grant usage on schema followit to followit;
grant usage on schema followit to followit_consumer;

drop trigger feed_input on feed_input;
drop function feed_input;

alter table feed_input set schema followit;
alter table feed set schema followit;

create function followit.feed_input() returns trigger language plpgsql
as $$
begin
    insert into followit.feed values (
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
create trigger feed_input
    before insert on followit.feed_input
    for each row
    execute procedure followit.feed_input();

-- migrate:down

