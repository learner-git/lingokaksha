# LingoKaksha Backend

A high-performance, AI-driven backend for the **LingoKaksha** multi-language learning platform. Built with **FastAPI**, this service leverages a sophisticated fallback architecture across multiple LLM providers to ensure 99.9% uptime and low-latency responses.

## 🚀 Features

*   **AI Chat Tutor**: Real-time streaming conversation with CEFR-aligned roleplay and corrections.
*   **Dynamic Quiz Generation**: Topic-specific MCQs with detailed bilingual explanations.
*   **Mock Exams**: Professional-grade proficiency tests mimicking official standards (e.g., Goethe, TELC).
*   **Structured Lessons**: Dynamically generated curriculum content with examples and practice.
*   **Grammar Engine**: Intelligent sentence analysis and bilingual correction.

## 🛠 Tech Stack

- **Framework**: FastAPI (Asynchronous Python)
- **AI Providers**: 
  - Google GenAI (Gemini 2.0 Flash)
  - Groq Cloud (Llama 3.3 70B)
  - OpenAI (GPT-4o Mini)
- **Validation**: Pydantic v2
- **Environment**: Python Dotenv

## ⚙️ Setup & Installation

### 1. Prerequisites
- Python 3.9+
- A Google Cloud Project (for Vertex AI) or Gemini API Key
- Groq API Key (Optional fallback)
- OpenAI API Key (Optional fallback)

### 2. Install Dependencies
```bash
pip install -r requirements.txt
```

### 3. Environment Configuration
Create a `.env` file in the root of the backend directory:
```env
# Gemini / Vertex AI
GOOGLE_CLOUD_PROJECT=your-project-id
GOOGLE_CLOUD_LOCATION=us-central1
GOOGLE_API_KEY=your-gemini-key

# Groq
GROQ_API_KEY=your-groq-key
GROQ_MODEL=llama-3.3-70b-versatile

# OpenAI
OPENAI_API_KEY=your-openai-key

# Server Settings
PORT=8000
```

### 4. Run the Server
```bash
python main.py
```
The API will be available at `http://localhost:8000`. Documentation (Swagger UI) is available at `/docs`.

## 🔌 API Reference

### POST `/api/tutor`
Streams a conversation with the AI tutor.
**Body:** `{"messages": [...], "language": "german", "level": "A2", "topic": "at the restaurant"}`

### POST `/api/quiz`
Generates 5-10 MCQ questions.
**Body:** `{"topic": "Verbs", "level": "B1", "language": "german", "count": 5}`

### POST `/api/lesson`
Generates a structured language lesson.
**Body:** `{"topic": "Dative Prepositions", "level": "A2", "language": "german"}`

### POST `/api/grammar`
Analyzes and corrects a sentence.
**Body:** `{"sentence": "Ich gehe zu der Schule.", "language": "german"}`

## 🏗 Architecture: Unified Dispatcher Pattern

The backend implements a **Unified Dispatcher Pattern** found in `main.py`. This ensures that if the primary provider (Gemini) encounters a rate limit or cold start delay, the request is instantly re-routed to Groq or OpenAI. 

All prompts are externalized in `prompts.py` for easy maintenance and A/B testing of pedagogical strategies.

---
Developed with ❤️ for LingoKaksha Learners.
