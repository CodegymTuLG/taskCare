# 📱 Todo App - Advanced Task Manager

Ứng dụng quản lý công việc với 5 tính năng nâng cao, hỗ trợ 3 ngôn ngữ (Tiếng Việt, English, 日本語).

## ✨ Features

### 🎯 5 Tính Năng Nâng Cao

1. **✅ Data Persistence (Hive)**
   - Lưu trữ local tự động
   - Không mất dữ liệu khi đóng app
   - Migration schema tự động

2. **🔔 Reminders & Notifications**
   - Đặt hạn chót cho công việc
   - Nhận thông báo trước 1 giờ
   - Hiển thị trạng thái: Còn thời gian / Quá hạn

3. **🏷️ Categories/Tags**
   - 4 danh mục: Công việc, Cá nhân, Mua sắm, Học tập
   - Icon và màu sắc riêng biệt
   - Lọc theo danh mục

4. **🔍 Search Functionality**
   - Tìm kiếm theo tiêu đề, mô tả
   - Tìm trong checklist lồng nhau
   - Hiển thị kết quả realtime

5. **📋 Nested Subtasks (3 levels)**
   - Chia nhỏ công việc thành nhiều cấp
   - Tính % hoàn thành tự động
   - Expand/collapse từng cấp

### 🌍 Multi-language Support
- 🇻🇳 Tiếng Việt
- 🇺🇸 English
- 🇯🇵 日本語

### 🎨 Other Features
- 4 mức độ ưu tiên (Thấp, Thường, Cao, Khẩn cấp)
- Bộ lọc: Tất cả / Chưa xong / Hoàn thành
- Sắp xếp: Mới nhất / Cũ nhất / Ưu tiên
- Chia sẻ công việc
- Hoàn tác xóa (3 giây)
- Progress bar cho checklist
- Material Design 3 UI

## 🚀 Quick Start

### Android
```bash
flutter pub get
flutter build apk --release
```
APK output: `build/app/outputs/flutter-apk/app-release.apk`

### iOS (cần macOS)
```bash
flutter pub get
cd ios && pod install && cd ..
open ios/Runner.xcworkspace
```

Hoặc xem [BUILD_IOS_INSTRUCTIONS.md](BUILD_IOS_INSTRUCTIONS.md) để build chi tiết.

### iOS (không cần Mac - Dùng Codemagic)
Xem hướng dẫn: [SETUP_CODEMAGIC.md](SETUP_CODEMAGIC.md)

## 📖 Documentation

- **[SETUP_CODEMAGIC.md](SETUP_CODEMAGIC.md)** - Build iOS không cần Mac (30 phút)
- **[BUILD_IOS_INSTRUCTIONS.md](BUILD_IOS_INSTRUCTIONS.md)** - Build iOS trên Mac chi tiết
- **[QUICKSTART_IOS.md](QUICKSTART_IOS.md)** - Build iOS nhanh (5 phút)
- **[CLOUD_BUILD_OPTIONS.md](CLOUD_BUILD_OPTIONS.md)** - So sánh cloud build services
- **[README_BUILD.md](README_BUILD.md)** - Hướng dẫn build tổng quát
- **[DEPLOYMENT_SUMMARY.md](DEPLOYMENT_SUMMARY.md)** - Tổng quan deployment

## 🛠️ Tech Stack

- **Framework**: Flutter 3.10.4+
- **Database**: Hive (local NoSQL)
- **Notifications**: flutter_local_notifications
- **Permissions**: permission_handler
- **Time**: timezone, intl
- **Storage**: path_provider
- **ID**: uuid

## 📱 Screenshots

App hỗ trợ cả Android và iOS với UI Material Design 3.

## ✅ Testing Checklist

### Trên Emulator/Simulator:
- ✅ UI/UX navigation
- ✅ Data persistence
- ✅ Search functionality
- ✅ Categories & filters
- ✅ Nested subtasks

### Phải test trên thiết bị thật:
- ✅ Local notifications
- ✅ Background notifications
- ✅ Performance thực tế

## 🌐 Build & Deployment

### Local Build
```bash
# Android APK
flutter build apk --release

# Android App Bundle (cho Play Store)
flutter build appbundle --release

# iOS (trên Mac)
flutter build ipa --release
```

### Cloud Build (Codemagic)
1. Push code lên GitHub
2. Kết nối repo với Codemagic
3. Configure iOS signing (Automatic)
4. Trigger build
5. Download IPA

**Chi tiết**: [SETUP_CODEMAGIC.md](SETUP_CODEMAGIC.md)

## 💰 Cost

- **App**: $0 (100% miễn phí)
- **Codemagic**: $0 (500 phút/tháng free tier)
- **Apple Developer** (optional): $99/năm (để publish lên App Store)

## 📝 License

MIT License - Free to use for personal and commercial projects.

## 🔗 Links

- **Codemagic**: https://codemagic.io
- **Flutter**: https://flutter.dev
- **Hive**: https://docs.hivedb.dev

---

**Version**: 1.0.0
**Last Updated**: December 2025
