# Setup

Copy the `env.sample` file to `.env` and set the password.
`JWT_SECRET` should be 24 characters minimum

The passwords can be generated automatically using this snippet:
```bash
cat << EOF > .env
POSTGRES_PASSWORD="$(< /dev/urandom LC_CTYPE=C tr -dc A-Za-z0-9 | head -c32)"
JWT_SECRET="$(< /dev/urandom LC_CTYPE=C tr -dc A-Za-z0-9 | head -c32)"
EOF
```

Build the custom Postgres image:
```bash
docker compose build
```

Add `./` in front of the `data` volume in `docker-compose.yml`to store the database files in a folder instead of a volume.

# Run

```bash
docker compose up
```

# Usage

Generate a JWT for the both the users using https://jwt.io/#debugger-io:
1. Set the value of `JWT_SECRET` as secret
2. Set payload to `{"role": "followit"}`
3. Copy the encoded token

The same applies for the `consumer` role.

## Followit role

The `followit` role can add new data encoded as JSON:

```bash
curl http://localhost:3000/feed -X POST \
 -H "Authorization: Bearer $FOLLOWIT_TOKEN" \
 -H "Content-Type: application/json" \
 -d '$DATA'
```

## Consumer

The `consumer` role can read the data:

```bash
curl http://localhost:3000/feed \
 -H "Authorization: Bearer $CONSUMER_TOKEN" \
 -H "Content-Type: application/json"
```

The `consumer` role can delete the data as well:

```bash
curl "http://localhost:3000/feed?id=lte.$ID" -X DELETE \
 -H "Authorization: Bearer $CONSUMER_TOKEN" \
 -H "Content-Type: application/json"
```

`$ID` is the value of the latest row that has been read before.
It is highly suggested to always delete rows using such a filter, to avoid discading data that have been added between the read and the delete operations.
