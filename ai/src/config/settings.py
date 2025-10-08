from pathlib import Path

# Paths
BASE_DIR = Path(__file__).parent.parent.parent
MODEL_DIR = BASE_DIR / "models"

# Recovery thresholds
RECOVERY_THRESHOLD = {
    "low": 60,
    "medium": 80,
}

# Nutrition targets (grams per kg of body weight)
MACRO_TARGETS = {
    "protein": 1.6,  # g/kg
    "fat": 0.8,      # g/kg
    "carbs": 4.0,    # g/kg
}