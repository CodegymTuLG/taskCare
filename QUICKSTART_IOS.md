# 🍎 iOS Build - Quick Start Guide

## 📋 Checklist (5 phút setup)

### ✅ Bước 1: Copy project sang Mac

```bash
# Trên Mac, tải project về
# Option A: Git clone
git clone <your-repo-url>

# Option B: Copy trực tiếp qua AirDrop/USB
```

### ✅ Bước 2: Cài đặt (2 phút)

```bash
cd flutter_application_1

# Install dependencies
flutter pub get

# Install iOS pods
cd ios
pod install
cd ..
```

### ✅ Bước 3: Mở Xcode (30 giây)

```bash
open ios/Runner.xcworkspace
```

**⚠️ Chú ý:** Mở file `.xcworkspace`, KHÔNG phải `.xcodeproj`

### ✅ Bước 4: Configure Signing (1 phút)

Trong Xcode:

1. Click vào **Runner** (ở sidebar trái, icon app màu xanh)
2. Chọn **Runner** target ở TARGETS
3. Tab **Signing & Capabilities**:

   ```
   ✅ Tick "Automatically manage signing"
   Team: Chọn tên Apple ID của bạn
   Bundle Identifier: com.yourname.todoapp (đổi thành unique)
   ```

### ✅ Bước 5: Kết nối iPhone (30 giây)

1. Cắm iPhone vào Mac qua USB
2. Mở khóa iPhone
3. Trust computer nếu có popup
4. Trong Xcode, chọn iPhone từ device dropdown (góc trên bên trái, bên cạnh nút ▶️)

### ✅ Bước 6: Run! (1 phút)

Nhấn **⌘ + R** hoặc nút ▶️

**Lần đầu sẽ báo lỗi "Untrusted Developer":**

Trên iPhone:
```
Settings → General → VPN & Device Management
→ Tap vào tên developer → Trust
```

Quay lại app và mở → Done! 🎉

---

## 🎥 Visual Guide

```
Xcode Sidebar          Target Settings         Device Selector
┌──────────────┐      ┌──────────────────┐    ┌──────────────┐
│ ▼ Runner     │      │ Signing & Caps   │    │ Your iPhone ▼│
│   ├─ Runner  │  →   │ ☑ Auto manage   │    │              │
│   ├─ Tests   │      │ Team: Your Apple│    │ ▶️ Run       │
│   └─ Pods    │      │ Bundle: com.you │    └──────────────┘
└──────────────┘      └──────────────────┘
   Click đây            Configure đây         Chọn device rồi Run
```

---

## 🔥 One-Liner Build

```bash
# Build và run trực tiếp (nếu đã setup signing)
flutter run --release
```

---

## 🐛 Nếu Gặp Lỗi

### "CocoaPods not installed"
```bash
sudo gem install cocoapods
```

### "No Team Selected"
- Xcode → Settings (⌘,)
- Accounts → + → Sign in với Apple ID
- Quay lại Signing & Capabilities, chọn Team

### "Development Team Not Found"
- Cần Apple ID (miễn phí)
- Sign in ở Xcode → Settings → Accounts

### Build Failed
```bash
# Clean và rebuild
flutter clean
cd ios && pod install && cd ..
flutter run
```

---

## 💡 Pro Tips

### Faster Builds
```bash
# Chỉ build cho arm64 (iPhone hiện đại)
flutter build ios --release --dart-define=FLUTTER_BUILD_MODE=release
```

### Debug Logs
```bash
# Xem logs realtime
flutter logs
```

### Hot Restart
Trong debug mode, thay đổi code và nhấn:
- `r` - Hot reload (nhanh)
- `R` - Hot restart (restart app)

---

## 📱 Build IPA (để share cho người khác)

```bash
# Build IPA
flutter build ipa --release

# File output: build/ios/ipa/flutter_application_1.ipa
```

Distribute qua:
- ✅ **AirDrop** - Share trực tiếp
- ✅ **TestFlight** - Apple's testing platform
- ✅ **Xcode Organizer** - Export với nhiều options

---

## ⏱️ Total Time: ~5 phút

- Setup: 2 phút
- Configure: 1 phút
- Connect device: 30 giây
- First build: 1-2 phút
- **Done!** ✅

---

## 🎯 Khi Nào Cần Build iOS?

**Cần build trên device thật khi test:**
- ✅ Notifications (không hoạt động trên simulator)
- ✅ Camera/Photos
- ✅ Location services
- ✅ Performance thực tế

**Có thể dùng simulator để test:**
- ✅ UI/UX
- ✅ Navigation
- ✅ Data persistence
- ✅ Search, filters

---

## 🔄 Update Code

Sau khi thay đổi code trên Windows:

```bash
# Trên Mac, pull latest code
git pull

# Build lại
flutter run
```

Hoặc nếu dùng hot reload:
- Chỉ cần save file
- Nhấn `r` trong terminal
- App tự động update!

---

**Có thắc mắc?** Check [BUILD_IOS_INSTRUCTIONS.md](BUILD_IOS_INSTRUCTIONS.md) cho hướng dẫn chi tiết!
