from typing import Dict, List
from src.utils.logger import setup_logger
from src.db.models import UserData
from src.config.database import Session

logger = setup_logger(__name__)

class DataPipeline:
    """Handles data preprocessing and caching to PostgreSQL."""

    def __init__(self):
        self.logger = logger
        self.session = Session()

    def save_user_data(self, user_id: int, data: Dict[str, float]) -> None:
        """Saves user data to PostgreSQL."""
        try:
            user_data = UserData(
                user_id=user_id,
                heart_rate=data.get("heart_rate", 0.0),
                sleep_hours=data.get("sleep_hours", 0.0),
                steps=int(data.get("steps", 0)),
                protein=data.get("protein", 0.0),
                fat=data.get("fat", 0.0),
                carbs=data.get("carbs", 0.0),
                body_weight=data.get("body_weight", 0.0),
            )
            self.session.add(user_data)
            self.session.commit()
            self.logger.info(f"Saved data for user {user_id}")
        except Exception as e:
            self.session.rollback()
            self.logger.error(f"Error saving user data: {e}")
            raise

    def fetch_user_data(self, user_id: int) -> List[Dict[str, float]]:
        """Fetches user data from PostgreSQL."""
        try:
            records = self.session.query(UserData).filter_by(user_id=user_id).all()
            data = [
                {
                    "heart_rate": r.heart_rate,
                    "sleep_hours": r.sleep_hours,
                    "steps": r.steps,
                    "protein": r.protein,
                    "fat": r.fat,
                    "carbs": r.carbs,
                    "body_weight": r.body_weight,
                }
                for r in records
            ]
            self.logger.info(f"Fetched {len(data)} records for user {user_id}")
            return data
        except Exception as e:
            self.logger.error(f"Error fetching user data: {e}")
            raise