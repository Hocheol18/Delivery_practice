import 'package:delivery/common/model/model_with_id.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../common/utils/data_utils.dart';
import '../../restaurant/model/restaurant_model.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel implements IModelWithId {
  @override
  final String id;

  // 상품 이름
  final String name;

  // 상품 상세정보
  final String detail;

  // 이미지 URL
  @JsonKey(fromJson: DataUtils.pathToUrl)
  final String imgUrl;

  // 상품 가격
  final int price;

  // 레스트랑 정보
  final RestaurantModel restaurant;

  ProductModel({
    required this.name,
    required this.detail,
    required this.imgUrl,
    required this.price,
    required this.restaurant,
    required this.id,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => _$ProductModelFromJson(json);
}
