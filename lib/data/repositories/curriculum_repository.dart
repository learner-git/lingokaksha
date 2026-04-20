import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../providers/user_provider.dart';
import '../models/lesson_model.dart';

part 'curriculum_repository.g.dart';

@riverpod
CurriculumRepository curriculumRepository(CurriculumRepositoryRef ref) {
  final language = ref.watch(selectedLanguageProvider);
  return CurriculumRepository(language: language);
}

class CurriculumRepository {
  final String language;

  CurriculumRepository({required this.language});

  final Map<String, Map<String, List<LessonTopic>>> _curricula = {
    'german': {
      'A1': [
        // 1. Introduction to German Language Basics
        LessonTopic(id: 'a1-basics-alphabet', title: 'Alphabet & Pronunciation', description: 'German alphabet, umlauts (ä, ö, ü), ß, and key pronunciation rules.', level: 'A1', category: '1. Language Basics'),
        LessonTopic(id: 'a1-basics-numbers', title: 'Numbers & Basics', description: 'Numbers 0–100, dates, time (clock/schedules), and basic math.', level: 'A1', category: '1. Language Basics'),

        // 2. Core Grammar Foundations
        LessonTopic(id: 'a1-grammar-pronouns', title: 'Personal Pronouns', description: 'ich, du, er, sie, es, wir, ihr, Sie.', level: 'A1', category: '2. Grammar Foundations'),
        LessonTopic(id: 'a1-grammar-conjugation', title: 'Verb Conjugation', description: 'Regular verbs and irregulars like sein, haben, sprechen, fahren.', level: 'A1', category: '2. Grammar Foundations'),
        LessonTopic(id: 'a1-grammar-structure', title: 'Sentence Structure', description: 'Verb in position 2, Yes/No questions, and W-questions.', level: 'A1', category: '2. Grammar Foundations'),
        LessonTopic(id: 'a1-grammar-articles', title: 'Articles (Der, Die, Das)', description: 'Gender basics and indefinite articles (ein, eine).', level: 'A1', category: '2. Grammar Foundations'),
        LessonTopic(id: 'a1-grammar-plurals', title: 'Plurals', description: 'Basic plural formation and common patterns.', level: 'A1', category: '2. Grammar Foundations'),
        LessonTopic(id: 'a1-grammar-negation', title: 'Negation (nicht & kein)', description: 'How to use nicht and kein correctly.', level: 'A1', category: '2. Grammar Foundations'),
        LessonTopic(id: 'a1-grammar-cases', title: 'Cases (Intro)', description: 'Nominative and Accusative basics; der → den change.', level: 'A1', category: '2. Grammar Foundations'),
        LessonTopic(id: 'a1-grammar-possessive', title: 'Possessive Pronouns', description: 'mein, dein, sein, ihr, unser.', level: 'A1', category: '2. Grammar Foundations'),
        LessonTopic(id: 'a1-grammar-modals', title: 'Modal Verbs', description: 'Basic use of können, müssen, wollen and sentence structure.', level: 'A1', category: '2. Grammar Foundations'),
        LessonTopic(id: 'a1-grammar-separable', title: 'Separable Verbs', description: 'How verbs like ankommen and einkaufen split in sentences.', level: 'A1', category: '2. Grammar Foundations'),
        LessonTopic(id: 'a1-grammar-imperative', title: 'Imperative', description: 'Basic commands: Komm! Kommen Sie!', level: 'A1', category: '2. Grammar Foundations'),
        LessonTopic(id: 'a1-grammar-prepositions', title: 'Prepositions (Basic)', description: 'Basic usage of in, auf, mit, von, zu.', level: 'A1', category: '2. Grammar Foundations'),

        // 3. Communication Skills
        LessonTopic(id: 'a1-comm-intro', title: 'Introducing Yourself', description: 'Name, age, country, and languages.', level: 'A1', category: '3. Communication Skills'),
        LessonTopic(id: 'a1-comm-questions', title: 'Asking Questions', description: 'Personal questions and clarification (Wie bitte?).', level: 'A1', category: '3. Communication Skills'),
        LessonTopic(id: 'a1-comm-everyday', title: 'Everyday Conversations', description: 'Dialogues at a café, shop, and school/work.', level: 'A1', category: '3. Communication Skills'),
        LessonTopic(id: 'a1-comm-location', title: 'Talking About Location', description: 'Living in a city and being at home.', level: 'A1', category: '3. Communication Skills'),
        LessonTopic(id: 'a1-comm-time', title: 'Time & Routine', description: 'Daily schedule, days of the week, and frequency.', level: 'A1', category: '3. Communication Skills'),

        // 4. Vocabulary Topics
        LessonTopic(id: 'a1-vocab-personal', title: 'Personal Information', description: 'Nationality and profession.', level: 'A1', category: '4. Vocabulary'),
        LessonTopic(id: 'a1-vocab-home', title: 'Home & Living', description: 'Rooms and furniture.', level: 'A1', category: '4. Vocabulary'),
        LessonTopic(id: 'a1-vocab-food', title: 'Food & Drinks', description: 'Ordering food and grocery shopping.', level: 'A1', category: '4. Vocabulary'),
        LessonTopic(id: 'a1-vocab-shopping', title: 'Shopping', description: 'Prices and asking for items.', level: 'A1', category: '4. Vocabulary'),
        LessonTopic(id: 'a1-vocab-transport', title: 'Transportation', description: 'Bus, train, and directions.', level: 'A1', category: '4. Vocabulary'),
        LessonTopic(id: 'a1-vocab-family', title: 'Family & Friends', description: 'Family members and relationships.', level: 'A1', category: '4. Vocabulary'),
        LessonTopic(id: 'a1-vocab-daily', title: 'Daily Life', description: 'Routines and hobbies.', level: 'A1', category: '4. Vocabulary'),
        LessonTopic(id: 'a1-vocab-weather', title: 'Weather', description: 'Basic weather expressions.', level: 'A1', category: '4. Vocabulary'),

        // 5-7. Skills Development
        LessonTopic(id: 'a1-skills-writing', title: 'Writing Skills', description: 'Filling forms and writing short messages/emails.', level: 'A1', category: '5. Skills Development'),
        LessonTopic(id: 'a1-skills-listening', title: 'Listening Skills', description: 'Understanding slow speech, instructions, and numbers.', level: 'A1', category: '5. Skills Development'),
        LessonTopic(id: 'a1-skills-reading', title: 'Reading Skills', description: 'Signs, notices, and simple dialogues.', level: 'A1', category: '5. Skills Development'),

        // 8-10. Fluency & Exam Prep
        LessonTopic(id: 'a1-fluency-pronunciation', title: 'Pronunciation & Fluency', description: 'Sound clarity, word stress, and building confidence.', level: 'A1', category: '6. Mastery & Prep'),
        LessonTopic(id: 'a1-practical-tasks', title: 'Real-Life Application', description: 'Directions, shopping, and booking appointments.', level: 'A1', category: '6. Mastery & Prep'),
      ],
      'A2': [
        // 1. Core Grammar Expansion
        LessonTopic(id: 'a2-grammar-perfekt', title: 'Past Tense: Perfekt', description: 'Mastering haben/sein + Partizip II for spoken German.', level: 'A2', category: '1. Core Grammar'),
        LessonTopic(id: 'a2-grammar-praeteritum', title: 'Past Tense: Präteritum', description: 'Introduction to simple past for sein, haben and common verbs.', level: 'A2', category: '1. Core Grammar'),
        LessonTopic(id: 'a2-grammar-modals', title: 'Expanded Modal Verbs', description: 'müssen, können, dürfen, sollen, wollen in depth.', level: 'A2', category: '1. Core Grammar'),
        LessonTopic(id: 'a2-grammar-dative', title: 'The Dative Case', description: 'Understanding indirect objects and dative articles.', level: 'A2', category: '1. Core Grammar'),
        LessonTopic(id: 'a2-grammar-wechsel', title: 'Two-way Prepositions', description: 'in, auf, an... Difference between motion vs. location.', level: 'A2', category: '1. Core Grammar'),
        LessonTopic(id: 'a2-grammar-reflexive', title: 'Reflexive Verbs', description: 'sich waschen, sich treffen... Reflexive pronouns.', level: 'A2', category: '1. Core Grammar'),
        LessonTopic(id: 'a2-grammar-separable', title: 'Separable & Inseparable Verbs', description: 'Positioning verbs correctly in complex sentences.', level: 'A2', category: '1. Core Grammar'),
        LessonTopic(id: 'a2-grammar-subordinate', title: 'Subordinate Clauses (weil, dass, wenn)', description: 'Learning how to use conjunctions that kick verbs to the end.', level: 'A2', category: '1. Core Grammar'),
        LessonTopic(id: 'a2-grammar-comparative', title: 'Comparative & Superlative', description: 'How to compare things: größer, am größten.', level: 'A2', category: '1. Core Grammar'),
        LessonTopic(id: 'a2-grammar-adjectives', title: 'Adjective Declension Basics', description: 'Basic endings after definite and indefinite articles.', level: 'A2', category: '1. Core Grammar'),
        LessonTopic(id: 'a2-grammar-prepositions', title: 'Expanded Prepositions', description: 'Dative prepositions (mit, nach) and Accusative (für, ohne).', level: 'A2', category: '1. Core Grammar'),

        // 2. Communication Skills
        LessonTopic(id: 'a2-comm-appointments', title: 'Everyday Situations', description: 'Making appointments and giving directions.', level: 'A2', category: '2. Communication'),
        LessonTopic(id: 'a2-comm-opinions', title: 'Functional Language', description: 'Expressing opinions and making suggestions politely.', level: 'A2', category: '2. Communication'),

        // 3. Vocabulary Topics
        LessonTopic(id: 'a2-vocab-daily', title: 'Daily Life & Chores', description: 'Household, food, cooking and money.', level: 'A2', category: '3. Vocabulary'),
        LessonTopic(id: 'a2-vocab-health', title: 'Health & Body', description: 'Visiting the doctor and describing symptoms.', level: 'A2', category: '3. Vocabulary'),
        LessonTopic(id: 'a2-vocab-travel', title: 'Travel & Transportation', description: 'Booking hotels and navigating public transport.', level: 'A2', category: '3. Vocabulary'),
        LessonTopic(id: 'a2-vocab-work', title: 'Work & Professional Life', description: 'Job titles and workplace communication.', level: 'A2', category: '3. Vocabulary'),
        LessonTopic(id: 'a2-vocab-social', title: 'Social Life & Events', description: 'Hobbies, invitations, and environment.', level: 'A2', category: '3. Vocabulary'),

        // 4-6. Writing, Listening, Reading
        LessonTopic(id: 'a2-skills-writing', title: 'Writing Skills', description: 'Writing short emails and describing past events.', level: 'A2', category: '4. Skills Development'),
        LessonTopic(id: 'a2-skills-listening', title: 'Listening Comprehension', description: 'Understanding announcements and short dialogues.', level: 'A2', category: '5. Skills Development'),
        LessonTopic(id: 'a2-skills-reading', title: 'Reading Proficiency', description: 'Short articles, ads, and instructions.', level: 'A2', category: '6. Skills Development'),

        // 7-9. Fluency
        LessonTopic(id: 'a2-fluency-pronunciation', title: 'Pronunciation & Fluency', description: 'Sentence stress, intonation and umlauts.', level: 'A2', category: '7. Mastery & Prep'),
        LessonTopic(id: 'a2-practical-tasks', title: 'Real-Life Tasks', description: 'Landlords, doctors, and job interviews.', level: 'A2', category: '8. Mastery & Prep'),
      ],
      'B1': [
        // 1. Core Grammar
        LessonTopic(id: 'b1-grammar-praeteritum', title: 'Präteritum (Simple Past)', description: 'Mastering written narration and common verbs like sein and haben.', level: 'B1', category: '1. Core Grammar'),
        LessonTopic(id: 'b1-grammar-plusquamperfekt', title: 'Plusquamperfekt (Past Perfect)', description: 'Talking about events before another past event.', level: 'B1', category: '1. Core Grammar'),
        LessonTopic(id: 'b1-grammar-passiv', title: 'Passive Voice (Passiv)', description: 'Present and past passive: "Das Haus wird/wurde gebaut".', level: 'B1', category: '1. Core Grammar'),
        LessonTopic(id: 'b1-grammar-relative', title: 'Relative Clauses', description: 'Using der, die, das to provide detail about nouns in all cases.', level: 'B1', category: '1. Core Grammar'),
        LessonTopic(id: 'b1-grammar-subordinate-adv', title: 'Advanced Subordinate Clauses', description: 'obwohl, damit, nachdem, während, and als.', level: 'B1', category: '1. Core Grammar'),
        LessonTopic(id: 'b1-grammar-infinitive-zu', title: 'Infinitive Clauses with "zu"', description: 'Mastering um...zu, ohne...zu, and statt...zu.', level: 'B1', category: '1. Core Grammar'),
        LessonTopic(id: 'b1-grammar-reflexive-adv', title: 'Advanced Reflexive Verbs', description: 'Distinguishing between Akkusativ and Dativ reflexive pronouns.', level: 'B1', category: '1. Core Grammar'),
        LessonTopic(id: 'b1-grammar-adjectives-core', title: 'Core Adjective Declension', description: 'Full mastery of endings after definite, indefinite, and no articles.', level: 'B1', category: '1. Core Grammar'),
        LessonTopic(id: 'b1-grammar-prepositions-fixed', title: 'Fixed Prepositions with Verbs', description: 'Verbs that take specific prepositions (e.g., warten auf, denken an).', level: 'B1', category: '1. Core Grammar'),
        LessonTopic(id: 'b1-grammar-konjunktiv2', title: 'Konjunktiv II (Wishes & Politeness)', description: 'Hypothetical situations and polite requests.', level: 'B1', category: '1. Core Grammar'),
        LessonTopic(id: 'b1-grammar-comparisons-adv', title: 'Advanced Comparisons', description: 'je... desto..., als vs wie, and increasing qualities.', level: 'B1', category: '1. Core Grammar'),

        // 2. Communication
        LessonTopic(id: 'b1-comm-opinions', title: 'Opinions & Arguments', description: 'Structuring arguments using "Einerseits... andererseits".', level: 'B1', category: '3. Communication'),
        LessonTopic(id: 'b1-comm-narration', title: 'Narration & Storytelling', description: 'Sequencing complex events professionally.', level: 'B1', category: '3. Communication'),
        LessonTopic(id: 'b1-comm-formal', title: 'Formal Communication', description: 'Phone calls, work communication, and customer service.', level: 'B1', category: '3. Communication'),

        // 3. Vocabulary
        LessonTopic(id: 'b1-vocab-society', title: 'Living & Society', description: 'Housing contracts and neighborhood discussions.', level: 'B1', category: '4. Vocabulary'),
        LessonTopic(id: 'b1-vocab-career', title: 'Work & Career', description: 'Job applications, CVs, and interview prep.', level: 'B1', category: '4. Vocabulary'),
        LessonTopic(id: 'b1-vocab-environment', title: 'Environment & Technology', description: 'Climate change and digital life.', level: 'B1', category: '4. Vocabulary'),
        LessonTopic(id: 'b1-vocab-relationships', title: 'Relationships & Emotions', description: 'Feelings, conflicts, and social behavior.', level: 'B1', category: '4. Vocabulary'),

        // 4-5. Skills & Prep
        LessonTopic(id: 'b1-skills-writing', title: 'Structured Writing', description: 'Formal emails, complaints, and logical flow.', level: 'B1', category: '5. Skills Development'),
        LessonTopic(id: 'b1-skills-reading', title: 'Reading & Analysis', description: 'Skimming and scanning news and formal texts.', level: 'B1', category: '5. Skills Development'),
        LessonTopic(id: 'b1-practical-independence', title: 'Real-Life Independence', description: 'Bureaucracy and living independently in Germany.', level: 'B1', category: '6. Mastery & Prep'),
      ],
      'BUSINESS': [
        // 1. Foundation: Business Communication Basics
        LessonTopic(id: 'bus-found-formal', title: 'Formal vs Informal Language', description: 'Sie vs Du, formal tone, and professional titles/addressing.', level: 'Business', category: '1. Foundation'),
        LessonTopic(id: 'bus-found-intro', title: 'Professional Introductions', description: 'Presenting your role, company, colleagues, and business small talk.', level: 'Business', category: '1. Foundation'),
        LessonTopic(id: 'bus-found-etiquette', title: 'Business Etiquette', description: 'German work culture: Punctuality, directness, and email etiquette.', level: 'Business', category: '1. Foundation'),

        // 2. Core Grammar for Business
        LessonTopic(id: 'bus-gram-passive', title: 'Passive Voice (Process focus)', description: 'Describing contracts, reports, and documentation processes.', level: 'Business', category: '2. Business Grammar'),
        LessonTopic(id: 'bus-gram-konj2', title: 'Konjunktiv II (Polite Requests)', description: 'Making polite requests and professional suggestions.', level: 'Business', category: '2. Business Grammar'),
        LessonTopic(id: 'bus-gram-konj1', title: 'Konjunktiv I (Indirect Speech)', description: 'Reporting statements for news and formal communication.', level: 'Business', category: '2. Business Grammar'),
        LessonTopic(id: 'bus-gram-nominal', title: 'Nominalization (Formal Style)', description: 'Turning verbs into nouns for a professional reporting style.', level: 'Business', category: '2. Business Grammar'),
        LessonTopic(id: 'bus-gram-complex', title: 'Complex Structures', description: 'Subordinate clauses (obwohl, während, sofern) for nuanced arguments.', level: 'Business', category: '2. Business Grammar'),
        LessonTopic(id: 'bus-gram-prep', title: 'Fixed Prepositions', description: 'Professional verbs: sich beziehen auf, teilnehmen an, etc.', level: 'Business', category: '2. Business Grammar'),

        // 3. Communication Skills
        LessonTopic(id: 'bus-comm-meetings', title: 'Professional Meetings', description: 'Opening meetings, setting agendas, and interrupting politely.', level: 'Business', category: '3. Communication Skills'),
        LessonTopic(id: 'bus-comm-pres', title: 'Presentations', description: 'Structuring presentations and describing charts/trends.', level: 'Business', category: '3. Communication Skills'),
        LessonTopic(id: 'bus-comm-phone', title: 'Telephone Skills', description: 'Answering calls, taking messages, and clarifying information.', level: 'Business', category: '3. Communication Skills'),
        LessonTopic(id: 'bus-comm-email', title: 'Email Writing', description: 'Formal inquiries, complaints, follow-ups, and closings.', level: 'Business', category: '3. Communication Skills'),
        LessonTopic(id: 'bus-comm-neg', title: 'Negotiation Skills', description: 'Making offers, counteroffers, and diplomatic disagreement.', level: 'Business', category: '3. Communication Skills'),
        LessonTopic(id: 'bus-comm-conflict', title: 'Handling Conflict', description: 'Managing complaints, delays, and misunderstandings.', level: 'Business', category: '3. Communication Skills'),

        // 4. Business Vocabulary
        LessonTopic(id: 'bus-voc-org', title: 'Company & Organization', description: 'Departments (HR, Marketing), hierarchy, and roles.', level: 'Business', category: '4. Business Vocabulary'),
        LessonTopic(id: 'bus-voc-career', title: 'Work & Career', description: 'Job descriptions, contracts, salaries, and performance reviews.', level: 'Business', category: '4. Business Vocabulary'),
        LessonTopic(id: 'bus-voc-finance', title: 'Finance & Economics', description: 'Revenue, profit, loss, budgeting, and investments.', level: 'Business', category: '4. Business Vocabulary'),
        LessonTopic(id: 'bus-voc-logistics', title: 'Logistics & Production', description: 'Supply chain, manufacturing, and international delivery.', level: 'Business', category: '4. Business Vocabulary'),

        // 5. Professional Writing & Mastery
        LessonTopic(id: 'bus-write-docs', title: 'Formal Documents & Reports', description: 'Writing reports (Berichte), proposals, and meeting minutes.', level: 'Business', category: '5. Writing & Skills'),
        LessonTopic(id: 'bus-write-apps', title: 'Job Applications', description: 'Mastering the Lebenslauf (CV) and Anschreiben (Cover Letter).', level: 'Business', category: '5. Writing & Skills'),
        LessonTopic(id: 'bus-skills-intercultural', title: 'Intercultural Competence', description: 'German workplace expectations and direct feedback culture.', level: 'Business', category: '5. Writing & Skills'),
      ],
    },
    'french': {
      'A1': [
        LessonTopic(id: 'fr-a1-basics-alphabet', title: 'Alphabet & Accents', description: 'French alphabet, accents (é, è, ê, ë, à, â, î, ï, ô, û, ù, ç), and key pronunciation rules.', level: 'A1', category: '1. Language Basics'),
        LessonTopic(id: 'fr-a1-basics-numbers', title: 'Numbers & Basics', description: 'Numbers 0–100, telling time, and basic greetings.', level: 'A1', category: '1. Language Basics'),
        LessonTopic(id: 'fr-a1-grammar-pronouns', title: 'Subject Pronouns', description: 'je, tu, il, elle, on, nous, vous, ils, elles.', level: 'A1', category: '2. Grammar Foundations'),
        LessonTopic(id: 'fr-a1-grammar-verbs-er', title: 'Regular -er Verbs', description: 'Present tense conjugation of parler, habiter, manger.', level: 'A1', category: '2. Grammar Foundations'),
        LessonTopic(id: 'fr-a1-grammar-etre-avoir', title: 'Être & Avoir', description: 'The two most important verbs in French.', level: 'A1', category: '2. Grammar Foundations'),
        LessonTopic(id: 'fr-a1-grammar-articles', title: 'Articles (Le, La, Les)', description: 'Definite and indefinite articles (un, une, des).', level: 'A1', category: '2. Grammar Foundations'),
        LessonTopic(id: 'fr-a1-comm-intro', title: 'Introducing Yourself', description: 'Name, age, nationality, and profession.', level: 'A1', category: '3. Communication Skills'),
      ],
      // Add more French levels as needed
    },
    'spanish': {
      'A1': [
        LessonTopic(id: 'es-a1-basics-alphabet', title: 'Alphabet & Pronunciation', description: 'Spanish alphabet, ñ, and accent rules.', level: 'A1', category: '1. Language Basics'),
        LessonTopic(id: 'es-a1-basics-numbers', title: 'Numbers & Greetings', description: 'Numbers 0–100 and common greetings.', level: 'A1', category: '1. Language Basics'),
        LessonTopic(id: 'es-a1-grammar-pronouns', title: 'Personal Pronouns', description: 'yo, tú, él, ella, usted, nosotros, vosotros, ellos, ustedes.', level: 'A1', category: '2. Grammar Foundations'),
        LessonTopic(id: 'es-a1-grammar-verbs-ar', title: 'Regular -ar Verbs', description: 'Present tense of hablar, estudiar, trabajar.', level: 'A1', category: '2. Grammar Foundations'),
        LessonTopic(id: 'es-a1-grammar-ser-estar', title: 'Ser vs Estar', description: 'Understanding the two "to be" verbs.', level: 'A1', category: '2. Grammar Foundations'),
        LessonTopic(id: 'es-a1-grammar-articles', title: 'Articles (El, La, Los, Las)', description: 'Gender and number agreement.', level: 'A1', category: '2. Grammar Foundations'),
        LessonTopic(id: 'es-a1-comm-intro', title: 'Introducing Yourself', description: 'Presenting yourself and others.', level: 'A1', category: '3. Communication Skills'),
      ],
      // Add more Spanish levels as needed
    },
  };

  List<LessonTopic> getTopicsByLevel(String level) {
    return _curricula[language]?[level.toUpperCase()] ?? [];
  }
}
