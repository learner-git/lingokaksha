"""
LingoKaksha Backend — Professional Refactor
Priority: Gemini (Vertex AI) -> Groq -> OpenAI
"""

import json
import os
import asyncio
import logging
import re
from typing import Optional, List, Dict, Any, AsyncGenerator
from contextlib import asynccontextmanager

from dotenv import load_dotenv

from fastapi import FastAPI, HTTPException, Security, Depends, File, UploadFile
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import StreamingResponse
from pydantic import BaseModel
import tempfile

# SDK Imports
try:
    from google import genai
    from google.genai import types
except ImportError:
    genai = None
    types = None
    print("Warning: google-genai not installed")

from groq import AsyncGroq
from openai import AsyncOpenAI

# Custom Prompts
import prompts

load_dotenv()

# --- Configuration & Logging ---
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s"
)
logger = logging.getLogger("LingoKaksha.Backend")

# --- Global State ---
STATE = {
    "client": None,
    "gemini_available": False,
    "groq": None,
    "openai": None
}

# --- Constants ---
DEFAULT_TIMEOUT = 45
GEMINI_MODEL = os.getenv("GEMINI_MODEL", "gemini-2.0-flash")
GROQ_MODEL = os.getenv("GROQ_MODEL", "llama-3.1-8b-instant")
OPENAI_MODEL = "gpt-4o-mini"

# --- Lifespan Manager ---
@asynccontextmanager
async def lifespan(app: FastAPI):
    """Handles startup and shutdown of AI clients safely."""
    logger.info("Initializing AI Clients...")

    # 1. Gemini (Vertex AI or API Key)
    try:
        project = os.getenv("GOOGLE_CLOUD_PROJECT")
        api_key = os.getenv("GOOGLE_API_KEY")

        if genai:
            if project:
                STATE["client"] = genai.Client(
                    vertexai=True,
                    project=project,
                    location=os.getenv("GOOGLE_CLOUD_LOCATION", "eu-west1")
                )
                STATE["gemini_available"] = True
                logger.info(f"Gemini (Vertex AI) initialized for project: {project}")
            elif api_key:
                STATE["client"] = genai.Client(api_key=api_key)
                STATE["gemini_available"] = True
                logger.info("Gemini initialized using API Key.")
    except Exception as e:
        logger.error(f"Gemini Init Failed: {e}")

    # 2. Groq
    try:
        groq_key = os.getenv("GROQ_API_KEY")
        if groq_key:
            STATE["groq"] = AsyncGroq(api_key=groq_key)
            logger.info("Groq client initialized.")
    except Exception as e:
        logger.error(f"Groq Init Failed: {e}")

    # 3. OpenAI
    try:
        oa_key = os.getenv("OPENAI_API_KEY")
        if oa_key:
            STATE["openai"] = AsyncOpenAI(api_key=oa_key)
            logger.info("OpenAI client initialized.")
    except Exception as e:
        logger.error(f"OpenAI Init Failed: {e}")

    yield
    # Shutdown logic (if any)
    logger.info("Shutting down AI clients...")

# --- FastAPI App Setup ---
app = FastAPI(
    title="LingoKaksha API",
    lifespan=lifespan
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"]
)

# --- Pydantic Schemas ---
class TutorRequest(BaseModel):
    messages: List[Dict[str, str]]
    level: str = "A2"
    topic: str = "general conversation"
    language: str = "german"

class QuizRequest(BaseModel):
    topic: str
    level: str
    count: int = 5
    language: str = "german"

class LessonRequest(BaseModel):
    topic: str
    level: str
    language: str = "german"

class GrammarRequest(BaseModel):
    sentence: str
    level: Optional[str] = None
    language: str = "german"

class ClarificationRequest(BaseModel):
    topic: str
    level: str
    current_explanation: str
    language: str = "german"

class WordDetailsRequest(BaseModel):
    word: str
    language: str = "german"
    level: str = "A1"

class VoiceStartRequest(BaseModel):
    mode: str
    language: str
    level: str

# --- Core AI Dispatcher ---

