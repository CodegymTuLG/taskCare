# 🚀 Các Bước Tiếp Theo - Build iOS trên Codemagic

## ✅ Đã Hoàn Thành

- ✅ **Phase 1-5**: Tất cả 5 tính năng đã implement xong
- ✅ **Code committed**: Đã commit với message đầy đủ
- ✅ **Documentation**: Tất cả tài liệu đã được tạo
- ✅ **Codemagic config**: File `codemagic.yaml` đã sẵn sàng
- ✅ **Android APK**: Đang build... (chờ hoàn thành)

---

## 📤 Bước 1: Push Code lên GitHub (2 phút)

### Option A: Nếu Repository Đã Có Sẵn

```bash
cd "e:/Study/flutter/flutter_application_1"
git push origin main
```

**Nếu gặp lỗi "Permission denied":**
```bash
# Cần authenticate với GitHub
# Cách 1: HTTPS (đơn giản)
git remote set-url origin https://github.com/YOUR_USERNAME/taskCare.git
git push origin main
# GitHub sẽ hỏi username + personal access token

# Cách 2: SSH (nếu đã setup SSH key)
git remote set-url origin git@github.com:YOUR_USERNAME/taskCare.git
git push origin main
```

### Option B: Tạo Repository Mới Trên GitHub

1. Mở browser: https://github.com/new
2. Repository name: `taskCare` (hoặc tên khác)
3. Visibility: **Public** (để dùng free tier của Codemagic)
4. ❌ **KHÔNG** tick "Initialize with README" (vì code đã có)
5. Click "Create repository"

6. Chạy commands GitHub cung cấp:
```bash
cd "e:/Study/flutter/flutter_application_1"
git remote set-url origin https://github.com/YOUR_USERNAME/taskCare.git
git push -u origin main
```

**Done!** Code đã lên GitHub ✅

---

## 🎯 Bước 2: Setup Codemagic (10 phút)

### 2.1. Đăng Ký Codemagic

1. Mở: https://codemagic.io
2. Click **"Sign up for free"**
3. Chọn **"Sign in with GitHub"**
4. Authorize Codemagic → Allow access
5. Verify email (check inbox)

### 2.2. Add Application

1. Codemagic dashboard → Click **"Add application"**
2. Select Git provider: **GitHub**
3. Tìm và chọn repository: **taskCare** (hoặc tên bạn đặt)
4. Click **"Next"**
5. Select project type: **Flutter App**
6. Click **"Finish: Add application"**

### 2.3. Configure iOS Code Signing

**👉 RECOMMENDED: Automatic Signing (Đơn giản nhất)**

1. Click vào app vừa tạo: **taskCare**
2. Tab **"Settings"** (góc phải)
3. Scroll xuống section **"iOS code signing"**
4. Click **"Automatic"**
5. Click **"Add Apple ID credentials"**

6. Nhập thông tin:
   ```
   Apple ID: your-icloud@email.com
   Password: your-password
   ```

   **⚠️ Nếu có 2FA (Two-Factor Authentication):**
   - Mở: https://appleid.apple.com
   - Sign in → Security
   - App-Specific Passwords → Generate
   - Dùng password này thay vì password thật

7. Click **"Verify"**
8. Bundle ID: `com.yourname.todoapp` (phải unique!)
   - Ví dụ: `com.nguyen.taskcare`
   - Không dùng chữ hoa, không dùng space
9. Click **"Save"**

**Signing configured!** ✅

### 2.4. Configure Workflow (codemagic.yaml)

File `codemagic.yaml` đã sẵn sáng! Nhưng cần sửa 2 chỗ:

1. Mở file: `codemagic.yaml`
2. Tìm dòng 12:
   ```yaml
   BUNDLE_ID: "com.yourname.todoapp"
   ```
   Đổi thành Bundle ID bạn dùng ở bước 2.3:
   ```yaml
   BUNDLE_ID: "com.nguyen.taskcare"
   ```

