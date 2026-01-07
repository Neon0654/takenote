# FEATURES

Dưới đây là danh sách **các chức năng đã được implement** trong project (liệt kê theo module, mỗi mục kèm file/thư mục liên quan và mô tả ngắn). Chỉ liệt kê những chức năng có code hiện hữu trong repository.

---

## 1) Module: Notes / Home 🔖

1. **Liệt kê ghi chú (Home / Folder mode)**
   - Files: `lib/controllers/notes_controller.dart`, `lib/presentation/pages/home_page.dart`, `lib/data/database/notes_database.dart`
   - Mô tả: Load và hiển thị danh sách ghi chú (chế độ Home hoặc chế độ xem trong Folder), hiển thị tiêu đề, nội dung tóm tắt, ngày, tag, reminder.

2. **Lọc ghi chú theo nhãn (Tag filter, chỉ Home)**
   - Files: `lib/presentation/pages/home_page.dart`, `lib/controllers/notes_controller.dart`, `lib/data/database/notes_database.dart`
   - Mô tả: Hiển thị thanh nhãn (ChoiceChip) và chỉ hiện ghi chú chứa nhãn được chọn.

3. **Sắp xếp ghi chú (Sort: ngày/tên, asc/desc)**
   - Files: `lib/presentation/pages/home_page.dart`, `lib/controllers/note_sort_type.dart`
   - Mô tả: Cho phép sắp xếp theo ngày tạo (mới→cũ, cũ→mới) hoặc tên (A→Z, Z→A).

4. **Chọn nhiều & thao tác hàng loạt (Selection / Batch actions)**
   - Files: `lib/controllers/selection_controller.dart`, `lib/presentation/pages/home_page.dart`, `lib/presentation/pages/folder_list_page.dart`
   - Mô tả: Bật chế độ chọn, chọn tất cả, di chuyển hàng loạt vào thùng rác hoặc vào thư mục.

5. **Ghim / bỏ ghim (Pin / Unpin)**
   - Files: `lib/controllers/notes_controller.dart`, `lib/data/database/notes_database.dart`, `lib/presentation/pages/home_page.dart`
   - Mô tả: Toggle trạng thái pinned; hiển thị icon và sort ưu tiên cho pinned.

---

## 2) Module: Tạo / Chỉnh sửa ghi chú ✍️

6. **Tạo ghi chú (Add note)**
   - Files: `lib/controllers/notes_controller.dart`, `lib/presentation/pages/edit_note_page.dart`, `lib/data/database/notes_database.dart`
   - Mô tả: Thêm ghi chú mới vào DB.

7. **Chỉnh sửa ghi chú (Edit note) & Auto-save (debounced)**
   - Files: `lib/presentation/pages/edit_note_page.dart`, `lib/controllers/edit_note_controller.dart`, `lib/data/database/notes_database.dart`
   - Mô tả: Chỉnh sửa nội dung/tiêu đề; có auto-save debounce (600ms) và force save khi thoát.

8. **Thêm / Xóa nhãn cho ghi chú (Tag attach/detach)**
   - Files: `lib/presentation/widgets/tag_selector_dialog.dart`, `lib/presentation/pages/edit_note_page.dart`, `lib/data/database/notes_database.dart`
   - Mô tả: Chọn nhãn từ dialog, gắn hoặc gỡ nhãn khỏi ghi chú.

9. **Quản lý nhãn (Tag management: create/delete)**
   - Files: `lib/presentation/pages/tag_management_page.dart`, `lib/data/database/notes_database.dart`
   - Mô tả: Tạo nhãn mới, xóa nhãn (kèm xóa liên kết note_tags).

10. **Đính kèm tệp (Attachments: add / open / delete)**
    - Files: `lib/presentation/pages/edit_note_page.dart`, `lib/data/models/attachment.dart`, `lib/data/database/notes_database.dart`
    - Mô tả: Chọn tệp (FilePicker), copy vào app docs, lưu metadata, mở bằng `open_filex`, xóa attachment.

11. **Chia sẻ ghi chú (Share utilities)**
    - Files: `lib/utils/share_utils.dart`
    - Mô tả: Hàm để share nội dung ghi chú (dùng `share_plus`).

---

