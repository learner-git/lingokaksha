// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quiz_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

QuizQuestion _$QuizQuestionFromJson(Map<String, dynamic> json) {
  return _QuizQuestion.fromJson(json);
}

/// @nodoc
mixin _$QuizQuestion {
  String get id => throw _privateConstructorUsedError;
  @BilingualStringConverter()
  String get question => throw _privateConstructorUsedError;
  List<String> get options => throw _privateConstructorUsedError;
  @FlexibleIntConverter()
  int get correctIndex => throw _privateConstructorUsedError;
  @BilingualStringConverter()
  String get explanation => throw _privateConstructorUsedError;
  String? get hint => throw _privateConstructorUsedError;
  String? get topic => throw _privateConstructorUsedError;
  String? get level => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $QuizQuestionCopyWith<QuizQuestion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuizQuestionCopyWith<$Res> {
  factory $QuizQuestionCopyWith(
          QuizQuestion value, $Res Function(QuizQuestion) then) =
      _$QuizQuestionCopyWithImpl<$Res, QuizQuestion>;
  @useResult
  $Res call(
      {String id,
      @BilingualStringConverter() String question,
      List<String> options,
      @FlexibleIntConverter() int correctIndex,
      @BilingualStringConverter() String explanation,
      String? hint,
      String? topic,
      String? level});
}

/// @nodoc
class _$QuizQuestionCopyWithImpl<$Res, $Val extends QuizQuestion>
    implements $QuizQuestionCopyWith<$Res> {
  _$QuizQuestionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? question = null,
    Object? options = null,
    Object? correctIndex = null,
    Object? explanation = null,
    Object? hint = freezed,
    Object? topic = freezed,
    Object? level = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      question: null == question
          ? _value.question
          : question // ignore: cast_nullable_to_non_nullable
              as String,
      options: null == options
          ? _value.options
          : options // ignore: cast_nullable_to_non_nullable
              as List<String>,
      correctIndex: null == correctIndex
          ? _value.correctIndex
          : correctIndex // ignore: cast_nullable_to_non_nullable
              as int,
      explanation: null == explanation
          ? _value.explanation
          : explanation // ignore: cast_nullable_to_non_nullable
              as String,
      hint: freezed == hint
          ? _value.hint
          : hint // ignore: cast_nullable_to_non_nullable
              as String?,
      topic: freezed == topic
          ? _value.topic
          : topic // ignore: cast_nullable_to_non_nullable
              as String?,
      level: freezed == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuizQuestionImplCopyWith<$Res>
    implements $QuizQuestionCopyWith<$Res> {
  factory _$$QuizQuestionImplCopyWith(
          _$QuizQuestionImpl value, $Res Function(_$QuizQuestionImpl) then) =
      __$$QuizQuestionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @BilingualStringConverter() String question,
      List<String> options,
      @FlexibleIntConverter() int correctIndex,
      @BilingualStringConverter() String explanation,
      String? hint,
      String? topic,
      String? level});
}

/// @nodoc
class __$$QuizQuestionImplCopyWithImpl<$Res>
    extends _$QuizQuestionCopyWithImpl<$Res, _$QuizQuestionImpl>
    implements _$$QuizQuestionImplCopyWith<$Res> {
  __$$QuizQuestionImplCopyWithImpl(
      _$QuizQuestionImpl _value, $Res Function(_$QuizQuestionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? question = null,
    Object? options = null,
    Object? correctIndex = null,
    Object? explanation = null,
    Object? hint = freezed,
    Object? topic = freezed,
    Object? level = freezed,
  }) {
    return _then(_$QuizQuestionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      question: null == question
          ? _value.question
          : question // ignore: cast_nullable_to_non_nullable
              as String,
      options: null == options
          ? _value._options
          : options // ignore: cast_nullable_to_non_nullable
              as List<String>,
      correctIndex: null == correctIndex
          ? _value.correctIndex
          : correctIndex // ignore: cast_nullable_to_non_nullable
              as int,
      explanation: null == explanation
          ? _value.explanation
          : explanation // ignore: cast_nullable_to_non_nullable
              as String,
      hint: freezed == hint
          ? _value.hint
          : hint // ignore: cast_nullable_to_non_nullable
              as String?,
      topic: freezed == topic
          ? _value.topic
          : topic // ignore: cast_nullable_to_non_nullable
              as String?,
      level: freezed == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuizQuestionImpl implements _QuizQuestion {
  const _$QuizQuestionImpl(
      {required this.id,
      @BilingualStringConverter() required this.question,
      required final List<String> options,
      @FlexibleIntConverter() required this.correctIndex,
      @BilingualStringConverter() required this.explanation,
      this.hint,
      this.topic,
      this.level})
      : _options = options;

  factory _$QuizQuestionImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuizQuestionImplFromJson(json);

  @override
  final String id;
  @override
  @BilingualStringConverter()
  final String question;
  final List<String> _options;
  @override
  List<String> get options {
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_options);
  }

  @override
  @FlexibleIntConverter()
  final int correctIndex;
  @override
  @BilingualStringConverter()
  final String explanation;
  @override
  final String? hint;
  @override
  final String? topic;
  @override
  final String? level;

  @override
  String toString() {
    return 'QuizQuestion(id: $id, question: $question, options: $options, correctIndex: $correctIndex, explanation: $explanation, hint: $hint, topic: $topic, level: $level)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizQuestionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.question, question) ||
                other.question == question) &&
            const DeepCollectionEquality().equals(other._options, _options) &&
            (identical(other.correctIndex, correctIndex) ||
                other.correctIndex == correctIndex) &&
            (identical(other.explanation, explanation) ||
                other.explanation == explanation) &&
            (identical(other.hint, hint) || other.hint == hint) &&
            (identical(other.topic, topic) || other.topic == topic) &&
            (identical(other.level, level) || other.level == level));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      question,
      const DeepCollectionEquality().hash(_options),
      correctIndex,
      explanation,
      hint,
      topic,
      level);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QuizQuestionImplCopyWith<_$QuizQuestionImpl> get copyWith =>
      __$$QuizQuestionImplCopyWithImpl<_$QuizQuestionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuizQuestionImplToJson(
      this,
    );
  }
}

