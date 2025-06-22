# 🎈 Boom Boom Balloon - Balon Patlatma Oyunu

## Proje Açıklaması
Boom Boom Balloon, çocuklar için tasarlanmış, eğlenceli ve refleks geliştiren bir balon patlatma oyunudur. Amaç, ekranda rastgele çıkan balonları patlatarak en yüksek skora ulaşmaktır. Oyun, seviye sistemi, farklı balon türleri, modern ana menü ve yüksek skor kaydı gibi özellikler sunar.

- **Proje Adı:** Boom Boom Balloon
- **Amaç:** Çocuklara eğlenceli ve güvenli bir oyun deneyimi sunmak, refleks ve dikkat gelişimini desteklemek.
- **Hedef Kitle:** 4-12 yaş arası çocuklar ve aileleri.
- **Kullanılan Teknolojiler:**
  - Flutter (3.7.2+)
  - Flame Game Engine
  - Dart
  - Shared Preferences

---

## Kurulum Rehberi

### Gerekli Yazılımlar
- Flutter SDK (3.7.2 veya üzeri)
- Android Studio veya VS Code
- Android cihaz veya emulator (Android 5.0+)

### Adım Adım Kurulum
1. **Projeyi İndir:**
   - Proje dosyalarını bilgisayarınıza indirin veya klonlayın.
2. **APK ile Kurulum:**
   - `apk/ballon_game-v1.0.0.apk` dosyasını Android cihazınıza aktarın.
   - Cihazda "Bilinmeyen kaynaklara izin ver" seçeneğini aktif edin.
   - APK dosyasına tıklayarak yükleyin.
3. **Kaynak Koddan Derleme (Geliştiriciler için):**
   ```bash
   flutter pub get
   flutter build apk --release
   # veya test için:
   flutter run
   ```
4. **Bağımlılıklar:**
   - flame: ^1.12.0
   - flame_audio: ^2.1.1
   - flutter_exit_app: ^1.0.2
   - cupertino_icons: ^1.0.8
   - shared_preferences: ^2.2.2

---

## Haftalık Geliştirme Planı

| Hafta | Yapılacaklar |
|-------|--------------|
| ✅ 1. Hafta | Menü sistemi, balonlar ve tıklama mekaniği |
| ✅ 2. Hafta | **Patlama animasyonu** ve efekt sesleri eklendi |
| ✅ 3. Hafta | **Skor sistemi** ve yanlış tıklamalarda ceza puanı eklendi |
| ✅ 4. Hafta | **Zaman modu**: süre biterse oyun sonu ekranı eklendi |
| ✅ 5. Hafta | **Yüksek skor** kaydı (SharedPreferences ile) eklendi |
| ❌ 6. Hafta | **AR Desteği** eklenmeye başlanacak (devre dışı bırakıldı) |
| ✅ 7. Hafta | Yayınlama öncesi testler ve görsel iyileştirmeler yapıldı |

---

## Kullanım Talimatları

- Oyuna başlamak için ana menüden "Başla" butonuna tıklayın.
- Ekranda çıkan balonlara dokunarak patlatın.
- Farklı renk ve boyutlardaki balonlar farklı puanlar kazandırır.
- Kırmızı balonları patlatırsanız puan kaybedersiniz.
- Kaçırılan balonlar da puan kaybettirir.
- Her 20 puanda bir seviye atlanır, oyun zorlaşır.
- Oyun sırasında puanınızı ve seviyenizi üstte görebilirsiniz.
- Oyunu duraklatmak için sağ üstteki "Duraklat" butonunu kullanabilirsiniz.
- Oyun sonunda skor tablosunda en yüksek puanınızı görebilirsiniz.

---

## AR Özellikleri

> **Not:** Bu sürümde AR (Artırılmış Gerçeklik) özelliği devre dışı bırakılmıştır. Gelecekteki sürümlerde AR desteği tekrar eklenecektir.

- Kullanılan AR Teknolojisi: ar_flutter_plugin (şu an devre dışı)
- AR deneyimi için gerekli donanım: ARCore destekli Android cihaz (gelecekteki sürümler için)

---

## Ekran Görüntüleri

Aşağıda oyunun farklı bölümlerine ait örnek ekran görüntüleri için dosya yolları verilmiştir. Kendi ekran görüntülerinizi bu dosya yollarına ekleyebilirsiniz.

- Ana Menü: `assets/screenshots/main_menu.png`
- Oyun Ekranı: `assets/screenshots/gameplay.png`
- Seviye Atlama: `assets/screenshots/level_up.png`
- Skor Tablosu: `assets/screenshots/score_table.png`
- Oyun Sonu: `assets/screenshots/game_over.png`
- (AR Özelliği için) `assets/screenshots/ar_mode.png` (şu an devre dışı)

---

## Geliştirici
- **Berkan Alpay**
- GitHub: [@byalpay](https://github.com/byalpay)

---

## Lisans
Bu proje MIT lisansı ile lisanslanmıştır.
