-- Database SI-Desa
-- Jalankan file ini pada database PostgreSQL yang sudah dibuat.

CREATE TABLE warga (
    id_warga SERIAL PRIMARY KEY,
    nik VARCHAR(16) NOT NULL UNIQUE,
    nama_lengkap VARCHAR(100) NOT NULL,
    jenis_kelamin CHAR(1) CHECK (jenis_kelamin IN ('L', 'P')),
    tempat_lahir VARCHAR(100),
    tanggal_lahir DATE,
    alamat TEXT NOT NULL,
    rt VARCHAR(3),
    rw VARCHAR(3),
    no_telepon VARCHAR(20),
    email VARCHAR(100),
    status_warga VARCHAR(20) NOT NULL DEFAULT 'Aktif'
        CHECK (status_warga IN ('Aktif', 'Tidak Aktif', 'Pindah', 'Meninggal')),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE profil_warga (
    id_profil SERIAL PRIMARY KEY,
    id_warga INTEGER NOT NULL UNIQUE
        REFERENCES warga(id_warga) ON DELETE CASCADE,
    no_kk VARCHAR(16),
    agama VARCHAR(30),
    pekerjaan VARCHAR(100),
    pendidikan_terakhir VARCHAR(50),
    status_perkawinan VARCHAR(30),
    kewarganegaraan VARCHAR(30) DEFAULT 'WNI',
    golongan_darah VARCHAR(3),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE kategori_kegiatan (
    id_kategori SERIAL PRIMARY KEY,
    nama_kategori VARCHAR(80) NOT NULL UNIQUE,
    deskripsi TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE kegiatan (
    id_kegiatan SERIAL PRIMARY KEY,
    id_kategori INTEGER NOT NULL
        REFERENCES kategori_kegiatan(id_kategori) ON DELETE RESTRICT,
    nama_kegiatan VARCHAR(150) NOT NULL,
    deskripsi TEXT,
    lokasi VARCHAR(200) NOT NULL,
    tanggal_kegiatan DATE NOT NULL,
    waktu_mulai TIME,
    waktu_selesai TIME,
    status_kegiatan VARCHAR(20) NOT NULL DEFAULT 'Direncanakan'
        CHECK (status_kegiatan IN ('Direncanakan', 'Berlangsung', 'Selesai', 'Dibatalkan')),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE partisipasi_kegiatan (
    id_partisipasi SERIAL PRIMARY KEY,
    id_warga INTEGER NOT NULL
        REFERENCES warga(id_warga) ON DELETE CASCADE,
    id_kegiatan INTEGER NOT NULL
        REFERENCES kegiatan(id_kegiatan) ON DELETE CASCADE,
    tanggal_daftar TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status_pendaftaran VARCHAR(20) NOT NULL DEFAULT 'Terdaftar'
        CHECK (status_pendaftaran IN ('Terdaftar', 'Dibatalkan')),
    status_kehadiran VARCHAR(20) NOT NULL DEFAULT 'Belum Dikonfirmasi'
        CHECK (status_kehadiran IN ('Belum Dikonfirmasi', 'Hadir', 'Tidak Hadir', 'Izin')),
    keterangan TEXT,
    CONSTRAINT uq_partisipasi_warga_kegiatan UNIQUE (id_warga, id_kegiatan)
);

CREATE TABLE anggaran_kegiatan (
    id_anggaran SERIAL PRIMARY KEY,
    id_kegiatan INTEGER NOT NULL
        REFERENCES kegiatan(id_kegiatan) ON DELETE CASCADE,
    nama_pengeluaran VARCHAR(120) NOT NULL,
    jumlah NUMERIC(14,2) NOT NULL CHECK (jumlah >= 0),
    keterangan TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE fasilitas_kegiatan (
    id_fasilitas_kegiatan SERIAL PRIMARY KEY,
    id_kegiatan INTEGER NOT NULL
        REFERENCES kegiatan(id_kegiatan) ON DELETE CASCADE,
    nama_fasilitas VARCHAR(120) NOT NULL,
    jumlah INTEGER NOT NULL DEFAULT 1 CHECK (jumlah > 0),
    kondisi VARCHAR(40),
    keterangan TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_kegiatan_kategori ON kegiatan(id_kategori);
CREATE INDEX idx_partisipasi_warga ON partisipasi_kegiatan(id_warga);
CREATE INDEX idx_partisipasi_kegiatan ON partisipasi_kegiatan(id_kegiatan);
CREATE INDEX idx_anggaran_kegiatan ON anggaran_kegiatan(id_kegiatan);
CREATE INDEX idx_fasilitas_kegiatan ON fasilitas_kegiatan(id_kegiatan);

-- Data awal kategori (opsional)
INSERT INTO kategori_kegiatan (nama_kategori, deskripsi) VALUES
('Sosial', 'Kegiatan sosial dan kemasyarakatan'),
('Keamanan', 'Kegiatan keamanan dan ketertiban lingkungan'),
('Kesehatan', 'Kegiatan kesehatan masyarakat'),
('Lingkungan', 'Kegiatan kebersihan dan lingkungan desa');
