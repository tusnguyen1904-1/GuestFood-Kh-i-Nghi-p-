# guestFood

Ứng dụng cá nhân tìm món quanh cơ sở Dĩ An và ghi sổ chi theo tài khoản. Frontend React/Vite, backend Supabase Auth, Data API, PostgreSQL và Edge Function xóa tài khoản. Thư mục triển khai là `app`; demo HTML cũ ở gốc repo.

## Chạy trên máy

Dùng Node.js 22.12+ hoặc 24. Trong thư mục app, chạy `npm ci`, sau đó `npm run dev`. Chạy `npm run build` để kiểm tra TypeScript và tạo dist. Khi thiếu cấu hình Supabase, app cho xem danh mục mẫu, GPS, liên kết chỉ đường và sổ mẫu. Tài khoản và giao dịch cá nhân cần kết nối backend.

## Kết nối Supabase

1. Tạo project Free. Trong Authentication bật đăng nhập Email/Password, cho phép đăng ký và tắt **Confirm email**. Lần đăng ký đầu tiên phải nhận phiên đăng nhập ngay. Email người dùng khai báo chưa được xác minh.
2. Từ app, chạy các lệnh bên dưới bằng Supabase CLI. Migration tạo bảng, phân quyền theo hàng và hàm quản trị; seed thêm 23 hồ sơ Maps và 47 món mẫu.

```sh
supabase login
supabase link --project-ref YOUR_PROJECT_REF
supabase db push --include-seed
supabase functions deploy delete-account
```

3. Sao chép .env.example thành .env.local, điền VITE_SUPABASE_URL và VITE_SUPABASE_PUBLISHABLE_KEY. Khởi động lại Vite. Chỉ hai biến công khai này được đưa vào frontend.
4. Đăng ký một tài khoản qua giao diện. Để cấp quyền quản trị, lấy **User UID** của tài khoản chủ dự án trong Authentication, đối chiếu trực tiếp rồi chạy câu SQL bên dưới bằng SQL Editor. Thay chuỗi YOUR_USER_UUID bằng UUID thực tế. Tránh cấp quản trị chỉ dựa trên địa chỉ email tự khai.

```sql
insert into public.admin_roles (user_id)
values ('YOUR_USER_UUID'::uuid)
on conflict do nothing;
```

5. Trong Auth URL Configuration đặt Site URL là URL HTTPS chính thức, thêm đúng URL chuyển hướng của môi trường kiểm thử. Cấu hình SMTP cho chức năng quên mật khẩu trước khi cho người dùng bên ngoài sử dụng email khôi phục.

## Triển khai Vercel Hobby

Khi import từ GitHub, chọn nhánh chứa bản full-stack, **Root Directory = app**, Framework = Vite, Build = npm run build, Output = dist. Thêm hai biến VITE_SUPABASE ở trên cho môi trường tương ứng, rồi triển khai lại sau mỗi thay đổi biến. Khi triển khai bằng CLI từ thư mục app, thư mục hiện tại đã là gốc triển khai.

## Kiểm tra trước khi mở đăng ký

- Đăng ký, đăng xuất và đăng nhập lại trên hai trình duyệt. Tài khoản A đặt ngân sách 300.000 ₫, ghi 32.000 ₫, phải còn 268.000 ₫. Tài khoản B có sổ riêng. Sổ mẫu không được nhập vào database.
- Tìm “com ga” đến 40k và mở đúng hồ sơ quán. Cho phép hoặc từ chối định vị; kiểm tra mốc H1, sai số và liên kết đi bộ trên thiết bị thật. Xem supabase/CATALOG.md cho phạm vi kiểm chứng bản đồ.
- Dùng quản trị để ẩn một bản ghi thử, kiểm tra khách không thấy chi nhánh và món của quán đó. Sửa địa điểm và thực đơn được thực hiện trong cùng giao dịch, có lịch sử duyệt.
- Khi phát hành, lưu bản sao database tại nơi riêng tư bằng công cụ PostgreSQL hoặc Supabase CLI và thử phục hồi ở database kiểm thử. Có thể quay về deployment Vercel trước đó mà vẫn giữ dữ liệu trên Supabase.
