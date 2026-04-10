class Validators {
  static String? validateTC(String? value) {
    if (value == null || value.isEmpty) return 'TC Kimlik numarası boş olamaz';
    if (value.length != 11) return 'TC Kimlik numarası 11 hane olmalıdır';
    if (value.startsWith('0')) return 'TC Kimlik numarası 0 ile başlayamaz';
    
    List<int> digits = value.split('').map((e) => int.parse(e)).toList();
    
    // Check digit 10
    int sumOdd = digits[0] + digits[2] + digits[4] + digits[6] + digits[8];
    int sumEven = digits[1] + digits[3] + digits[5] + digits[7];
    int digit10 = ((sumOdd * 7) - sumEven) % 10;
    if (digit10 != digits[9]) return 'Geçersiz TC Kimlik numarası (L10)';
    
    // Check digit 11
    int sum10 = digits.sublist(0, 10).reduce((a, b) => a + b);
    int digit11 = sum10 % 10;
    if (digit11 != digits[10]) return 'Geçersiz TC Kimlik numarası (L11)';
    
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'E-posta adresi boş olamaz';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'Geçerli bir e-posta adresi giriniz';
    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) return '$fieldName boş olamaz';
    return null;
  }
}
