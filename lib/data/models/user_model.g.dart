// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      uid: json['uid'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      photoUrl: json['photoUrl'] as String?,
      level: json['level'] as String? ?? 'A1',
      targetLevel: json['targetLevel'] as String? ?? 'A2',
      xp: (json['xp'] as num?)?.toInt() ?? 0,
      streak: (json['streak'] as num?)?.toInt() ?? 0,
      totalLessons: (json['totalLessons'] as num?)?.toInt() ?? 0,
      totalMinutes: (json['totalMinutes'] as num?)?.toInt() ?? 0,
      weakTopics: (json['weakTopics'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      completedLessons: (json['completedLessons'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      lastActive: json['lastActive'] == null
          ? null
          : DateTime.parse(json['lastActive'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'displayName': instance.displayName,
      'photoUrl': instance.photoUrl,
      'level': instance.level,
      'targetLevel': instance.targetLevel,
      'xp': instance.xp,
      'streak': instance.streak,
      'totalLessons': instance.totalLessons,
      'totalMinutes': instance.totalMinutes,
      'weakTopics': instance.weakTopics,
      'completedLessons': instance.completedLessons,
      'lastActive': instance.lastActive?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
    };
