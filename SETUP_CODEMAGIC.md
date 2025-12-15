# 🚀 Setup Codemagic - Step by Step (10 phút)

## ✅ Checklist Trước Khi Bắt Đầu

- [ ] Code đã sẵn sàng (done ✅)
- [ ] Có tài khoản GitHub/GitLab/Bitbucket
- [ ] Có Apple ID (miễn phí - dùng iCloud email)

---

## 📝 Step 1: Tạo Git Repository (3 phút)

### Option A: GitHub (Recommended)

```bash
# Mở terminal tại: e:\Study\flutter\flutter_application_1

# 1. Initialize git (nếu chưa có)
git init

# 2. Add all files
git add .

# 3. Commit
git commit -m "Todo App - 5 features implemented"

# 4. Tạo repo trên GitHub
# Vào: https://github.com/new
# Repository name: flutter-todo-app
# Visibility: Public (để free unlimited builds)
# ✅ Create repository

# 5. Link repo
git remote add origin https://github.com/YOUR_USERNAME/flutter-todo-app.git
git branch -M main
git push -u origin main
```

**Done!** Code đã lên GitHub ✅

---

## 🎯 Step 2: Đăng Ký Codemagic (2 phút)

### 2.1. Truy Cập Codemagic

```
1. Mở browser: https://codemagic.io
2. Click "Sign up for free"
3. Chọn "Sign in with GitHub" (hoặc GitLab/Bitbucket)
4. Authorize Codemagic → Allow access
```

### 2.2. Verify Account

- Check email
- Click verify link
- Done!

---

## 🔗 Step 3: Add Application (2 phút)

### 3.1. Link Repository

```
1. Codemagic dashboard → "Add application"
2. Select Git provider: GitHub
3. Chọn repository: flutter-todo-app
4. Click "Next"
```

### 3.2. Select Project Type

```
1. Select: "Flutter App"
2. Click "Finish: Add application"
```

**App đã được add!** ✅

---

## 🔐 Step 4: Configure iOS Signing (3 phút)

### 4.1. Access Signing Settings

```
1. Click vào app: flutter-todo-app
2. Tab "Settings"
3. Section "iOS code signing"
```

### 4.2. Choose Signing Method

**👉 RECOMMENDED: Automatic Signing (Đơn giản nhất)**

```
1. Click "Automatic"
2. Chọn "Add Apple ID credentials"
3. Nhập:
   - Apple ID: your-icloud@email.com
   - Password: your-password

   (Nếu có 2FA, dùng app-specific password:
    → appleid.apple.com → Sign in →
    Security → App-Specific Passwords → Generate)

4. Click "Verify"
5. Bundle ID: com.yourname.todoapp (unique!)
6. Save
```

**Signing configured!** ✅

---

## ▶️ Step 5: First Build! (15 phút build time)

### 5.1. Start Build

```
1. Workflow editor → "Start new build"
2. Settings:
   - Branch: main
   - Build for: iOS ✅
   - Mode: Release ✅

3. Click "Start new build"
```

### 5.2. Monitor Build

```
Build progress:
1. ⏳ Cloning repository... (30 sec)
2. ⏳ Installing dependencies... (2 min)
3. ⏳ Building iOS app... (8 min)
4. ⏳ Code signing... (1 min)
5. ⏳ Creating .ipa... (2 min)
6. ✅ Build successful! (Total: ~12-15 min)
```

### 5.3. Download IPA

```
1. Build finished → Click on build
2. Artifacts section
3. Click "Download" next to .ipa file
4. Save: flutter_application_1.ipa (~50-60 MB)
```

**IPA downloaded!** ✅

---

## 📱 Step 6: Install trên iPhone (5 phút)

### Method 1: Diawi (Easiest - No Install)

```
1. Mở: https://www.diawi.com
2. Drag & drop file .ipa
3. Click "Send"
4. Đợi upload (~2 phút)
5. Copy link: https://i.diawi.com/xxxxx
6. Mở link trên iPhone
7. Click "Install"
8. Settings → General → VPN & Device Management → Trust
9. Open app!
```

### Method 2: AltStore (Best for Testing)

```
1. Download AltStore:
   Windows: https://altstore.io
   Mac: https://altstore.io

2. Install AltServer lên máy tính
3. Install AltStore app lên iPhone (qua iTunes/Finder)
4. Mở AltStore app trên iPhone
5. My Apps → + → Browse
6. Chọn file .ipa
7. Auto install!

Refresh: Mỗi 7 ngày (free Apple ID limit)
```

---

## 🔄 Step 7: Auto-Build (Optional - 2 phút)

### Enable Auto-Build on Push

```
1. Codemagic → Settings
2. Build triggers
3. ✅ Enable "Trigger on push"
4. Branch: main
5. Save
```

**Từ giờ:** Push code → Auto build IPA! 🎉

---

## 📊 Summary

### ⏱️ Time Breakdown

| Step | Time | Status |
|------|------|--------|
| 1. Git setup | 3 min | ✅ Ready |
| 2. Codemagic signup | 2 min | Easy |
| 3. Add app | 2 min | Easy |
| 4. iOS signing | 3 min | Medium |
| 5. Build | 15 min | Automated |
| 6. Install | 5 min | Easy |
| **Total** | **30 min** | **Done!** |

### 💰 Cost

```
Codemagic: $0 (500 min/month free)
Diawi: $0 (free)
Apple ID: $0 (free)
Total: $0 ✅
```

---

## 🎯 Next Builds

```bash
# 1. Make changes
# 2. Commit
git add .
git commit -m "Update features"
git push

# 3. Codemagic auto-builds (if enabled)
# Or: Manual trigger từ dashboard

# 4. Download new IPA
# 5. Install/Update
```

**Each build: ~15 min**

---

## 🐛 Troubleshooting

### Build Failed: "Code signing error"

**Fix:**
```
1. Settings → iOS code signing
2. Re-enter Apple ID
3. Verify Bundle ID is unique
4. Try again
```

### Build Failed: "Pod install error"

**Fix:** Add pre-build script:
```bash
cd ios && pod repo update && pod install
```

### IPA không cài được

**Fix:**
```
1. Check: Device UDID có trong profile?
2. Certificate chưa expire?
3. Thử resign với AltStore
```

### Diawi link expire

**Solution:**
- Link chỉ valid 24h
- Rebuild và upload mới
- Hoặc dùng AltStore (permanent)

---

## ✅ Final Checklist

- [ ] Code pushed lên Git
- [ ] Codemagic account created
- [ ] App added
- [ ] iOS signing configured
- [ ] First build successful
- [ ] IPA downloaded
- [ ] Installed trên iPhone
- [ ] App chạy OK
- [ ] Notifications work
- [ ] All features tested

---

## 🎉 Success!

Bây giờ bạn có thể:
- ✅ Build iOS mà không cần Mac
- ✅ Test app trên iPhone thực tế
- ✅ Distribute cho testers (via Diawi)
- ✅ Auto-build on git push

**Enjoy your app!** 🚀

---

## 📞 Need Help?

- Codemagic Docs: https://docs.codemagic.io
- Codemagic Slack: https://codemagic.io/slack
- Flutter Discord: https://discord.gg/flutter

---

**Happy Building!** 🎊
