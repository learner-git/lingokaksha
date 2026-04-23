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

from dotenv import load_dotenv

from fastapi import FastAPI, HTTPException, Security, Depends, File, UploadFile
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import StreamingResponse
from pydantic import BaseModel
import tempfile

# SDK Imports
from google import genai
from google.genai import types
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

# --- Constants ---
DEFAULT_TIMEOUT = 45
GEMINI_MODEL = os.getenv("GEMINI_MODEL", "gemini-2.0-flash")
GROQ_MODEL = os.getenv("GROQ_MODEL", "llama-3.1-8b-instant")
OPENAI_MODEL = "gpt-4o-mini"

# --- Client Initialization ---
def init_clients():
    """Initializes all AI clients and returns availability flags."""
    # 1. Gemini
    g_client, g_avail = None, False
    try:
        project = os.getenv("GOOGLE_CLOUD_PROJECT")
        api_key = os.getenv("GOOGLE_API_KEY")

        # If project is set, default to Vertex AI to use programmatic credentials
        if project:
            g_client = genai.Client(
                vertexai=True,
                project=project,
                location=os.getenv("GOOGLE_CLOUD_LOCATION", "eu-west1")
            )
            g_avail = True
            logger.info(f"Gemini (Vertex AI) initialized for project: {project}")
        elif api_key:
            g_client = genai.Client(api_key=api_key)
            g_avail = True
            logger.info("Gemini initialized using API Key.")
        else:
            logger.warning("Gemini skipped: Neither API Key nor Cloud Project found.")

    except Exception as e:
        logger.error(f"Gemini Init Failed: {e}")
        g_client, g_avail = None, False

    # 2. Groq
    groq_key = os.getenv("GROQ_API_KEY")
    _groq = AsyncGroq(api_key=groq_key) if groq_key else None
    
    # 3. OpenAI
    oa_key = os.getenv("OPENAI_API_KEY")
    _oa = AsyncOpenAI(api_key=oa_key) if oa_key else None

    return g_client, g_avail, _groq, _oa

CLIENT, GEMINI_AVAILABLE, GROQ, OPENAI = init_clients()

# --- FastAPI App Setup ---
app = FastAPI(
    title="LingoKaksha API",
    description="Multi-language AI Learning Platform Backend",
    version="2.1.0"
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
    if GEMINI_AVAILABLE and CLIENT:
        try:
            config = types.GenerateContentConfig(
                system_instruction=system_instruction,
                temperature=0.3,
                max_output_tokens=max_tokens,
                response_mime_type="application/json" if json_mode else "text/plain"
            )
            response = await CLIENT.aio.models.generate_content(
                model=GEMINI_MODEL,
                contents=prompt,
                config=config
            )
            if response.text: return response.text
        except Exception as e:
            logger.warning(f"Gemini failed: {e}")

    # 2. Groq (Priority 2)
    if GROQ:
        try:
            resp = await asyncio.wait_for(
                GROQ.chat.completions.create(
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
    if OPENAI:
        try:
            resp = await asyncio.wait_for(
                OPENAI.chat.completions.create(
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
    if GEMINI_AVAILABLE and CLIENT:
        try:
            contents = [types.Content(role=m["role"], parts=[types.Part.from_text(text=m["content"])]) for m in messages]
            async for chunk in CLIENT.aio.models.generate_content_stream(
                model=GEMINI_MODEL,
                contents=contents,
                config=types.GenerateContentConfig(system_instruction=system_prompt, temperature=0.7)
            ):
                if chunk.text: yield chunk.text
            return
        except Exception as e:
            logger.warning(f"Gemini Stream Failed: {e}")

    # 2. Groq Stream
    if GROQ:
        try:
            full_messages = [{"role": "system", "content": system_prompt}] + messages
            stream = await GROQ.chat.completions.create(
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
    if OPENAI:
        try:
            full_messages = [{"role": "system", "content": system_prompt}] + messages
            stream = await OPENAI.chat.completions.create(
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
        # Step 1: Regex to strip markdown code blocks
        cleaned = re.sub(r"```json\s?|\s?```", "", raw).strip()

        # Step 2: Extract content between first { and last }
        start = cleaned.find('{')
        end = cleaned.rfind('}')
        if start != -1 and end != -1:
            cleaned = cleaned[start : end + 1]

        # Step 3: Handle trailing commas
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
    
    return StreamingResponse(
        stream_llm(filtered_messages, system_prompt),
        media_type="text/plain"
    )

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
    """Generates an opening line for a voice session."""
    prompt = f"Generate a short, engaging opening line in {req.language} for a {req.level} learner. Mode: {req.mode}. Followed by its English translation in brackets."
    system = f"You are a friendly {req.language} tutor. Keep it under 20 words. Return ONLY the text."

    opening = await call_llm(prompt, system, json_mode=False)
    return {"text": opening or "Hello! Let's start our conversation."}

@app.post("/api/voice-analysis")
async def voice_analysis(
    language: str,
    level: str,
    mode: str = "normal",
    expected_text: Optional[str] = None,
    history: Optional[str] = None, # Received as JSON string from query or form
    file: UploadFile = File(...)
):
    """
    STT + LLM Analysis Endpoint with History support.
    """
    if not GROQ:
        raise HTTPException(status_code=503, detail="Voice service (Groq) not configured")

    try:
        # Save uploaded file to temp
        with tempfile.NamedTemporaryFile(delete=False, suffix=".m4a") as tmp:
            content = await file.read()
            tmp.write(content)
            tmp_path = tmp.name

        # 1. Transcribe with Whisper
        with open(tmp_path, "rb") as audio:
            transcription = await GROQ.audio.transcriptions.create(
                file=audio,
                model="whisper-large-v3",
                language=None, # Auto-detect
                response_format="text"
            )

        # Cleanup temp file
        os.unlink(tmp_path)

        user_text = transcription if isinstance(transcription, str) else transcription.text

        # Parse history if provided
        history_list = []
        if history:
            try:
                history_list = json.loads(history)
            except:
                logger.warning("Failed to parse history JSON")

        # 2. Analyze with LLM
        prompt = prompts.get_voice_analysis_prompt(language, level, user_text, mode, history=history_list, expected_text=expected_text)
        system = f"You are a {language} voice tutor. Return JSON only."

        raw_analysis = await call_llm(prompt, system)
        if not raw_analysis:
             return {"user_text": user_text, "tutor_response": "I heard you, but I couldn't analyze it right now."}

        return clean_and_parse_json(raw_analysis)

    except Exception as e:
        logger.error(f"Voice Analysis Error: {e}")
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/health")
async def health():
    return {
        "status": "healthy",
        "gemini": GEMINI_AVAILABLE,
        "groq": bool(GROQ),
        "openai": bool(OPENAI)
    }

if __name__ == "__main__":
    import uvicorn
    # Cloud Run provides PORT environment variable
    port = int(os.environ.get("PORT", 8000))

    print(f"Starting LingoShikshak on port {port}...")
    uvicorn.run("main:app", host="0.0.0.0", port=port, reload=False)