async def call_llm(prompt: str, system_instruction: str, json_mode: bool = True, max_tokens: int = 1500) -> Optional[str]:
    """Unified Non-Streaming Dispatcher: Gemini -> Groq -> OpenAI"""

    # 1. Gemini (Priority 1)
    if STATE["gemini_available"] and STATE["client"]:
        try:
            config = types.GenerateContentConfig(
                system_instruction=system_instruction,
                temperature=0.3,
                max_output_tokens=max_tokens,
                response_mime_type="application/json" if json_mode else "text/plain"
            )
            response = await STATE["client"].aio.models.generate_content(
                model=GEMINI_MODEL,
                contents=prompt,
                config=config
            )
            if response.text: return response.text
        except Exception as e:
            logger.warning(f"Gemini failed: {e}")

    # 2. Groq (Priority 2)
    if STATE["groq"]:
        try:
            resp = await asyncio.wait_for(
                STATE["groq"].chat.completions.create(
                    model=GROQ_MODEL,
                    messages=[
                        {"role": "system", "content": f"{system_instruction} Return ONLY JSON."},
                        {"role": "user", "content": prompt}
                    ],
                    response_format={"type": "json_object"} if json_mode else None,
                    temperature=0.2,
                    max_tokens=max_tokens
                ), timeout=DEFAULT_TIMEOUT
            )
            return resp.choices[0].message.content
        except Exception as e:
            logger.warning(f"Groq failed: {e}")

    # 3. OpenAI (Final Fallback)
    if STATE["openai"]:
        try:
            resp = await asyncio.wait_for(
                STATE["openai"].chat.completions.create(
                    model=OPENAI_MODEL,
                    messages=[
                        {"role": "system", "content": system_instruction},
                        {"role": "user", "content": prompt}
                    ],
                    response_format={"type": "json_object"} if json_mode else None,
                    temperature=0.3
                ), timeout=DEFAULT_TIMEOUT
            )
            return resp.choices[0].message.content
        except Exception as e:
            logger.error(f"All LLMs failed: {e}")

    return None

async def stream_llm(messages: List[Dict[str, str]], system_prompt: str) -> AsyncGenerator[str, None]:
    """Unified Streaming Dispatcher for Chat Tutor"""

    # 1. Gemini Stream
    if STATE["gemini_available"] and STATE["client"]:
        try:
            contents = [types.Content(role=m["role"], parts=[types.Part.from_text(text=m["content"])]) for m in messages]
            async for chunk in STATE["client"].aio.models.generate_content_stream(
                model=GEMINI_MODEL,
                contents=contents,
                config=types.GenerateContentConfig(system_instruction=system_prompt, temperature=0.7)
            ):
                if chunk.text: yield chunk.text
            return
        except Exception as e:
            logger.warning(f"Gemini Stream Failed: {e}")

    # 2. Groq Stream
    if STATE["groq"]:
        try:
            full_messages = [{"role": "system", "content": system_prompt}] + messages
            stream = await STATE["groq"].chat.completions.create(
                model=GROQ_MODEL,
                messages=full_messages,
                stream=True,
                temperature=0.7
            )
            async for chunk in stream:
                content = chunk.choices[0].delta.content
                if content: yield content
            return
        except Exception as e:
            logger.warning(f"Groq Stream Failed: {e}")

    # 3. OpenAI Stream
    if STATE["openai"]:
        try:
            full_messages = [{"role": "system", "content": system_prompt}] + messages
            stream = await STATE["openai"].chat.completions.create(
                model=OPENAI_MODEL,
                messages=full_messages,
                stream=True
            )
            async for chunk in stream:
                content = chunk.choices[0].delta.content
                if content: yield content
            return
        except Exception as e:
            logger.error(f"OpenAI Stream Failed: {e}")

    yield "Service temporarily unavailable. Please try again later."

# --- Helper Functions ---

def clean_and_parse_json(raw: str) -> Dict[str, Any]:
    """Robustly cleans LLM output and parses into a Dict."""
    try:
        cleaned = re.sub(r"```json\s?|\s?```", "", raw).strip()
        start = cleaned.find('{')
        end = cleaned.rfind('}')
        if start != -1 and end != -1:
            cleaned = cleaned[start : end + 1]
        cleaned = re.sub(r',\s*([\]}])', r'\1', cleaned)
        return json.loads(cleaned, strict=False)
    except Exception as e:
        logger.error(f"JSON Parse Error. Raw content: {raw}")
        raise HTTPException(status_code=500, detail="Invalid AI Response Format")

# --- Endpoints ---

@app.post("/api/tutor")
async def chat_tutor(req: TutorRequest):
    system_prompt = prompts.get_tutor_system_prompt(req.language, req.level, req.topic)
    filtered_messages = [m for m in req.messages if m.get("role") != "system"][-6:]
    return StreamingResponse(stream_llm(filtered_messages, system_prompt), media_type="text/plain")

