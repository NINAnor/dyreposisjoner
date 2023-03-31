-- migrate:up

update feed set inserttime = date_trunc('second', inserttime);
alter table feed alter column inserttime set default date_trunc('second', now()::timestamp);

-- migrate:down

