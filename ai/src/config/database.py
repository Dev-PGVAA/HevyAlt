from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from src.utils.logger import setup_logger

logger = setup_logger(__name__)

DATABASE_URL = "postgresql://postgres:372159@localhost:5432/hevyalt_db"
engine = create_engine(DATABASE_URL)
Session = sessionmaker(bind=engine)

def init_db():
    """Initialize database tables."""
    from src.db.models import Base
    try:
        Base.metadata.create_all(engine)
        logger.info("Database initialized")
    except Exception as e:
        logger.error(f"Error initializing database: {e}")
        raise