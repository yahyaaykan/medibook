class Patient {
  String? firstName;
  String? lastName;
  String? tcNo;
  DateTime? birthDate;
  String? gender;
  String? phone;
  String? email;
  String? address;

  Patient({
    this.firstName,
    this.lastName,
    this.tcNo,
    this.birthDate,
    this.gender,
    this.phone,
    this.email,
    this.address,
  });

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'tcNo': tcNo,
        'birthDate': birthDate?.toIso8601String(),
        'gender': gender,
        'phone': phone,
        'email': email,
        'address': address,
      };

  factory Patient.fromJson(Map<String, dynamic> json) => Patient(
        firstName: json['firstName'],
        lastName: json['lastName'],
        tcNo: json['tcNo'],
        birthDate: json['birthDate'] != null
            ? DateTime.parse(json['birthDate'])
            : null,
        gender: json['gender'],
        phone: json['phone'],
        email: json['email'],
        address: json['address'],
      );
}
