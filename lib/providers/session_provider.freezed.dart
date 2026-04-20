// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SessionState {
  int get sessionXp => throw _privateConstructorUsedError;
  int get sessionMinutes => throw _privateConstructorUsedError;
  bool get lessonCompleted => throw _privateConstructorUsedError;
  String? get completedLessonId => throw _privateConstructorUsedError;
  int get quizScore => throw _privateConstructorUsedError;
  int get quizTotal => throw _privateConstructorUsedError;
  List<ActivityEvent> get sessionEvents => throw _privateConstructorUsedError;
  DateTime? get startedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SessionStateCopyWith<SessionState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionStateCopyWith<$Res> {
  factory $SessionStateCopyWith(
          SessionState value, $Res Function(SessionState) then) =
      _$SessionStateCopyWithImpl<$Res, SessionState>;
  @useResult
  $Res call(
      {int sessionXp,
      int sessionMinutes,
      bool lessonCompleted,
      String? completedLessonId,
      int quizScore,
      int quizTotal,
      List<ActivityEvent> sessionEvents,
      DateTime? startedAt});
}

/// @nodoc
class _$SessionStateCopyWithImpl<$Res, $Val extends SessionState>
    implements $SessionStateCopyWith<$Res> {
  _$SessionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionXp = null,
    Object? sessionMinutes = null,
    Object? lessonCompleted = null,
    Object? completedLessonId = freezed,
    Object? quizScore = null,
    Object? quizTotal = null,
    Object? sessionEvents = null,
    Object? startedAt = freezed,
  }) {
    return _then(_value.copyWith(
      sessionXp: null == sessionXp
          ? _value.sessionXp
          : sessionXp // ignore: cast_nullable_to_non_nullable
              as int,
      sessionMinutes: null == sessionMinutes
          ? _value.sessionMinutes
          : sessionMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      lessonCompleted: null == lessonCompleted
          ? _value.lessonCompleted
          : lessonCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      completedLessonId: freezed == completedLessonId
          ? _value.completedLessonId
          : completedLessonId // ignore: cast_nullable_to_non_nullable
              as String?,
      quizScore: null == quizScore
          ? _value.quizScore
          : quizScore // ignore: cast_nullable_to_non_nullable
              as int,
      quizTotal: null == quizTotal
          ? _value.quizTotal
          : quizTotal // ignore: cast_nullable_to_non_nullable
              as int,
      sessionEvents: null == sessionEvents
          ? _value.sessionEvents
          : sessionEvents // ignore: cast_nullable_to_non_nullable
              as List<ActivityEvent>,
      startedAt: freezed == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SessionStateImplCopyWith<$Res>
    implements $SessionStateCopyWith<$Res> {
  factory _$$SessionStateImplCopyWith(
          _$SessionStateImpl value, $Res Function(_$SessionStateImpl) then) =
      __$$SessionStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int sessionXp,
      int sessionMinutes,
      bool lessonCompleted,
      String? completedLessonId,
      int quizScore,
      int quizTotal,
      List<ActivityEvent> sessionEvents,
      DateTime? startedAt});
}

/// @nodoc
class __$$SessionStateImplCopyWithImpl<$Res>
    extends _$SessionStateCopyWithImpl<$Res, _$SessionStateImpl>
    implements _$$SessionStateImplCopyWith<$Res> {
  __$$SessionStateImplCopyWithImpl(
      _$SessionStateImpl _value, $Res Function(_$SessionStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionXp = null,
    Object? sessionMinutes = null,
    Object? lessonCompleted = null,
    Object? completedLessonId = freezed,
    Object? quizScore = null,
    Object? quizTotal = null,
    Object? sessionEvents = null,
    Object? startedAt = freezed,
  }) {
    return _then(_$SessionStateImpl(
      sessionXp: null == sessionXp
          ? _value.sessionXp
          : sessionXp // ignore: cast_nullable_to_non_nullable
              as int,
      sessionMinutes: null == sessionMinutes
          ? _value.sessionMinutes
          : sessionMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      lessonCompleted: null == lessonCompleted
          ? _value.lessonCompleted
          : lessonCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      completedLessonId: freezed == completedLessonId
          ? _value.completedLessonId
          : completedLessonId // ignore: cast_nullable_to_non_nullable
              as String?,
      quizScore: null == quizScore
          ? _value.quizScore
          : quizScore // ignore: cast_nullable_to_non_nullable
              as int,
      quizTotal: null == quizTotal
          ? _value.quizTotal
          : quizTotal // ignore: cast_nullable_to_non_nullable
              as int,
      sessionEvents: null == sessionEvents
          ? _value._sessionEvents
          : sessionEvents // ignore: cast_nullable_to_non_nullable
              as List<ActivityEvent>,
      startedAt: freezed == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$SessionStateImpl implements _SessionState {
  const _$SessionStateImpl(
      {this.sessionXp = 0,
      this.sessionMinutes = 0,
      this.lessonCompleted = false,
      this.completedLessonId,
      this.quizScore = 0,
      this.quizTotal = 0,
      final List<ActivityEvent> sessionEvents = const [],
      this.startedAt})
      : _sessionEvents = sessionEvents;

  @override
  @JsonKey()
  final int sessionXp;
  @override
  @JsonKey()
  final int sessionMinutes;
  @override
  @JsonKey()
  final bool lessonCompleted;
  @override
  final String? completedLessonId;
  @override
  @JsonKey()
  final int quizScore;
  @override
  @JsonKey()
  final int quizTotal;
  final List<ActivityEvent> _sessionEvents;
  @override
  @JsonKey()
  List<ActivityEvent> get sessionEvents {
    if (_sessionEvents is EqualUnmodifiableListView) return _sessionEvents;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sessionEvents);
  }

  @override
  final DateTime? startedAt;

  @override
  String toString() {
    return 'SessionState(sessionXp: $sessionXp, sessionMinutes: $sessionMinutes, lessonCompleted: $lessonCompleted, completedLessonId: $completedLessonId, quizScore: $quizScore, quizTotal: $quizTotal, sessionEvents: $sessionEvents, startedAt: $startedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionStateImpl &&
            (identical(other.sessionXp, sessionXp) ||
                other.sessionXp == sessionXp) &&
            (identical(other.sessionMinutes, sessionMinutes) ||
                other.sessionMinutes == sessionMinutes) &&
            (identical(other.lessonCompleted, lessonCompleted) ||
                other.lessonCompleted == lessonCompleted) &&
            (identical(other.completedLessonId, completedLessonId) ||
                other.completedLessonId == completedLessonId) &&
            (identical(other.quizScore, quizScore) ||
                other.quizScore == quizScore) &&
            (identical(other.quizTotal, quizTotal) ||
                other.quizTotal == quizTotal) &&
            const DeepCollectionEquality()
                .equals(other._sessionEvents, _sessionEvents) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      sessionXp,
      sessionMinutes,
      lessonCompleted,
      completedLessonId,
      quizScore,
      quizTotal,
      const DeepCollectionEquality().hash(_sessionEvents),
      startedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionStateImplCopyWith<_$SessionStateImpl> get copyWith =>
      __$$SessionStateImplCopyWithImpl<_$SessionStateImpl>(this, _$identity);
}

abstract class _SessionState implements SessionState {
  const factory _SessionState(
      {final int sessionXp,
      final int sessionMinutes,
      final bool lessonCompleted,
      final String? completedLessonId,
      final int quizScore,
      final int quizTotal,
      final List<ActivityEvent> sessionEvents,
      final DateTime? startedAt}) = _$SessionStateImpl;

  @override
  int get sessionXp;
  @override
  int get sessionMinutes;
  @override
  bool get lessonCompleted;
  @override
  String? get completedLessonId;
  @override
  int get quizScore;
  @override
  int get quizTotal;
  @override
  List<ActivityEvent> get sessionEvents;
  @override
  DateTime? get startedAt;
  @override
  @JsonKey(ignore: true)
  _$$SessionStateImplCopyWith<_$SessionStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
