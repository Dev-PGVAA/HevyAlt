import pytest
import asyncio
from src.analytics.recovery_predictor import RecoveryPredictor
from src.ai_core.feature_builder import FeatureBuilder

@pytest.mark.asyncio
async def test_recovery_predictor():
    predictor = RecoveryPredictor("dummy_path")
    features = FeatureBuilder().build_recovery_features(heart_rate=70, sleep_hours=7.5, steps=8000)
    score = await predictor.predict(features)
    assert 0 <= score <= 100