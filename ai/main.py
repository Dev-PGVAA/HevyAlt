import asyncio
from src.ai_core.feature_builder import FeatureBuilder
from src.ai_core.explainable_ai import ExplainableAI
from src.ai_core.decision_engine import DecisionEngine
from src.analytics.recovery_predictor import RecoveryPredictor
from src.analytics.nutrition_analyzer import NutritionAnalyzer
from src.ai_core.data_pipeline import DataPipeline
from src.config.database import init_db, Session
from src.db.models import Feedback
from src.config.settings import MODEL_DIR

async def main():
    # Initialize database
    init_db()

    # Initialize components
    feature_builder = FeatureBuilder()
    explainable_ai = ExplainableAI()
    recovery_predictor = RecoveryPredictor(MODEL_DIR / "recovery_model.pt", version="1.0")
    await recovery_predictor.initialize()
    nutrition_analyzer = NutritionAnalyzer()
    data_pipeline = DataPipeline()
    decision_engine = DecisionEngine()

    # Example data
    user_id = 1
    health_data = {"heart_rate": 70, "sleep_hours": 7.5, "steps": 8000}
    nutrition_data = {"protein": 120, "fat": 50, "carbs": 200, "body_weight": 75}

    # Save to database
    data_pipeline.save_user_data(user_id, {**health_data, **nutrition_data})

    # Recovery prediction
    recovery_features = feature_builder.build_recovery_features(**health_data)
    recovery_score = await recovery_predictor.predict(recovery_features)
    recovery_recommendation = decision_engine.recovery_recommendation(recovery_score)
    recovery_explanation = explainable_ai.explain_recovery(recovery_score, recovery_features)
    print(f"Recovery: {recovery_recommendation}\nExplanation: {recovery_explanation}")

    # Nutrition analysis
    nutrition_features = feature_builder.build_nutrition_features(**nutrition_data)
    nutrition_recommendation = await nutrition_analyzer.analyze(nutrition_features, nutrition_data["body_weight"])
    nutrition_explanation = explainable_ai.explain_nutrition(nutrition_recommendation, nutrition_features)
    print(f"Nutrition: {nutrition_recommendation}\nExplanation: {nutrition_explanation}")

    # Save feedback (example)
    session = Session()
    feedback = Feedback(user_id=user_id, recommendation=nutrition_recommendation, rating=4)
    feedback.save_feedback(session)  # Исправлен вызов

if __name__ == "__main__":
    asyncio.run(main())