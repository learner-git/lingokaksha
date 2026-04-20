# LingoKaksha 🌍🚀

**LingoKaksha** is a next-generation, AI-first language learning platform designed to help users master **German, French, and Spanish** through immersive, personalized, and dynamic content.

By combining the power of multiple Large Language Models (LLMs) with a robust Flutter frontend, LingoKaksha provides a classroom-like experience right in your pocket.

---

## ✨ Key Features

### 🤖 AI Chat Tutor (GermanShikshak & more)
- **Streaming Conversations**: Real-time practice with AI tutors tailored to your level.
- **Roleplay Scenarios**: Practice real-world situations like ordering at a café, checking into a hotel, or visiting a doctor.
- **Instant Grammar Correction**: A "Magic Wand" tool that analyzes your messages and explains errors before you send them.

### 📚 Adaptive Curriculum
- **Dynamic Lessons**: Content generated on-the-fly based on your current CEFR level (A1 to B2).
- **Interactive Quizzes**: Topic-specific MCQs with deep bilingual explanations for every answer.
- **Mock Exams**: Professional-grade tests designed to mimic official language proficiency exams (Goethe, TELC, etc.).

### 📈 Smart Progress Tracking
- **Firestore Integration**: All your XP, levels, and completed lessons are synced across devices.
- **Multi-Language Support**: Progress is tracked independently for every language you learn.
- **Daily Challenges**: Keep your streak alive with a new "Word of the Day" and daily practice goals.

---

## 🏗 System Architecture

LingoKaksha uses a **Multi-Provider Fallback Architecture** to ensure high availability:
1. **Primary**: Gemini 2.0 (Vertex AI) — Fast and intelligent.
2. **Secondary**: Groq (Llama 3.3) — Ultra-low latency fallback.
3. **Tertiary**: OpenAI (GPT-4o Mini) — Industry-standard accuracy.

---

## 🛠 Tech Stack

- **Frontend**: Flutter (Riverpod for State Management)
- **Backend**: FastAPI (Python)
- **Database**: Firebase / Firestore
- **AI SDKs**: Google GenAI, Groq, OpenAI
- **Deployment**: Dockerized Backend

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- [Firebase Account](https://firebase.google.com/)
- API Keys for Gemini, Groq, or OpenAI.

### Installation

1. **Clone the Repo**
   ```bash
   git clone https://github.com/your-username/lingokaksha.git
   cd lingokaksha
   ```

2. **Frontend Setup**
   ```bash
   flutter pub get
   flutter run
   ```

3. **Backend Setup**
   ```bash
   cd backend
   pip install -r requirements.txt
   python main.py
   ```

---

## 📂 Project Structure

- `/lib`: Flutter source code (Providers, Models, Screens).
- `/backend`: FastAPI server and AI logic.
- `/assets`: Images, fonts, and local data.

---

## 📝 License
This project is for educational purposes.

---
*Built with ❤️ for global learners.*
