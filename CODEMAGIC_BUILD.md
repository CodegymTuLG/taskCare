# 🚀 Build iOS với Codemagic (Không Cần Mac)

## ✨ Tại Sao Dùng Codemagic?

- ✅ **500 phút build/tháng MIỄN PHÍ**
- ✅ **Không cần Mac**
- ✅ **Tự động build IPA**
- ✅ **Upload lên TestFlight tự động**
- ✅ **Hỗ trợ Flutter native**

---

## 🎯 Setup (10 phút)

### Bước 1: Push Code Lên Git (5 phút)

```bash
# Nếu chưa có git repo
cd e:/Study/flutter/flutter_application_1

# Initialize git
git init

# Add all files
git add .

# Commit
git commit -m "Initial commit - Todo App with 5 features"

# Tạo repo trên GitHub/GitLab/Bitbucket
# Rồi push lên
git remote add origin https://github.com/yourusername/flutter-todo-app.git
git push -u origin main
```

### Bước 2: Đăng Ký Codemagic (2 phút)

1. Truy cập: https://codemagic.io
2. Click **"Sign up for free"**
3. Đăng nhập bằng GitHub/GitLab/Bitbucket
4. Authorize Codemagic access

### Bước 3: Add Project (1 phút)

1. Click **"Add application"**
2. Chọn repository: `flutter-todo-app`
3. Select **Flutter App**
4. Click **"Finish"**

### Bước 4: Configure iOS Build (2 phút)

1. Click vào project → **"Start new build"**
2. Workflow settings:
   ```yaml
   Build for: iOS
   Build mode: Release
   Build .ipa: ✅ Enabled
   ```

3. **Code Signing** (Quan trọng!):
   - Option A: **Automatic** (Codemagic tự tạo - Đơn giản nhất)
   - Option B: **Manual** (Dùng Apple Developer account của bạn)

---

## 🔐 Code Signing Options

### Option A: Automatic Signing (Đơn Giản - FREE)

**Ưu điểm:**
- ✅ Không cần Apple Developer account ($99/năm)
- ✅ Codemagic tự tạo certificate
- ✅ Có thể cài trên device test (tối đa 100 devices)

**Nhược điểm:**
- ⚠️ Không thể upload lên App Store
- ⚠️ IPA chỉ dùng được 7 ngày

**Setup:**
1. Codemagic → Settings → **iOS code signing**
2. Chọn **"Automatic"**
3. Đăng nhập Apple ID (miễn phí)
4. Done!

### Option B: Manual Signing (Chuyên Nghiệp)

**Cần:**
- Apple Developer Account ($99/năm)
- Certificates & Provisioning Profiles

**Setup:**
1. Vào https://developer.apple.com
2. Tạo Certificates & Profiles
3. Download về
4. Upload lên Codemagic

---

## ▶️ Build Đầu Tiên

### Automatic Build

1. Click **"Start new build"**
2. Select branch: `main`
3. Build mode: **Release**
4. Click **"Start build"**

### Theo dõi Build

```
Build started → Installing dependencies → Building iOS
→ Signing → Packaging IPA → Done! (~10-15 phút)
```

### Download IPA

1. Build xong → Click vào build
2. Download file `.ipa`
3. File size: ~50-60 MB

---

## 📱 Cài IPA Lên iPhone

### Cách 1: AltStore (Windows/Mac - Miễn Phí)

**Download:** https://altstore.io

**Cài đặt:**
1. Cài AltStore lên máy tính
2. Cài AltStore app lên iPhone
3. Drag & drop file `.ipa` vào AltStore
4. IPA tự động cài lên iPhone

**Lưu ý:** Phải refresh mỗi 7 ngày (free Apple ID limit)

### Cách 2: Diawi (Upload Link - Dễ Nhất)

**Website:** https://www.diawi.com

**Cách dùng:**
1. Upload file `.ipa` lên Diawi
2. Nhận được link (VD: `https://i.diawi.com/xxxxx`)
3. Mở link trên iPhone → Cài đặt
4. Settings → General → VPN & Device Management → Trust

