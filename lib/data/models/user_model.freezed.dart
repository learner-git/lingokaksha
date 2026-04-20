// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel.fromJson(json);
}

/// @nodoc
mixin _$UserModel {
  String get uid => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String? get displayName => throw _privateConstructorUsedError;
  String? get photoUrl => throw _privateConstructorUsedError;
  String get level => throw _privateConstructorUsedError;
  String get targetLevel => throw _privateConstructorUsedError;
  int get xp => throw _privateConstructorUsedError;
  int get streak => throw _privateConstructorUsedError;
  int get totalLessons => throw _privateConstructorUsedError;
  int get totalMinutes => throw _privateConstructorUsedError;
  List<String> get weakTopics => throw _privateConstructorUsedError;
  List<String> get completedLessons => throw _privateConstructorUsedError;
  DateTime? get lastActive => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserModelCopyWith<UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res, UserModel>;
  @useResult
  $Res call(
      {String uid,
      String email,
      String? displayName,
      String? photoUrl,
      String level,
      String targetLevel,
      int xp,
      int streak,
      int totalLessons,
      int totalMinutes,
      List<String> weakTopics,
      List<String> completedLessons,
      DateTime? lastActive,
      DateTime? createdAt});
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res, $Val extends UserModel>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? email = null,
    Object? displayName = freezed,
    Object? photoUrl = freezed,
    Object? level = null,
    Object? targetLevel = null,
    Object? xp = null,
    Object? streak = null,
    Object? totalLessons = null,
    Object? totalMinutes = null,
    Object? weakTopics = null,
    Object? completedLessons = null,
    Object? lastActive = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as String,
      targetLevel: null == targetLevel
          ? _value.targetLevel
          : targetLevel // ignore: cast_nullable_to_non_nullable
              as String,
      xp: null == xp
          ? _value.xp
          : xp // ignore: cast_nullable_to_non_nullable
              as int,
      streak: null == streak
          ? _value.streak
          : streak // ignore: cast_nullable_to_non_nullable
              as int,
      totalLessons: null == totalLessons
          ? _value.totalLessons
          : totalLessons // ignore: cast_nullable_to_non_nullable
              as int,
      totalMinutes: null == totalMinutes
          ? _value.totalMinutes
          : totalMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      weakTopics: null == weakTopics
          ? _value.weakTopics
          : weakTopics // ignore: cast_nullable_to_non_nullable
              as List<String>,
      completedLessons: null == completedLessons
          ? _value.completedLessons
          : completedLessons // ignore: cast_nullable_to_non_nullable
              as List<String>,
      lastActive: freezed == lastActive
          ? _value.lastActive
          : lastActive // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserModelImplCopyWith<$Res>
    implements $UserModelCopyWith<$Res> {
  factory _$$UserModelImplCopyWith(
          _$UserModelImpl value, $Res Function(_$UserModelImpl) then) =
      __$$UserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uid,
      String email,
      String? displayName,
      String? photoUrl,
      String level,
      String targetLevel,
      int xp,
      int streak,
      int totalLessons,
      int totalMinutes,
      List<String> weakTopics,
      List<String> completedLessons,
      DateTime? lastActive,
      DateTime? createdAt});
}

