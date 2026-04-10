import '../models/hospital_models.dart';

class DataService {
  static final List<City> cities = [
    City(id: '1', name: 'İstanbul'),
    City(id: '2', name: 'Ankara'),
    City(id: '3', name: 'İzmir'),
  ];

  static final List<Hospital> hospitals = [
    Hospital(id: '1', cityId: '1', name: 'Acıbadem Maslak'),
    Hospital(id: '2', cityId: '1', name: 'Memorial Şişli'),
    Hospital(id: '3', cityId: '2', name: 'Medicana Ankara'),
    Hospital(id: '4', cityId: '3', name: 'Ege Üniversitesi Hastanesi'),
  ];

  static final List<Department> departments = [
    Department(id: '1', hospitalId: '1', name: 'Kardiyoloji'),
    Department(id: '2', hospitalId: '1', name: 'Nöroloji'),
    Department(id: '3', hospitalId: '2', name: 'Dahiliye'),
    Department(id: '4', hospitalId: '3', name: 'Göz Hastalıkları'),
  ];

  static final List<Doctor> doctors = [
    Doctor(
      id: '1',
      departmentId: '1',
      name: 'Dr. Ahmet Yılmaz',
      specialty: 'Prof. Dr. - Kardiyolog',
      rating: 4.8,
      imageUrl: 'https://i.pravatar.cc/150?u=1',
    ),
    Doctor(
      id: '2',
      departmentId: '1',
      name: 'Dr. Ayşe Demir',
      specialty: 'Doç. Dr. - Kardiyolog',
      rating: 4.9,
      imageUrl: 'https://i.pravatar.cc/150?u=2',
    ),
    Doctor(
      id: '3',
      departmentId: '2',
      name: 'Dr. Mehmet Öz',
      specialty: 'Uzman Dr. - Nörolog',
      rating: 4.7,
      imageUrl: 'https://i.pravatar.cc/150?u=3',
    ),
  ];
}
