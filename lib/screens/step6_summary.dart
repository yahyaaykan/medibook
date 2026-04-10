import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/appointment_provider.dart';

class Step6Summary extends StatelessWidget {
  const Step6Summary({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppointmentProvider>();

    if (provider.isConfirmed) {
      return _buildSuccessScreen(provider.confirmationUuid ?? '-');
    }

    // Checking if there's an active confirmation in progress (if we added a loading flag)
    // For now, let's assume if it's not confirmed and kvkk is accepted, it might be loading if we click.
    // We can add a simple check.
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Randevu Özeti',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          
          _buildSummarySection(
            'Hasta Bilgileri',
            '${provider.patient.firstName ?? '-'} ${provider.patient.lastName ?? '-'}\nTC: ${provider.patient.tcNo ?? '-'}',
            onEdit: () => provider.goToStep(0),
          ),
          _buildSummarySection(
            'Sigorta & Sağlık',
            'Sigorta: ${provider.insuranceType ?? '-'}\nAlerji: ${provider.hasAllergy ? 'Var' : 'Yok'}',
            onEdit: () => provider.goToStep(1),
          ),
          _buildSummarySection(
            'Doktor & Hastane',
            '${provider.selectedHospital?.name ?? '-'}\n${provider.selectedDepartment?.name ?? '-'}\n${provider.selectedDoctor?.name ?? '-'}',
            onEdit: () => provider.goToStep(2),
          ),
          _buildSummarySection(
            'Randevu Zamanı',
            '${provider.selectedDate != null ? DateFormat('dd.MM.yyyy').format(provider.selectedDate!) : '-'} - ${provider.selectedSlot ?? '-'}',
            onEdit: () => provider.goToStep(3),
          ),
          
          const Divider(height: 48),
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF00C853).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF00C853)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Toplam Ücret', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(
                  '${provider.calculateTotalPrice().toStringAsFixed(2)} TL',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF00C853)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (!(provider.kvkkAccepted && provider.consentAccepted))
            const Text(
              '* Lütfen önceki adımdaki onay kutularını işaretleyiniz.',
              style: TextStyle(color: Colors.redAccent, fontSize: 12),
            ),
        ],
      ),
    );
  }

  Widget _buildSummarySection(String title, String content, {required VoidCallback onEdit}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF00C853))),
                IconButton(
                  icon: const Icon(Icons.edit, size: 18),
                  onPressed: onEdit,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(content, style: const TextStyle(height: 1.4)),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessScreen(String uuid) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline, color: Color(0xFF00C853), size: 100),
            const SizedBox(height: 24),
            const Text(
              'Randevunuz Başarıyla Oluşturuldu!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('Randevu Numaranız:', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SelectableText(
                uuid,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
