# Academy LMS - Learning Management System

Ini adalah repositori untuk Academy LMS, sebuah platform manajemen pembelajaran yang dibangun menggunakan CodeIgniter 3. Aplikasi ini memungkinkan pengelolaan kursus, pelajaran, siswa, dan instruktur secara online.

## Fitur Utama

* Manajemen Kursus dan Pelajaran
* Portal untuk Siswa dan Instruktur
* Sistem Pendaftaran dan Login Pengguna
* Berbagai Pilihan Metode Pembayaran
* Blog dan Manajemen Halaman Statis
* Panel Administrasi untuk Pengelolaan Sistem

## Persyaratan Server

* PHP versi 7.2 atau lebih tinggi
* Ekstensi PHP: intl, json, mbstring, mysqlnd
* Database MySQL atau MariaDB
* Web Server (Apache, Nginx, atau sejenisnya)
* Composer untuk manajemen dependensi

## Panduan Instalasi

1. **Clone Repositori**

   ```bash
   git clone https://github.com/mulmeddrwcorp/drwacademy-lms.git
   cd academy-lms
   ```

2. **Install Dependensi**

   Pastikan Anda memiliki [Composer](https://getcomposer.org/) terinstal, lalu jalankan perintah berikut:

   ```bash
   composer install
   ```

3. **Konfigurasi Database**

   * Buat sebuah database baru di server MySQL Anda.
   * Karena file `uploads/install.sql` tidak disertakan di repositori ini, Anda perlu mengimpornya secara manual dari backup yang Anda miliki.
   * Buka file `application/config/database.php` dan sesuaikan konfigurasi berikut dengan detail koneksi database Anda:

     ```php
     'hostname' => 'localhost',
     'username' => 'root',
     'password' => '',
     'database' => 'nama_database_anda',
     ```

4. **Konfigurasi Aplikasi**

   * Buka file `application/config/config.php` dan atur `base_url` sesuai dengan domain atau alamat lokal Anda:

     ```php
     $config['base_url'] = 'http://localhost/academy-lms';
     ```

   * Pastikan direktori `application/cache` dan `uploads` dapat ditulis (writable) oleh server.

5. **Jalankan Aplikasi**

   Arahkan browser Anda ke `base_url` yang telah Anda konfigurasikan. Halaman login atau beranda seharusnya sudah dapat diakses.

## Struktur Direktori

* `application/`: Berisi inti dari aplikasi CodeIgniter (controllers, models, views, config, dll).
* `assets/`: Berisi file-file statis seperti CSS, JavaScript, dan gambar.
* `system/`: Berisi file-file inti dari framework CodeIgniter.
* `uploads/`: Direktori untuk file yang diunggah oleh pengguna (gambar, dokumen, dll).
* `vendor/`: Direktori untuk dependensi yang dikelola oleh Composer.

## Lingkungan

Anda dapat mengatur lingkungan aplikasi (misalnya, `development`, `production`) di file `index.php` pada baris berikut:

```php
define('ENVIRONMENT', isset($_SERVER['CI_ENV']) ? $_SERVER['CI_ENV'] : 'development');
```