## 3) Module: Reminder & Notification ⏰

12. **Tạo / Liệt kê / Xóa nhắc (Reminder CRUD)**
    - Files: `lib/presentation/pages/edit_note_page.dart`, `lib/data/models/reminder.dart`, `lib/data/database/notes_database.dart`
    - Mô tả: Thêm nhắc (date + time picker), hiển thị list reminders của note, xóa nhắc.

13. **Lên lịch thông báo & huỷ (Notification scheduling & cancel, quyền)**
    - Files: `lib/services/notification_service.dart`, `lib/presentation/pages/edit_note_page.dart`, `lib/main.dart`
    - Mô tả: Init notification, yêu cầu permission (Android 13+), schedule notification (exact), cancel notification khi xóa reminder.

---

## 4) Module: Thùng rác (Trash) 🗑️

14. **Di chuyển vào thùng rác (Soft delete)**
    - Files: `lib/data/database/notes_database.dart`, `lib/presentation/pages/home_page.dart`
    - Mô tả: Cập nhật cờ `isDeleted = 1` và bỏ ghim; hỗ trợ thao tác đơn lẻ và hàng loạt.

15. **Khôi phục từ thùng rác**
    - Files: `lib/data/database/notes_database.dart`, `lib/presentation/pages/trash_page.dart`
    - Mô tả: Đặt `isDeleted = 0` để restore.

16. **Xóa vĩnh viễn (Delete permanently)**
    - Files: `lib/data/database/notes_database.dart`, `lib/presentation/pages/trash_page.dart`
    - Mô tả: Xóa note và các dữ liệu liên quan (reminders, note_tags, attachments).

---

## 5) Module: Thư mục (Folder) 📂

17. **Tạo / Chỉnh sửa / Xóa thư mục**
    - Files: `lib/presentation/pages/create_folder_dialog.dart`, `lib/controllers/folder_controller.dart`, `lib/data/database/notes_database.dart`
    - Mô tả: Tạo folder (tên + màu), chỉnh sửa tên/màu, xóa folder (kèm xóa liên kết folder_notes).

18. **Liệt kê thư mục & đếm số note trong mỗi folder**
    - Files: `lib/presentation/pages/folder_list_page.dart`, `lib/data/database/notes_database.dart`
    - Mô tả: Hiển thị danh sách folder và số ghi chú trong từng folder.

19. **Xem ghi chú trong folder (Folder notes view)**
    - Files: `lib/presentation/pages/folder_notes_page.dart`, `lib/controllers/notes_controller.dart`
    - Mô tả: Mở chế độ xem chỉ các ghi chú thuộc folder.

20. **Di chuyển note vào / ra khỏi folder (link/unlink)**
    - Files: `lib/data/database/notes_database.dart`, `lib/presentation/pages/home_page.dart`
    - Mô tả: Thêm/xóa liên kết `folder_notes` để di chuyển note.

---

## 6) Module: Tìm kiếm (Search) 🔎

21. **Tìm kiếm nội dung ghi chú với lọc thời gian**
    - Files: `lib/presentation/pages/search_page.dart`, `lib/data/database/notes_database.dart`
    - Mô tả: Tìm theo keyword (title/content) kết hợp bộ lọc thời gian (hôm qua / 7 ngày / 30 ngày).

---

## 7) Helpers / UI components / Utils 🧩

22. **Confirm dialog tái sử dụng (Xác nhận hành động)**
    - Files: `lib/utils/confirm_dialog.dart`
    - Mô tả: AlertDialog chuẩn để xác nhận hành động (xóa, restore...).

23. **Tag selector dialog (UI reuse)**
    - Files: `lib/presentation/widgets/tag_selector_dialog.dart`
    - Mô tả: Dialog chọn/ tạo và gán nhãn cho note.

24. **Note list item widget**
    - Files: `lib/presentation/widgets/note_list_item.dart`
    - Mô tả: Component ListTile / Card dùng cho danh sách note (hỗ trợ selection).

---

**Tổng số chức năng đã implement:** **24**

---

> Ghi chú: File này chỉ liệt kê các chức năng có code hiển thị trong repository (UI, logic, DB). Không bao gồm tính năng được suy đoán hoặc chưa có implement.
