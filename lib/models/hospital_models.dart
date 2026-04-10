class City {
  final String id;
  final String name;

  City({required this.id, required this.name});
}

class Hospital {
  final String id;
  final String cityId;
  final String name;

  Hospital({required this.id, required this.cityId, required this.name});
}

class Department {
  final String id;
  final String hospitalId;
  final String name;

  Department({required this.id, required this.hospitalId, required this.name});
}

class Doctor {
  final String id;
  final String departmentId;
  final String name;
  final String specialty;
  final double rating;
  final String imageUrl;

  Doctor({
    required this.id,
    required this.departmentId,
    required this.name,
    required this.specialty,
    required this.rating,
    required this.imageUrl,
  });
}
