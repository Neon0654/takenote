# takenote — Ứng dụng quản lý ghi chú (Notes) 📓

Ứng dụng di động/desktop/ứng dụng web viết bằng Flutter để quản lý ghi chú cá nhân, lưu trữ cục bộ bằng SQLite. Ứng dụng hỗ trợ ghi chú có nhãn (tags), thư mục, đính kèm tệp, nhắc nhở (notifications), tìm kiếm và thao tác hàng loạt.

> **Tổng quan nhanh:** Ứng dụng dùng SQLite để lưu dữ liệu, có hệ thống nhãn, thư mục, nhắc nhở địa phương. Xem danh sách tính năng chi tiết tại `FEATURES.md` (có tổng số tính năng đã triển khai).

---

## 🚀 Chức năng nổi bật
- Tạo, chỉnh sửa và xóa ghi chú (xóa mềm vào thùng rác).
- Ghim / bỏ ghim ghi chú (ưu tiên hiển thị).
- Nhãn (tag): tạo, đổi tên, xóa; gắn/bỏ nhãn cho từng ghi chú hoặc theo nhóm.
- Thư mục: tạo/đổi tên/xóa thư mục, xem ghi chú theo thư mục, di chuyển ghi chú giữa các thư mục.
- Đính kèm tệp (File picker) và quản lý tệp kèm theo ghi chú; xóa tệp thực sự khi xóa đính kèm.
- Nhắc nhở & thông báo cục bộ (lên lịch thông báo theo múi giờ).
- Tìm kiếm theo từ khóa kết hợp bộ lọc thời gian (Hôm qua, 7 ngày, 30 ngày).
- Chọn nhiều & thao tác hàng loạt: gắn nhãn, di chuyển, xóa, chia sẻ.

---

## 🛠 Cài đặt & chạy ứng dụng
### Yêu cầu
- Flutter SDK (khuyến nghị bản stable), Dart
- Android SDK (để chạy trên Android) / Xcode (macOS để chạy iOS) / Visual Studio (Windows desktop)

### Thiết lập nhanh
1. Clone repo và cài dependencies:

```bash
git clone <repo-url>
cd takenote
flutter pub get
```

2. Chạy kiểm tra tĩnh:

```bash
flutter analyze
```

3. Chạy ứng dụng:

- Android / iOS:

```bash
flutter run
```

- Web (Chrome):

```bash
flutter run -d chrome
```

- Desktop (Windows/macOS/Linux):

```bash
flutter run -d windows
# hoặc -d macos, -d linux
```

4. Build release (ví dụ Android APK):

```bash
flutter build apk --release
```

---

## ✅ Test
- Chạy tất cả test:

```bash
flutter test
```

- Lưu ý: tests về DB sử dụng `sqflite_common_ffi` để chạy SQLite trong môi trường test.

---

## 🗄 Cấu trúc dự án (tổng quan)
- `lib/main.dart` — khởi tạo app, đăng ký services (ví dụ: notification).
- `lib/presentation/` — phần UI (pages, widgets) và state management (cubits).
- `lib/domain/` — entities, interfaces (use cases, repositories).
- `lib/data/` — datasource, models, repository implementations, database.
- `lib/services/` — dịch vụ như notification setup.
- `test/` — unit & widget tests.

---

## 🔧 Ghi chú kỹ thuật & vận hành
- **Database & migration:** SQLite schema và migration được quản lý trong code (DB version hiện tại trong code). Khi nâng cấp schema, app tự chạy migration.
- **Notifications:** Sử dụng `flutter_local_notifications` + timezone; app khởi tạo service và yêu cầu quyền khi khởi động.
- **Attachments:** Tệp đính kèm lưu đường dẫn file; khi xóa đính kèm, tệp trên đĩa cũng bị xóa nếu tồn tại.
- **Edge cases:** Không lưu ghi chú rỗng; không tạo/đổi tên nhãn rỗng; không đặt nhắc trong quá khứ.

---

## 📣 Cách đóng góp
- Fork → tạo branch feature/bugfix → commit → tạo Pull Request.
- Trước PR: chạy `flutter test` và `flutter analyze`.
- Viết test cho thay đổi quan trọng (unit hoặc widget).

---

## ⚠️ Lưu ý nền tảng & quyền
- Android: đảm bảo khai báo quyền thông báo (nếu cần) và kiểm tra cài đặt notification channel.
- iOS: cần cấu hình notification capability và các mô tả quyền trong Info.plist nếu triển khai notification.
- Desktop: cần toolchain phù hợp (Visual Studio cho Windows, Xcode cho macOS).

---

## 📚 Tham khảo
- Xem chi tiết tính năng: `FEATURES.md` (bằng tiếng Việt)
- Flutter docs: https://docs.flutter.dev/

---
