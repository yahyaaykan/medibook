import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import '../providers/appointment_provider.dart';
import '../services/validators.dart';

class Step1PatientInfo extends StatefulWidget {
  const Step1PatientInfo({super.key});

  @override
  State<Step1PatientInfo> createState() => _Step1PatientInfoState();
}

class _Step1PatientInfoState extends State<Step1PatientInfo> {
  final _formKey = GlobalKey<FormState>();
  final _phoneFormatter = MaskTextInputFormatter(
    mask: '0(5##) ### ## ##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppointmentProvider>();
    final patient = provider.patient;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Kişisel Bilgiler',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            TextFormField(
              key: const ValueKey('input_ad'),
              initialValue: patient.firstName,
              decoration: const InputDecoration(labelText: 'Ad'),
              onChanged: (v) => patient.firstName = v,
              validator: (v) => Validators.validateRequired(v, 'Ad'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              key: const ValueKey('input_soyad'),
              initialValue: patient.lastName,
              decoration: const InputDecoration(labelText: 'Soyad'),
              onChanged: (v) => patient.lastName = v,
              validator: (v) => Validators.validateRequired(v, 'Soyad'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              key: const ValueKey('input_tc'),
              initialValue: patient.tcNo,
              decoration: const InputDecoration(labelText: 'TC Kimlik No'),
              keyboardType: TextInputType.number,
              onChanged: (v) => patient.tcNo = v,
              validator: Validators.validateTC,
            ),
            const SizedBox(height: 16),
            TextFormField(
              key: const ValueKey('input_email'),
              initialValue: patient.email,
              decoration: const InputDecoration(labelText: 'E-posta'),
              keyboardType: TextInputType.emailAddress,
              onChanged: (v) => patient.email = v,
              validator: Validators.validateEmail,
            ),
            const SizedBox(height: 16),
            TextFormField(
              key: const ValueKey('input_telefon'),
              inputFormatters: [_phoneFormatter],
              initialValue: patient.phone,
              decoration: const InputDecoration(labelText: 'Telefon'),
              keyboardType: TextInputType.phone,
              onChanged: (v) => patient.phone = v,
              validator: (v) => Validators.validateRequired(v, 'Telefon'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              key: const ValueKey('input_dogum'),
              readOnly: true,
              controller: TextEditingController(
                text: patient.birthDate != null
                    ? '${patient.birthDate!.day}/${patient.birthDate!.month}/${patient.birthDate!.year}'
                    : '',
              ),
              decoration: const InputDecoration(
                labelText: 'Doğum Tarihi',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: patient.birthDate ?? DateTime(2000),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  setState(() => patient.birthDate = date);
                }
              },
            ),
            const SizedBox(height: 16),
            const Text('Cinsiyet', style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: [
                Radio<String>(
                  key: const ValueKey('radio_erkek'),
                  value: 'Erkek',
                  groupValue: patient.gender,
                  onChanged: (v) => setState(() => patient.gender = v),
                ),
                const Text('Erkek'),
                const SizedBox(width: 20),
                Radio<String>(
                  key: const ValueKey('radio_kadin'),
                  value: 'Kadın',
                  groupValue: patient.gender,
                  onChanged: (v) => setState(() => patient.gender = v),
                ),
                const Text('Kadın'),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              key: const ValueKey('input_adres'),
              initialValue: patient.address,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Adres'),
              onChanged: (v) => patient.address = v,
              validator: (v) {
                if (v == null || v.length < 10) return 'Adres en az 10 karakter olmalıdır';
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
