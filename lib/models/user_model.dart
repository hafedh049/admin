class UserModel {
  final String userID;
  final String email;
  final String password;
  final String phoneNumber;
  final String username;
  final String categoryName;
  final String categoryID;
  final String userAvatar;
  final List<String> userType;
  final String userDescription;
  final int followers;
  final String gender;

  UserModel({
    required this.userID,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.username,
    required this.categoryName,
    required this.categoryID,
    required this.userAvatar,
    required this.userType,
    required this.userDescription,
    required this.followers,
    required this.gender,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userID: json['userID'],
      email: json['email'],
      password: json['password'],
      phoneNumber: json['phoneNumber'],
      username: json['userName'],
      categoryName: json['categoryName'],
      categoryID: json['categoryID'],
      userAvatar: json['userAvatar'],
      userType: List<String>.from(json['userType'] ?? <String>[]),
      userDescription: json['userDescription'],
      followers: json['followers'],
      gender: json['gender'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'userID': userID,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
      'userName': username,
      'categoryName': categoryName,
      'categoryID': categoryID,
      'userAvatar': userAvatar,
      'userType': userType,
      'userDescription': userDescription,
      'followers': followers,
      'gender': gender,
    };
  }
}
