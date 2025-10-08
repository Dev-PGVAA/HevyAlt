import asyncio
from typing import Dict
from src.utils.logger import setup_logger
from src.ai_core.decision_engine import DecisionEngine

logger = setup_logger(__name__)

class NutritionAnalyzer:
    """Analyzes nutrition data asynchronously and provides recommendations."""

    def __init__(self):
        self.decision_engine = DecisionEngine()
        self.logger = logger

    async def analyze(self, features: Dict[str, float], body_weight: float) -> str:
        """Analyzes nutrition features asynchronously."""
        try:
            recommendation = self.decision_engine.nutrition_recommendation(features, body_weight)
            await asyncio.sleep(0.1)  # Simulate async processing
            self.logger.info(f"Nutrition analysis completed: {recommendation}")
            return recommendation
        except Exception as e:
            self.logger.error(f"Error analyzing nutrition: {e}")
            raise