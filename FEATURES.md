# Danh sách tính năng đã triển khai ✅

Tài liệu liệt kê toàn bộ tính năng hiện có trong ứng dụng, được mô tả theo hành vi người dùng (không liệt kê tên file hoặc lớp).

---

**Tổng số chức năng đã triển khai:** **43**

## 1. Tính năng chính (Ghi chú) 🔧

- **Tạo ghi chú mới**
  - Người dùng có thể tạo ghi chú mới qua màn hình soạn thảo.
  - Nếu tiêu đề và nội dung đều trống thì ghi chú không được lưu.

- **Chỉnh sửa và lưu**
  - Mở ghi chú để chỉnh sửa và lưu khi quay lại (hoặc lưu sau thao tác lưu rõ ràng).
  - Nội dung và tiêu đề có chế độ hiển thị giới hạn dòng và hiển thị dấu chấm lửng khi quá dài.

- **Hiển thị danh sách ghi chú**
  - Màn hình chính hiển thị lưới ghi chú với tiêu đề, xem trước nội dung, trạng thái ghim, số lượng đính kèm và biểu tượng nhắc nhở nếu có.
  - Kết quả rỗng có trạng thái hiển thị rõ ràng (ví dụ: "Chưa có ghi chú nào").

- **Ghim / Bỏ ghim**
  - Người dùng có thể ghim hoặc bỏ ghim ghi chú bằng thao tác nhấn vào biểu tượng ghim.
  - Ghi chú ghim được hiển thị ưu tiên (luôn lên đầu khi sắp xếp).

- **Xóa (đưa vào thùng rác)**
  - Xóa là xóa mềm: ghi chú được đánh dấu là đã xóa và chuyển vào thùng rác.
  - Khi đưa vào thùng rác, ghi chú bị bỏ ghim và cập nhật thời gian.
  - Hỗ trợ xóa nhiều ghi chú cùng lúc kèm hộp thoại xác nhận trước khi thực hiện.

- **Chế độ xem**
  - Người dùng có thể xem tất cả ghi chú, ghi chú không thuộc thư mục (unassigned), hoặc xem theo thư mục cụ thể, hoặc xem thùng rác.

- **Sắp xếp**
  - Hỗ trợ sắp xếp theo tiêu đề (A→Z / Z→A), theo ngày tạo (mới → cũ / cũ → mới), theo ngày cập nhật.
  - Ghim luôn được ưu tiên lên đầu danh sách.

---

## 2. Nhãn (Tag) 🏷️

- **Danh sách nhãn và trạng thái rỗng**
  - Hiển thị danh sách nhãn; khi chưa có nhãn, hiển thị trạng thái "Chưa có nhãn nào".

- **Thêm nhãn**
  - Người dùng có thể tạo nhãn mới qua dialog với trường nhập tên.
  - Tên nhãn rỗng sẽ bị bỏ qua (không tạo nhãn rỗng).
  - Tạo nhãn trùng tên được xử lý an toàn (không tạo trùng do cơ chế chèn an toàn).

- **Đổi tên nhãn**
  - Cho phép đổi tên nhãn qua dialog; tên mới rỗng sẽ bị bỏ qua.
  - Sau đổi tên, danh sách ghi chú được làm mới để phản ánh thay đổi.

- **Xóa nhãn**
  - Xóa nhãn sẽ gỡ nhãn khỏi tất cả các ghi chú liên quan (có hộp thoại xác nhận trước khi xóa).

- **Gắn / bỏ nhãn cho 1 ghi chú**
  - Dialog lựa chọn nhãn với checkbox, thao tác thêm / gỡ nhãn thực hiện ngay khi thay đổi checkbox.

- **Gắn / bỏ nhãn cho nhiều ghi chú**
  - Hỗ trợ gắn nhãn hàng loạt cho các ghi chú đã chọn; dialog khởi tạo trạng thái chọn dựa trên nhãn của một ghi chú mẫu, sau đó áp dụng thêm/bớt nhãn cho từng ghi chú trong tập.

---

## 3. Thư mục (Folder) 📁

- **Danh sách thư mục**
  - Hiển thị thư mục kèm số lượng ghi chú trong mỗi thư mục; khi rỗng có trạng thái tương ứng.

- **Tạo, đổi tên, xóa thư mục**
  - Thêm thư mục mới với tên và màu; đổi tên và xóa thư mục có xác nhận; xóa sẽ gỡ liên kết ghi chú – thư mục trước khi xóa.

- **Xem ghi chú theo thư mục**
  - Mở thư mục để chỉ xem ghi chú thuộc thư mục đó.

- **Di chuyển ghi chú vào / ra khỏi thư mục**
  - Thêm ghi chú mới trực tiếp vào thư mục khi tạo.
  - Hỗ trợ chuyển nhiều ghi chú vào thư mục thông qua màn hình chọn ghi chú (chỉ hiển thị ghi chú chưa có thư mục để chuyển vào).
  - Hỗ trợ đưa ghi chú ra khỏi thư mục (bằng cách di chuyển đến null).

---

## 4. Tìm kiếm & Bộ lọc 🔎

- **Tìm kiếm theo từ khóa**
  - Tìm theo tiêu đề và nội dung; hiển thị kết quả dạng danh sách với tiêu đề + xem trước nội dung.

- **Bộ lọc thời gian**
  - Bộ chọn nhanh: Tất cả / Hôm qua / 7 ngày / 30 ngày.
  - Chọn lại cùng bộ lọc sẽ tắt bộ lọc (về Tất cả).
  - Tìm kiếm áp dụng kết hợp với bộ lọc thời gian (lọc theo createdAt).

---

## 5. Đính kèm (Attachments) 📎

