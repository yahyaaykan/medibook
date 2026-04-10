import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/appointment_provider.dart';

class Step5ExtraServices extends StatefulWidget {
  const Step5ExtraServices({super.key});

  @override
  State<Step5ExtraServices> createState() => _Step5ExtraServicesState();
}

class _Step5ExtraServicesState extends State<Step5ExtraServices> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppointmentProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ek Hizmetler & Onay',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          
          const Text('Ek Tetkikler', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              FilterChip(
                key: const ValueKey('chip_kan_tahlili'),
                label: const Text('Kan Tahlili'),
                selected: provider.extraServices.contains('Kan Tahlili'),
                onSelected: (v) => _toggleService(provider, 'Kan Tahlili', v),
              ),
              FilterChip(
                key: const ValueKey('chip_mr'),
                label: const Text('MR'),
                selected: provider.extraServices.contains('MR'),
                onSelected: (v) => _toggleService(provider, 'MR', v),
              ),
              FilterChip(
                key: const ValueKey('chip_rontgen'),
                label: const Text('Röntgen'),
                selected: provider.extraServices.contains('Röntgen'),
                onSelected: (v) => _toggleService(provider, 'Röntgen', v),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Refakatçi Sayısı', style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  IconButton(
                    key: const ValueKey('stepper_refakatci_minus'),
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: provider.attendantCount > 0 
                        ? () => setState(() => provider.attendantCount--) 
                        : null,
                  ),
                  Text('${provider.attendantCount}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(
                    key: const ValueKey('stepper_refakatci_plus'),
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: provider.attendantCount < 3 
                        ? () => setState(() => provider.attendantCount++) 
                        : null,
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          const Text('Ulaşım Yardımı', style: TextStyle(fontWeight: FontWeight.bold)),
          Column(
            children: [
              RadioListTile<String>(
                title: const Text('Tek Yön'),
                value: 'Tek Yön',
                groupValue: provider.transportType,
                onChanged: (v) => setState(() => provider.transportType = v),
              ),
              RadioListTile<String>(
                title: const Text('Gidiş-Dönüş'),
                value: 'Gidiş-Dönüş',
                groupValue: provider.transportType,
                onChanged: (v) => setState(() => provider.transportType = v),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          const Text('Hatırlatmalar', style: TextStyle(fontWeight: FontWeight.bold)),
          CheckboxListTile(
            title: const Text('SMS ile hatırlat'),
            value: provider.smsReminder,
            onChanged: (v) => setState(() => provider.smsReminder = v ?? false),
          ),
          CheckboxListTile(
            title: const Text('E-posta ile hatırlat'),
            value: provider.emailReminder,
            onChanged: (v) => setState(() => provider.emailReminder = v ?? false),
          ),

          const Divider(height: 64),
          
          CheckboxListTile(
            key: const ValueKey('checkbox_kvkk'),
            title: const Text('KVKK metnini okudum ve onaylıyorum.', style: TextStyle(fontSize: 12)),
            value: provider.kvkkAccepted,
            onChanged: (v) => setState(() => provider.kvkkAccepted = v ?? false),
            controlAffinity: ListTileControlAffinity.leading,
          ),
          CheckboxListTile(
            key: const ValueKey('checkbox_acik_riza'),
            title: const Text('Açık rıza beyanını kabul ediyorum.', style: TextStyle(fontSize: 12)),
            value: provider.consentAccepted,
            onChanged: (v) => setState(() => provider.consentAccepted = v ?? false),
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ],
      ),
    );
  }

  void _toggleService(AppointmentProvider provider, String service, bool selected) {
    setState(() {
      if (selected) {
        provider.extraServices.add(service);
      } else {
        provider.extraServices.remove(service);
      }
    });
  }
}
