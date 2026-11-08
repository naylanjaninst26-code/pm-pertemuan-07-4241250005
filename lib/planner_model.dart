import 'package:flutter/foundation.dart';
import 'package:pm_pertemuan_07/tugas_kuliah.dart';

// State bersama untuk seluruh halaman. Tidak ada UI di sini,
// jadi cukup flutter/foundation dan mudah diuji.
class PlannerModel extends ChangeNotifier {
  // Data privat: hanya bisa diubah lewat tambah(), tandaiSelesai(), dan hapus()
  final List<TugasKuliah> _tugas = [];
  int _idBerikut = 1;

  // Daftar tugas, diurutkan dari tenggat terdekat (hanya bisa dibaca)
  List<TugasKuliah> get semua {
    final salinan = [..._tugas];
    salinan.sort((a, b) => a.tenggat.compareTo(b.tenggat));
    return List.unmodifiable(salinan);
  }

  int get total => _tugas.length;
  int get jumlahSelesai => _tugas.where((t) => t.selesai).length;
  int get jumlahAktif => total - jumlahSelesai;
  double get persenSelesai => total == 0 ? 0 : jumlahSelesai / total * 100;

  // Mengembalikan id tugas baru. Input kosong ditolak dengan FormatException.
  int tambah({
    required String judul,
    required String mataKuliah,
    required DateTime tenggat,
  }) {
    final judulBersih = judul.trim();
    final mkBersih = mataKuliah.trim();
    if (judulBersih.isEmpty) {
      throw const FormatException('Judul tugas tidak boleh kosong');
    }
    if (mkBersih.isEmpty) {
      throw const FormatException('Mata kuliah tidak boleh kosong');
    }

    final id = _idBerikut++;
    _tugas.add(
      TugasKuliah(
        id: id,
        judul: judulBersih,
        mataKuliah: mkBersih,
        tenggat: tenggat,
      ),
    );
    notifyListeners(); // kabari semua halaman yang mendengarkan
    return id;
  }

  void tandaiSelesai(int id, {bool selesai = true}) {
    final indeks = _tugas.indexWhere((t) => t.id == id);
    if (indeks == -1) return; // id tidak ada: abaikan, tidak crash
    _tugas[indeks] = _tugas[indeks].copyWith(selesai: selesai);
    notifyListeners();
  }

  void hapus(int id) {
    final sebelum = _tugas.length;
    _tugas.removeWhere((t) => t.id == id);
    if (_tugas.length != sebelum) notifyListeners();
  }
}
