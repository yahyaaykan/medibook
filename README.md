# MediBook — Akıllı Hastane Randevu Sistemi

Bu proje, bir özel hastane için 6 adımlı, gelişmiş validasyonlara ve kullanıcı deneyimi prensiplerine sahip bir randevu sihirbazı (Wizard) uygulamasıdır.

## Öğrenci Bilgileri
- **Ad Soyad:** Yahya AYKAN
- **Öğrenci No:** 23080410201

## Proje Hakkında
MediBook, modern bir sağlık uygulaması arayüzü ve güçlü bir teknik altyapı ile geliştirilmiştir. Uygulama, hastaların kişisel bilgilerinden doktor seçimine, tarih/saat belirlemeden ek hizmetlere kadar tüm süreci uçtan uca yönetir.

### Teknik Özellikler
- **Framework:** Flutter
- **State Management:** Provider
- **Yerel Depolama:** SharedPreferences (Taslak kaydetme desteği)
- **Validasyon:** Custom TC Kimlik Luhn Algoritması, E-posta Regex, Telefon Maskeleme
- **Cascading Dropdowns:** 4 seviyeli dinamik Şehir-Hastane-Bölüm-Doktor hiyerarşisi
- **Test Altyapısı:** 30+ Maestro UI Test Key entegrasyonu

## Yapay Zeka (AI) Kullanımı
Bu projenin geliştirilmesinde **Gemini 3 Flash** (Antigravity adlı asistan üzerinden) kullanılmıştır.

### Örnek 5 Prompt
1. "Flutter'da TC Kimlik numarası için Luhn algoritmasını kontrol eden bir validasyon fonksiyonu yazar mısın?"
2. "Provider kullanarak 6 adımlı bir wizard yapısı kurmak istiyorum, adımlar arası state nasıl korunur?"
3. "Şehir, Hastane, Bölüm ve Doktor seçimleri için birbirine bağlı (cascading) dropdown yapısını nasıl kodlarız?"
4. "Hafta sonlarının seçilemediği ve 30 dakikalık slotların olduğu bir randevu takvimi oluşturur musun?"
5. "Tüm form alanlarına Maestro UI testleri için gerekli olan spesifik ValueKey'leri nasıl eklemeliyim?"

## Kurulum
1. Repoyu klonlayın: `git clone https://github.com/yahyaaykan/medibook`
2. Bağımlılıkları yükleyin: `flutter pub get`
3. Uygulamayı çalıştırın: `flutter run`

---
*Bu proje ders içi etkinlik kapsamında geliştirilmiştir.*
