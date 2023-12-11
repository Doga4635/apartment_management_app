
class UserModel {
  String uid;
  String? profilePic;
  String role;
  String apartmentName;
  String flatNumber;

  UserModel({
    required this.uid,
    this.profilePic,
    required this.role,
    required this.apartmentName,
    required this.flatNumber,
  });

  factory UserModel.fromMap(Map<String,dynamic> map) {
    return UserModel(
        uid: map['uid'] ?? '',
        profilePic: map['profilePic'] ?? '',
        role: map['role'] ?? '',
        apartmentName: map['apartmentName'] ?? '',
        flatNumber: map['flatNumber'] ?? '');
  }

  Map<String,dynamic> toMap() {
    return {
      "uid": uid,
      "profilePic": profilePic,
      "role": role,
      "apartmentName": apartmentName,
      "flatNumber": flatNumber,
    };
  }


}