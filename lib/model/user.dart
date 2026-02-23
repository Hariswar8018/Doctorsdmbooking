class UserModel {
  String id;
  String name;
  int age;
  String gender;
  int phone;
  String occupation;
  String place;
  String email;

  UserModel({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.phone,
    required this.occupation,
    required this.place,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "age": age,
      "gender": gender,
      "phone": phone,
      "occupation": occupation,
      "place": place,
      "email": email,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map["id"],
      name: map["name"],
      age: int.tryParse(map["age"].toString()) ?? 0,
      phone: int.tryParse(map["phone"].toString()) ?? 0,
      gender: map["gender"],
      occupation: map["occupation"],
      place: map["place"],
      email: map["email"],
    );
  }
}