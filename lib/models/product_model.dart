import 'package:animated_custom_dropdown/custom_dropdown.dart';

class ProductModel with CustomDropdownListFilter {
  final String categoryID;
  final String categoryName;
  final String supplierID;
  final String productID;
  final String productName;
  final String productDescription;
  final double productBuyPrice;
  final double productRating;
  final List<MediaModel> productImages;
  final List<MediaModel> productShorts;
  List<String> productOptions;

  ProductModel({
    required this.categoryName,
    required this.productOptions,
    required this.categoryID,
    required this.supplierID,
    required this.productID,
    required this.productName,
    required this.productDescription,
    required this.productBuyPrice,
    required this.productRating,
    required this.productImages,
    required this.productShorts,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      productOptions: json['productOptions'].cast<String>(),
      categoryID: json['categoryID'],
      categoryName: json['categoryName'],
      supplierID: json['supplierID'],
      productID: json['productID'],
      productName: json['productName'],
      productDescription: json['productDescription'],
      productBuyPrice: json['productBuyPrice'],
      productRating: json['productRating'],
      productImages: (json['productImages'] as List<dynamic>).map((dynamic e) => MediaModel.fromJson(e as Map<String, dynamic>)).toList().cast<MediaModel>(),
      productShorts: (json['productShorts'] as List<dynamic>).map((dynamic e) => MediaModel.fromJson(e as Map<String, dynamic>)).toList().cast<MediaModel>(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'categoryID': categoryID,
      'productOptions': productOptions,
      'categoryName': categoryName,
      'supplierID': supplierID,
      'productID': productID,
      'productName': productName,
      'productDescription': productDescription,
      'productBuyPrice': productBuyPrice,
      'productRating': productRating,
      'productImages': <Map<String, dynamic>>[for (final MediaModel e in productImages) e.toJson()],
      'productShorts': <Map<String, dynamic>>[for (final MediaModel e in productShorts) e.toJson()],
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