abstract class _QuizQuestion implements QuizQuestion {
  const factory _QuizQuestion(
      {required final String id,
      @BilingualStringConverter() required final String question,
      required final List<String> options,
      @FlexibleIntConverter() required final int correctIndex,
      @BilingualStringConverter() required final String explanation,
      final String? hint,
      final String? topic,
      final String? level}) = _$QuizQuestionImpl;

  factory _QuizQuestion.fromJson(Map<String, dynamic> json) =
      _$QuizQuestionImpl.fromJson;

  @override
  String get id;
  @override
  @BilingualStringConverter()
  String get question;
  @override
  List<String> get options;
  @override
  @FlexibleIntConverter()
  int get correctIndex;
  @override
  @BilingualStringConverter()
  String get explanation;
  @override
  String? get hint;
  @override
  String? get topic;
  @override
  String? get level;
  @override
  @JsonKey(ignore: true)
  _$$QuizQuestionImplCopyWith<_$QuizQuestionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

QuizSession _$QuizSessionFromJson(Map<String, dynamic> json) {
  return _QuizSession.fromJson(json);
}

/// @nodoc
mixin _$QuizSession {
  String get id => throw _privateConstructorUsedError;
  List<QuizQuestion> get questions => throw _privateConstructorUsedError;
  String get topic => throw _privateConstructorUsedError;
  String get level => throw _privateConstructorUsedError;
  List<int?> get userAnswers => throw _privateConstructorUsedError;
  int get currentIndex => throw _privateConstructorUsedError;
  bool get completed => throw _privateConstructorUsedError;
  DateTime? get startedAt => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $QuizSessionCopyWith<QuizSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuizSessionCopyWith<$Res> {
  factory $QuizSessionCopyWith(
          QuizSession value, $Res Function(QuizSession) then) =
      _$QuizSessionCopyWithImpl<$Res, QuizSession>;
  @useResult
  $Res call(
      {String id,
      List<QuizQuestion> questions,
      String topic,
      String level,
      List<int?> userAnswers,
      int currentIndex,
      bool completed,
      DateTime? startedAt,
      DateTime? completedAt});
}

/// @nodoc
class _$QuizSessionCopyWithImpl<$Res, $Val extends QuizSession>
    implements $QuizSessionCopyWith<$Res> {
  _$QuizSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? questions = null,
    Object? topic = null,
    Object? level = null,
    Object? userAnswers = null,
    Object? currentIndex = null,
    Object? completed = null,
    Object? startedAt = freezed,
    Object? completedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      questions: null == questions
          ? _value.questions
          : questions // ignore: cast_nullable_to_non_nullable
              as List<QuizQuestion>,
      topic: null == topic
          ? _value.topic
          : topic // ignore: cast_nullable_to_non_nullable
              as String,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as String,
      userAnswers: null == userAnswers
          ? _value.userAnswers
          : userAnswers // ignore: cast_nullable_to_non_nullable
              as List<int?>,
      currentIndex: null == currentIndex
          ? _value.currentIndex
          : currentIndex // ignore: cast_nullable_to_non_nullable
              as int,
      completed: null == completed
          ? _value.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as bool,
      startedAt: freezed == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuizSessionImplCopyWith<$Res>
    implements $QuizSessionCopyWith<$Res> {
  factory _$$QuizSessionImplCopyWith(
          _$QuizSessionImpl value, $Res Function(_$QuizSessionImpl) then) =
      __$$QuizSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      List<QuizQuestion> questions,
      String topic,
      String level,
      List<int?> userAnswers,
      int currentIndex,
      bool completed,
      DateTime? startedAt,
      DateTime? completedAt});
}

/// @nodoc
class __$$QuizSessionImplCopyWithImpl<$Res>
    extends _$QuizSessionCopyWithImpl<$Res, _$QuizSessionImpl>
    implements _$$QuizSessionImplCopyWith<$Res> {
  __$$QuizSessionImplCopyWithImpl(
      _$QuizSessionImpl _value, $Res Function(_$QuizSessionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? questions = null,
    Object? topic = null,
    Object? level = null,
    Object? userAnswers = null,
    Object? currentIndex = null,
    Object? completed = null,
    Object? startedAt = freezed,
    Object? completedAt = freezed,
  }) {
    return _then(_$QuizSessionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      questions: null == questions
          ? _value._questions
          : questions // ignore: cast_nullable_to_non_nullable
              as List<QuizQuestion>,
      topic: null == topic
          ? _value.topic
          : topic // ignore: cast_nullable_to_non_nullable
              as String,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as String,
      userAnswers: null == userAnswers
          ? _value._userAnswers
          : userAnswers // ignore: cast_nullable_to_non_nullable
              as List<int?>,
      currentIndex: null == currentIndex
          ? _value.currentIndex
          : currentIndex // ignore: cast_nullable_to_non_nullable
              as int,
      completed: null == completed
          ? _value.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as bool,
      startedAt: freezed == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuizSessionImpl extends _QuizSession {
  const _$QuizSessionImpl(
      {required this.id,
      required final List<QuizQuestion> questions,
      required this.topic,
      required this.level,
      final List<int?> userAnswers = const [],
      this.currentIndex = 0,
      this.completed = false,
      this.startedAt,
      this.completedAt})
      : _questions = questions,
        _userAnswers = userAnswers,
        super._();

  factory _$QuizSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuizSessionImplFromJson(json);

  @override
  final String id;
  final List<QuizQuestion> _questions;
  @override
  List<QuizQuestion> get questions {
    if (_questions is EqualUnmodifiableListView) return _questions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_questions);
  }

  @override
  final String topic;
  @override
  final String level;
  final List<int?> _userAnswers;
  @override
  @JsonKey()
  List<int?> get userAnswers {
    if (_userAnswers is EqualUnmodifiableListView) return _userAnswers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_userAnswers);
  }

  @override
  @JsonKey()
  final int currentIndex;
  @override
  @JsonKey()
  final bool completed;
  @override
  final DateTime? startedAt;
  @override
  final DateTime? completedAt;

  @override
  String toString() {
    return 'QuizSession(id: $id, questions: $questions, topic: $topic, level: $level, userAnswers: $userAnswers, currentIndex: $currentIndex, completed: $completed, startedAt: $startedAt, completedAt: $completedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizSessionImpl &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality()
                .equals(other._questions, _questions) &&
            (identical(other.topic, topic) || other.topic == topic) &&
            (identical(other.level, level) || other.level == level) &&
            const DeepCollectionEquality()
                .equals(other._userAnswers, _userAnswers) &&
            (identical(other.currentIndex, currentIndex) ||
                other.currentIndex == currentIndex) &&
            (identical(other.completed, completed) ||
                other.completed == completed) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      const DeepCollectionEquality().hash(_questions),
      topic,
      level,
      const DeepCollectionEquality().hash(_userAnswers),
      currentIndex,
      completed,
      startedAt,
      completedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QuizSessionImplCopyWith<_$QuizSessionImpl> get copyWith =>
      __$$QuizSessionImplCopyWithImpl<_$QuizSessionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuizSessionImplToJson(
      this,
    );
  }
}

abstract class _QuizSession extends QuizSession {
  const factory _QuizSession(
      {required final String id,
      required final List<QuizQuestion> questions,
      required final String topic,
      required final String level,
      final List<int?> userAnswers,
      final int currentIndex,
      final bool completed,
      final DateTime? startedAt,
      final DateTime? completedAt}) = _$QuizSessionImpl;
  const _QuizSession._() : super._();

  factory _QuizSession.fromJson(Map<String, dynamic> json) =
      _$QuizSessionImpl.fromJson;

  @override
  String get id;
  @override
  List<QuizQuestion> get questions;
  @override
  String get topic;
  @override
  String get level;
  @override
  List<int?> get userAnswers;
  @override
  int get currentIndex;
  @override
  bool get completed;
  @override
  DateTime? get startedAt;
  @override
  DateTime? get completedAt;
  @override
  @JsonKey(ignore: true)
  _$$QuizSessionImplCopyWith<_$QuizSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
