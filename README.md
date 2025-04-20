```markdown
# 🎈 Balon Patlatma Oyunu - Flutter Flame ile

Bu proje, Flutter + Flame engine kullanılarak geliştirilmiş basit ama eğlenceli bir balon patlatma oyunudur.  
Amaç, rastgele çıkan 7 renkli balonlar arasından sadece **kırmızı** balonlara tıklayarak onları patlatmaktır.  
🎯 Diğer renklere tıklamak herhangi bir işlem yapmaz.

---

## 🧩 Kullanılan Teknolojiler

- [Flutter](https://flutter.dev/)
- [Flame Game Engine](https://flame-engine.org/)
- [Dart](https://dart.dev/)

---

## 📲 Uygulamayı Çalıştırma / APK Oluşturma

### Gerekli Araçlar:
- Flutter SDK (3.7.2 veya üstü)
- Android Studio veya VS Code
- Cihazda internet bağlantısı (ilk build için)
- Android cihaz veya emulator

### Kurulum Adımları:

```bash
# Projeyi klonla
git clone https://github.com/byalpay/ballongame-ar.git
cd ballongame-ar

# Gerekli paketleri yükle
flutter pub get

# Android APK üret
flutter build apk --release

# Cihazda çalıştırmak için:
flutter run
```

📦 APK dosyası burada oluşur:  
`build/app/outputs/flutter-apk/app-release.apk`

---

## 🕹️ Oyun Özellikleri

- 🎨 7 farklı renk balon (kırmızı, mavi, yeşil, sarı, turuncu, mor, pembe)
- 👆 Sadece **kırmızı balonlara tıklanabiliyor** ve patlıyor
- 🧼 Sade ve kullanıcı dostu arayüz
- 📋 Başla ve Çıkış butonlarıyla ana menü
- ❌ Diğer renklerde işlem yapılmaz (ileri aşamada ceza puanı verilebilir)

---

## 📅 Haftalık Geliştirme Planı

| Hafta | Yapılacaklar |
|-------|--------------|
| ✅ 1. Hafta | Menü sistemi, balonlar ve tıklama mekaniği |
| ⏳ 2. Hafta | **Patlama animasyonu** ve efekt sesleri eklenecek |
| ⏳ 3. Hafta | **Skor sistemi** ve yanlış tıklamalarda ceza puanı |
| ⏳ 4. Hafta | **Zaman modu**: süre biterse oyun sonu ekranı |
| ⏳ 5. Hafta | **Yüksek skor** kaydı (SharedPreferences ile) |
| ⏳ 6. Hafta | **AR Desteği** eklenmeye başlanacak |
| ⏳ 7. Hafta | Yayınlama öncesi testler ve görsel iyileştirmeler |

---

## 👨‍💻 Geliştirici

- **Berkan Alpay**  
- GitHub: [@byalpay](https://github.com/byalpay)

---

## 📝 Lisans

This project is licensed under the MIT License.

---

## 📸 Ekran Görüntüsü (isteğe bağlı)

> 📷 Oyun ekranından görseller ekleyebilirsin:  
> Örnek:
> - `assets/screenshots/main_menu.png`
> - `assets/screenshots/gameplay.png`
```

---

### 📌 Ne Yapacaksın?

1. Proje klasörüne gir
2. `README.md` dosyasını aç veya oluştur
3. Bu içeriği kopyalayıp yapıştır
4. Terminalde şunları yaz:

```bash
git add README.md
git commit -m "Proje için detaylı README eklendi"
git push
```
