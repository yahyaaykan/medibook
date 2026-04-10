import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/appointment_provider.dart';
import '../services/data_service.dart';
import '../models/hospital_models.dart';

class Step3Cascading extends StatelessWidget {
  const Step3Cascading({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppointmentProvider>();

    final filteredHospitals = DataService.hospitals
        .where((h) => h.cityId == provider.selectedCity?.id)
        .toList();

    final filteredDepartments = DataService.departments
        .where((d) => d.hospitalId == provider.selectedHospital?.id)
        .toList();

    final filteredDoctors = DataService.doctors
        .where((d) => d.departmentId == provider.selectedDepartment?.id)
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bölüm & Doktor Seçimi',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          
          // City Selection
          DropdownButtonFormField<City>(
            key: const ValueKey('dropdown_sehir'),
            value: provider.selectedCity,
            decoration: const InputDecoration(labelText: 'Şehir Seçin'),
            items: DataService.cities.map((city) {
              return DropdownMenuItem(value: city, child: Text(city.name));
            }).toList(),
            onChanged: (v) => provider.setCity(v),
          ),
          const SizedBox(height: 16),

          // Hospital Selection
          DropdownButtonFormField<Hospital>(
            key: const ValueKey('dropdown_hastane'),
            value: provider.selectedHospital,
            decoration: const InputDecoration(labelText: 'Hastane Seçin'),
            items: filteredHospitals.map((h) {
              return DropdownMenuItem(value: h, child: Text(h.name));
            }).toList(),
            onChanged: provider.selectedCity == null ? null : (v) => provider.setHospital(v),
          ),
          const SizedBox(height: 16),

          // Department Selection
          DropdownButtonFormField<Department>(
            key: const ValueKey('dropdown_bolum'),
            value: provider.selectedDepartment,
            decoration: const InputDecoration(labelText: 'Bölüm Seçin'),
            items: filteredDepartments.map((d) {
              return DropdownMenuItem(value: d, child: Text(d.name));
            }).toList(),
            onChanged: provider.selectedHospital == null ? null : (v) => provider.setDepartment(v),
          ),
          const SizedBox(height: 16),

          // Doctor Selection (Dropdown)
          DropdownButtonFormField<Doctor>(
            key: const ValueKey('dropdown_doktor'),
            value: provider.selectedDoctor,
            decoration: const InputDecoration(labelText: 'Doktor Seçin'),
            items: filteredDoctors.map((d) {
              return DropdownMenuItem(value: d, child: Text(d.name));
            }).toList(),
            onChanged: provider.selectedDepartment == null ? null : (v) => provider.setDoctor(v),
          ),
          
          const SizedBox(height: 24),
          
          // Doctor List View (Dynamic Items)
          if (filteredDoctors.isNotEmpty) ...[
            const Text('Doktor Detayları', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredDoctors.length,
              itemBuilder: (context, index) {
                final doctor = filteredDoctors[index];
                final isSelected = provider.selectedDoctor?.id == doctor.id;
                return Card(
                  color: isSelected ? const Color(0xFF00C853).withOpacity(0.1) : null,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: isSelected ? const Color(0xFF00C853) : Colors.white10,
                    ),
                  ),
                  child: ListTile(
                    key: ValueKey('doktor_item_$index'),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(doctor.imageUrl),
                    ),
                    title: Text(doctor.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(doctor.specialty),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        Text(doctor.rating.toString()),
                      ],
                    ),
                    onTap: () => provider.setDoctor(doctor),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}
