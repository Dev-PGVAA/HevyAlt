Ниже представлен улучшенный **README.md** для проекта **HevyAlt AI Core** на русском языке, включающий план развития AI, подробное руководство по использованию и обучению, с акцентом на PostgreSQL и лучшие практики. Руководство описывает настройку, использование и обучение AI-компонентов, таких как предиктор восстановления и анализатор питания.

---

# HevyAlt AI Core

**HevyAlt AI Core** — модульная, масштабируемая система ИИ для персонализированных фитнес-рекомендаций, использующая данные HealthKit, питания и тренировок. Предоставляет оценки восстановления, советы по питанию и объяснения, храня данные в PostgreSQL.

## Функции

- **Предиктор восстановления**: Оценивает готовность к тренировкам по пульсу, сну и шагам.
- **Анализатор питания**: Предлагает корректировки макронутриентов.
- **Объясняемый ИИ**: Простые объяснения рекомендаций.
- **Конвейер данных**: Хранит данные и обратную связь в PostgreSQL.
- **Асинхронная обработка**: Эффективные прогнозы в реальном времени.
- **Обратная связь**: Сбор оценок пользователей для улучшения моделей.

## План развития ИИ

### Базовые функции ИИ (MVP)

- **Предиктор восстановления**: Асинхронный расчет на основе LightGBM.
- **Анализатор питания**: Рекомендации по макронутриентам с конфигурацией в PostgreSQL.
- **Объясняемый ИИ**: Понятные объяснения всех выводов.
- **Конвейер данных**: Хранение данных и обратной связи в PostgreSQL.

### Продвинутые функции ИИ (будущее)

- **Адаптивные тренировки**: Динамические планы (LSTM/Transformer).
- **Прогноз прогресса**: Предсказание силы и состава тела (XGBoost).
- **Анализ техники**: Оценка техники по видео (Mediapipe + PyTorch).
- **Анализ голосовых заметок**: Извлечение настроения и намерений (Whisper + NLP).
- **Персональные челленджи**: Генерация мотивационных целей.
- **Рекомендации добавок**: Советы по питательным веществам.

### Технический план

- **Архитектура**: Модульный `ai_core` с асинхронными `model_manager`, `feature_builder`, `decision_engine`, `data_pipeline`.
- **База данных**: PostgreSQL для конфигураций, данных и обратной связи.
- **Масштабируемость**: Асинхронная обработка, очередь Redis (планируется).
- **Модели**: Rule-based (MVP) → ML (LightGBM, PyTorch) → Глубокое обучение.

### Следующие шаги

1. Обучение LightGBM для восстановления/питания (1 кв. 2026).
2. Интеграция анализа техники по видео (2 кв. 2026).
3. Добавление обработки голоса и челленджей (3 кв. 2026).
4. Внедрение Redis для масштабируемости (4 кв. 2026).

## Руководство по использованию и обучению

### Требования

- Python 3.9+
- PostgreSQL 15
- Docker (для запуска PostgreSQL)
- Зависимости: `numpy`, `torch`, `scikit-learn`, `sqlalchemy`, `psycopg2-binary`, `tenacity`, `pytest`, `pytest-asyncio`, `lightgbm`, `pandas`

### Настройка

1. **Клонируйте репозиторий**:

   ```bash
   git clone <repository-url>
   cd ai_fitness_advisor
   ```

2. **Установите зависимости**:

   ```bash
   pip install -r requirements.txt
   ```

3. **Запустите PostgreSQL**:

   ```bash
   docker-compose up -d
   ```

   - Запускает PostgreSQL на `localhost:5432` с пользователем `hevyalt`, паролем `password` и базой `hevyalt_db`.

4. **Инициализируйте базу данных**:
   ```bash
   python -c "from src.config.database import init_db; init_db()"
   ```
   - Создает таблицы для конфигураций, данных пользователей и обратной связи.

### Использование

1. **Запустите приложение**:

   ```bash
   python main.py
   ```

   - Обрабатывает тестовые данные (пульс: 70 уд/мин, сон: 7.5 ч, шаги: 8000, белки: 120 г, жиры: 50 г, углеводы: 200 г, вес: 75 кг).
   - Сохраняет данные в PostgreSQL, генерирует рекомендации по восстановлению/питанию и сохраняет обратную связь.

   **Пример вывода**:

   ```
   Восстановление: Умеренное восстановление: выберите тренировку средней интенсивности.
   Объяснение: Ваш показатель восстановления 67.5%. Основано на пульсе (70 уд/мин), сне (7.5 ч) и шагах (8000).
   Питание: Увеличьте потребление белка: текущий уровень 1.6 г/кг, целевой 1.6 г/кг. Снизьте потребление углеводов: текущий уровень 2.7 г/кг, целевой 4.0 г/кг.
   Объяснение: Рекомендация по питанию: Увеличьте потребление белка: текущий уровень 1.6 г/кг, целевой 1.6 г/кг. Снизьте потребление углеводов: текущий уровень 2.7 г/кг, целевой 4.0 г/кг. Основано на белках (1.6 г/кг), жирах (0.7 г/кг) и углеводах (2.7 г/кг).
   ```

2. **Запустите тесты**:

   ```bash
   pytest tests/
   ```

   - Проверяет функциональность `FeatureBuilder` и `RecoveryPredictor`.

3. **Сохранение пользовательских данных**:
   Измените `main.py` для ввода своих данных:

   ```python
   health_data = {"heart_rate": 65, "sleep_hours": 8.0, "steps": 10000}
   nutrition_data = {"protein": 150, "fat": 60, "carbs": 180, "body_weight": 80}
   ```

