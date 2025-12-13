# notes

Ghi chú ngắn (Notes) — Ứng dụng Flutter để quản lý ghi chú cá nhân.

Ứng dụng này là ví dụ thực tế về một Flutter app sử dụng SQLite (sqflite) để lưu ghi chú cục bộ, kèm một vài chức năng như tạo, sửa, xóa, tìm kiếm và lọc theo thời gian.

## Chức năng chính
- Hiển thị danh sách ghi chú (note list).
- Thêm ghi chú (Add note).
- Chỉnh sửa ghi chú (Edit note) với autosave khi chỉnh sửa.
- Xóa ghi chú (Delete note).
- Tìm kiếm ghi chú theo từ khóa (Search) và lọc theo khoảng thời gian: Hôm qua, 7 ngày, 30 ngày.
- Lưu cục bộ bằng SQLite (`sqflite`).
- Hỗ trợ chạy trên Android, iOS, Web và desktop (Windows/macOS/Linux).

## Cấu trúc mã nguồn (những file quan trọng)
- `lib/main.dart`: Điểm vào của ứng dụng.
- `lib/controllers/`: Controllers (logic) để quản lý ghi chú.
- `lib/presentation/pages/`: Các trang UI như `HomePage`, `EditNotePage`, `SearchPage`.
- `lib/data/database/notes_database.dart`: Lớp / repository thao tác SQLite.
- `lib/data/models/note.dart`: Mô hình dữ liệu `Note`.
- `test/`: Unit & widget tests (bao gồm dùng `sqflite_common_ffi` trên desktop để test DB).

## Cài đặt (Setup)
1. Cài Flutter SDK theo hướng dẫn chính thức: https://docs.flutter.dev/get-started/install
2. Mở terminal ở thư mục `notes`:

```bash
flutter pub get
flutter analyze
```

Gợi ý: nếu bạn dùng Windows hoặc macOS để chạy app desktop, hãy đảm bảo đã cài toolchain tương ứng (Visual Studio cho Windows, Xcode cho macOS).

## Chạy ứng dụng (Run)
- Chạy trên thiết bị Android/iOS đã kết nối:

```bash
flutter run
```

- Chạy trên web (Chrome):

```bash
flutter run -d chrome
```

- Chạy trên Windows (desktop):

```bash
flutter run -d windows
```

Nếu bạn muốn build release, dùng `flutter build` cho nền tảng tương ứng (ví dụ `flutter build apk`).

## Kiểm thử (Test)
Ứng dụng có test unit & widget cơ bản; test DB dùng `sqflite_common_ffi` để chạy SQLite trên desktop.

Chạy tất cả test:

```bash
flutter test
```

Chạy test cụ thể:

```bash
flutter test test/data/notes_database_test.dart
flutter test test/pages/home_page_test.dart
```

## Các tính năng và cách sử dụng (Ngắn gọn)
- Danh sách: Mở app ⇒ xem danh sách ghi chú, mỗi item hiển thị tiêu đề và 2 dòng nội dung.
- Thêm: Bấm nút `+` ⇒ màn hình `Thêm ghi chú` ⇒ nhập tiêu đề + nội dung ⇒ khi quay lại (back) app tự lưu ghi chú.
- Sửa: Chạm vào note ⇒ màn hình `Chỉnh sửa ghi chú` ⇒ khi chỉnh sửa app autosave mỗi 600ms.
- Xóa: Bấm biểu tượng `delete` trên item để xóa.
- Tìm kiếm: Bấm icon `search` (ở AppBar) ⇒ nhập từ khóa ⇒ app chạy tìm kiếm real-time và trả về kết quả ⇒ chạm vào result để mở note.
- Lọc theo thời gian: Trên trang tìm kiếm chọn filter `Hôm qua`, `7 ngày`, `30 ngày`.

## Lưu ý phát triển (Developer notes)
- Database: file SQLite tên `notes.db` (thực thi bởi `sqflite`).
- Mã test đã tích hợp `sqflite_common_ffi` để chạy môi trường test trên desktop.
- Đặt tên, UI và string mặc định bằng tiếng Việt — nếu cần chuyển đổi (i18n), cân nhắc thêm `intl`.

## Đóng góp (Contributing)
- Pull request: Fork → Tạo branch → Sửa → Tạo pull request.
- Trước khi PR, chạy `flutter test` và `flutter analyze`.

---

Tài liệu tham khảo: https://docs.flutter.dev/ (Flutter official docs). 