**Lưu ý:** Link hết hạn sau 24h

### Cách 3: TestFlight (Chuyên Nghiệp - Cần $99/năm)

**Nếu có Apple Developer Account:**

1. Codemagic → Settings → **App Store Connect**
2. Add API Key
3. Enable **"Publish to TestFlight"**
4. Build xong tự động upload

---

## 🔄 Tự Động Build

### Tạo codemagic.yaml

Tạo file này trong project root:

```yaml
# codemagic.yaml
workflows:
  ios-release:
    name: iOS Release Build
    max_build_duration: 60
    instance_type: mac_mini_m1

    environment:
      flutter: stable
      xcode: latest
      cocoapods: default

    triggering:
      events:
        - push
      branch_patterns:
        - pattern: 'main'
          include: true

    scripts:
      - name: Install dependencies
        script: |
          flutter pub get
          cd ios && pod install

      - name: Build iOS
        script: |
          flutter build ipa --release \
            --export-options-plist=$HOME/export_options.plist

    artifacts:
      - build/ios/ipa/*.ipa

    publishing:
      email:
        recipients:
          - your-email@example.com
        notify:
          success: true
          failure: true
```

**Push file này lên git:**
```bash
git add codemagic.yaml
git commit -m "Add Codemagic auto-build config"
git push
```

→ Mỗi lần push code, Codemagic tự động build IPA!

---

## 💰 Pricing

### Free Tier
- ✅ 500 build minutes/tháng
- ✅ 1 concurrent build
- ✅ Đủ cho personal projects

### Pro ($95/tháng - nếu cần)
- ✅ 1,000 build minutes
- ✅ 3 concurrent builds
- ✅ Priority support

---

## 🐛 Troubleshooting

### Build Failed: "Podfile not found"

**Solution:** Thêm vào codemagic.yaml:
```yaml
scripts:
  - name: Generate Podfile
    script: |
      flutter pub get
      cd ios && flutter build ios --release --no-codesign
```

### Build Failed: "Code signing error"

**Solution:**
1. Check Apple ID đã login đúng
2. Verify Bundle Identifier unique
3. Thử switch sang Automatic signing

### IPA không cài được

**Lỗi:** "Unable to install"
- Check device UDID có trong provisioning profile
- Verify certificate chưa expire
- Thử resign IPA với AltStore

---

## 📊 Ước Tính Thời Gian

| Task | Time |
|------|------|
| Setup Codemagic | 10 phút |
| First build | 10-15 phút |
| Download IPA | 1 phút |
| Install via Diawi | 2 phút |
| **Total** | **~25-30 phút** |

---

## 🎯 Workflow Recommended

**Cho Development (Test Nhanh):**
```
Code trên Windows → Push git → Codemagic build
→ Download IPA → Diawi upload → iPhone install
```

**Cho Production (Distribute):**
```
Code → Push git → Codemagic build
→ Auto upload TestFlight → Testers install
```

---

## 🔗 Useful Links

- Codemagic: https://codemagic.io
- AltStore: https://altstore.io
- Diawi: https://www.diawi.com
- Codemagic Docs: https://docs.codemagic.io/flutter-code-signing/ios-code-signing/
- TestFlight: https://developer.apple.com/testflight/

---

## ✅ Checklist

- [ ] Push code lên Git
- [ ] Đăng ký Codemagic (free)
- [ ] Add project
- [ ] Configure iOS signing (Automatic recommended)
- [ ] Start build
- [ ] Download IPA
- [ ] Upload Diawi hoặc cài qua AltStore
- [ ] Test trên iPhone
- [ ] Verify notifications hoạt động

---

**Tổng chi phí:** $0 (hoàn toàn miễn phí với Free tier!)

**Thời gian setup:** ~10 phút

**Mỗi lần build:** ~10-15 phút

Good luck! 🚀
