// class UserModel {
//   final String id;
//   final String email;
//   final String firstName;
//   final String lastName;
//   final String? profilePictureUrl;

//   UserModel({
//     required this.id,
//     required this.email,
//     required this.firstName,
//     required this.lastName,
//     this.profilePictureUrl,
//   });

//   factory UserModel.fromJson(Map<String, dynamic> json) {
//     return UserModel(
//       id: json['id'] ?? '',
//       email: json['email'] ?? '',
//       firstName: json['first_name'] ?? '',
//       lastName: json['last_name'] ?? '',
//       profilePictureUrl: json['profile_picture_url'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'email': email,
//       'first_name': firstName,
//       'last_name': lastName,
//       'profile_picture_url': profilePictureUrl,
//     };
//   }
// }

class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String userName;
  final String email;
  final String? profileImage;
  final String role;
  final String provider;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final bool isActive;
  final String? dob;
  final String? location;
  final String? postalCode;
  final String? gender;
  final String? phone;

  const UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.email,
    this.profileImage,
    required this.role,
    required this.provider,
    required this.isEmailVerified,
    required this.isPhoneVerified,
    required this.isActive,
    this.dob,
    this.location,
    this.postalCode,
    this.gender,
    this.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? json['id'] ?? json['userId'] ?? '',
      firstName: json['firstName'] ?? json['first_name'] ?? '',
      lastName: json['lastName'] ?? json['last_name'] ?? '',
      userName: json['userName'] ?? '',
      email: json['email'] ?? '',
      profileImage: json['profileImage'] ?? json['profile_image'] ?? json['avatar'] ?? json['image'],
      role: json['role'] ?? '',
      provider: json['provider'] ?? json['loginMethod'] ?? '',
      isEmailVerified: json['isEmailVerified'] ?? false,
      isPhoneVerified: json['isPhoneVerified'] ?? false,
      isActive: json['isActive'] ?? false,
      dob: json['dob'] ?? json['dateOfBirth'],
      location: json['location'],
      postalCode: json['postalCode'] ?? json['postal_code'],
      gender: json['gender'],
      phone: json['phone'] ?? json['phoneNumber'] ?? json['userName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstName': firstName,
      'lastName': lastName,
      'userName': userName,
      'email': email,
      'profileImage': profileImage,
      'role': role,
      'provider': provider,
      'isEmailVerified': isEmailVerified,
      'isPhoneVerified': isPhoneVerified,
      'isActive': isActive,
      'dob': dob,
      'dateOfBirth': dob,
      'location': location,
      'postalCode': postalCode,
      'postal_code': postalCode,
      'gender': gender,
      'phone': phone,
      'phoneNumber': phone,
    };
  }
}
