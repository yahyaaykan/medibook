import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/appointment_provider.dart';

class Step2Insurance extends StatefulWidget {
  const Step2Insurance({super.key});

  @override
  State<Step2Insurance> createState() => _Step2InsuranceState();
}

class _Step2InsuranceState extends State<Step2Insurance> {
  final TextEditingController _medController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppointmentProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sigorta & Sağlık Bilgileri',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          DropdownButtonFormField<String>(
            key: const ValueKey('dropdown_sigorta'),
            value: provider.insuranceType,
            decoration: const InputDecoration(labelText: 'Sigorta Türü'),
            items: ['SGK', 'Özel', 'Yok']
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (v) => setState(() => provider.insuranceType = v),
          ),
          if (provider.insuranceType == 'Özel') ...[
            const SizedBox(height: 16),
            TextFormField(
              key: const ValueKey('input_sigorta_firma'),
              initialValue: provider.insuranceCompany,
              decoration: const InputDecoration(labelText: 'Sigorta Firması'),
              onChanged: (v) => provider.insuranceCompany = v,
            ),
          ],
          const SizedBox(height: 24),
          const Text('Kronik Hastalıklar', style: TextStyle(fontWeight: FontWeight.bold)),
          Wrap(
            spacing: 8,
            children: ['Diyabet', 'Hipertansiyon', 'Astım', 'Kalp']
                .map((e) => FilterChip(
                      label: Text(e),
                      selected: provider.chronicDiseases.contains(e),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            provider.chronicDiseases.add(e);
                          } else {
                            provider.chronicDiseases.remove(e);
                          }
                        });
                      },
                    ))
                .toList(),
          ),
          const SizedBox(height: 24),
          const Text('Kullanılan İlaçlar', style: TextStyle(fontWeight: FontWeight.bold)),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _medController,
                  decoration: const InputDecoration(hintText: 'İlaç adı girin'),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle, color: Color(0xFF00C853)),
                onPressed: () {
                  if (_medController.text.isNotEmpty) {
                    setState(() {
                      provider.medications.add(_medController.text);
                      _medController.clear();
                    });
                  }
                },
              ),
            ],
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: provider.medications.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(provider.medications[index]),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => setState(() => provider.medications.removeAt(index)),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Alerjiniz var mı?', style: TextStyle(fontWeight: FontWeight.bold)),
              Switch(
                key: const ValueKey('switch_alerji'),
                value: provider.hasAllergy,
                onChanged: (v) => setState(() => provider.hasAllergy = v),
              ),
            ],
          ),
          if (provider.hasAllergy) ...[
            const SizedBox(height: 16),
            TextFormField(
              key: const ValueKey('input_alerji_aciklama'),
              initialValue: provider.allergyDescription,
              maxLines: 2,
              decoration: const InputDecoration(labelText: 'Alerji Açıklaması'),
              onChanged: (v) => provider.allergyDescription = v,
            ),
          ],
        ],
      ),
    );
  }
}
