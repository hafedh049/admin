import 'package:animated_custom_dropdown/custom_dropdown.dart';

class ProductModel with CustomDropdownListFilter {
  final String categoryID;
  final String categoryName;
  final String supplierID;
  final String productID;
  final String productName;
  final String productType;
  final String productDescription;
  final double productBuyPrice;
  final double productSellPrice;
  final double productRating;
  final List<MediaModel> productImages;
  final List<MediaModel> productShorts;

  ProductModel({
    required this.categoryName,
    required this.categoryID,
    required this.supplierID,
    required this.productID,
    required this.productName,
    required this.productType,
    required this.productDescription,
    required this.productBuyPrice,
    required this.productSellPrice,
    required this.productRating,
    required this.productImages,
    required this.productShorts,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      categoryID: json['categoryID'],
      categoryName: json['categoryName'],
      supplierID: json['supplierID'],
      productID: json['productID'],
      productName: json['productName'],
      productType: json['productType'],
      productDescription: json['productDescription'],
      productBuyPrice: json['productBuyPrice'],
      productSellPrice: json['productSellPrice'],
      productRating: json['productRating'],
      productImages: (json['productImages'] as List<dynamic>).map((dynamic e) => MediaModel.fromJson(e as Map<String, dynamic>)).toList().cast<MediaModel>(),
      productShorts: (json['productShorts'] as List<dynamic>).map((dynamic e) => MediaModel.fromJson(e as Map<String, dynamic>)).toList().cast<MediaModel>(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'categoryID': categoryID,
      'categoryName': categoryName,
      'supplierID': supplierID,
      'productID': productID,
      'productName': productName,
      'productType': productType,
      'productDescription': productDescription,
      'productBuyPrice': productBuyPrice,
      'productSellPrice': productSellPrice,
      'productRating': productRating,
      'productImages': [for (final MediaModel e in productImages) e.toJson()],
      'productShorts': [for (final MediaModel e in productShorts) e.toJson()],
    };
  }

  @override
  String toString() => productName;

  @override
  bool filter(String query) => productName.toLowerCase().contains(query.toLowerCase());
}

class MediaModel {
  final String ext;
  final String name;
  final String path;
  final String type;

  MediaModel({
    required this.ext,
    required this.name,
    required this.path,
    required this.type,
  });

  factory MediaModel.fromJson(Map<String, dynamic> json) {
    return MediaModel(
      ext: json['ext'],
      name: json['name'],
      path: json['path'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'ext': ext,
      'name': name,
      'path': path,
      'type': type,
    };
  }
}
