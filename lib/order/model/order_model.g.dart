// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderProductModel _$OrderProductModelFromJson(Map<String, dynamic> json) =>
    OrderProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toInt(),
      detail: json['detail'] as String,
      imgUrl: DataUtils.pathToUrl(json['imgUrl'] as String),
    );

Map<String, dynamic> _$OrderProductModelToJson(OrderProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'detail': instance.detail,
      'imgUrl': instance.imgUrl,
    };

OrderProductCountModel _$OrderProductCountModelFromJson(
  Map<String, dynamic> json,
) => OrderProductCountModel(
  productModel: OrderProductModel.fromJson(
    json['productModel'] as Map<String, dynamic>,
  ),
  count: (json['count'] as num).toInt(),
);

Map<String, dynamic> _$OrderProductCountModelToJson(
  OrderProductCountModel instance,
) => <String, dynamic>{
  'productModel': instance.productModel,
  'count': instance.count,
};

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => OrderModel(
  id: json['id'] as String,
  restaurant: RestaurantModel.fromJson(
    json['restaurant'] as Map<String, dynamic>,
  ),
  totalPrice: (json['totalPrice'] as num).toInt(),
  createdAt: DataUtils.stringToDataTime(json['createdAt'] as String),
  products:
      (json['products'] as List<dynamic>)
          .map(
            (e) => OrderProductCountModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
);

Map<String, dynamic> _$OrderModelToJson(OrderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'restaurant': instance.restaurant,
      'totalPrice': instance.totalPrice,
      'createdAt': instance.createdAt.toIso8601String(),
      'products': instance.products,
    };