@app.post("/api/quiz")
async def generate_quiz(req: QuizRequest):
    prompt = prompts.get_quiz_prompt(req.language, req.level, req.topic, req.count)
    system = f"You are a {req.language} teacher. Return ONLY JSON."
    raw = await call_llm(prompt, system)
    if not raw: raise HTTPException(502, "AI Service Unavailable")
    return clean_and_parse_json(raw)

@app.post("/api/exam")
async def generate_exam(req: QuizRequest):
    prompt = prompts.get_exam_prompt(req.language, req.level, req.topic)
    system = f"You are an official {req.language} Examiner. Return JSON only."
    raw = await call_llm(prompt, system, max_tokens=3000)
    if not raw: raise HTTPException(502, "Exam service offline")
    return clean_and_parse_json(raw)

@app.post("/api/lesson")
async def generate_lesson(req: LessonRequest):
    prompt = prompts.get_lesson_prompt(req.language, req.level, req.topic)
    system = "You are a curriculum designer. Return JSON only."
    raw = await call_llm(prompt, system)
    if not raw: raise HTTPException(502, "Lesson generation failed")
    return clean_and_parse_json(raw)

@app.post("/api/lesson/clarify")
async def clarify_lesson(req: ClarificationRequest):
    prompt = prompts.get_clarification_prompt(req.language, req.level, req.topic, req.current_explanation)
    system = f"You are a helpful {req.language} teacher. Return ONLY JSON."
    raw = await call_llm(prompt, system)
    if not raw: raise HTTPException(502, "Clarification service unavailable")
    return clean_and_parse_json(raw)

@app.post("/api/grammar")
async def check_grammar(req: GrammarRequest):
    prompt = prompts.get_grammar_prompt(req.language, req.sentence)
    system = "Return ONLY valid JSON."
    raw = await call_llm(prompt, system)
    if not raw: return {"correct": True, "errors": [], "corrected": req.sentence, "explanation": ""}
    return clean_and_parse_json(raw)

@app.post("/api/word-details")
async def get_word_details(req: WordDetailsRequest):
    prompt = prompts.get_word_details_prompt(req.language, req.level, req.word)
    system = f"You are a linguistic expert in {req.language}. Return ONLY JSON."
    raw = await call_llm(prompt, system)
    if not raw: raise HTTPException(502, "Word details service unavailable")
    return clean_and_parse_json(raw)

@app.post("/api/voice-start")
async def voice_start(req: VoiceStartRequest):
    prompt = f"Say 'Hello, how are you?' in {req.language} followed by its English translation in brackets. Keep it simple for a {req.level} learner. Mode: {req.mode}."
    system = f"You are a friendly {req.language} tutor. Return ONLY the text in the format: [Target Language] ([English Translation])"
    opening = await call_llm(prompt, system, json_mode=False)
    return {"text": opening or "Hello! How are you?"}

@app.post("/api/voice-analysis")
async def voice_analysis(
    language: str,
    level: str,
    mode: str = "normal",
    expected_text: Optional[str] = None,
    history: Optional[str] = None,
    file: UploadFile = File(...)
):
    if not STATE["groq"]:
        raise HTTPException(status_code=503, detail="Voice service (Groq) not configured")
    try:
        with tempfile.NamedTemporaryFile(delete=False, suffix=".m4a") as tmp:
            content = await file.read()
            tmp.write(content)
            tmp_path = tmp.name

        with open(tmp_path, "rb") as audio:
            transcription = await STATE["groq"].audio.transcriptions.create(
                file=audio,
                model="whisper-large-v3",
                language=None,
                response_format="text"
            )
        os.unlink(tmp_path)
        user_text = transcription if isinstance(transcription, str) else transcription.text

        history_list = []
        if history:
            try: history_list = json.loads(history)
            except: pass

        prompt = prompts.get_voice_analysis_prompt(language, level, user_text, mode, history=history_list, expected_text=expected_text)
        system = f"You are a {language} voice tutor. Return JSON only."
        raw_analysis = await call_llm(prompt, system)
        return clean_and_parse_json(raw_analysis) if raw_analysis else {"user_text": user_text, "tutor_response": "I heard you, but I couldn't analyze it."}
    except Exception as e:
        logger.error(f"Voice Analysis Error: {e}")
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/health")
async def health():
    return {
        "status": "healthy",
        "gemini": STATE["gemini_available"],
        "groq": bool(STATE["groq"]),
        "openai": bool(STATE["openai"])
    }

if __name__ == "__main__":
    import uvicorn
    port = int(os.environ.get("PORT", 8080))
    uvicorn.run("main:app", host="0.0.0.0", port=port, reload=False)
