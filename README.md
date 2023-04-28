# Configuration

## Secrets

Generate passwords and tokens randomly:

```bash
docker compose --file setup/docker-compose.yml build
docker compose --file setup/docker-compose.yml run --rm setup
```

## Migrate from old versions

If the database has not been initialized with dbmate, run this SQL statement:

```sql
create table if not exists schema_migrations (version varchar(128) primary key);
insert into schema_migrations (version) values ('20230331130126');
```

# Run

```bash
docker compose --env-file secrets/docker up --build
```

# Usage

## Followit role

The `followit` role can add new data encoded as JSON:

```bash
source secrets/tokens
curl http://localhost:3000/feed_input -X POST \
 -H "Authorization: Bearer $FOLLOWIT_TOKEN" \
 -H "Content-Type: application/json" \
 -d "$DATA"
```

## Followit consumer

The `followit_consumer` role can read the data:

```bash
source secrets/tokens
curl http://localhost:3000/feed \
 -H "Authorization: Bearer $FOLLOWITCONSUMER_TOKEN" \
 -H "Content-Type: application/json"
```

The `followit_consumer` role can delete the data as well:

```bash
source secrets/tokens
curl "http://localhost:3000/feed?positionId=lte.$ID" -X DELETE \
 -H "Authorization: Bearer $FOLLOWITCONSUMER_TOKEN" \
 -H "Content-Type: application/json"
```

`$ID` is the value of the latest row that has been read before.
It is highly suggested to always delete rows using such a filter, to avoid discading data that have been added between the read and the delete operations.

# Test

```
source secrets/tokens
curl http://localhost:3000/feed_input -X POST \
 -H "Authorization: Bearer $FOLLOWIT_TOKEN" \
 -H "Content-Type: application/json" \
 -d '{"positionId": 1234, "lat": "12.12", "lng": "13.13", "ttf": "1", "date": "2023-03-03T12:00:00+00:00", "collarId": "123", "serialId": "456"}'
```
