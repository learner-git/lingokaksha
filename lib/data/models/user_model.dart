import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String uid,
    required String email,
    String? displayName,
    String? photoUrl,
    @Default('A1') String level,
    @Default('A2') String targetLevel,
    @Default(0) int xp,
    @Default(0) int streak,
    @Default(0) int totalLessons,
    @Default(0) int totalMinutes,
    @Default([]) List<String> weakTopics,
    @Default([]) List<String> completedLessons,
    DateTime? lastActive,
    DateTime? createdAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
