# Backend SI-Desa

REST API sederhana untuk Sistem Informasi Kegiatan dan Layanan Warga Desa menggunakan Express.js dan PostgreSQL.

## 1. Persiapan database

1. Buat database PostgreSQL dengan nama `si_desa`.
2. Jalankan file `database/schema.sql` melalui pgAdmin atau SQL Shell (psql).
3. Pastikan tabel `warga`, `profil_warga`, `kategori_kegiatan`, `kegiatan`, `partisipasi_kegiatan`, `anggaran_kegiatan`, dan `fasilitas_kegiatan` sudah terbentuk.

## 2. Menjalankan project

```bash
npm install
```

Salin `.env.example` menjadi `.env`, kemudian sesuaikan konfigurasi PostgreSQL, terutama `DB_USER`, `DB_PASSWORD`, dan `DB_NAME`.

```bash
npm run dev
```

Server berjalan pada `http://localhost:3000`.

## 3. Endpoint REST API

| Metode | URL | Fungsi |
|---|---|---|
| GET | `http://localhost:3000/api/warga` | Menampilkan semua warga |
| GET | `http://localhost:3000/api/warga/1` | Menampilkan warga berdasarkan ID |
| POST | `http://localhost:3000/api/warga` | Menambahkan warga |
| PUT | `http://localhost:3000/api/warga/1` | Memperbarui warga berdasarkan ID |
| DELETE | `http://localhost:3000/api/warga/1` | Menghapus warga berdasarkan ID |

### Contoh body POST dan PUT (Postman > Body > raw > JSON)

```json
{
  "nik": "3401010101010001",
  "nama_lengkap": "Budi Santoso",
  "jenis_kelamin": "L",
  "tempat_lahir": "Bantul",
  "tanggal_lahir": "2000-01-01",
  "alamat": "Dusun Sumber, Desa Contoh",
  "rt": "001",
  "rw": "002",
  "no_telepon": "081234567890",
  "email": "budi@example.com",
  "status_warga": "Aktif"
}
```

Untuk pengujian PUT, gunakan body JSON yang sama dan ganti nilai sesuai data yang ingin diperbarui.

## 4. Import ke dbdiagram.io

1. Buka https://dbdiagram.io.
2. Buat diagram baru.
3. Pilih fitur import PostgreSQL atau tempelkan definisi tabel yang sesuai.
4. Salin struktur dari `database/schema.sql`. Jika import SQL lengkap tidak diterima, masukkan definisi tabel satu per satu menggunakan sintaks DBML.
5. Simpan diagram dan atur akses menjadi publik, lalu salin tautan diagram.

## 5. Screenshot Postman

Ambil screenshot untuk masing-masing:
1. POST: respons `201 Created`.
2. GET semua data: respons `200 OK`.
3. GET berdasarkan ID: respons `200 OK`.
4. PUT: respons `200 OK`.
5. DELETE: respons `200 OK`.

Lakukan GET berdasarkan ID sebelum PUT dan DELETE untuk memastikan ID yang digunakan tersedia.

## 6. Pengumpulan

Jangan sertakan folder `node_modules` dan file `.env`. File `.env.example` boleh disertakan sebagai contoh konfigurasi. Pastikan repository GitHub diatur Public jika memilih pengumpulan melalui GitHub.
