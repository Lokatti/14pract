class RegisterRequest {
  String firstName;
  String lastName;
  String middleName;
  int? rating;
  String email;
  String password;
  String role;

  RegisterRequest({
    required this.firstName,
    required this.lastName,
    required this.middleName,
    required this.rating,
    required this.email,
    required this.password,
    required this.role
  });

  Map<String, dynamic> toJson() => {
    'firstName': firstName,
    'lastName': lastName,
    'middleName': middleName,
    'rating': rating,
    'email': email,
    'password': password,
    'role': role
  };
}