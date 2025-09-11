# Custom Domain Setup Guide

## Langkah-langkah Setup Custom Domain dengan Nginx

### 1. **Persiapan Domain**
- Beli domain dari registrar (Namecheap, GoDaddy, dll)
- Point DNS A record ke IP server Anda:
  ```
  A record: @ -> IP_SERVER_ANDA
  A record: www -> IP_SERVER_ANDA
  ```

### 2. **Update Konfigurasi Nginx**
Edit file `nginx/sites/default.conf`:
```bash
# Ganti "yourdomain.com" dengan domain Anda yang sebenarnya
sed -i 's/yourdomain.com/DOMAIN_ANDA.com/g' nginx/sites/default.conf
```

### 3. **Deploy dengan Nginx**
```bash
# Stop container yang sedang berjalan
docker-compose down

# Start dengan konfigurasi production (Nginx)
docker-compose -f docker-compose.prod.yml up --build -d
```

### 4. **Setup SSL Certificate (HTTPS)**
```bash
# Jalankan script SSL setup
chmod +x setup-ssl.sh
./setup-ssl.sh DOMAIN_ANDA.com
```

### 5. **Update CodeIgniter Base URL**
Edit `application/config/config.php`:
```php
$config['base_url'] = 'https://DOMAIN_ANDA.com/';
```

## Arsitektur Final:

```
Internet → Nginx (Port 80/443) → Apache+PHP (Internal) → MySQL (Port 3307)
```

## Keuntungan Setup Nginx:

✅ **Professional URLs**: `https://yourdomain.com` (tanpa port)  
✅ **SSL/HTTPS**: Otomatis dengan Let's Encrypt  
✅ **Performance**: Nginx handle static files, cache, compression  
✅ **Security**: Rate limiting, DDoS protection  
✅ **Scalability**: Bisa tambah multiple domains/subdomain  

## Testing:

1. **HTTP**: `http://yourdomain.com`
2. **HTTPS**: `https://yourdomain.com` (setelah SSL setup)
3. **Database**: Masih bisa diakses eksternal di `IP:3307`

## Troubleshooting:

- **Domain tidak bisa diakses**: Cek DNS propagation (bisa 24 jam)
- **SSL error**: Pastikan domain sudah pointing ke server
- **500 error**: Cek logs dengan `docker-compose logs nginx web`
