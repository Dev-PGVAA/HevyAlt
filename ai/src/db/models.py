from sqlalchemy import Column, Integer, Float, String, JSON
from sqlalchemy.ext.declarative import declarative_base
from src.utils.logger import setup_logger

Base = declarative_base()
logger = setup_logger(__name__)

class Config(Base):
    """Stores AI configuration parameters."""
    __tablename__ = "configs"
    id = Column(Integer, primary_key=True)
    name = Column(String, unique=True)
    parameters = Column(JSON)

class UserData(Base):
    """Stores user health and nutrition data."""
    __tablename__ = "user_data"
    id = Column(Integer, primary_key=True)
    user_id = Column(Integer)
    heart_rate = Column(Float)
    sleep_hours = Column(Float)
    steps = Column(Integer)
    protein = Column(Float)
    fat = Column(Float)
    carbs = Column(Float)
    body_weight = Column(Float)

class Feedback(Base):
    """Stores user feedback on recommendations."""
    __tablename__ = "feedback"
    id = Column(Integer, primary_key=True)
    user_id = Column(Integer)
    recommendation = Column(String)
    rating = Column(Integer)  # 1-5 scale

    def save_feedback(self, session) -> None:
        """Saves feedback to database."""
        try:
            session.add(self)
            session.commit()
            logger.info(f"Saved feedback for user {self.user_id}")
        except Exception as e:
            session.rollback()
            logger.error(f"Error saving feedback: {e}")
            raise