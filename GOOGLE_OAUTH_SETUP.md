# Google OAuth Setup Guide

## Langkah-langkah Setup Google OAuth

### 1. Buat Google OAuth Application

1. Buka [Google Cloud Console](https://console.cloud.google.com/)
2. Buat project baru atau pilih project yang sudah ada
3. Buka "APIs & Services" > "Credentials"
4. Klik "Create Credentials" > "OAuth 2.0 Client IDs"
5. Pilih "Web application"
6. Isi nama aplikasi
7. Tambahkan Authorized redirect URIs:
   ```
   http://your-domain.com/login/google_callback
   https://your-domain.com/login/google_callback
   ```
8. Simpan Client ID dan Client Secret

### 2. Konfigurasi di Aplikasi

1. Buka file `application/config/config.php`
2. Isi konfigurasi berikut:
   ```php
   $config['google_client_id'] = 'your-google-client-id';
   $config['google_client_secret'] = 'your-google-client-secret';
   $config['google_redirect_uri'] = 'http://your-domain.com/login/google_callback';
   ```

### 3. Install Dependencies

Jalankan perintah berikut di server:
```bash
cd /var/www/academy-lms
composer install
```

### 4. Update Database Schema

Tambahkan kolom `google_id` ke tabel `users`:
```sql
ALTER TABLE `users` ADD COLUMN `google_id` VARCHAR(100) NULL AFTER `password`;
```

### 5. Tambahkan Tombol Login Google

Tambahkan tombol berikut di halaman login:
```html
<a href="<?php echo site_url('login/google_login'); ?>" class="btn btn-danger">
    <i class="fab fa-google"></i> Login with Google
</a>
```

## Catatan Keamanan

- Jangan pernah commit Client Secret ke repository
- Gunakan HTTPS di production
- Validasi domain di Google Console untuk keamanan

## Testing

1. Pastikan semua konfigurasi sudah benar
2. Coba akses `http://your-domain.com/login/google_login`
3. Anda akan diarahkan ke Google untuk authorize
4. Setelah authorize, akan kembali ke aplikasi dan otomatis login

## Troubleshooting

- **Error "invalid_client"**: Periksa Client ID dan Secret
- **Error "redirect_uri_mismatch"**: Pastikan redirect URI sama persis di Google Console dan config
- **Error 500**: Periksa apakah Google Client library sudah terinstall via composer
