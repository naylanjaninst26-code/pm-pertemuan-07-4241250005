import 'package:flutter_test/flutter_test.dart';
import 'package:pm_pertemuan_07/planner_model.dart';

void main() {
  late PlannerModel model;
  final tenggat = DateTime(2026, 11, 20);

  setUp(() {
    model = PlannerModel();
  });

  test('tambah menyimpan tugas dan memberi tahu pendengar', () {
    var dipanggil = 0;
    model.addListener(() => dipanggil++);

    model.tambah(
      judul: 'Laporan praktikum',
      mataKuliah: 'Pemrograman Mobile',
      tenggat: tenggat,
    );

    expect(model.total, 1);
    expect(model.jumlahAktif, 1);
    expect(dipanggil, 1);
  });

  test('judul kosong ditolak dan data tidak berubah', () {
    expect(
      () => model.tambah(
        judul: '   ',
        mataKuliah: 'Basis Data',
        tenggat: tenggat,
      ),
      throwsFormatException,
    );
    expect(model.total, 0);
  });

  test('tandaiSelesai mengubah status dan persentase', () {
    final id = model.tambah(
      judul: 'Makalah',
      mataKuliah: 'Etika Profesi',
      tenggat: tenggat,
    );
    model.tambah(
      judul: 'Soal latihan',
      mataKuliah: 'Statistika',
      tenggat: tenggat,
    );

    model.tandaiSelesai(id);

    expect(model.jumlahSelesai, 1);
    expect(model.jumlahAktif, 1);
    expect(model.persenSelesai, 50);
  });

  test('hapus menghapus tugas yang dipilih saja', () {
    final id = model.tambah(
      judul: 'Resume bab 3',
      mataKuliah: 'Jaringan Komputer',
      tenggat: tenggat,
    );
    model.tambah(
      judul: 'Kuis daring',
      mataKuliah: 'Statistika',
      tenggat: tenggat,
    );

    model.hapus(id);

    expect(model.total, 1);
    expect(model.semua.first.judul, 'Kuis daring');
  });

  test('persentase 0 ketika belum ada tugas', () {
    expect(model.persenSelesai, 0);
  });

  test('daftar diurutkan dari tenggat terdekat', () {
    model.tambah(
      judul: 'Tugas akhir',
      mataKuliah: 'Pemrograman Mobile',
      tenggat: DateTime(2026, 12, 1),
    );
    model.tambah(
      judul: 'Kuis',
      mataKuliah: 'Basis Data',
      tenggat: DateTime(2026, 11, 15),
    );

    expect(model.semua.first.judul, 'Kuis');
  });
}
