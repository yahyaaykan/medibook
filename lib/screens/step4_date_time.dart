import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/appointment_provider.dart';

class Step4DateTime extends StatefulWidget {
  const Step4DateTime({super.key});

  @override
  State<Step4DateTime> createState() => _Step4DateTimeState();
}

class _Step4DateTimeState extends State<Step4DateTime> {
  final List<String> _allSlots = [
    '09:00', '09:30', '10:00', '10:30', '11:00', '11:30',
    '13:00', '13:30', '14:00', '14:30', '15:00', '15:30',
  ];

  final List<String> _fullSlots = ['10:00', '14:30'];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppointmentProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tarih & Saat Seçimi',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          
          ElevatedButton.icon(
            key: const ValueKey('btn_tarih_sec'),
            icon: const Icon(Icons.calendar_month, color: Colors.black),
            label: Text(provider.selectedDate == null 
                ? 'Tarih Seç' 
                : DateFormat('dd/MM/yyyy').format(provider.selectedDate!)),
            onPressed: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: provider.selectedDate ?? DateTime.now().add(const Duration(days: 1)),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 30)),
                selectableDayPredicate: (day) {
                  return day.weekday != DateTime.saturday && day.weekday != DateTime.sunday;
                },
              );
              if (date != null) {
                setState(() => provider.selectedDate = date);
              }
            },
          ),
          
          const SizedBox(height: 32),
          const Text('Kullanılabilir Saatler', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 2.5,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: _allSlots.length,
            itemBuilder: (context, index) {
              final slot = _allSlots[index];
              final isFull = _fullSlots.contains(slot);
              final isSelected = provider.selectedSlot == slot;

              return InkWell(
                key: ValueKey('slot_$slot'),
                onTap: isFull ? null : () => setState(() => provider.selectedSlot = slot),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? const Color(0xFF00C853) 
                        : (isFull ? Colors.grey[900] : Colors.white.withOpacity(0.05)),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF00C853) : Colors.white10,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    slot,
                    style: TextStyle(
                      color: isSelected ? Colors.black : (isFull ? Colors.grey : Colors.white),
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      decoration: isFull ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ),
              );
            },
          ),
          
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Acil Randevu', style: TextStyle(fontWeight: FontWeight.bold)),
              Switch(
                key: const ValueKey('switch_acil'),
                value: provider.isEmergency,
                onChanged: (v) => setState(() => provider.isEmergency = v),
                activeColor: Colors.redAccent,
              ),
            ],
          ),
          if (provider.isEmergency)
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                'UYARI: Acil randevular ek ücrete tabidir.',
                style: TextStyle(color: Colors.redAccent, fontSize: 12),
              ),
            ),
          
          const SizedBox(height: 24),
          TextFormField(
            key: const ValueKey('input_notlar'),
            maxLength: 200,
            maxLines: 3,
            initialValue: provider.notes,
            decoration: const InputDecoration(
              labelText: 'Notlar',
              alignLabelWithHint: true,
            ),
            onChanged: (v) => provider.notes = v,
          ),
        ],
      ),
    );
  }
}