/// @nodoc
class __$$UserModelImplCopyWithImpl<$Res>
    extends _$UserModelCopyWithImpl<$Res, _$UserModelImpl>
    implements _$$UserModelImplCopyWith<$Res> {
  __$$UserModelImplCopyWithImpl(
      _$UserModelImpl _value, $Res Function(_$UserModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? email = null,
    Object? displayName = freezed,
    Object? photoUrl = freezed,
    Object? level = null,
    Object? targetLevel = null,
    Object? xp = null,
    Object? streak = null,
    Object? totalLessons = null,
    Object? totalMinutes = null,
    Object? weakTopics = null,
    Object? completedLessons = null,
    Object? lastActive = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$UserModelImpl(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as String,
      targetLevel: null == targetLevel
          ? _value.targetLevel
          : targetLevel // ignore: cast_nullable_to_non_nullable
              as String,
      xp: null == xp
          ? _value.xp
          : xp // ignore: cast_nullable_to_non_nullable
              as int,
      streak: null == streak
          ? _value.streak
          : streak // ignore: cast_nullable_to_non_nullable
              as int,
      totalLessons: null == totalLessons
          ? _value.totalLessons
          : totalLessons // ignore: cast_nullable_to_non_nullable
              as int,
      totalMinutes: null == totalMinutes
          ? _value.totalMinutes
          : totalMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      weakTopics: null == weakTopics
          ? _value._weakTopics
          : weakTopics // ignore: cast_nullable_to_non_nullable
              as List<String>,
      completedLessons: null == completedLessons
          ? _value._completedLessons
          : completedLessons // ignore: cast_nullable_to_non_nullable
              as List<String>,
      lastActive: freezed == lastActive
          ? _value.lastActive
          : lastActive // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserModelImpl implements _UserModel {
  const _$UserModelImpl(
      {required this.uid,
      required this.email,
      this.displayName,
      this.photoUrl,
      this.level = 'A1',
      this.targetLevel = 'A2',
      this.xp = 0,
      this.streak = 0,
      this.totalLessons = 0,
      this.totalMinutes = 0,
      final List<String> weakTopics = const [],
      final List<String> completedLessons = const [],
      this.lastActive,
      this.createdAt})
      : _weakTopics = weakTopics,
        _completedLessons = completedLessons;

  factory _$UserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserModelImplFromJson(json);

  @override
  final String uid;
  @override
  final String email;
  @override
  final String? displayName;
  @override
  final String? photoUrl;
  @override
  @JsonKey()
  final String level;
  @override
  @JsonKey()
  final String targetLevel;
  @override
  @JsonKey()
  final int xp;
  @override
  @JsonKey()
  final int streak;
  @override
  @JsonKey()
  final int totalLessons;
  @override
  @JsonKey()
  final int totalMinutes;
  final List<String> _weakTopics;
  @override
  @JsonKey()
  List<String> get weakTopics {
    if (_weakTopics is EqualUnmodifiableListView) return _weakTopics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_weakTopics);
  }

  final List<String> _completedLessons;
  @override
  @JsonKey()
  List<String> get completedLessons {
    if (_completedLessons is EqualUnmodifiableListView)
      return _completedLessons;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_completedLessons);
  }

  @override
  final DateTime? lastActive;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'UserModel(uid: $uid, email: $email, displayName: $displayName, photoUrl: $photoUrl, level: $level, targetLevel: $targetLevel, xp: $xp, streak: $streak, totalLessons: $totalLessons, totalMinutes: $totalMinutes, weakTopics: $weakTopics, completedLessons: $completedLessons, lastActive: $lastActive, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserModelImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.targetLevel, targetLevel) ||
                other.targetLevel == targetLevel) &&
            (identical(other.xp, xp) || other.xp == xp) &&
            (identical(other.streak, streak) || other.streak == streak) &&
            (identical(other.totalLessons, totalLessons) ||
                other.totalLessons == totalLessons) &&
            (identical(other.totalMinutes, totalMinutes) ||
                other.totalMinutes == totalMinutes) &&
            const DeepCollectionEquality()
                .equals(other._weakTopics, _weakTopics) &&
            const DeepCollectionEquality()
                .equals(other._completedLessons, _completedLessons) &&
            (identical(other.lastActive, lastActive) ||
                other.lastActive == lastActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      uid,
      email,
      displayName,
      photoUrl,
      level,
      targetLevel,
      xp,
      streak,
      totalLessons,
      totalMinutes,
      const DeepCollectionEquality().hash(_weakTopics),
      const DeepCollectionEquality().hash(_completedLessons),
      lastActive,
      createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      __$$UserModelImplCopyWithImpl<_$UserModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserModelImplToJson(
      this,
    );
  }
}

abstract class _UserModel implements UserModel {
  const factory _UserModel(
      {required final String uid,
      required final String email,
      final String? displayName,
      final String? photoUrl,
      final String level,
      final String targetLevel,
      final int xp,
      final int streak,
      final int totalLessons,
      final int totalMinutes,
      final List<String> weakTopics,
      final List<String> completedLessons,
      final DateTime? lastActive,
      final DateTime? createdAt}) = _$UserModelImpl;

  factory _UserModel.fromJson(Map<String, dynamic> json) =
      _$UserModelImpl.fromJson;

  @override
  String get uid;
  @override
  String get email;
  @override
  String? get displayName;
  @override
  String? get photoUrl;
  @override
  String get level;
  @override
  String get targetLevel;
  @override
  int get xp;
  @override
  int get streak;
  @override
  int get totalLessons;
  @override
  int get totalMinutes;
  @override
  List<String> get weakTopics;
  @override
  List<String> get completedLessons;
  @override
  DateTime? get lastActive;
  @override
  DateTime? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
