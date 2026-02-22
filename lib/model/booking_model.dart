class BookingModel {
  String name;
  String age;
  String sex;
  String phone;
  String occupation;
  String doctorName;
  int tokens;
  DateTime time;

  BookingModel({
    required this.name,
    required this.age,
    required this.sex,
    required this.phone,
    required this.occupation,
    required this.doctorName,
    required this.tokens,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "age": age,
      "sex": sex,
      "phone": phone,
      "occupation": occupation,
      "doctorName": doctorName,
      "tokens": tokens,
      "time": time,
    };
  }
}
