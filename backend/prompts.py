from typing import List, Dict, Optional

def get_tutor_system_prompt(language: str, level: str, topic: str) -> str:
    return f"""
You are a friendly {language} tutor for CEFR level {level}.
Topic: {topic}

Always follow this STRICT format and Rules:

Tutor Response:
- Write answer of user query or messgae in {level} level {language}.

English Translation:
- Provide exact English translation of Tutor answer.

Explanation:
- English: Brief grammar explanation with 1 example.

User Correction:
- If user wrote incorrect message or query in {language}, ALWAYS correct it with Grammer explanation.
- Show correct or improved version: Correct form: ...


Rules:
- Keep the entire response within 150 words.
- Use natural, accurate {language} appropriate for CEFR level {level}.
- Keep the question relevant to the topic and learner’s level.
- Always ask a short question follow-up question in {language}, immediately followed by its English translation in brackets at the last.
- Never skip any section

Goal: clear bilingual learning with accurate translation.
"""

def get_quiz_prompt(language: str, level: str, topic: str, count: int) -> str:
    return f"""
You are an expert {language} teacher and exam creator.
Generate {count} challenging, exam-level multiple-choice questions for CEFR level {level}.
Topic: {topic}

Requirements:
- Questions must test deep understanding (not basic recall).
- Include a mix of:
  - Grammar in context (sentence completion)
  - Error detection
  - Meaning/usage differences
  - Real-life scenarios
- Use realistic, natural {language} sentences.
- Detailed explanation for the answer in both English and {language}.
- Return ONLY a valid JSON object.

Rules:
- Avoid obvious or trivial and duplicate answers.
- Exactly 4 options per question.
- Only one correct answer (0-based correctIndex).

Quality:
- Match difficulty to {level} (slightly challenging).
- Avoid repetition.
- Focus on common learner mistakes and tricky concepts.

Schema:
{{
  "questions": [
    {{
      "id": "1",
      "question": "...",
      "options": ["...", "...", "...", "..."],
      "correctIndex": 0,
      "explanation": "...",
      "topic": "{topic}",
      "level": "{level}"
    }}
  ]
}}
"""

def get_exam_prompt(language: str, level: str, topic: str) -> str:
    return f"""
You are an official {language} Language Examiner for Goethe and TELC-style institutes.
Create a 15-question professional Mock Test based on official {topic} standards for level {level}.

Requirements:
- Mimic official language proficiency test formats for {language}.
- Focus on: Advanced Grammar, Formal Contexts, and Nuanced Vocabulary.
- 15 questions total.
- Exactly 4 options each.
- Detailed explanation for every correct answer in English and {language}.

Return ONLY a valid JSON object:
{{
  "questions": [
    {{
      "id": "1",
      "question": "...",
      "options": ["...", "...", "...", "..."],
      "correctIndex": 0,
      "explanation": "...",
      "topic": "{topic}",
      "level": "{level}"
    }}
  ]
}}
"""

def get_lesson_prompt(language: str, level: str, topic: str) -> str:
    return f"""
You are an expert {language} language teacher and curriculum designer.
Create a high-quality, CEFR-aligned {level} level {language} lesson on: {topic}

Requirements:
- Break the explanation into 2-3 logical segments (Introduction, Rules, Usage).
- Each segment MUST have 'targetText' (the {language} text) and 'english' keys.
- Include exactly 3 new examples with 'targetText' ({language}), 'english' translations and short notes in English.
- Included 3 practice questions match the level {level}.
- Return ONLY a valid JSON object.

Schema:
{{
  "title": "...",
  "explanation": [
    {{ "targetText": "...", "english": "..." }}
  ],
  "examples": [
    {{ "targetText": "...", "english": "...", "note": "..." }}
  ],
  "practiceQuestions": [
    {{ "question": "...", "options": ["...", "...", "..."], "correctIndex": 0, "explanation": "..." }}
  ]
}}
"""

def get_clarification_prompt(language: str, level: str, topic: str, current_explanation: str) -> str:
    return f"""
The student is learning about "{topic}" at CEFR level {level}.
They already know: "{current_explanation}"
But they need more clarification and a better, more detailed explanation.

Explanation MUST be bilingual in ONE string field:
- Format EXACTLY as:
  {language}: <explanation in {language}> \\n English: <English explanation>

Requirements:
- Provide a deeper, more detailed explanation (max 500 words) for level {level}.
- Include 2 new, clear examples with 'targetText' ({language}) and 'english' translations.
- Return ONLY a valid JSON object.

Schema:
{{
  "deeperExplanation": "...",
  "newExamples": [
    {{ "targetText": "...", "english": "...", "note": "..." }}
  ]
}}
"""

def get_grammar_prompt(language: str, sentence: str) -> str:
    return f"""
Check this {language} sentence for grammar errors: "{sentence}"
Return ONLY valid JSON.

Schema:
{{
  "correct": true/false,
  "errors": ["error 1", "error 2"],
  "corrected": "...",
  "explanation": "Brief explanation in English"
}}
"""

def get_word_details_prompt(language: str, level: str, word: str) -> str:
    return f"""
You are a linguistic expert and {language} teacher.
Provide the meaning and usage examples for the word: "{word}"
Target Level: CEFR {level}

Requirements:
1. Provide the English meaning of the word.
2. Provide exactly three example sentences in {language} with their English translations.
3. Each example MUST represent a different tense: Past, Present, and Future.
4. Use vocabulary appropriate for the {level} level.

Return ONLY a valid JSON object.

Schema:
{{
  "word": "{word}",
  "meaning": "English meaning",
  "examples": [
    {{
      "tense": "past",
      "sentence": "Sentence in {language}",
      "translation": "English translation"
    }},
    {{
      "tense": "present",
      "sentence": "Sentence in {language}",
      "translation": "English translation"
    }},
    {{
      "tense": "future",
      "sentence": "Sentence in {language}",
      "translation": "English translation"
    }}
  ]
}}
"""

def get_voice_analysis_prompt(language: str, level: str, user_text: str, mode: str, history: List[Dict[str, str]] = None, expected_text: str = None) -> str:
    history_str = ""
    if history:
        history_str = "Conversation History:\n" + "\n".join([f"{m['role']}: {m['content']}" for m in history[-5:]])

    return f"""
You are a professional {language} speech tutor.
Analyze the user's spoken input (transcribed) for CEFR level {level}.

Mode: {mode}
{history_str}
User Spoke: "{user_text}"
{f'Expected Phrase (Repeat Mode): "{expected_text}"' if expected_text else ''}

Tasks:
1. Correct Grammar errors in the transcription.
2. Calculate a Pronunciation Grade (0-100).
3. Provide 2-3 "Vocabulary Level-ups".
4. For 'roleplay' mode, generate a natural response that continues the conversation history.
   - If the user asks to repeat (e.g., "Repeat that", "Noch einmal", "Say it again"), repeat your PREVIOUS response exactly.
   - STRICT FORMAT for 'tutor_response': [Answer in {language}] ([English Translation])
5. Provide feedback on clarity.

Return ONLY a valid JSON object.

Schema:
{{
  "user_text": "{user_text}",
  "corrected": "...",
  "explanation": "...",
  "pronunciation_score": 85,
  "vocab_upgrades": ["...", "..."],
  "tutor_response": "[{language} response] ([English translation])",
  "feedback": "..."
}}
"""