3. Tìm dòng 33 và 56 (2 chỗ):
   ```yaml
   recipients:
     - your-email@example.com
   ```
   Đổi thành email thật:
   ```yaml
   recipients:
     - your-real-email@gmail.com
   ```

4. Lưu file và commit:
   ```bash
   git add codemagic.yaml
   git commit -m "Update Codemagic config with real values"
   git push origin main
   ```

---

## 🏗️ Bước 3: Build iOS IPA! (15 phút)

### 3.1. Start Build

1. Quay lại Codemagic dashboard
2. Click vào app: **taskCare**
3. Tab **"Builds"**
4. Click **"Start new build"**

5. Settings:
   ```
   Workflow: ios-release ✅
   Branch: main ✅
   ```

6. Click **"Start new build"**

### 3.2. Monitor Build Progress

```
Build sẽ mất ~12-15 phút:

⏳ 1. Cloning repository...           (30 sec)
⏳ 2. Installing Flutter...           (1 min)
⏳ 3. Flutter pub get...              (1 min)
⏳ 4. CocoaPods install...            (2 min)
⏳ 5. Building iOS app...             (8 min)
⏳ 6. Code signing...                 (1 min)
⏳ 7. Creating .ipa...                (1 min)
✅ 8. Build successful!
```

**Nếu build failed:**
- Click vào build log → xem lỗi
- Thường gặp:
  - **"Code signing error"**: Kiểm tra lại Apple ID credentials
  - **"Bundle ID already exists"**: Đổi Bundle ID khác
  - **"Pod install failed"**: Thêm script `pod repo update`

### 3.3. Download IPA

1. Build finished → Click vào build vừa xong
2. Scroll xuống section **"Artifacts"**
3. Click **"Download"** next to file `.ipa`
4. Save: `flutter_application_1.ipa` (~50-60 MB)

**IPA downloaded!** ✅

---

## 📱 Bước 4: Cài IPA lên iPhone (5 phút)

### Method 1: Diawi (Dễ Nhất - FREE)

1. Mở: https://www.diawi.com
2. Drag & drop file `.ipa` vào trang
3. Settings:
   ```
   ✅ Find by UDID (optional)
   ✅ Wall of Apps (optional)
   Password: (để trống)
   ```
4. Click **"Send"**
5. Đợi upload (~2 phút)
6. Copy link: `https://i.diawi.com/xxxxx`

**Trên iPhone:**
7. Mở Safari → paste link
8. Click **"Install"**
9. Settings → General → **VPN & Device Management**
10. Click vào tên developer → **Trust**
11. Quay lại Home screen → Mở app!

**⚠️ Lưu ý:**
- Link Diawi chỉ valid **24 giờ**
- Sau 7 ngày cần resign (free Apple ID limit)
- Để test lâu dài → dùng AltStore hoặc TestFlight

### Method 2: AltStore (Stable - FREE)

**Tốt hơn cho testing lâu dài:**

1. Download AltStore:
   - Windows: https://altstore.io
   - Mac: https://altstore.io

2. Install AltServer lên máy tính
3. Install AltStore app lên iPhone (qua iTunes/Finder)
4. Mở AltStore app trên iPhone
5. My Apps → **+** → Browse
6. Chọn file `.ipa`
7. Auto install!

**Refresh:** Mỗi 7 ngày mở AltStore → Refresh (1 tap)

### Method 3: TestFlight (Professional)

**Cần Apple Developer Account ($99/năm):**

1. Build với Distribution certificate
2. Upload lên App Store Connect
3. Invite testers qua TestFlight
4. Testers download từ TestFlight app

**Ưu điểm:**
- Không expire
- Không cần refresh
- Professional testing platform

---

## 🔄 Bước 5: Auto-Build (Optional - 2 phút)

### Enable Auto-Build on Git Push

1. Codemagic → App → **Settings**
2. Section **"Build triggers"**
3. ✅ Tick **"Trigger on push"**
4. Branch: `main`
5. Workflow: `ios-release`
6. Click **"Save"**

**Từ giờ:**
```bash
# Thay đổi code
git add .
git commit -m "Update features"
git push

# Codemagic tự động build! 🎉
# Nhận email khi build xong
```

