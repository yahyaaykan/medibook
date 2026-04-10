import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/appointment_provider.dart';
import 'step1_patient_info.dart';
import 'step2_insurance.dart';
import 'step3_cascading.dart';
import 'step4_date_time.dart';
import 'step5_extra_services.dart';
import 'step6_summary.dart';

class WizardScreen extends StatefulWidget {
  const WizardScreen({super.key});

  @override
  State<WizardScreen> createState() => _WizardScreenState();
}

class _WizardScreenState extends State<WizardScreen> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppointmentProvider>();

    // Sync PageController with currentStep
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_pageController.hasClients && _pageController.page?.round() != provider.currentStep) {
        _pageController.animateToPage(
          provider.currentStep,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('MediBook - Randevu Al'),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: _buildProgressIndicator(provider.currentStep),
        ),
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          Step1PatientInfo(),
          Step2Insurance(),
          Step3Cascading(),
          Step4DateTime(),
          Step5ExtraServices(),
          Step6Summary(),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(provider),
    );
  }

  Widget _buildProgressIndicator(int currentStep) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(6, (index) {
          bool isActive = index <= currentStep;
          return Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: isActive ? const Color(0xFF00C853) : Colors.grey[800],
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    color: isActive ? Colors.black : Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (index < 5)
                Container(
                  width: 30,
                  height: 2,
                  color: index < currentStep ? const Color(0xFF00C853) : Colors.grey[800],
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildBottomNav(AppointmentProvider provider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFF121A18),
        border: Border(top: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        children: [
          // GERİ BUTTON
          Expanded(
            child: ElevatedButton(
              key: const ValueKey('btn_geri'),
              onPressed: provider.currentStep == 0 ? null : provider.prevStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: provider.currentStep == 0 ? Colors.grey[900] : Colors.transparent,
                side: BorderSide(color: provider.currentStep == 0 ? Colors.transparent : const Color(0xFF00C853)),
                foregroundColor: const Color(0xFF00C853),
              ),
              child: const Text('GERİ'),
            ),
          ),
          const SizedBox(width: 12),
          // İLERİ BUTTON
          if (provider.currentStep < 5)
            Expanded(
              child: ElevatedButton(
                key: const ValueKey('btn_ileri'),
                onPressed: provider.nextStep,
                child: const Text('İLERİ'),
              ),
            ),
          // ONAYLA BUTTON (Visible only on last step)
          if (provider.currentStep == 5)
            Expanded(
              child: ElevatedButton(
                key: const ValueKey('btn_onayla'),
                onPressed: (provider.kvkkAccepted && provider.consentAccepted && !provider.isConfirmed) 
                    ? () => provider.confirmAppointment()
                    : null,
                child: const Text('ONAYLA'),
              ),
            ),
        ],
      ),
    );
  }
}
