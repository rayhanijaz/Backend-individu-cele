const express = require('express');
const pool = require('../db');

const router = express.Router();

// GET /api/warga - mendapatkan seluruh data warga
router.get('/', async (req, res) => {
  try {
    const result = await pool.query(
      'SELECT * FROM warga ORDER BY id_warga ASC'
    );
    res.status(200).json({
      message: 'Data warga berhasil ditampilkan',
      data: result.rows
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Gagal mengambil data warga' });
  }
});

// GET /api/warga/:id - mendapatkan satu data warga berdasarkan ID
router.get('/:id', async (req, res) => {
  const { id } = req.params;
  if (!/^\d+$/.test(id)) {
    return res.status(400).json({ message: 'ID warga harus berupa angka' });
  }

  try {
    const result = await pool.query(
      'SELECT * FROM warga WHERE id_warga = $1',
      [Number(id)]
    );

    if (result.rowCount === 0) {
      return res.status(404).json({ message: 'Data warga tidak ditemukan' });
    }

    res.status(200).json({
      message: 'Data warga berhasil ditemukan',
      data: result.rows[0]
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Gagal mengambil data warga' });
  }
});

// POST /api/warga - menambahkan data warga
router.post('/', async (req, res) => {
  const {
    nik, nama_lengkap, jenis_kelamin, tempat_lahir, tanggal_lahir,
    alamat, rt, rw, no_telepon, email, status_warga
  } = req.body;

  if (!nik || !nama_lengkap || !alamat) {
    return res.status(400).json({
      message: 'nik, nama_lengkap, dan alamat wajib diisi'
    });
  }

  try {
    const result = await pool.query(
      `INSERT INTO warga
       (nik, nama_lengkap, jenis_kelamin, tempat_lahir, tanggal_lahir,
        alamat, rt, rw, no_telepon, email, status_warga)
       VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,COALESCE($11, 'Aktif'))
       RETURNING *`,
      [
        nik, nama_lengkap, jenis_kelamin || null, tempat_lahir || null,
        tanggal_lahir || null, alamat, rt || null, rw || null,
        no_telepon || null, email || null, status_warga || null
      ]
    );

    res.status(201).json({
      message: 'Data warga berhasil ditambahkan',
      data: result.rows[0]
    });
  } catch (error) {
    console.error(error);
    if (error.code === '23505') {
      return res.status(409).json({ message: 'NIK sudah terdaftar' });
    }
    if (error.code === '23514' || error.code === '22001' || error.code === '22007') {
      return res.status(400).json({ message: 'Data tidak valid', detail: error.message });
    }
    res.status(500).json({ message: 'Gagal menambahkan data warga' });
  }
});

// PUT /api/warga/:id - memperbarui data warga berdasarkan ID
router.put('/:id', async (req, res) => {
  const { id } = req.params;
  if (!/^\d+$/.test(id)) {
    return res.status(400).json({ message: 'ID warga harus berupa angka' });
  }

  const {
    nik, nama_lengkap, jenis_kelamin, tempat_lahir, tanggal_lahir,
    alamat, rt, rw, no_telepon, email, status_warga
  } = req.body;

  if (!nik || !nama_lengkap || !alamat) {
    return res.status(400).json({
      message: 'nik, nama_lengkap, dan alamat wajib diisi'
    });
  }

  try {
    const result = await pool.query(
      `UPDATE warga SET
        nik=$1, nama_lengkap=$2, jenis_kelamin=$3, tempat_lahir=$4,
        tanggal_lahir=$5, alamat=$6, rt=$7, rw=$8, no_telepon=$9,
        email=$10, status_warga=$11, updated_at=CURRENT_TIMESTAMP
       WHERE id_warga=$12
       RETURNING *`,
      [
        nik, nama_lengkap, jenis_kelamin || null, tempat_lahir || null,
        tanggal_lahir || null, alamat, rt || null, rw || null,
        no_telepon || null, email || null, status_warga || 'Aktif',
        Number(id)
      ]
    );

    if (result.rowCount === 0) {
      return res.status(404).json({ message: 'Data warga tidak ditemukan' });
    }

    res.status(200).json({
      message: 'Data warga berhasil diperbarui',
      data: result.rows[0]
    });
  } catch (error) {
    console.error(error);
    if (error.code === '23505') {
      return res.status(409).json({ message: 'NIK sudah digunakan warga lain' });
    }
    res.status(500).json({ message: 'Gagal memperbarui data warga' });
  }
});

// DELETE /api/warga/:id - menghapus data warga berdasarkan ID
router.delete('/:id', async (req, res) => {
  const { id } = req.params;
  if (!/^\d+$/.test(id)) {
    return res.status(400).json({ message: 'ID warga harus berupa angka' });
  }

  try {
    const result = await pool.query(
      'DELETE FROM warga WHERE id_warga = $1 RETURNING *',
      [Number(id)]
    );

    if (result.rowCount === 0) {
      return res.status(404).json({ message: 'Data warga tidak ditemukan' });
    }

    res.status(200).json({
      message: 'Data warga berhasil dihapus',
      data: result.rows[0]
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Gagal menghapus data warga' });
  }
});

module.exports = router;