- **Thêm tệp đính kèm**
  - Người dùng chọn file thông qua file picker; file path được lưu và hiển thị số lượng đính kèm trên giao diện.
  - Nếu người dùng không chọn file hoặc đường dẫn null thì thao tác bị hủy.

- **Hiển thị số lượng đính kèm**
  - Số lượng đính kèm hiển thị trên ô ghi chú và chi tiết ghi chú.

- **Xóa đính kèm**
  - Khi xóa, bản ghi đính kèm trong DB bị xóa và tệp tin trên đĩa cũng bị xóa (nếu tồn tại).

---

## 6. Nhắc nhở & Thông báo ⏰

- **Tạo nhắc nhở**
  - Người dùng chọn ngày và giờ (date picker + time picker). Không cho phép đặt nhắc cho thời điểm trong quá khứ.
  - Mỗi nhắc nhở lưu kèm một ID thông báo duy nhất.

- **Lên lịch thông báo địa phương**
  - Ứng dụng khởi tạo dịch vụ thông báo và yêu cầu quyền thông báo khi bật ứng dụng.
  - Thời gian và múi giờ được xử lý (mặc định Asia/Ho_Chi_Minh).
  - Lên lịch thông báo qua plugin; lỗi khi lên lịch sẽ bị bắt và không làm sập ứng dụng.

- **Xóa / Hoàn thành nhắc nhở**
  - Xóa nhắc nhở trả về ID thông báo (nếu có) và hủy thông báo tương ứng.
  - Có thể đánh dấu nhắc nhở là đã xong.

- **Hiển thị nhắc nhở trong chi tiết**
  - Danh sách nhắc nhở hiện trong phần chi tiết meta của ghi chú, mỗi mục có nút gỡ để xóa.

---

## 7. Chọn & Thao tác hàng loạt (Selection & Bulk Ops) ✔️

- **Bắt đầu chọn**
  - Giữ (long press) một ghi chú để bắt đầu chế độ chọn; sau đó chạm để chọn / bỏ chọn các mục khác.

- **Chọn tất cả**
  - Có nút "Chọn tất cả" để chọn toàn bộ danh sách hiện tại.

- **Thao tác hàng loạt**
  - Các thao tác trên tập đã chọn: gắn nhãn hàng loạt, di chuyển vào thư mục, đưa vào thùng rác (xóa mềm), chia sẻ nhiều ghi chú.
  - Trong thùng rác, hỗ trợ phục hồi và xóa vĩnh viễn nhiều ghi chú cùng lúc với xác nhận.

- **Giao diện chọn**
  - Thanh app bar chuyển trạng thái, hiển thị số lượng đã chọn và các hành động phù hợp; các nút bị vô hiệu hóa khi không có mục được chọn.

---

## 8. Chia sẻ (Share) 📤

- **Chia sẻ một ghi chú**
  - Chia sẻ nội dung ghi chú (tiêu đề + nội dung) nếu nội dung không rỗng.

- **Chia sẻ nhiều ghi chú**
  - Gom nhiều ghi chú thành một chuỗi văn bản và chia sẻ cùng lúc.

---

## 9. Giao diện & Trải nghiệm người dùng (UX) 🎨

- **Hiệu ứng giao diện**
  - Phần chi tiết meta mở rộng/thu lại có animation mượt (AnimatedSize).

- **Thông báo trạng thái & xác nhận**
  - Hộp thoại xác nhận trước các hành động phá hủy (xóa vĩnh viễn, đưa vào thùng rác, xóa nhãn, v.v.).

- **Trạng thái hiển thị người dùng**
  - Hiển thị placeholder cho tiêu đề rỗng ("(Không tiêu đề)").
  - Giao diện nhãn (chip), biểu tượng ghim, biểu tượng đính kèm, biểu tượng nhắc nhở.
  - Giao diện lựa chọn rõ ràng: viền và nền thay đổi khi mục được chọn.

---

## 10. Lưu trữ & Bảo toàn dữ liệu (Database & Persistence) 💾

- **Lưu trữ SQLite**
  - Bảng cho ghi chú, nhãn, liên kết note–tag, nhắc nhở, đính kèm, thư mục, liên kết folder–note.
  - Cập nhật schema và nâng cấp DB được xử lý qua các bước nâng cấp (migration) để thêm cột hoặc bảng mới.

- **Quản lý dữ liệu liên quan**
  - Khi xóa ghi chú vĩnh viễn, các dữ liệu phụ (nhắc nhở, liên kết nhãn, đính kèm) cũng bị xóa.
  - Phân biệt rõ giữa xóa mềm (vào thùng rác) và xóa vĩnh viễn.

---

## 11. Xử lý cạnh & Validation ⚠️

- **Không lưu ghi chú rỗng**
  - Ghi chú không có tiêu đề và nội dung sẽ không được lưu.

- **Không tạo/đổi tên nhãn rỗng**
  - Tên nhãn rỗng sẽ bị bỏ qua.

- **Không đặt nhắc trong quá khứ**
  - Nếu người dùng chọn thời điểm trước hiện tại, thao tác thêm nhắc sẽ hủy.

- **Bảo toàn khi lỗi**
  - Việc lên lịch thông báo được bọc try/catch để tránh phá vỡ luồng nếu plugin thất bại.

---

## 12. Dịch vụ & Quyền (Services & Permissions) 🔐

- **Thông báo cục bộ**
  - Khởi tạo plugin thông báo, thiết lập múi giờ và yêu cầu quyền thông báo khi ứng dụng khởi động.

- **Quyền truy cập tập tin**
  - Sử dụng file picker để chọn tệp đính kèm; kiểm tra đường dẫn tệp trước khi lưu.

--- ✨
