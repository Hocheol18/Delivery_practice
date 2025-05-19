import 'package:delivery/common/model/model_with_id.dart';
import 'package:delivery/restaurant/model/restaurant_model.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../common/utils/data_utils.dart';

part 'order_model.g.dart';

@JsonSerializable()
class OrderProductModel {
  final String id;
  final String name;
  final int price;
  final String detail;
  @JsonKey(fromJson: DataUtils.pathToUrl)
  final String imgUrl;

  OrderProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.detail,
    required this.imgUrl,
  });

  factory OrderProductModel.fromJson(Map<String, dynamic> json) =>
      _$OrderProductModelFromJson(json);
}

@JsonSerializable()
class OrderProductCountModel {
  final OrderProductModel productModel;
  final int count;

  OrderProductCountModel({required this.productModel, required this.count});

  factory OrderProductCountModel.fromJson(Map<String, dynamic> json) =>
      _$OrderProductCountModelFromJson(json);
}

@JsonSerializable()
class OrderModel implements IModelWithId {
  @override
  final String id;
  final RestaurantModel restaurant;
  final int totalPrice;
  @JsonKey(fromJson: DataUtils.stringToDataTime)
  final DateTime createdAt;
  final List<OrderProductCountModel> products;

  OrderModel({
    required this.id,
    required this.restaurant,
    required this.totalPrice,
    required this.createdAt,
    required this.products,
  });
  
  factory OrderModel.fromJson(Map<String, dynamic> json) => _$OrderModelFromJson(json);
}
