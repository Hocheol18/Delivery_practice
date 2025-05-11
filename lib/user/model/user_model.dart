import 'package:json_annotation/json_annotation.dart';

import '../../common/utils/data_utils.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String id;
  final String username;
  // 요청 URL일 때 JsonKey.
  @JsonKey(fromJson: DataUtils.pathToUrl)
  final String imageUrl;

  UserModel({
    required this.id,
    required this.username,
    required this.imageUrl
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}