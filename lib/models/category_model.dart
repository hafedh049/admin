import 'package:animated_custom_dropdown/custom_dropdown.dart';

class CategoryModel with CustomDropdownListFilter {
  final String categoryID;
  final String categoryName;
  final String categoryUrl;

  CategoryModel({
    required this.categoryID,
    required this.categoryName,
    required this.categoryUrl,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      categoryID: json['categoryID'],
      categoryName: json['categoryName'],
      categoryUrl: json['categoryUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'categoryID': categoryID,
      'categoryName': categoryName,
      'categoryUrl': categoryUrl,
    };
  }

  @override
  String toString() => categoryName;

  @override
  bool filter(String query) => categoryName.toLowerCase().contains(query.toLowerCase());
}
