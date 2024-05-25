class OfferModel {
  final String offerID;
  final String categoryID;
  final String category;
  final String username;
  final String userID;
  final String offerName;
  final String offerType;
  final String offerImage;
  final double offerDiscount;
  final DateTime timestamp;

  OfferModel({
    required this.offerID,
    required this.categoryID,
    required this.category,
    required this.username,
    required this.userID,
    required this.offerName,
    required this.offerType,
    required this.offerImage,
    required this.offerDiscount,
    required this.timestamp,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      offerID: json['offerID'] as String,
      categoryID: json['categoryID'] as String,
      category: json['category'] as String,
      username: json['username'] as String,
      userID: json['userID'] as String,
      offerName: json['offerName'] as String,
      offerType: json['offerType'] as String,
      offerImage: json['offerImage'] as String,
      offerDiscount: (json['offerDiscount'] as num).toDouble(),
      timestamp: json['timestamp'].toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'offerID': offerID,
      'categoryID': categoryID,
      'category': category,
      'username': username,
      'userID': userID,
      'offerName': offerName,
      'offerType': offerType,
      'offerImage': offerImage,
      'offerDiscount': offerDiscount,
      'timestamp': timestamp,
    };
  }
}
