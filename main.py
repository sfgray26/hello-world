from fastapi import FastAPI, Depends, Security, HTTPException, status
from fastapi.security import APIKeyHeader
from apscheduler.schedulers.background import BackgroundScheduler
from sqlalchemy.orm import Session
import os
from models import Base, engine, Session as DBSession
from betting_model import CBBEdgeModel

app = FastAPI()
Base.metadata.create_all(engine)

# Auth
API_KEY_HEADER = APIKeyHeader(name="X-API-Key")
VALID_API_KEYS = {os.getenv("API_KEY_USER1"): "user1", os.getenv("API_KEY_USER2"): "user2"}

def verify_api_key(api_key: str = Security(API_KEY_HEADER)):
    if api_key not in VALID_API_KEYS:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED)
    return VALID_API_KEYS[api_key]

# Cron job
def nightly_analysis():
    """Run at 3 AM daily"""
    with DBSession() as db:
        # [FETCH ODDS, RATINGS, RUN MODEL]
        pass

scheduler = BackgroundScheduler()
scheduler.add_job(nightly_analysis, 'cron', hour=3)
scheduler.start()

# API routes
@app.get("/predictions")
def get_predictions(user=Depends(verify_api_key)):
    with DBSession() as db:
        return db.query(Prediction).filter(Prediction.verdict.like('Bet%')).all()

@app.get("/performance")
def get_performance(user=Depends(verify_api_key)):
    # Calculate CLV, ROI, calibration
    pass