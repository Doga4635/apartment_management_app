
class UserModel {
  String uid;
  String name;
  String? profilePic;
  String role;
  String apartmentName;
  String flatNumber;
  bool garbage;

  UserModel({
    required this.uid,
    required this.name,
    this.profilePic,
    required this.role,
    required this.apartmentName,
    required this.flatNumber,
    required this.garbage,
  });

  factory UserModel.fromMap(Map<String,dynamic> map) {
    return UserModel(
        uid: map['uid'] ?? '',
        name: map['name'] ?? '',
        profilePic: map['profilePic'] ?? '',
        role: map['role'] ?? '',
        apartmentName: map['apartmentName'] ?? '',
        flatNumber: map['flatNumber'] ?? '',
        garbage: map['garbage'] ?? '',
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
      "garbage": garbage,
    };
  }


}