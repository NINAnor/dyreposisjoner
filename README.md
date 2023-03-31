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
curl http://localhost:3000/feed_input -X POST \
 -H "Authorization: Bearer $FOLLOWIT_TOKEN" \
 -H "Content-Type: application/json" \
 -d '$DATA'
```

## Consumer

The `consumer` role can read the data:

```bash
source secrets/tokens
curl http://localhost:3000/feed \
 -H "Authorization: Bearer $CONSUMER_TOKEN" \
 -H "Content-Type: application/json"
```

The `consumer` role can delete the data as well:

```bash
source secrets/tokens
curl "http://localhost:3000/feed?positionId=lte.$ID" -X DELETE \
 -H "Authorization: Bearer $CONSUMER_TOKEN" \
 -H "Content-Type: application/json"
```

`$ID` is the value of the latest row that has been read before.
It is highly suggested to always delete rows using such a filter, to avoid discading data that have been added between the read and the delete operations.
