# Hướng Dẫn Deploy Ứng Dụng Rails Lên Railway

## Tổng Quan

Railway là một nền tảng cloud cho phép deploy ứng dụng một cách dễ dàng. Hướng dẫn này sẽ giúp bạn deploy ứng dụng Rails của bạn lên Railway.

## Yêu Cầu

- Tài khoản Railway (đăng ký tại https://railway.app)
- Git repository của dự án
- Railway CLI (tùy chọn, có thể dùng web interface)

## Các Bước Deploy

### Bước 1: Chuẩn Bị Repository

Đảm bảo code của bạn đã được commit và push lên Git repository (GitHub, GitLab, hoặc Bitbucket).

```bash
git add .
git commit -m "Chuẩn bị deploy lên Railway"
git push origin main
```

### Bước 2: Tạo Project Trên Railway

1. Đăng nhập vào https://railway.app
2. Click **"New Project"**
3. Chọn **"Deploy from GitHub repo"** (hoặc GitLab/Bitbucket)
4. Chọn repository của bạn
5. Railway sẽ tự động phát hiện đây là ứng dụng Rails

### Bước 3: Thêm PostgreSQL Database

1. Trong project dashboard, click **"+ New"**
2. Chọn **"Database"** → **"Add PostgreSQL"**
3. Railway sẽ tự động tạo database và set biến môi trường `DATABASE_URL`

### Bước 4: Cấu Hình Environment Variables

Trong project settings, thêm các biến môi trường sau:

#### Biến Bắt Buộc:
- `RAILS_ENV=production`
- `RAILS_MASTER_KEY` - Lấy từ file `config/master.key` (hoặc tạo mới)
- `RAILS_SERVE_STATIC_FILES=true` - Để serve static files
- `RAILS_LOG_TO_STDOUT=true` - Để xem logs trên Railway

#### Biến Database (nếu không dùng DATABASE_URL):
- `WAKER_POSTGRES_DB_HOST` - Host của database
- `WAKER_POSTGRES_DB_PORT` - Port (thường là 5432)
- `WAKER_POSTGRES_DB_USER` - Username
- `WAKER_POSTGRES_DB_PASS` - Password
- `WAKER_POSTGRES_DB_NAME` - Tên database

**Lưu ý:** Railway tự động set `DATABASE_URL`, nên bạn không cần set các biến WAKER_POSTGRES_* nếu đã cấu hình `database.yml` để sử dụng `DATABASE_URL`.

#### Biến Tùy Chọn (theo nhu cầu):
- `HOST` - Domain của website (ví dụ: your-app.railway.app)
- `WEB` - Tên website
- `USER_EMAIL` - Email để gửi mail
- `PASSWORD_EMAIL` - Password email
- `GRAYLOG_HOST` - Nếu dùng Graylog logging
- `GRAYLOG_PORT` - Port của Graylog
- `PAGE_CACHING_PATH` - Đường dẫn cache (mặc định: public/cached_pages)
- `ASSET_HOST` - CDN cho assets (nếu có)
- `RAILS_MAX_THREADS` - Số threads (mặc định: 5)
- `PORT` - Port để chạy app (Railway tự động set)

### Bước 5: Lấy RAILS_MASTER_KEY

Nếu bạn chưa có `RAILS_MASTER_KEY`, có thể:

1. Lấy từ file `config/master.key` (nếu có)
2. Hoặc tạo mới bằng cách:
   ```bash
   # Trên máy local
   EDITOR="code --wait" rails credentials:edit
   ```
   Sau đó lấy key từ file `config/master.key`

### Bước 6: Deploy

1. Railway sẽ tự động detect và build ứng dụng
2. Quá trình build sẽ:
   - Cài đặt Ruby dependencies (`bundle install`)
   - Cài đặt Node.js dependencies (`yarn install`)
   - Build assets (`yarn build`)
   - Precompile Rails assets (`rails assets:precompile`)
   - Chạy migrations (`rails db:migrate`) - từ Procfile release command

3. Sau khi build xong, ứng dụng sẽ tự động deploy

### Bước 7: Chạy Database Migrations

Migrations sẽ tự động chạy nhờ `release` command trong Procfile. Nếu cần chạy thủ công:

1. Vào project dashboard
2. Click vào service của bạn
3. Chọn tab **"Deployments"**
4. Click vào deployment mới nhất
5. Chọn **"View Logs"** để xem logs

Hoặc dùng Railway CLI:
```bash
railway run rails db:migrate
```

### Bước 8: Seed Database (Nếu Cần)

Nếu cần seed dữ liệu ban đầu:
```bash
railway run rails db:seed
```

### Bước 9: Cấu Hình Domain (Tùy Chọn)

1. Trong project dashboard, click vào service
2. Vào tab **"Settings"**
3. Scroll xuống **"Networking"**
4. Click **"Generate Domain"** để tạo domain miễn phí
5. Hoặc thêm custom domain của bạn

## Cấu Trúc Files Đã Tạo

### Procfile
File này định nghĩa các processes sẽ chạy:
- `web`: Web server (Puma)
- `release`: Chạy migrations trước khi deploy
- `worker`: Background job worker (delayed_job)

### railway.json
File cấu hình build và deploy cho Railway (tùy chọn, Railway có thể auto-detect)

### database.yml
Đã được cập nhật để sử dụng `DATABASE_URL` từ Railway

## Troubleshooting

### Lỗi Build

1. **Lỗi thiếu dependencies:**
   - Kiểm tra `Gemfile` và `package.json`
   - Đảm bảo Ruby version đúng (3.1.2)
   - Kiểm tra Node.js version trong Railway

2. **Lỗi assets:**
   - Đảm bảo `yarn build` chạy thành công
   - Kiểm tra `RAILS_SERVE_STATIC_FILES=true`

3. **Lỗi database:**
   - Kiểm tra `DATABASE_URL` đã được set
   - Đảm bảo PostgreSQL service đã được tạo
   - Kiểm tra migrations đã chạy

### Xem Logs

1. Trong Railway dashboard
2. Click vào service
3. Tab **"Deployments"** → chọn deployment → **"View Logs"**
4. Hoặc tab **"Metrics"** để xem real-time logs

### Restart Service

1. Vào service dashboard
2. Click **"Settings"**
3. Scroll xuống **"Danger Zone"**
4. Click **"Restart"**

## Lưu Ý Quan Trọng

1. **Secrets & Credentials:**
   - KHÔNG commit `config/master.key` lên Git
   - Sử dụng Railway environment variables cho sensitive data
   - Sử dụng `rails credentials:edit` để quản lý secrets

2. **Database:**
   - Railway tự động backup database
   - Có thể tạo snapshot từ dashboard
   - Database sẽ bị xóa nếu xóa service (trừ khi đã backup)

3. **Storage:**
   - Railway sử dụng ephemeral storage (mất dữ liệu khi restart)
   - Nên dùng external storage (S3, Cloudinary) cho uploads
   - Cập nhật `config/storage.yml` nếu cần

4. **Background Jobs:**
   - Worker process trong Procfile sẽ chạy delayed_job
   - Đảm bảo worker service đã được tạo và chạy

5. **Performance:**
   - Railway có free tier với giới hạn
   - Nên monitor usage trong dashboard
   - Có thể upgrade plan nếu cần

## Các Lệnh Hữu Ích

### Railway CLI

Cài đặt:
```bash
npm i -g @railway/cli
railway login
```

Các lệnh thường dùng:
```bash
# Link project
railway link

# Chạy lệnh Rails
railway run rails console
railway run rails db:migrate
railway run rails db:seed

# Xem logs
railway logs

# Xem variables
railway variables
```

## Tài Liệu Tham Khảo

- Railway Docs: https://docs.railway.app
- Rails Deployment: https://guides.rubyonrails.org/deployment.html
- Railway Pricing: https://railway.app/pricing

## Hỗ Trợ

Nếu gặp vấn đề:
1. Kiểm tra logs trong Railway dashboard
2. Xem Railway documentation
3. Kiểm tra Rails logs trong production environment

---

**Chúc bạn deploy thành công! 🚀**

