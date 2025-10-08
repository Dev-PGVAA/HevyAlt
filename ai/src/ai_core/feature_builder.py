from typing import Dict, Optional
from src.utils.logger import setup_logger

logger = setup_logger(__name__)

class FeatureBuilder:
    """Builds feature vectors from raw HealthKit and nutrition data."""

    def __init__(self):
        self.logger = logger

    def build_recovery_features(
        self, heart_rate: float, sleep_hours: float, steps: int
    ) -> Dict[str, float]:
        """Builds features for recovery prediction with validation."""
        try:
            if not (30 <= heart_rate <= 200):
                raise ValueError("Heart rate must be between 30 and 200 bpm")
            if not (0 <= sleep_hours <= 24):
                raise ValueError("Sleep hours must be between 0 and 24")
            if steps < 0:
                raise ValueError("Steps cannot be negative")
            features = {
                "heart_rate": heart_rate,
                "sleep_hours": sleep_hours,
                "steps_normalized": steps / 10000,
            }
            self.logger.info("Recovery features built successfully")
            return features
        except Exception as e:
            self.logger.error(f"Error building recovery features: {e}")
            raise

    def build_nutrition_features(
        self, protein: float, fat: float, carbs: float, body_weight: float
    ) -> Dict[str, float]:
        """Builds features for nutrition analysis with validation."""
        try:
            if any(x < 0 for x in [protein, fat, carbs, body_weight]):
                raise ValueError("Nutrition values and body weight cannot be negative")
            if not (30 <= body_weight <= 200):
                raise ValueError("Body weight must be between 30 and 200 kg")
            features = {
                "protein_g_per_kg": protein / body_weight,
                "fat_g_per_kg": fat / body_weight,
                "carbs_g_per_kg": carbs / body_weight,
            }
            self.logger.info("Nutrition features built successfully")
            return features
        except Exception as e:
            self.logger.error(f"Error building nutrition features: {e}")
            raise