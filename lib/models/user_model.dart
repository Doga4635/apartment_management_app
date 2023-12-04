
class UserModel {
  String uid;
  String role;
  String apartmentName;
  String flatNumber;

  UserModel({
    required this.uid,
    required this.role,
    required this.apartmentName,
    required this.flatNumber
  });

  factory UserModel.fromMap(Map<String,dynamic> map) {
    return UserModel(
        uid: map['uid'] ?? '',
        role: map['role'] ?? '',
        apartmentName: map['apartmentName'] ?? '',
        flatNumber: map['flatNumber'] ?? '');
  }

  Map<String,dynamic> toMap() {
    return {
      "uid": uid,
      "role": role,
      "apartmentName": apartmentName,
      "flatNumber": flatNumber,
    };
  }


}