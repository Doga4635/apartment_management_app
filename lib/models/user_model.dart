
class UserModel {
  String uid;
  String name;
  String? profilePic;
  String role;
  String apartmentName;
  String flatNumber;
  String deviceToken;
  String accessToken;
  
  UserModel({
    required this.uid, 
    required this.role,
    required this.profilePic,
    required this.name,
    required this.apartmentName,
    required this.flatNumber,
    required this.deviceToken,
    required this.accessToken,
    });

  

  factory UserModel.fromMap(Map<String,dynamic> map) {
    return UserModel(
        uid: map['uid'] ?? '',
        name: map['name'] ?? '',
        profilePic: map['profilePic'] ?? '',
        role: map['role'] ?? '',
        apartmentName: map['apartmentName'] ?? '',
        flatNumber: map['flatNumber'] ?? '',
        deviceToken: map['deviceToken'] ?? '',
        accessToken: map['accessToken'] ?? '',
    );
  }

  Map<String,dynamic> toMap() {
    return {
      "uid": uid,
      "name": name,
      "profilePic": profilePic,
      "role": role,
      "apartmentName": apartmentName,
      "flatNumber": flatNumber,
      "deviceToken": deviceToken,
      "accessToken": accessToken,
    };
  }

  static fromJson(Map<String, dynamic> map) {}


}