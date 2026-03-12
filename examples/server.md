# Running GDBS as a Server

GDBS exposes a REST + WebSocket API when run in server mode.

## Start

```bash
gdbs serve                    # default port 6432
gdbs serve --port 8080        # custom port
gdbs --db ./mydb.gdbs serve   # custom database file
```

## REST endpoints

```
POST   /gql              Execute a GQL statement
GET    /seeds/:id        Retrieve a seed by ID
DELETE /seeds/:id        Delete a seed
GET    /tiles            List all tiles
GET    /stats            Database statistics
```

## Example — store via HTTP

```bash
curl -X POST http://localhost:6432/gql \
  -H "Content-Type: application/json" \
  -d '{"query": "STORE \"Hello from the API\" WITH type = \"test\""}'
```

## Example — query via HTTP

```bash
curl -X POST http://localhost:6432/gql \
  -H "Content-Type: application/json" \
  -d '{"query": "NEARBY \"hello\" LIMIT 5"}'
```
