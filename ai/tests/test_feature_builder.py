import pytest
from src.ai_core.feature_builder import FeatureBuilder

def test_build_recovery_features_valid():
    fb = FeatureBuilder()
    features = fb.build_recovery_features(heart_rate=70, sleep_hours=7.5, steps=8000)
    assert features["heart_rate"] == 70
    assert features["sleep_hours"] == 7.5
    assert features["steps_normalized"] == 0.8

def test_build_recovery_features_invalid():
    fb = FeatureBuilder()
    with pytest.raises(ValueError):
        fb.build_recovery_features(heart_rate=-10, sleep_hours=7.5, steps=8000)

def test_build_nutrition_features_valid():
    fb = FeatureBuilder()
    features = fb.build_nutrition_features(protein=120, fat=50, carbs=200, body_weight=75)
    assert features["protein_g_per_kg"] == 120 / 75
    assert features["fat_g_per_kg"] == 50 / 75
    assert features["carbs_g_per_kg"] == 200 / 75

def test_build_nutrition_features_invalid():
    fb = FeatureBuilder()
    with pytest.raises(ValueError):
        fb.build_nutrition_features(protein=-10, fat=50, carbs=200, body_weight=75)