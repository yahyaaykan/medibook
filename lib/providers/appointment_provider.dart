import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/patient_model.dart';
import '../models/hospital_models.dart';

class AppointmentProvider with ChangeNotifier {
  int _currentStep = 0;
  int get currentStep => _currentStep;

  // Step 1: Patient Info
  Patient patient = Patient();

  // Step 2: Insurance
  String? insuranceType;
  String? insuranceCompany;
  List<String> chronicDiseases = [];
  List<String> medications = [];
  bool hasAllergy = false;
  String? allergyDescription;

  // Step 3: Cascading selection
  City? selectedCity;
  Hospital? selectedHospital;
  Department? selectedDepartment;
  Doctor? selectedDoctor;

  // Step 4: Date & Time
  DateTime? selectedDate;
  String? selectedSlot;
  bool isEmergency = false;
  String notes = '';

  // Step 5: Extra Services
  List<String> extraServices = [];
  int attendantCount = 0;
  String? transportType;
  bool smsReminder = false;
  bool emailReminder = false;
  bool kvkkAccepted = false;
  bool consentAccepted = false;

  bool isConfirmed = false;
  String? confirmationUuid;

  AppointmentProvider() {
    _loadDraft();
  }

  void nextStep() {
    if (_currentStep < 5) {
      _currentStep++;
      _saveDraft();
      notifyListeners();
    }
  }

  void prevStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  void goToStep(int step) {
    _currentStep = step;
    notifyListeners();
  }

  // Cascading Logic
  void setCity(City? city) {
    selectedCity = city;
    selectedHospital = null;
    selectedDepartment = null;
    selectedDoctor = null;
    notifyListeners();
  }

  void setHospital(Hospital? hospital) {
    selectedHospital = hospital;
    selectedDepartment = null;
    selectedDoctor = null;
    notifyListeners();
  }

  void setDepartment(Department? department) {
    selectedDepartment = department;
    selectedDoctor = null;
    notifyListeners();
  }

  void setDoctor(Doctor? doctor) {
    selectedDoctor = doctor;
    notifyListeners();
  }

  // Draft Saving
  Future<void> _saveDraft() async {
    final prefs = await SharedPreferences.getInstance();
    final draft = {
      'currentStep': _currentStep,
      'patient': patient.toJson(),
      'insuranceType': insuranceType,
      'insuranceCompany': insuranceCompany,
      'hasAllergy': hasAllergy,
      'allergyDescription': allergyDescription,
      'isEmergency': isEmergency,
      'notes': notes,
      'attendantCount': attendantCount,
      'kvkkAccepted': kvkkAccepted,
      'consentAccepted': consentAccepted,
    };
    await prefs.setString('appointment_draft', jsonEncode(draft));
  }

  Future<void> _loadDraft() async {
    final prefs = await SharedPreferences.getInstance();
    final draftStr = prefs.getString('appointment_draft');
    if (draftStr != null) {
      final draft = jsonDecode(draftStr);
      _currentStep = draft['currentStep'] ?? 0;
      patient = Patient.fromJson(draft['patient'] ?? {});
      insuranceType = draft['insuranceType'];
      insuranceCompany = draft['insuranceCompany'];
      hasAllergy = draft['hasAllergy'] ?? false;
      allergyDescription = draft['allergyDescription'];
      isEmergency = draft['isEmergency'] ?? false;
      notes = draft['notes'] ?? '';
      attendantCount = draft['attendantCount'] ?? 0;
      kvkkAccepted = draft['kvkkAccepted'] ?? false;
      consentAccepted = draft['consentAccepted'] ?? false;
      notifyListeners();
    }
  }

  Future<void> confirmAppointment() async {
    confirmationUuid = null;
    isConfirmed = false;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    confirmationUuid = const Uuid().v4();
    isConfirmed = true;
    notifyListeners();
    _saveDraft();
  }

  void setConfirmation(String uuid) {
    confirmationUuid = uuid;
    isConfirmed = true;
    notifyListeners();
  }

  double calculateTotalPrice() {
    double total = 500.0; // Base consult fee
    if (selectedDoctor?.specialty.contains('Prof') ?? false) total += 200;
    total += extraServices.length * 150.0;
    if (isEmergency) total += 300;
    return total;
  }
}
