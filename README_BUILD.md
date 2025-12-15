# 📱 Todo App - Build & Deployment Guide

## 🎯 Tổng quan

App quản lý công việc với 5 tính năng nâng cao:
- ✅ Data Persistence (Hive)
- ✅ Categories/Tags
- ✅ Search Functionality
- ✅ Reminders/Notifications
- ✅ Nested Subtasks (3 levels)

Hỗ trợ 3 ngôn ngữ: 🇻🇳 Tiếng Việt | 🇺🇸 English | 🇯🇵 日本語

---

## 🚀 Quick Start

### Windows (Android APK)

```bash
# Cài dependencies
flutter pub get

# Build APK
flutter build apk --release

# File output: build/app/outputs/flutter-apk/app-release.apk
```

### macOS (iOS IPA)

```bash
# Chạy script tự động
chmod +x build_ios.sh
./build_ios.sh

# Hoặc thủ công
flutter pub get
cd ios && pod install && cd ..
open ios/Runner.xcworkspace  # Mở Xcode
```

📖 **Chi tiết**: Xem [BUILD_IOS_INSTRUCTIONS.md](BUILD_IOS_INSTRUCTIONS.md)

---

## 📦 Build Outputs

### Android

**APK Location:**
```
build/app/outputs/flutter-apk/app-release.apk
```

**Cài đặt:**
- Copy APK vào điện thoại Android
- Mở file và cài đặt
- Cần bật "Install from Unknown Sources"

### iOS

**Requirements:**
- macOS với Xcode
- Apple Developer Account
- iPhone thực tế (không thể test notifications trên simulator)

**Archive Location:**
```
build/ios/archive/Runner.xcarchive
```

---

## 🔧 Development

### Run on Emulator/Simulator

```bash
# Android
flutter run

# iOS (chỉ trên Mac)
flutter run -d iPhone
```

### Debug Mode

```bash
flutter run --debug
```

### Hot Reload
Trong debug mode, nhấn `r` để reload, `R` để restart

---

## 📱 Platform-Specific Setup

### Android

**Permissions (android/app/src/main/AndroidManifest.xml):**
```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
```

**Min SDK:** 21 (Android 5.0)
**Target SDK:** 34 (Android 14)

### iOS

**Permissions (ios/Runner/Info.plist):**
```xml
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>remote-notification</string>
</array>
```

**Min iOS Version:** 12.0
**Xcode Version:** 14.0+

---

## 🧪 Testing

### Run Tests

```bash
flutter test
```

### Widget Test
```bash
flutter test test/widget_test.dart
```

### Integration Test (on device)
```bash
flutter drive --target=test_driver/app.dart
```

---

## 🐛 Troubleshooting

### Common Issues

**1. "CocoaPods not installed" (iOS)**
```bash
sudo gem install cocoapods
pod setup
```

**2. "Gradle build failed" (Android)**
```bash
flutter clean
flutter pub get
flutter build apk --release
```

**3. "No valid iOS code signing certificates"**
- Mở Xcode
- Settings → Accounts → Add Apple ID
- Xcode sẽ tự tạo certificates

**4. Notifications không hoạt động**
- Android: Kiểm tra permissions trong Settings
- iOS: Phải test trên device thật (không phải simulator)

### Clean Build

```bash
# Xóa tất cả build artifacts
flutter clean

# Xóa cả dependencies
rm -rf ios/Pods ios/Podfile.lock
flutter pub get
```

---

## 📊 Build Sizes

**Android APK:** ~40-50 MB
**iOS IPA:** ~50-60 MB

(Tùy thuộc vào dependencies và assets)

---

## 🚢 Distribution

### TestFlight (iOS)

1. Build archive trong Xcode
2. Product → Archive
3. Window → Organizer
4. Upload to App Store Connect
5. Invite testers trong TestFlight

### Google Play Console (Android)

1. Build App Bundle:
   ```bash
   flutter build appbundle --release
   ```
2. Upload file `build/app/outputs/bundle/release/app-release.aab`
3. Tạo internal testing track
4. Distribute đến testers

---

## 📝 Notes

### Features Cần Test Trên Device Thật:

✅ **Notifications:**
- Phải test trên thiết bị thật
- iOS simulator không hỗ trợ local notifications
- Android emulator có thể test nhưng không đáng tin cậy

✅ **Data Persistence:**
- Hive lưu local, test bằng cách:
  - Tạo todos
  - Force quit app
  - Mở lại → data vẫn còn

✅ **Background Tasks:**
- Notifications được schedule ngay cả khi app đóng
- Test bằng cách set due date 1-2 giờ sau

### Performance Tips:

- Build `--release` mode cho performance tốt nhất
- Debug mode chạy chậm hơn nhiều
- Notifications có thể delay 1-2 phút (OS scheduling)

---

## 🔗 Useful Commands

```bash
# Kiểm tra devices kết nối
flutter devices

# Kiểm tra Flutter health
flutter doctor

# Xem log realtime
flutter logs

# Profile performance
flutter run --profile

# Analyze code
flutter analyze

# Update dependencies
flutter pub upgrade
```

---

## 📞 Support

Nếu gặp vấn đề:

1. Chạy `flutter doctor` để check setup
2. Xem [BUILD_IOS_INSTRUCTIONS.md](BUILD_IOS_INSTRUCTIONS.md) cho iOS
3. Check Flutter documentation: https://flutter.dev/docs

---

## ✨ Features Checklist

- [x] Multi-language (Vi/En/Ja)
- [x] Data persistence
- [x] Categories with icons
- [x] Search functionality
- [x] Due date reminders
- [x] Local notifications
- [x] Nested subtasks (3 levels)
- [x] Priority levels (4 levels)
- [x] Checklist progress bars
- [x] Share functionality
- [x] Undo delete
- [x] Filters & sorting

---

**Version:** 1.0.0
**Flutter SDK:** >=3.10.4
**Last Updated:** December 2025
