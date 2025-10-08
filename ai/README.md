````markdown
# HevyAlt AI Fitness Advisor

Гайд по установке, использованию и обучению модели для проекта `HevyAlt AI Fitness Advisor`.

## Требования

- Python 3.9+
- PostgreSQL 15 (локально)
- pip для установки зависимостей
- Git для клонирования репозитория
- LightGBM для обучения модели

## Установка

1. **Клонируйте репозиторий**:
   ```bash
   git clone <ваш-репозиторий>
   cd ai_fitness_advisor
   ```
````

2. **Установите зависимости**:

   ```bash
   pip install -r requirements.txt
   ```

3. **Установите PostgreSQL локально**:

   - **MacOS**:
     ```bash
     brew install postgresql@15
     brew services start postgresql@15
     ```
   - **Ubuntu**:
     ```bash
     sudo apt update
     sudo apt install postgresql-15
     sudo service postgresql start
     ```
   - **Windows**:
     Скачайте и установите PostgreSQL 15 с [официального сайта](https://www.postgresql.org/download/windows/).

4. **Настройте базу данных**:

   - Подключитесь к PostgreSQL:
     ```bash
     psql -U postgres
     ```
   - Создайте пользователя и базу данных:
     ```sql
     CREATE USER hevyalt WITH PASSWORD 'password';
     CREATE DATABASE hevyalt_db OWNER hevyalt;
     GRANT ALL PRIVILEGES ON DATABASE hevyalt_db TO hevyalt;
     \q
     ```
   - Проверьте подключение:
     ```bash
     psql -h localhost -U hevyalt -d hevyalt_db
     ```

5. **Инициализируйте базу данных**:
   ```bash
   python3 -c "from src.config.database import init_db; init_db()"
   ```

## Использование

1. **Запустите приложение**:

   ```bash
   python3 main.py
   ```

   Выводит рекомендации по восстановлению и питанию на основе тестовых данных:

   ```
   Recovery: Low recovery: prioritize rest or light activity.
   Explanation: Your recovery score is 0.0%. Based on heart rate (70 bpm), sleep (7.5 hours), and steps (8000).
   Nutrition: Increase carbs intake: current 2.7 g/kg, target 4.0 g/kg.
   Explanation: Nutrition advice: Increase carbs intake: current 2.7 g/kg, target 4.0 g/kg. Based on protein (1.6 g/kg), fat (0.7 g/kg), and carbs (2.7 g/kg).
   ```

2. **Проверьте тесты**:
   ```bash
   pytest tests/
   ```

## Обучение модели

1. **Подготовьте данные**:

   - Соберите данные через `DataPipeline`:
     ```python
     from src.ai_core.data_pipeline import DataPipeline
     pipeline = DataPipeline()
     health_data = {
         "user_id": 1,
         "heart_rate": 70.0,
         "sleep_hours": 7.5,
         "steps": 8000,
         "protein": 120.0,
         "fat": 50.0,
         "carbs": 200.0,
         "body_weight": 75.0
     }
     pipeline.save_user_data(1, health_data)
     ```
   - Экспортируйте данные в CSV:
     ```python
     import pandas as pd
     data = pipeline.fetch_user_data(1)
     df = pd.DataFrame(data)
     df["recovery_score"] = df["sleep_hours"] * 12 - df["heart_rate"] * 0.6 + df["steps"] / 10000 * 15
     df["recovery_score"] = df["recovery_score"].clip(0, 100)
     df.to_csv("training_data.csv", index=False)
     ```

2. **Создайте скрипт для обучения** (`train_recovery_model.py`):

   ```python
   import lightgbm as lgb
   import pandas as pd
   from sklearn.model_selection import train_test_split
   from src.utils.logger import setup_logger
   from src.config.settings import MODEL_DIR

   logger = setup_logger(__name__)

   def train_recovery_model(data_path: str, model_path: str):
       try:
           df = pd.read_csv(data_path)
           X = df[["heart_rate", "sleep_hours", "steps"]]
           y = df["recovery_score"]
           X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
           model = lgb.LGBMRegressor(n_estimators=100, learning_rate=0.1)
           model.fit(X_train, y_train, eval_set=[(X_test, y_test)], eval_metric="rmse")
           model.save_model(model_path)
           logger.info(f"Модель сохранена в {model_path}")
       except Exception as e:
           logger.error(f"Ошибка обучения модели: {e}")
           raise

   if __name__ == "__main__":
       train_recovery_model("training_data.csv", str(MODEL_DIR / "recovery_model.txt"))
   ```

3. **Обучите модель**:

   ```bash
   python3 train_recovery_model.py
   ```

4. **Обновите `ModelManager` для загрузки модели**:
   В `src/ai_core/model_manager.py`:

   ```python
   import lightgbm as lgb
   from typing import Dict
   import asyncio
   from src.utils.logger import setup_logger
   from pathlib import Path

   logger = setup_logger(__name__)

   class ModelManager:
       def __init__(self):
           self.models = {}
           self.logger = logger

       async def load_model(self, model_name: str, model_path: str, version: str = "1.0") -> None:
           try:
               self.models.setdefault(model_name, {})[version] = lgb.Booster(model_file=model_path)
               self.logger.info(f"Model {model_name} v{version} loaded from {model_path}")
           except Exception as e:
               self.logger.error(f"Error loading model {model_name} v{version}: {e}")
               raise

       async def predict(self, model_name: str, features: Dict[str, float], version: str = "1.0") -> float:
           try:
               if model_name not in self.models or version not in self.models[model_name]:
                   raise ValueError(f"Model {model_name} v{version} not loaded")
               model = self.models[model_name][version]
               X = [[features["heart_rate"], features["sleep_hours"], features["steps_normalized"]]]
               prediction = model.predict(X)[0]
               await asyncio.sleep(0.1)  # Simulate async work
               self.logger.info(f"Prediction for {model_name} v{version}: {prediction}")
               return float(prediction)
           except Exception as e:
               self.logger.error(f"Error predicting with {model_name} v{version}: {e}")
               raise
   ```

5. **Перезапустите приложение**:
   ```bash
   python3 main.py
   ```

## Примечания

- **Логи**: Проверяйте `ai_fitness.log` для диагностики.
- **Обучение**: Для точных предсказаний соберите больше данных и добавьте целевую переменную (`recovery_score`).
- **Расширения**: Добавьте поддержку компьютерного зрения (Mediapipe) или голосового анализа (Whisper) для анализа техники или заметок.

```

```
