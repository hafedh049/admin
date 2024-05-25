import 'package:dabka/models/product_model.dart';

class OrderModel {
  final String orderID;
  final String ownerID;
  final DateTime timestamp;
  final String ownerName;
  final List<ProductModel> products;
  String state;

  OrderModel({
    required this.orderID,
    required this.ownerID,
    required this.timestamp,
    required this.ownerName,
    required this.products,
    this.state = "IN PROGRESS",
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderID: json['orderID'],
      ownerID: json['ownerID'],
      timestamp: json['timestamp'].toDate(),
      ownerName: json['ownerName'],
      products: (json['products'] as List).map((dynamic product) => ProductModel.fromJson(product)).toList().cast<ProductModel>(),
      state: json['state'] ?? "IN PROGRESS",
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'orderID': orderID,
      'ownerID': ownerID,
      'timestamp': timestamp,
      'ownerName': ownerName,
      'products': products.map((ProductModel product) => product.toJson()).toList(),
      'state': state,
    };
  }
}
