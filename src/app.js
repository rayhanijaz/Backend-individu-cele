const express = require('express');
const wargaRoutes = require('./routes/warga');

const app = express();

app.use(express.json());

app.get('/', (req, res) => {
  res.json({ message: 'REST API SI-Desa aktif' });
});

app.use('/api/warga', wargaRoutes);

module.exports = app;
