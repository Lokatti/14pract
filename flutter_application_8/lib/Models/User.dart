class User {
  final int usersId;
  final String firstName;
  final String lastName;
  final String? middleName;
  final int? rating;
  final String role;
  final String email;
  final String password;
  final String? fcmToken;
  final String? salt;
  final int? requisitesId;
  final int? pictureId;

  User({
    required this.usersId,
        required this.firstName,
        required this.lastName,
        this.middleName,
        this.rating,
        required this.role,
        required this.email,
        required this.password,
        this.fcmToken,
        this.salt,
        this.requisitesId,
        this.pictureId,
    });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      usersId: json['usersId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      middleName: json['middleName'],
      rating: json['rating'],
      role: json['role'],
      email: json['email'],
      password: json['password'],
      fcmToken: json['fcmToken'],
      salt: json['salt'],
      requisitesId: json['requisitesId'],
      pictureId: json['pictureId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'usersId': usersId,
      'firstName': firstName,
      'middleName': middleName,
      'rating': rating,
      'role': role,
      'email': email,
      'lastName': lastName,
      'password': password,
      'fcmToken': fcmToken,
      'salt': salt,
      'requisitesId': requisitesId,
      'pictureId': pictureId,
    };
  }
}
