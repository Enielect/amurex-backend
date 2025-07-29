# Supabase CLI & Local Instance Setup

### I need ot improve this instuctions to be more robust.

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/) installed
- [Node.js](https://nodejs.org/) (optional, for some CLI features)

## 1. Install Supabase CLI

### Ubuntu/Linux

```bash
# Using Homebrew (recommended)
brew install supabase/tap/supabase

# Or via npm
npm install -g supabase
```

### Windows

```powershell
# Using Scoop
scoop bucket add supabase https://github.com/supabase/scoop-bucket.git
scoop install supabase

# Or via npm
npm install -g supabase
```

## 2. Initialize a Supabase Project

```bash
supabase init
```

This creates a `supabase` folder with configuration files.

## 3. Start Local Supabase Instance

```bash
supabase start
```

- This spins up local Postgres, API, and Studio using Docker.
- Access Supabase Studio at [http://localhost:54323](http://localhost:54323)
- Default Postgres connection:  
    - Host: `localhost`
    - Port: `54322`
    - User: `postgres`
    - Password: `postgres`
    - DB: `postgres`

## 4. Stop Supabase Instance

```bash
supabase stop
```

## 5. Useful CLI Commands

- `supabase db reset` — Reset local database
- `supabase db push` — Apply migrations
- `supabase functions deploy <name>` — Deploy edge functions

## Troubleshooting

- Ensure Docker is running.
- Use `supabase status` to check instance health.
- For port conflicts, edit `supabase/config.toml`.

## References

- [Supabase CLI Docs](https://supabase.com/docs/guides/cli)
- [Supabase Local Development](https://supabase.com/docs/guides/local-development)
