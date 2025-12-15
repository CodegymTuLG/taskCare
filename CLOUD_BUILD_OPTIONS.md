# ☁️ Cloud Build Services - So Sánh Chi Tiết

## 🎯 Tổng Quan

Tất cả đều cho phép build iOS mà **KHÔNG CẦN MAC**!

---

## 1. 🔥 Codemagic (Recommended)

**Website:** https://codemagic.io

### ✅ Ưu điểm
- 500 phút build/tháng FREE
- Hỗ trợ Flutter native
- UI đơn giản, dễ dùng
- Auto-upload TestFlight
- Build trong 10-15 phút

### ❌ Nhược điểm
- Free tier giới hạn 500 phút/tháng

### 💰 Giá
- **Free:** 500 phút/tháng
- **Pro:** $95/tháng (1000 phút)

### 📝 Setup
```bash
1. Push code lên Git
2. Đăng ký Codemagic
3. Connect repo
4. Configure signing (Automatic)
5. Build!
```

**Thời gian:** ~10 phút setup

---

## 2. 🌐 GitHub Actions (Free Unlimited)

**Website:** https://github.com/features/actions

### ✅ Ưu điểm
- **MIỄN PHÍ** cho public repos
- 2000 phút/tháng cho private repos (FREE)
- Tích hợp sẵn với GitHub
- Tùy biến cao với YAML

### ❌ Nhược điểm
- Phức tạp hơn Codemagic
- Cần tự config code signing
- Build chậm hơn (20-30 phút)

### 💰 Giá
- **Public repos:** MIỄN PHÍ không giới hạn
- **Private repos:** 2000 phút/tháng FREE

### 📝 Setup

Tạo file `.github/workflows/ios-build.yml`:

```yaml
name: iOS Build

on:
  push:
    branches: [ main ]

jobs:
  build:
    runs-on: macos-latest

    steps:
    - uses: actions/checkout@v3

    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.16.0'

    - name: Install dependencies
      run: flutter pub get

    - name: Build iOS
      run: flutter build ios --release --no-codesign

    - name: Upload IPA
      uses: actions/upload-artifact@v3
      with:
        name: ios-build
        path: build/ios/iphoneos/*.app
```

**Thời gian:** ~30 phút setup (cần hiểu YAML)

---

## 3. 🔷 Bitrise

**Website:** https://www.bitrise.io

### ✅ Ưu điểm
- 200 phút build/tháng FREE
- UI drag-and-drop
- Nhiều integrations
- Support tốt

### ❌ Nhược điểm
- Free tier ít hơn Codemagic
- UI hơi phức tạp

### 💰 Giá
- **Free:** 200 phút/tháng
- **Hobby:** $45/tháng (400 phút)

### 📝 Setup
1. Đăng ký Bitrise
2. Add app từ Git
3. Chọn workflow "iOS"
4. Configure signing
5. Run build

**Thời gian:** ~15 phút setup

---

## 4. 🚀 Appcircle

**Website:** https://appcircle.io

### ✅ Ưu điểm
- 25 builds/tháng FREE
- Hỗ trợ Flutter tốt
- Distribution platform tích hợp
- Dễ dùng

### ❌ Nhược điểm
- Giới hạn theo số builds, không phải minutes
- Free tier khá ít

### 💰 Giá
- **Free:** 25 builds/tháng
- **Starter:** $99/tháng (100 builds)

### 📝 Setup
Tương tự Codemagic, drag & drop UI

---

## 5. 💎 CircleCI

**Website:** https://circleci.com

### ✅ Ưu điểm
- 2500 credits/tháng FREE
- macOS builds available
- Powerful caching
- Good documentation

### ❌ Nhược điểm
- Credits system phức tạp
- iOS build tốn nhiều credits (30-50 credits/build)
- Cần config YAML

### 💰 Giá
- **Free:** 2500 credits/tháng (~50-80 iOS builds)
- **Performance:** $15/tháng

---

## 📊 So Sánh Nhanh

