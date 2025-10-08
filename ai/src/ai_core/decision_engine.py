from typing import Dict, Optional
from src.utils.logger import setup_logger
from src.db.models import Config
from src.config.database import Session
from tenacity import retry, stop_after_attempt, wait_fixed

logger = setup_logger(__name__)

class DecisionEngine:
    """Generates actionable recommendations based on model outputs."""

    def __init__(self):
        self.logger = logger
        self.session = Session()
        self.configs = self._load_configs()

    def _load_configs(self) -> Dict[str, float]:
        """Loads configuration from PostgreSQL."""
        try:
            config = self.session.query(Config).filter_by(name="thresholds").first()
            return config.parameters if config else {"low": 60, "medium": 80, "protein": 1.6, "fat": 0.8, "carbs": 4.0}
        except Exception as e:
            self.logger.error(f"Error loading configs: {e}")
            return {"low": 60, "medium": 80, "protein": 1.6, "fat": 0.8, "carbs": 4.0}

    @retry(stop=stop_after_attempt(3), wait=wait_fixed(2))
    def recovery_recommendation(self, recovery_score: float) -> str:
        """Generates recovery recommendation with fallback."""
        try:
            if recovery_score < self.configs["low"]:
                return "Low recovery: prioritize rest or light activity."
            elif recovery_score < self.configs["medium"]:
                return "Moderate recovery: opt for medium-intensity training."
            else:
                return "High recovery: full-intensity training recommended."
        except Exception as e:
            self.logger.error(f"Error generating recovery recommendation: {e}")
            return "Unable to assess recovery; try light activity."

    def nutrition_recommendation(self, features: Dict[str, float], body_weight: float) -> str:
        """Generates nutrition recommendations with fallback."""
        try:
            recommendations = []
            for macro in ["protein", "fat", "carbs"]:
                current = features[f"{macro}_g_per_kg"]
                target = self.configs[macro]
                if current < target * 0.8:
                    recommendations.append(
                        f"Increase {macro} intake: current {current:.1f} g/kg, target {target:.1f} g/kg."
                    )
                elif current > target * 1.2:
                    recommendations.append(
                        f"Reduce {macro} intake: current {current:.1f} g/kg, target {target:.1f} g/kg."
                    )
            return " ".join(recommendations) or "Nutrition intake is balanced."
        except Exception as e:
            self.logger.error(f"Error generating nutrition recommendation: {e}")
            return "Unable to analyze nutrition; maintain balanced intake."