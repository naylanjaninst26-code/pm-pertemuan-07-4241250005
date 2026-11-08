// Data satu tugas kuliah. Immutable: untuk mengubah, buat salinan lewat copyWith.
class TugasKuliah {
  const TugasKuliah({
    required this.id,
    required this.judul,
    required this.mataKuliah,
    required this.tenggat,
    this.selesai = false,
  });

  final int id;
  final String judul;
  final String mataKuliah;
  final DateTime tenggat;
  final bool selesai;

  TugasKuliah copyWith({bool? selesai}) => TugasKuliah(
    id: id,
    judul: judul,
    mataKuliah: mataKuliah,
    tenggat: tenggat,
    selesai: selesai ?? this.selesai,
  );
}
