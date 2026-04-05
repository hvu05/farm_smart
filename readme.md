# Farm Smart Backend

Backend boilerplate for Smart Farm System (IoT). Stack: Express + TypeScript + Prisma + PostgreSQL + Socket.io + MQTT.

## Requirements

- Node.js 18+ (recommended 20+)
- Docker (for quick PostgreSQL setup)

## Installation

1. Clone repo and enter the project directory

```bash
git clone <repo-url>
cd farm-smart
```

2. Install dependencies

```bash
npm i
```

3. Create `.env` (currently, we haven't need it, only need DATABASE_URL)

```env

# PORT=8000
# NODE_ENV=development
# CORS_ORIGIN=*
# MQTT_URL=mqtt://localhost:1883
# MQTT_USERNAME=
# MQTT_PASSWORD=
# MQTT_SUBSCRIBE_TOPIC=smartfarm/+/telemetry
```

4. Start PostgreSQL (Docker)

```bash
docker compose up -d
```

5. Prisma (optional when models exist)

```bash
npx prisma migrate dev --name init
npx prisma generate
```

6. Run dev

```bash
npm run dev
```

## Quick check

- `GET http://localhost:8000/ping`
- `GET http://localhost:8000/api/example/health`

## MQTT note

- MQTT is currently commented in `src/server.ts`.
- If you want to enable MQTT, uncomment `initMqtt()` and `closeMqtt()` and update env vars in `.env`.
