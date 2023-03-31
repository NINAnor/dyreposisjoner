-- migrate:up

alter table feed add column inserttime timestamp with time zone default now();

-- migrate:down

