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

# Followit

## Add data

The `followit` role can add new data encoded as JSON:

```bash
source secrets/tokens
curl http://localhost:3000/feed_input -X POST \
 -H "Content-Profile: followit" \
 -H "Authorization: Bearer $FOLLOWIT_TOKEN" \
 -H "Content-Type: application/json" \
 -d "$DATA"
```

Here is an example for `DATA`:
```bash
DATA='{"positionId": 1234, "lat": "12.12", "lng": "13.13", "ttf": "1", "date": "2023-03-03T12:00:00+00:00", "collarId": "123", "serialId": "456"}'
```

## Retrieve and delete data

The `followit_consumer` role can read the data:

```bash
source secrets/tokens
curl http://localhost:3000/feed \
 -H "Accept-Profile: followit" \
 -H "Authorization: Bearer $FOLLOWITCONSUMER_TOKEN"
```

The `followit_consumer` role can delete the data as well:

```bash
source secrets/tokens
curl "http://localhost:3000/feed?positionId=lte.$ID" -X DELETE \
 -H "Content-Profile: followit" \
 -H "Authorization: Bearer $FOLLOWITCONSUMER_TOKEN"
```

`$ID` is the value of the latest row that has been read before.
It is highly suggested to always delete rows using such a filter, to avoid discading data that have been added between the read and the delete operations.

# Telespor

## Add data

The `telespor` role can add new data encoded as GeoJSON feature:

```bash
source secrets/tokens
curl http://localhost:3000/feed_input -X POST \
 -H "Content-Profile: telespor" \
 -H "Authorization: Bearer $TELESPOR_TOKEN" \
 -H "Content-Type: application/json" \
 -d "$FEATURE"
```

Here is an example for `FEATURE`:
```bash
FEATURE='{"type":"Feature","geometry":{"type":"Point","coordinates":[10.5,60.5]},"properties":{"IndividualNo":"1AB","SeqNo":12,"Temp":3,"ServerArrival":"2023-03-03T12:00:00+00:00","NetworkOperator":123,"SignalLevel":100,"COG":0,"SOG":1234567,"Timestamp":"2023-03-03T12:00:00+00:00","UnitNo":2233445,"BatteryVoltage":3.5}}'
```

## Retrieve and delete data

The `telespor_consumer` role can read the data:

```bash
source secrets/tokens
curl http://localhost:3000/feed \
 -H "Accept-Profile: telespor" \
 -H "Authorization: Bearer $TELESPORCONSUMER_TOKEN"
```

The `telespor_consumer` role can delete the data as well:

```bash
source secrets/tokens
curl "http://localhost:3000/feed?positionId=lte.$ID" -X DELETE \
 -H "Content-Profile: telespor" \
 -H "Authorization: Bearer $TELESPORCONSUMER_TOKEN"
```

`$ID` is the value of the latest row that has been read before.
It is highly suggested to always delete rows using such a filter, to avoid discading data that have been added between the read and the delete operations.