| Service | Free Tier | Ease of Use | Build Time | Best For |
|---------|-----------|-------------|------------|----------|
| **Codemagic** | 500 min | ⭐⭐⭐⭐⭐ | 10-15 min | Beginners |
| **GitHub Actions** | Unlimited* | ⭐⭐⭐ | 20-30 min | Public repos |
| **Bitrise** | 200 min | ⭐⭐⭐⭐ | 15-20 min | Teams |
| **Appcircle** | 25 builds | ⭐⭐⭐⭐ | 10-15 min | Distribution |
| **CircleCI** | 2500 credits | ⭐⭐⭐ | 15-20 min | Advanced users |

*Public repos only

---

## 🎯 Recommendation

### Cho Bạn (Personal Project):

**Option 1: Codemagic** ⭐⭐⭐⭐⭐
- Setup nhanh nhất (10 phút)
- Free tier tốt (500 phút)
- Build nhanh
- Dễ dùng nhất

**Option 2: GitHub Actions**
- Nếu code đã có trên GitHub public repo
- Unlimited builds
- Tốn thời gian setup hơn

---

## 🔄 Workflow Đề Xuất

### Setup One-Time (Codemagic)

```bash
# 1. Push lên Git (nếu chưa có)
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/yourusername/todo-app.git
git push -u origin main

# 2. Đăng ký Codemagic
# → codemagic.io → Sign up with GitHub

# 3. Add project
# → Add application → Select repo → Flutter App

# 4. Configure
# → iOS code signing → Automatic

# 5. Build!
# → Start new build → Release → ✅
```

### Build Lần Sau (Tự Động)

```bash
# Chỉ cần push code
git add .
git commit -m "Update feature"
git push

# Codemagic tự động build! (nếu setup auto-trigger)
```

---

## 💡 Pro Tips

### 1. Tiết Kiệm Build Minutes

**Chỉ build khi cần:**
```yaml
# codemagic.yaml
triggering:
  events:
    - tag  # Chỉ build khi tạo tag, không phải mỗi commit
```

**Tag release:**
```bash
git tag v1.0.0
git push --tags
# Chỉ build khi release
```

### 2. Cache Dependencies

```yaml
cache:
  cache_paths:
    - $HOME/.pub-cache
    - ios/Pods
# Build nhanh hơn 2-3 lần
```

### 3. Parallel Builds

Nếu có nhiều branches:
```yaml
workflows:
  - ios-dev      # Branch dev
  - ios-staging  # Branch staging
  - ios-prod     # Branch main
```

---

## 📱 Install IPA Methods

### 1. Diawi (Dễ Nhất - FREE)
```
Upload IPA → Get link → Open trên iPhone → Install
Link expire: 24h
```

### 2. AltStore (Stable - FREE)
```
Install app lên máy tính + iPhone
Drag & drop IPA → Auto install
Cần refresh mỗi 7 ngày
```

### 3. TestFlight (Pro - Cần $99/năm)
```
Codemagic auto-upload → TestFlight
Testers install qua App Store
No expiry, no refresh
```

### 4. Firebase App Distribution (Good - FREE)
```
Codemagic → Firebase upload
Testers nhận email → Install
30 days expiry
```

---

## 🚀 Quick Decision Tree

```
Bạn có GitHub public repo?
│
├─ YES → GitHub Actions (unlimited free)
│
└─ NO → Bạn muốn gì?
    │
    ├─ Đơn giản, nhanh → Codemagic ⭐
    │
    ├─ Nhiều features → Bitrise
    │
    └─ Advanced control → CircleCI
```

---

## 📞 Recommended Setup

**Cho Project Này:**

1. **Push lên GitHub** (public repo - free)
2. **Setup Codemagic** (500 phút/tháng)
3. **Enable auto-build** (mỗi lần push main branch)
4. **Distribute via Diawi** (test) hoặc TestFlight (production)

**Total cost:** $0

**Build time:** 10-15 phút/build

**Setup time:** 10 phút one-time

---

## ✅ Action Items

- [ ] Tạo GitHub repo (public)
- [ ] Push code lên
- [ ] Đăng ký Codemagic (free)
- [ ] Link repo với Codemagic
- [ ] Configure iOS signing (Automatic)
- [ ] Trigger first build
- [ ] Download IPA
- [ ] Upload Diawi
- [ ] Test trên iPhone

**Estimated time:** 30 phút total

---

**Need help?** Check [CODEMAGIC_BUILD.md](CODEMAGIC_BUILD.md) for detailed step-by-step!
