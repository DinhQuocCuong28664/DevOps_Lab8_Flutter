# 🔦 Guiding Light — Lab 8: CI/CD with GitHub Actions

## 📌 Mục tiêu

Xây dựng pipeline CI/CD tự động cho ứng dụng Flutter sử dụng **GitHub Actions**, hỗ trợ build trên **3 nền tảng**: Android (APK), Web, và Windows.

---

## 📂 Cấu trúc Project

```
flutter-app/
├── lib/
│   └── main.dart              # File chính — chứa biến greetingMessage
├── test/
│   └── widget_test.dart       # Widget test — kiểm tra UI
├── pubspec.yaml               # Không sử dụng package bên thứ 3
├── analysis_options.yaml      # Cấu hình lint
└── guildinglight.md           # File hướng dẫn này
```

---

## 🔑 Biến quan trọng

Trong file `lib/main.dart`, dòng **7**:

```dart
const String greetingMessage = 'Welcome to Lab 8 CI/CD!';
```

> **Đây là biến bạn sẽ thay đổi để giả lập việc cập nhật UI** khi test luồng CI/CD.
> Sau khi thay đổi → commit → push, GitHub Actions sẽ tự động chạy build & test.

---

## 🚀 Hướng dẫn sử dụng

### Bước 1: Tạo Flutter project

```bash
flutter create flutter_app
```

### Bước 2: Copy file code

Copy nội dung `lib/main.dart` và `test/widget_test.dart` từ project này vào project vừa tạo, ghi đè lên file cũ.

### Bước 3: Chạy test

```bash
flutter test
```

### Bước 4: Build trên từng nền tảng

```bash
# Android
flutter build apk --release

# Web
flutter build web

# Windows
flutter build windows
```

---

## 🔄 Luồng CI/CD (GitHub Actions)

### Workflow gợi ý

Tạo file `.github/workflows/ci.yml` với các job:

1. **Test** — `flutter test`
2. **Build Android** — `flutter build apk --release`
3. **Build Web** — `flutter build web`
4. **Build Windows** — `flutter build windows` (chạy trên `windows-latest`)

### Ví dụ workflow cơ bản

```yaml
name: Flutter CI/CD

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.29.3'
          channel: 'stable'
      - run: flutter pub get
      - run: flutter test

  build-android:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-java@v4
        with:
          distribution: 'zulu'
          java-version: '17'
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.29.3'
          channel: 'stable'
      - run: flutter pub get
      - run: flutter build apk --release
      - uses: actions/upload-artifact@v4
        with:
          name: android-apk
          path: build/app/outputs/flutter-apk/app-release.apk

  build-web:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.29.3'
          channel: 'stable'
      - run: flutter pub get
      - run: flutter build web
      - uses: actions/upload-artifact@v4
        with:
          name: web-build
          path: build/web

  build-windows:
    needs: test
    runs-on: windows-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.29.3'
          channel: 'stable'
      - run: flutter pub get
      - run: flutter build windows
      - uses: actions/upload-artifact@v4
        with:
          name: windows-build
          path: build/windows/x64/runner/Release
```

---

## 🧪 Kịch bản test CI/CD

1. **Push lần đầu** → Pipeline chạy test + build 3 nền tảng ✅
2. **Sửa `greetingMessage`** → Commit & push → Pipeline chạy lại, test vẫn pass (vì test dùng biến `greetingMessage`) ✅
3. **Tạo Pull Request** → Pipeline chạy trên PR ✅
4. **Sửa test để fail** → Push → Pipeline báo đỏ ❌ (kiểm tra cơ chế fail)

---

## 📋 Lưu ý

- **Không dùng package bên thứ 3** → `flutter pub get` chạy nhanh, không lỗi tương thích.
- **Widget test dùng biến `greetingMessage`** → Khi bạn đổi string, test vẫn pass tự động (không cần sửa test).
- **Build Windows** cần runner `windows-latest` trên GitHub Actions.
- **Build Android** cần Java 17 (dùng `actions/setup-java`).

---

_Chúc bạn hoàn thành bài Lab thành công!_ 🎉
