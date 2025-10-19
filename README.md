# HevyAlt <span style="float: right">![Status](https://img.shields.io/badge/status-in_development-orange)</span>

![Backend](https://img.shields.io/badge/Backend-NestJS_+_PostgreSQL-red)
![Frontend](https://img.shields.io/badge/Frontend-Flutter-blue)
![AI Powered](https://img.shields.io/badge/AI-Powered-purple?logo=openai)
![License](https://img.shields.io/badge/License-HPUL--1.0-blue)

**Hevy Workout App Alternative** — открытое приложение для отслеживания тренировок, вдохновлённое популярным Hevy Workout App.  
Проект создан для спортсменов и энтузиастов, которые хотят гибко управлять тренировками, отслеживать прогресс и получать персональные рекомендации от AI.

---

## 💡 Vision

> Сделать лучший open-source фитнес-трекер, который остаётся бесплатным, приватным и умным — без рекламы и подписок.

**HevyAlt** объединяет гибкость кастомных тренировок, анализ прогресса и AI-советника в одном приложении.

---

## ⚙️ Основные возможности

- Авторизация пользователей
- Интеграция с HealthKit (чтение и запись данных)
- Мини-календарь тренировок и активности
- Трекер с шаблонами упражнений и сетов
- Система тегов (категоризация и фильтрация)
- Дневник питания и расчёт макросов
- Замеры тела (вес, объёмы, фото, графики)
- Общий дашборд со статистикой
- **AI-советник по тренировкам и питанию**
- Speech-to-Text голосовые заметки
- Интеграция с Apple Watch и iOS-виджетами
- Социальные функции и челленджи _(в планах)_

---

## 🧠 AI Features

- Генерация тренировочных планов и питания
- AI-советы по прогрессу и мотивации
- Анализ макросов и калорий
- Speech-to-Text заметки
- Персонализация рекомендаций на основе данных пользователя

---

## 🧩 Технологии

- **Frontend:** Flutter
- **Backend:** Node.js + NestJS
- **База данных:** PostgreSQL
- **AI Backend:** OpenAI API / LLM
- **Аутентификация:** JWT

---

## 🏗 Установка и запуск

### 1. Клонирование репозитория

```bash
git clone https://github.com/Dev-PGVAA/HevyAlt.git
cd HevyAlt
```

### 2. Установка зависимостей

**Backend:**

```bash
cd server
npm install
```

**Frontend (Flutter):**

```bash
cd native
flutter pub get
```

### 3. Настройка окружения

Создай `server/.env`:

```env
DATABASE_URL=<ваш_адрес_базы>
JWT_SECRET=<ваш_секрет>
PORT=5000
```

### 4. Запуск сервера

```bash
cd server
npm run dev
```

### 5. Запуск мобильного приложения

```bash
cd native
flutter run
```

---

## 🆚 Почему HevyAlt?

| Функция                   | Hevy        | HevyAlt |
| ------------------------- | ----------- | ------- |
| Open Source               | ❌          | ✅      |
| AI Рекомендации           | ❌          | ✅      |
| Личные шаблоны упражнений | 🔸 частично | ✅      |
| Без рекламы и подписок    | ❌          | ✅      |
| Гибкая фильтрация и теги  | 🔸          | ✅      |

---

## 🤝 Contributing

PR’ы приветствуются!
Если хочешь помочь:

1. Сделай fork
2. Создай ветку `feature/my-feature`
3. Отправь Pull Request

Пожалуйста, ознакомься с `LICENSE` перед публикацией изменений.

---

## 🔐 Privacy & Security

Проект не собирает и не передаёт личные данные без согласия.

---

## 📄 License

This project is licensed under the **HevyAlt Personal Use License (HPUL-1.0)**.
You may study and modify the source code for personal use, but redistribution or commercial use is prohibited.
See the [LICENSE](./LICENSE) file for full details.

---

> _HevyAlt — ваш помощник в мире фитнеса и здоровья._
