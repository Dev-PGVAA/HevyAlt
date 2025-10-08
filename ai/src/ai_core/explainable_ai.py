from typing import Dict, Optional
from src.utils.logger import setup_logger

logger = setup_logger(__name__)

class ExplainableAI:
    """Generates human-readable explanations for AI decisions."""

    def __init__(self):
        self.logger = logger

    def explain_recovery(
        self, recovery_score: float, features: Dict[str, float]
    ) -> str:
        """Explains recovery score in simple terms."""
        try:
            explanation = (
                f"Your recovery score is {recovery_score:.1f}%. "
                f"Based on heart rate ({features['heart_rate']} bpm), "
                f"sleep ({features['sleep_hours']} hours), "
                f"and steps ({features['steps_normalized']*10000:.0f})."
            )
            self.logger.info("Recovery explanation generated")
            return explanation
        except Exception as e:
            self.logger.error(f"Error generating recovery explanation: {e}")
            return "Error generating explanation."

    def explain_nutrition(
        self, recommendation: str, features: Dict[str, float]
    ) -> str:
        """Explains nutrition recommendations in simple terms."""
        try:
            explanation = (
                f"Nutrition advice: {recommendation} "
                f"Based on protein ({features['protein_g_per_kg']:.1f} g/kg), "
                f"fat ({features['fat_g_per_kg']:.1f} g/kg), "
                f"and carbs ({features['carbs_g_per_kg']:.1f} g/kg)."
            )
            self.logger.info("Nutrition explanation generated")
            return explanation
        except Exception as e:
            self.logger.error(f"Error generating nutrition explanation: {e}")
            return "Error generating explanation."