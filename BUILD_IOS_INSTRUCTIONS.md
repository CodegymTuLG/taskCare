# Hướng dẫn Build iOS App

## Yêu cầu:
- ✅ **macOS** (Monterey 12 hoặc mới hơn)
- ✅ **Xcode** (14.0 hoặc mới hơn)
- ✅ **Flutter SDK** đã cài đặt
- ✅ **Apple Developer Account**
- ✅ **iPhone thực tế** kết nối qua USB

---

## Bước 1: Cài đặt dependencies

```bash
# Di chuyển vào thư mục project
cd path/to/flutter_application_1

# Cài đặt Flutter dependencies
flutter pub get

# Cài đặt iOS dependencies (CocoaPods)
cd ios
pod install
cd ..
```

---

## Bước 2: Mở Xcode và cấu hình Signing

```bash
# Mở project trong Xcode
open ios/Runner.xcworkspace
```

**Trong Xcode:**

1. Chọn **Runner** (project root) ở sidebar trái
2. Chọn **Runner** target
3. Tab **Signing & Capabilities**:
   - ✅ Tick "Automatically manage signing"
   - Chọn **Team** của bạn từ dropdown
   - **Bundle Identifier**: Thay đổi thành unique ID (VD: `com.yourname.todoapp`)

4. Đảm bảo **Deployment Target** >= iOS 12.0

---

## Bước 3: Kết nối iPhone và Trust Developer

1. **Kết nối iPhone** qua USB
2. Mở khóa iPhone
3. Nếu xuất hiện popup "Trust This Computer?" → chọn **Trust**
4. Trong Xcode, chọn iPhone của bạn từ device dropdown (góc trên bên trái)

---

## Bước 4: Build và Run

### Option A: Từ Xcode (Đơn giản nhất)

1. Nhấn **⌘ + R** hoặc nút ▶️ Play
2. Xcode sẽ build và cài app lên iPhone
3. **Lần đầu chạy**: Sẽ báo lỗi "Untrusted Developer"
   - Trên iPhone: **Settings → General → VPN & Device Management**
   - Tap vào tên developer → **Trust**
   - Quay lại app và mở

### Option B: Từ Terminal (Advanced)

```bash
# List devices
flutter devices

# Run on connected iPhone
flutter run --release

# Build IPA file (để distribute)
flutter build ios --release
```

---

## Bước 5: Build IPA file (Optional - để share)

```bash
# Build archive
flutter build ipa --release

# File output sẽ ở:
# build/ios/archive/Runner.xcarchive
```

Để distribute IPA:
1. Mở Xcode
2. **Window → Organizer**
3. Chọn archive vừa build
4. Click **Distribute App**
5. Chọn **Ad Hoc** hoặc **Development**
6. Export IPA file

---

## Troubleshooting

### Lỗi: "CocoaPods not installed"
```bash
# Cài đặt CocoaPods
sudo gem install cocoapods
pod setup
```

### Lỗi: "No valid code signing certificates found"
- Cần Apple Developer Account
- Trong Xcode → Settings → Accounts → Add Apple ID
- Xcode sẽ tự động tạo certificates

### Lỗi: "The operation couldn't be completed"
```bash
# Clean build folder
flutter clean
cd ios && pod install && cd ..
flutter pub get
```

### Lỗi về Permissions (Notifications không hoạt động)
- File `ios/Runner/Info.plist` đã được cấu hình sẵn
- Đảm bảo trong Xcode, tab **Signing & Capabilities**:
  - ✅ Add **Background Modes**
  - ✅ Tick: Remote notifications, Background fetch

---

## Build cho TestFlight (Distribute qua App Store)

```bash
# Build archive
flutter build ipa --release

# Upload lên App Store Connect
# (Cần Apple Developer Program - $99/năm)
```

Hoặc trong Xcode:
1. Product → Archive
2. Window → Organizer
3. Distribute App → App Store Connect
4. Upload

---

## Notes quan trọng:

✅ **Đã cấu hình:**
- ✅ Background modes cho notifications
- ✅ Permissions cho local notifications
- ✅ Flutter dependencies

⚠️ **Cần kiểm tra:**
- Bundle Identifier phải unique
- Apple Developer Account đã đăng nhập Xcode
- iPhone đã Trust developer certificate

📱 **App features đã implement:**
- Data Persistence (Hive)
- Categories/Tags
- Search functionality
- Reminders/Notifications (cần test trên device thật)
- Nested Subtasks (3 levels)

---

## Quick Start Commands

```bash
# Full build process
flutter clean
flutter pub get
cd ios && pod install && cd ..
flutter run --release

# Or just run if already set up
flutter run
```

Good luck! 🚀
