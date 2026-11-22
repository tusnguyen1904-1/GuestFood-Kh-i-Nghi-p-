# guestFood · Đặc tả website tìm món và quản lý chi tiêu
Bản đề xuất ngày 21/11/2026 · Khu vực Đại học Bách khoa, cơ sở Dĩ An

## 1. Trải nghiệm từ lúc tìm món đến cuối tuần

Một sinh viên gõ **“com ga”**, chọn **Đến 40k** và thấy tên món, giá một phần cùng khoảng cách từ trường. Sau bữa ăn, bạn ấy ghi 32.000 ₫ thực trả. Chủ nhật, bạn ấy xem các ngày chi nhiều, bấm vào một ngày để kiểm tra từng khoản và biết ngân sách tuần còn bao nhiêu.

Giữ hai mục điều hướng **Tìm món** và **Chi tiêu**. Trong Chi tiêu có hai chế độ **Sổ chi** và **Thống kê** dùng chung dữ liệu. Bản đầu dùng một file HTML trên điện thoại và máy tính, danh mục nhúng sẵn, dữ liệu cá nhân lưu trong trình duyệt. Mốc mặc định đề xuất là sảnh H1 cơ sở Dĩ An. Cần chốt ghim H1 khi lập bộ dữ liệu. [Địa điểm nhà H1 do trường công bố](https://cce.hcmut.edu.vn/lien-he/)

## 2. Tìm món ăn

| Thao tác | Hành vi cần triển khai |
|---|---|
| Gõ tên món | Ô đầu trang có nhãn “Tên món ăn”, gợi ý “Thử cơm gà, bún bò, món chay…”. Bỏ khoảng trắng thừa, chuẩn hóa chữ hoa/thường, dấu tiếng Việt và đ/d khi so khớp. Giữ nguyên tên có dấu khi hiển thị. Gợi ý lấy từ món thực sự có trong danh mục. |
| Khớp từ khóa | Mọi từ phải có trong tên hoặc tên gọi khác của **cùng một món**. Ví dụ “bun bo” khớp “Bún bò Huế”. Cho khai báo từ đồng nghĩa như “mì/mỳ” và thẻ được duyệt như “món chay”. Khi từ khóa trống, trả các quán đạt bộ lọc hiện tại. |
| Chọn mức chi | Nút Đến 30k, Đến 40k, Đến 50k đặt trần giá cho một phần. Bộ lọc chi tiết có giá tối thiểu, tối đa và bán kính. Tính cả hai biên. Loại món thiếu giá khỏi kết quả có giới hạn tiền. Giá phần nhóm ghi rõ đơn vị nồi/mẹt và chỉ tham gia lọc theo suất khi có giá suất xác nhận. |
| Chọn khu vực | Hiện rõ “Quanh H1 · Bách khoa Dĩ An”; đề xuất bán kính ban đầu 2 km, cho đổi sang 1, 3 hoặc 5 km. Chỉ hỏi vị trí khi người dùng chọn. Nếu định vị lỗi, tiếp tục từ H1. Nhãn km là khoảng cách đường chim bay. |
| Đọc kết quả | Một thẻ cho mỗi chi nhánh. Món đại diện phải đồng thời khớp tên và giá, quán phải nằm trong bán kính. Khi có nhiều món, ưu tiên tên khớp nguyên cụm, rồi giá thấp hơn. Mặc định xếp quán gần nhất; cho đổi sang “Giá thấp nhất” theo giá món đạt lọc. Hiện cả số món và số quán. |
| Mở quán | Hiện món khớp trước, sau đó là toàn bộ thực đơn, địa chỉ, nguồn và ngày cập nhật giá, nút chỉ đường, ghi chi, ưu đãi, nhận xét. Quay lại giữ từ khóa, bộ lọc và vị trí cuộn. |
| Danh sách trống | Giữ nguyên điều kiện và cho xóa riêng từng bộ lọc. Chỉ gợi ý “Có thêm 3 quán trong 3 km” khi đếm được đúng 3 quán với các điều kiện còn lại. |

## 3. Sổ chi và thống kê

Một khoản gồm ngày ăn, số tiền thực trả nguyên dương theo đồng, tên quán, món hoặc mô tả, nhóm chi và ghi chú tùy chọn. Nhóm mặc định đề xuất gồm bữa sáng, bữa trưa, bữa tối, ăn vặt, đồ uống và khác. Mỗi khoản thuộc một nhóm để tổng các nhóm luôn bằng tổng chi. Cho nhập quán ngoài danh mục. Người dùng có thể sửa, xóa hoặc chọn **Ghi lại** để mở bản nháp cho hôm nay. Nút Lưu chỉ tạo một khoản kể cả khi chạm hai lần.

| Câu hỏi của sinh viên | Chỉ số và cách đọc |
|---|---|
| Tuần này còn bao nhiêu? | Ngân sách tuần trừ tổng thực trả từ thứ Hai đến Chủ nhật theo ngày địa phương. Vượt thì hiện “Đã vượt … ₫”. Chưa đặt ngân sách vẫn xem được tổng và ghi chi. Lưu ngân sách theo tuần để sửa tuần hiện tại không làm đổi lịch sử. |
| Mình đã chi bao nhiêu? | Chọn hôm nay, tuần, tháng hoặc khoảng ngày. Hiện tổng, số khoản và trung bình mỗi khoản = tổng / số khoản. Trung bình làm tròn đến đồng. Kỳ rỗng hiện tổng 0 ₫, số khoản 0, trung bình “—”. |
| Ngày nào chi nhiều? | Biểu đồ cột theo ngày, tính cả các ngày có tổng bằng 0. Với khoảng trên 31 ngày, gộp theo tuần và ghi ngày đầu–cuối từng cột. Chọn cột mở đúng các khoản cấu thành. |
| Tiền chủ yếu đi đâu? | Biểu đồ thanh ngang theo nhóm, hiện số tiền và tỷ trọng. Xếp theo tổng giảm dần. Cho chuyển sang xem theo quán, kể cả quán tự nhập. Chọn một hàng để xem giao dịch. |
| Mình có chi nhiều hơn trước? | So tuần hiện tại đến hôm nay với cùng số ngày của tuần trước. Ví dụ thứ Tư chỉ so thứ Hai–Tư ở cả hai tuần. Hiện chênh lệch bằng đồng; chỉ hiện phần trăm khi kỳ trước có tổng lớn hơn 0. Không suy diễn tiết kiệm từ những ngày chưa ghi. |

**Ví dụ nghiệm thu.** Ngân sách tuần 300.000 ₫. Thứ Hai ghi bữa trưa 35.000 ₫ và nước 15.000 ₫, thứ Ba ghi bữa trưa 40.000 ₫. Kết quả là **90.000 ₫**, **3 khoản**, trung bình **30.000 ₫**, còn **210.000 ₫**. Hai cột ngày là 50.000 ₫ và 40.000 ₫. Nhóm bữa trưa có 75.000 ₫. Sửa khoản thứ Ba sang chủ nhật tuần trước phải đưa tổng tuần này về 50.000 ₫. Đổi chế độ hiển thị, sửa hoặc xóa khoản đều cập nhật thẻ tổng, biểu đồ và danh sách cùng lúc.

## 4. Ba phong cách giao diện

| Phong cách | Màn hình tìm món | Màn hình thống kê | Khi nào nên chọn |
|---|---|---|---|
| **Cẩm nang ẩm thực quanh trường** | Nền kem, hình món sáng tự nhiên, tên món và giá đặt sát nhau, thông tin quán ở dòng dưới | Nền trắng, số tiền lớn, cột xanh đậm, nhấn cam đất cho khoản vượt | **Đề xuất cho guestFood.** Ảnh giúp chọn món nhanh, hệ màu và chữ đủ tiết chế để đọc sổ chi hằng tuần. |
| **Danh mục đô thị** | Danh sách gọn, ảnh thu nhỏ, giá và khoảng cách thẳng cột, nền trắng và xanh lam đậm | Biểu đồ và bảng số liệu cùng lưới; vừa xem được nhiều khoản | Hợp khi ưu tiên so giá giữa nhiều quán trong một màn hình. Ảnh nhỏ làm giảm sức hút của món. |
| **Tạp chí ẩm thực sinh viên** | Ảnh lớn, tiêu đề kiểu tạp chí, cụm món theo chủ đề | Trang sổ riêng dùng chữ sans và bảng ít màu | Hợp nếu dự án có người biên tập nội dung theo mùa. Ảnh lớn chiếm chỗ của kết quả trên điện thoại. |

**Quy cách cho phương án đề xuất.** Nền #FAF7F0, thẻ trắng, chữ #252821, hành động chính #20513D, nhấn #A44220. Dùng font hệ thống có dấu tiếng Việt, chữ nội dung 16 px, giá 20 px đậm, số liệu dùng chữ số có độ rộng bằng nhau. Thiết kế theo bước khoảng cách 4/8 px; một hành động chính trên mỗi vùng. Trạng thái vượt ngân sách có số tiền và chữ, biểu đồ có bảng số đọc được bằng bàn phím.

- **Điện thoại:** ô tìm và trần giá ở trên cùng, kết quả một cột. Bộ lọc mở thành bảng từ dưới, hiện số quán sẽ áp dụng. Trong Chi tiêu, đặt ngân sách còn lại cạnh nút ghi khoản; đưa biểu đồ xuống sau tổng kỳ. Vùng chạm ít nhất 44 px.
- **Máy tính:** bộ lọc ở trái, lưới 2–3 cột ở phải. Trong Thống kê, đặt biểu đồ ngày cạnh bảng nhóm chi. Khi nhấp một cột hoặc nhóm, danh sách giao dịch ngay dưới cập nhật và hiển thị điều kiện đang chọn.
- **Ảnh:** đề xuất 8–12 ảnh WebP minh họa theo nhóm món, dùng lại cho các món tương ứng để giữ file nhẹ. Ảnh 4:3, ánh sáng cửa sổ, cùng góc chụp và nền bàn trung tính. Ví dụ brief tạo ảnh: “Một phần cơm gà xối mỡ kiểu Việt Nam, góc 45 độ, ánh sáng ban ngày, đĩa đơn, nền gỗ sáng, không chữ và logo”. Ghi “Ảnh minh họa” trên ảnh hoặc ngay dưới ảnh. Chỉ dùng ảnh đúng loại món; khi thiếu ảnh, ưu tiên thẻ chữ rõ giá.

## 5. Dữ liệu quán quanh Bách khoa Dĩ An

**Mục tiêu ra mắt: 24 chi nhánh trong bán kính đề xuất 3 km từ H1**, ít nhất 2 món mỗi quán, tổng tối thiểu 48 món có giá và đơn vị bán. Ưu tiên món một người ăn. Bán kính tìm mặc định 2 km có thể chỉ hiện một phần danh mục. Không mở rộng âm thầm để đủ số lượng.

28 đầu mối dưới đây có liên kết Google Maps do cẩm nang địa phương công bố. Khu vực là mốc mô tả của nguồn. Trong lần khảo sát này chưa xác nhận được trang hồ sơ hiện hành sau từng liên kết rút gọn, khoảng cách tới H1, thực đơn hoặc tình trạng kinh doanh. Vì vậy bảng là danh sách khảo sát, chưa tính vào 24 chi nhánh đạt chuẩn. [Nguồn tên quán, khu vực và liên kết bản đồ](https://ganlang.vn/danh-sach-quan-an-uong-lang-dai-hoc-da-mo-cua-phuc-vu-sinh-vien/)

| STT | Quán / chi nhánh cần đối chiếu | Khu vực tham chiếu | Google Maps từ nguồn |
|---:|---|---|---|
| 1 | Lẩu chay Hằng Thiện | Vành đai KTX A | [Bản đồ](https://goo.gl/maps/k34qFCzktRuwR9e2A) |
| 2 | Ốc 30k | Vành đai KTX A | [Bản đồ](https://goo.gl/maps/Mmz33jCwURKHFbg77) |
| 3 | Cơm tấm Ngọc Thái | Cổng chui khu A | [Bản đồ](https://goo.gl/maps/2GkLLjEgebVtEz63A) |
| 4 | Bún đậu Box | Nhà Văn hóa Sinh viên | [Bản đồ](https://goo.gl/maps/9ayMj6whd49yEURDA) |
| 5 | Lẩu chay Tâm Diệu 3 | Nhà Văn hóa Sinh viên | [Bản đồ](https://goo.gl/maps/z7XzuDemWb9Jfihj7) |
| 6 | Cơm tấm Long Xuyên (không khói) | Nhà Văn hóa Sinh viên | [Bản đồ](https://goo.gl/maps/KdcCDSGXxwYDa5ks6) |
| 7 | Bánh mì Hà Nội | Nhà Văn hóa Sinh viên | [Bản đồ](https://goo.gl/maps/XhPU4bFw7VZrrtDA6) |
| 8 | Tiệm ăn Mlem Mlem | Nhà Văn hóa Sinh viên | [Bản đồ](https://goo.gl/maps/fFAus5Nm5ChmbvjA6) |
| 9 | Mộc Lan Quán 1 | ĐH Khoa học Tự nhiên | [Bản đồ](https://goo.gl/maps/V3TtS8BKVXWkDwKX6) |
| 10 | Combo Lan Anh 2 | ĐH Khoa học Tự nhiên | [Bản đồ](https://goo.gl/maps/By3mk9EjrKoK9HM9A) |
| 11 | Hủ tiếu Tự Nhiên | ĐH Khoa học Tự nhiên | [Bản đồ](https://goo.gl/maps/7avyf7Dmxtjp6RKk9) |
| 12 | Phở Thiên | ĐH Khoa học Tự nhiên | [Bản đồ](https://goo.gl/maps/Xj28WA3rRFTyva6y8) |
| 13 | Bò né Chu Pin | ĐH Khoa học Tự nhiên | [Bản đồ](https://goo.gl/maps/AoVJDwXmWjpc91Ar8) |
| 14 | Cơm tấm Ngô Quyền II | ĐH Khoa học Tự nhiên | [Bản đồ](https://goo.gl/maps/8QR8oGA78DGYPnbD9) |
| 15 | Bún chả Hà Nội – Bún đậu mắm tôm | ĐH Khoa học Tự nhiên | [Bản đồ](https://goo.gl/maps/ZBhznYS6c5t7Xf3h6) |
| 16 | Cơm tấm Ngô Quyền Nhà điều hành | Nhà điều hành ĐHQG | [Bản đồ](https://goo.gl/maps/9U46eduX2KgZgeTh7) |
| 17 | Bún đậu mắm tôm AC | Nhà điều hành ĐHQG | [Bản đồ](https://goo.gl/maps/1yAa89FAZH4gQQUGA) |
| 18 | Cơm Yến Nhi | Nhà điều hành ĐHQG | [Bản đồ](https://goo.gl/maps/Y1bfeZVXGk7wrkk58) |
| 19 | Phở Lý Quốc Sư | Chợ Nhân Văn | [Bản đồ](https://goo.gl/maps/EYSfnuTjDAQ7dgjJ8) |
| 20 | Mộc Lan Quán 2 | Chợ Nhân Văn | [Bản đồ](https://goo.gl/maps/MtxcioepnmLdd9Mw5) |
| 21 | Hủ tiếu 76 | Chợ Nhân Văn | [Bản đồ](https://goo.gl/maps/c36Lhg1qGRFEDyBr5) |
| 22 | Cơm chay Thiên Nhiên | Chợ Nhân Văn | [Bản đồ](https://goo.gl/maps/oDR5m8DhuikBNiaw5) |
| 23 | Lẩu nướng ngói 2 Danh | Vành đai KTX B | [Bản đồ](https://goo.gl/maps/mpTwji1wjHwHxWyg7) |
| 24 | Lẩu nướng Cô Liên | Tô Vĩnh Diện | [Bản đồ](https://goo.gl/maps/zPRw4nCorSJuHmPG6) |
| 25 | Dê Hưng Mập | Tô Vĩnh Diện | [Bản đồ](https://goo.gl/maps/FDddS3Lfs7Y7RXwH8) |
| 26 | Lẩu bò Hà Lan | Tô Vĩnh Diện | [Bản đồ](https://goo.gl/maps/cVeobf7Gafi2ijV49) |
| 27 | Lẩu chay Hữu Duyên 2 | Tô Vĩnh Diện | [Bản đồ](https://goo.gl/maps/4SbWfbSKAQEASfVH6) |
| 28 | Lẩu chay Mị Châu | Tô Vĩnh Diện | [Bản đồ](https://goo.gl/maps/V3cse2sJwx6btvdm6) |

**Tiêu chí đưa một quán lên web.** Chọn đúng chi nhánh trên Maps, lưu tên hiện hành, địa chỉ, ghim, liên kết hồ sơ và ngày kiểm tra. Tính khoảng cách từ tọa độ H1 đến ghim quán; kiểm tra trùng ghim và địa chỉ trước khi đếm. Hai chi nhánh cùng tên cần hai địa chỉ phân biệt. Nếu quán đóng cửa hoặc nằm ngoài phạm vi, thay bằng một quán ăn đủ điều kiện trong cùng khu vực. Với món và giá, đối chiếu menu có ngày hoặc xác nhận của quán; mỗi giá có đơn vị suất/tô/nồi và nguồn riêng. Giá minh họa để thử giao diện phải có nhãn “Giá mẫu”. Một nguồn đối chiếu trực tiếp cho khu Lương Định Của là [trang chi nhánh Mì Cay Seoul Làng Đại Học](https://micayseoul.com.vn/seoul-lang-dai-hoc/).

## 6. Dữ liệu cá nhân và các chức năng đi kèm

| Thành phần | Quyết định |
|---|---|
| Lịch sử chi | Lưu tên món, tên quán và số thực trả tại thời điểm ghi. Khi giá menu đổi hoặc quán ngừng hoạt động, lịch sử chi vẫn đọc được. Chỉ dùng giao dịch đã bấm Lưu để tính thống kê. |
| Đánh giá | Mỗi trình duyệt có một đánh giá 1–5 sao cho từng quán, cho sửa hoặc xóa. Tính lại điểm và lượt của guestFood. Gắn nhãn cho nhận xét mẫu; để trống điểm nếu chưa có lượt. |
| Ưu đãi | Hiện điều kiện, hạn dùng, chi nhánh và trạng thái. Đổi mã là mô phỏng, chặn đổi lặp. Người dùng có thể ghi số tiền sau giảm ở bước riêng. |
| Tài trợ và quảng cáo | Tối đa một chi nhánh tài trợ đạt đủ truy vấn, giá và khoảng cách, gắn nhãn cạnh tên. Quảng cáo nằm sau nhóm kết quả đầu, không cộng vào số quán; ẩn chiến dịch hết hạn. |
| Lưu trên thiết bị | Lưu sổ chi, ngân sách tuần, đánh giá và trạng thái mã đã dùng theo phiên bản dữ liệu. Nếu trình duyệt chặn lưu, báo “Dữ liệu chỉ giữ trong phiên này”. Sổ mới bắt đầu trống; dữ liệu để trình diễn thống kê dùng chế độ mẫu riêng. |
| Khi ngoại tuyến | Bản HTML đã tải về chứa danh mục, ảnh và biểu đồ. Tìm món và ghi chi dùng được tại chỗ. Chỉ đường cần kết nối. Kiểm tra khả năng lưu thực tế trên trình duyệt dùng để demo. |

## 7. Thứ tự triển khai và kiểm thử

1. **Danh mục và tìm món.** Chốt ghim H1, kiểm tra ít nhất 21 quán thật để vượt ngưỡng yêu cầu, hướng tới 24. Thử “com ga”, “CƠM GÀ”, “mi”/“mỳ” và từ khóa trống. Quán có cơm gà 45.000 ₫ và món khác 25.000 ₫ phải bị loại khi tìm cơm gà đến 40.000 ₫. Món đúng 40.000 ₫ được giữ.
2. **Sổ chi và thống kê.** Dùng ví dụ ở mục 3. Kiểm tra thêm kỳ trống, tuần giao tháng, ngày Chủ nhật, sửa số thực trả, xóa khoản cuối và tải lại. Chạm một cột phải xem được các khoản có tổng đúng bằng giá trị cột.
3. **UI và trải nghiệm phụ.** Kiểm tra ở 360, 768 và 1280 px; chữ có dấu, giá và nút không bị cắt. Thử bàn phím khi mở/đóng bộ lọc, từ chối vị trí, mất mạng, mã hết hạn và quán tài trợ ngoài bán kính.
4. **Sau bản đầu.** Ưu tiên xuất CSV theo kỳ để người dùng giữ sổ chi, sau đó cân nhắc lưu món yêu thích. Dùng thử với sinh viên bằng hai nhiệm vụ: tìm một món vừa 40.000 ₫ và xác định ngày chi nhiều nhất tuần. Quan sát bước nào khiến họ phải đoán hoặc quay lại trước khi thêm màn hình mới.

