# GDBS — Geometric Database System

A native database engine with 7-dimensional content-addressable storage, a graph traversal query language (GQL), and biologically-inspired learning dynamics. Free to download and use.

**Patent Pending — 63/970,430**

---

## What it is

GDBS is a database built on geometric principles rather than relational tables:

| Concept | GDBS equivalent | Description |
|---------|----------------|-------------|
| Table | **Tile** | A named collection of seeds |
| Row | **Seed** | Content-addressed record (SHA-256, 16 hex chars) |
| Foreign key | **Symlink** | Typed, weighted bidirectional link between seeds |
| Index | **Hub** | Auto-linked concept cluster with depth-map recall |
| Schema | **7D position** | Each seed occupies a geometric coordinate — proximity = similarity |

---

## Download

| Platform | Download |
|----------|----------|
| Windows x64 | [GDBS-1.0.0-win64.zip](https://github.com/garrjo/gdbs-free/releases/latest) |
| macOS / Linux | Coming in v1.1.0 |

---

## Quick start

```bash
# Store content
gdbs store "Diamond bulk modulus is 442 GPa, measured by Brillouin scattering"

# Query with GQL
gdbs -c "NEARBY 'bulk modulus' LIMIT 5"

# Interactive REPL
gdbs

# Start as a server (port 6432)
gdbs serve
```

---

## GQL — Geometric Query Language

GQL maps directly to standard database operations:

```gql
-- Create a tile (table)
CREATE TILE materials

-- Store a seed (insert)
STORE 'Diamond: B=442 GPa, G=535 GPa, E=1050 GPa'
WITH type = 'elastic_data',
     material = 'Diamond',
     source = 'Grimsditch & Ramdas, 1975'
IN materials
AS $diamond;

-- Link two seeds
LINK $diamond TO $silicon WEIGHT 0.7 TYPE semantic

-- Query by proximity (geometric nearest-neighbour)
NEARBY 'bulk modulus cubic crystal' IN materials LIMIT 10

-- Graph traversal
TRAVERSE $diamond DEPTH 3 WHERE type IN ('semantic', 'reference')

-- Standard CRUD
SELECT * FROM materials WHERE metadata.material = 'Diamond'
UPDATE SEED abc123def45678 SET metadata.status = 'verified'
DELETE SEED abc123def45678 CASCADE
```

### SQL interop

Standard SQL is translated automatically:

```sql
INSERT INTO materials (content, metadata)
VALUES ('Silicon: B=98 GPa', '{"material": "Silicon"}');

SELECT * FROM materials WHERE metadata.material = 'Silicon';

DELETE FROM materials WHERE metadata.source = 'unverified';
```

---

## Learning engine

GDBS includes a biologically-inspired memory system:

- **Hebbian learning** — connections strengthen with co-activation
- **STDP** — spike-timing-dependent plasticity (LTP / LTD)
- **Memory stages** — STM → Working → Long-Term Memory
- **Automatic decay** — unused connections weaken over time
- **Consolidation** — periodic memory state compaction

---

## CLI reference

```
gdbs store "content"          Store content, returns seed ID
gdbs search "query"           Search by content similarity
gdbs -c "GQL statement"       Execute a single GQL statement
gdbs serve [--port 6432]      Start HTTP + WebSocket server
gdbs stats                    Show database statistics
gdbs --db path/to/db.gdbs     Use a specific database file
gdbs --format json|table      Output format
gdbs --help                   Full command reference
```

Default database: `~/.gdbs/default.gdbs`

---

## Physics domain modules

The GDBS physics compute engines (plasma, materials, fluids, molecular dynamics, quantum, geophysics, cosmology) are available as add-on modules via [GDBS Web](https://gdbs.getvaultsync.com). They run on top of GDBS and write validated simulation results directly into the geometric database.

---

## Attribution

If you use GDBS in published work, a citation is appreciated:

> Garrett, J. (2026). GDBS: Geometric Database System. VaultSync Solutions Inc.
> https://gdbs.getvaultsync.com

---

Free to use. Source not included. See [LICENSE](LICENSE).
