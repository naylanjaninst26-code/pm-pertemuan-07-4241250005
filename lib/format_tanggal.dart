const _bulan = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'Mei',
  'Jun',
  'Jul',
  'Agu',
  'Sep',
  'Okt',
  'Nov',
  'Des',
];

// Contoh: 20 Nov 2026
String formatTanggal(DateTime d) => '${d.day} ${_bulan[d.month - 1]} ${d.year}';
