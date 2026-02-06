# CBB Edge

Starter repo for CBB Edge Analyzer with FastAPI, Railway, Postgres, and Streamlit.

## Features:

1. Backend built with FastAPI (Python 3.11), sync SQLAlchemy for database operations
2. Database: Supabase free tier or Railway PostgreSQL
3. Frontend: Streamlit for version 1, transition to Next.js Pages Router in version 2
4. API authentication using API Keys for version 1, optional Clerk.dev for full-featured authentication in version 2
5. Hosting: Railway.app for backend, database, and cron jobs (APScheduler for server-side cron management)
6. Rating data: KenPom API, cached BartTorvik scraper

## Quick Start

### Setting Up Locally

```bash
# Clone the repo
git clone https://github.com/sfgray26/hello-world.git
cd hello-world

# Checkout starter branch
git checkout cbb-edge-starter

# Set up the virtual environment
python -m venv venv
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Create database
createdb cbb_edge

# Set environment variables from .env
cp .env.example .env
```

### Deploying to Railway (Production)

1. **Install Railway CLI**: `npm install -g @railway/cli`
2. **Initialize Railway Project**: `railway init`
3. Add PostgreSQL to Railway: `railway add postgresql`
4. Deploy the service: `railway up`
5. Set environment variables in Railway dashboard.

Congratulations on launching CBB Edge!