4. **Запрос данных пользователя**:
   Используйте `DataPipeline` для получения данных:

   ```python
   from src.ai_core.data_pipeline import DataPipeline
   pipeline = DataPipeline()
   user_data = pipeline.fetch_user_data(user_id=1)
   print(user_data)
   ```

5. **Отправка обратной связи**:
   Добавьте обратную связь по рекомендациям:
   ```python
   from src.db.models import Feedback, Session
   session = Session()
   Feedback.save_feedback(session, user_id=1, recommendation="Увеличьте белок", rating=4)
   ```

### Обучение моделей ИИ

Текущий MVP использует rule-based логику. Для обучения модели LightGBM для `RecoveryPredictor`:

1. **Подготовьте данные**:

   - Соберите данные (пульс, часы сна, шаги, оценка восстановления) в CSV:
     ```csv
     heart_rate,sleep_hours,steps,recovery_score
     70,7.5,8000,67.5
     65,8.0,10000,75.0
     ```
   - Сохраните в `data/train_recovery.csv`.

2. **Обучите модель LightGBM**:

   ```python
   import lightgbm as lgb
   import pandas as pd
   from src.utils.logger import setup_logger

   logger = setup_logger(__name__)

   def train_recovery_model(data_path: str, model_path: str) -> None:
       try:
           data = pd.read_csv(data_path)
           X = data[["heart_rate", "sleep_hours", "steps"]]
           y = data["recovery_score"]
           model = lgb.LGBMRegressor()
           model.fit(X, y)
           model.save_model(model_path)
           logger.info(f"Модель сохранена в {model_path}")
       except Exception as e:
           logger.error(f"Ошибка обучения модели: {e}")
           raise

   train_recovery_model("data/train_recovery.csv", "models/recovery_model.txt")
   ```

3. **Обновите ModelManager**:
   Измените `ModelManager.load_model` для загрузки модели LightGBM:

   ```python
   import lightgbm as lgb

   async def load_model(self, model_name: str, model_path: str, version: str = "1.0") -> None:
       try:
           self.models.setdefault(model_name, {})[version] = lgb.Booster(model_file=model_path)
           self.logger.info(f"Модель {model_name} v{version} загружена из {model_path}")
       except Exception as e:
           self.logger.error(f"Ошибка загрузки модели {model_name} v{version}: {e}")
           raise
   ```

4. **Обновите предсказание**:
   Измените `RecoveryPredictor.predict` для использования LightGBM:

   ```python
   async def predict(self, features: Dict[str, float]) -> float:
       try:
           model = self.model_manager.models["recovery_model"]["1.0"]
           X = [[features["heart_rate"], features["sleep_hours"], features["steps_normalized"] * 10000]]
           score = model.predict(X)[0]
           score = max(0, min(100, score))
           await asyncio.sleep(0.1)  # Имитация асинхронности
           self.logger.info(f"Предсказанный показатель восстановления: {score}")
           return score
       except Exception as e:
           self.logger.error(f"Ошибка предсказания восстановления: {e}")
           raise
   ```

5. **Периодическое переобучение**:

   - Собирайте обратную связь из таблицы `Feedback` для маркировки новых данных.
   - Планируйте переобучение (например, ежемесячно) с помощью скрипта или cron:
     ```bash
     python train_recovery_model.py
     ```

6. **Сохранение конфигураций**:
   Обновите пороговые значения в PostgreSQL:
   ```python
   from src.db.models import Config, Session
   session = Session()
   config = Config(name="thresholds", parameters={"low": 60, "medium": 80, "protein": 1.6, "fat": 0.8, "carbs": 4.0})
   session.add(config)
   session.commit()
   ```

### Структура проекта

```
ai_fitness_advisor/
├── data/
│   └── train_recovery.csv
├── models/
│   └── recovery_model.txt
├── src/
│   ├── ai_core/
│   │   ├── __init__.py
│   │   ├── feature_builder.py
│   │   ├── model_manager.py
│   │   ├── decision_engine.py
│   │   ├── explainable_ai.py
│   │   └── data_pipeline.py
│   ├── analytics/
│   │   ├── __init__.py
│   │   ├── recovery_predictor.py
│   │   └── nutrition_analyzer.py
│   ├── config/
│   │   ├── __init__.py
│   │   └── database.py
│   ├── db/
│   │   ├── __init__.py
│   │   └── models.py
│   ├── utils/
│   │   ├── __init__.py
│   │   └── logger.py
├── tests/
│   ├── __init__.py
│   ├── test_feature_builder.py
│   └── test_recovery_predictor.py
├── docker-compose.yml
├── requirements.txt
└── main.py
```

### Требования

```text
numpy>=1.21.0
torch>=2.0.0
scikit-learn>=1.0.0
sqlalchemy>=2.0.0
psycopg2-binary>=2.9.0
tenacity>=8.0.0
pytest>=7.0.0
pytest-asyncio>=0.18.0
lightgbm>=3.3.0
pandas>=1.5.0
```

## Вклад в проект

- Отправляйте запросы и исправления на `<repository-url>`.
- Соблюдайте стиль кода PEP 8.
- Добавляйте тесты для новых функций.

## Лицензия

MIT License

---

Этот README предоставляет четкий обзор, полное руководство по использованию и обучению, а также план развития. Если нужны доработки или дополнительные разделы (например, инструкции по развертыванию), дайте знать!
