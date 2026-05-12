# Hermes Agent on Railway

One-click deployment of Hermes Agent (by Nous Research) on Railway.

## Quick Deploy

1. Fork this repo to your GitHub
2. Go to [Railway](https://railway.app)
3. Click **New Project** → **Deploy from GitHub**
4. Select this repo
5. Done! Railway auto-detects Dockerfile

## Or Deploy via CLI

```bash
cd hermes-agent
railway login
railway init
railway up
```

## Environment Variables (Optional)

- `HERMES_HOME` - Data directory (default: `/app/data`)
