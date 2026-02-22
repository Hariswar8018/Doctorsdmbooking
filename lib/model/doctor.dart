class DoctorModel {
  String id;
  String doctorName;
  String department;
  String other1;
  String other2;

  DoctorModel({
    required this.id,
    required this.doctorName,
    required this.department,
    required this.other1,
    required this.other2,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "doctorName": doctorName,
      "department": department,
      "other1": other1,
      "other2": other2,
    };
  }

  factory DoctorModel.fromMap(Map<String, dynamic> map) {
    return DoctorModel(
      id: map["id"],
      doctorName: map["doctorName"],
      department: map["department"],
      other1: map["other1"],
      other2: map["other2"],
    );
  }
}