---

## 📊 Tổng Kết

### ⏱️ Time Breakdown

| Bước | Thời Gian | Status |
|------|-----------|--------|
| Push GitHub | 2 phút | Sẵn sàng |
| Codemagic signup | 2 phút | Easy |
| Add app | 2 phút | Easy |
| iOS signing | 3 phút | Medium |
| Build | 15 phút | Automated |
| Install | 5 phút | Easy |
| **Total** | **29 phút** | **Done!** |

### 💰 Cost

```
✅ Codemagic: $0 (500 min/month free)
✅ Diawi: $0 (free)
✅ Apple ID: $0 (free)
✅ GitHub: $0 (public repo)
──────────────────────────
Total: $0
```

### 🎯 Free Tier Limits

- **Codemagic**: 500 phút/tháng
  - 1 build iOS = ~12-15 phút
  - **Có thể build ~33 lần/tháng**

- **Diawi**: Unlimited uploads
  - Link expire sau 24h

- **Apple Free Account**:
  - App expire sau 7 ngày
  - Tối đa 3 apps cùng lúc

---

## 🐛 Troubleshooting

### Build Failed: "Code signing error"

**Fix:**
1. Settings → iOS code signing
2. Re-enter Apple ID
3. Verify Bundle ID is unique (thử đổi)
4. Rebuild

### Build Failed: "Pod install error"

**Fix:** Thêm pre-build script trong workflow:
```yaml
- name: Update CocoaPods
  script: |
    cd ios
    pod repo update
    pod install
```

### IPA Không Cài Được

**Fix:**
1. Check: Device UDID có trong profile?
2. Certificate chưa expire?
3. Thử resign với AltStore
4. Hoặc dùng Diawi

### Diawi Link Expire

**Solution:**
- Link chỉ valid 24h
- Rebuild và upload mới
- Hoặc dùng AltStore (permanent)

### Notification Không Hoạt Động

**Check:**
1. Phải test trên device thật (không phải simulator)
2. iPhone Settings → Notifications → App → Allow
3. App có permission request notifications
4. Due date phải trong tương lai

---

## ✅ Final Checklist

Trước khi build:
- [ ] Code pushed lên GitHub
- [ ] Codemagic account created
- [ ] App added to Codemagic
- [ ] iOS signing configured (Automatic)
- [ ] Bundle ID unique
- [ ] Email updated trong codemagic.yaml

Sau khi build:
- [ ] IPA downloaded
- [ ] Installed trên iPhone
- [ ] App mở được
- [ ] Test tất cả features:
  - [ ] Data persistence (restart app)
  - [ ] Notifications (đặt due date)
  - [ ] Search (tìm todos)
  - [ ] Categories (lọc theo category)
  - [ ] Nested subtasks (3 levels)

---

## 🎉 Success!

Khi hoàn thành, bạn sẽ có:

✅ App chạy trên iPhone thực tế
✅ Build iOS mà không cần Mac
✅ Auto-build mỗi khi push code
✅ Free testing với Diawi
✅ 5 features nâng cao hoạt động
✅ Multi-language support
✅ Production-ready app

**Total cost: $0**
**Total time: ~30 phút**

---

## 📞 Need Help?

- **Codemagic Docs**: https://docs.codemagic.io/yaml-quick-start/building-a-flutter-app/
- **Codemagic Slack**: https://codemagic.io/slack
- **Flutter Discord**: https://discord.gg/flutter
- **Apple Developer**: https://developer.apple.com

---

## 📚 Chi Tiết Hơn?

Xem các file documentation:

- [SETUP_CODEMAGIC.md](SETUP_CODEMAGIC.md) - Step-by-step chi tiết
- [CLOUD_BUILD_OPTIONS.md](CLOUD_BUILD_OPTIONS.md) - So sánh services
- [CODEMAGIC_BUILD.md](CODEMAGIC_BUILD.md) - Full tutorial

---

**Ready to build?** Bắt đầu từ Bước 1! 🚀
