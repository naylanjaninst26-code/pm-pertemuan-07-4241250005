import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pm_pertemuan_07/format_tanggal.dart';
import 'package:pm_pertemuan_07/planner_model.dart';
import 'package:provider/provider.dart';

class HalamanTambah extends StatefulWidget {
  const HalamanTambah({super.key});

  @override
  State<HalamanTambah> createState() => _HalamanTambahState();
}

class _HalamanTambahState extends State<HalamanTambah> {
  // State lokal: isi form hanya dipakai halaman ini
  late final TextEditingController _judul;
  late final TextEditingController _mataKuliah;
  late DateTime _tenggat;

  @override
  void initState() {
    super.initState();
    // initState: dijalankan sekali, tempat membuat controller
    _judul = TextEditingController();
    _mataKuliah = TextEditingController();
    final sekarang = DateTime.now();
    _tenggat = DateTime(sekarang.year, sekarang.month, sekarang.day + 1);
  }

  @override
  void dispose() {
    // dispose: controller wajib dibersihkan agar tidak bocor memori
    _judul.dispose();
    _mataKuliah.dispose();
    super.dispose();
  }

  Future<void> _pilihTanggal() async {
    final sekarang = DateTime.now();
    final dipilih = await showDatePicker(
      context: context,
      initialDate: _tenggat,
      firstDate: DateTime(sekarang.year, sekarang.month, sekarang.day),
      lastDate: DateTime(sekarang.year + 2),
    );
    // Setelah await, pastikan halaman masih ada sebelum memakai setState
    if (dipilih == null || !mounted) return;
    setState(() => _tenggat = dipilih);
  }

  void _simpan() {
    final messenger = ScaffoldMessenger.of(context);
    try {
      context.read<PlannerModel>().tambah(
        judul: _judul.text,
        mataKuliah: _mataKuliah.text,
        tenggat: _tenggat,
      );
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Tugas ditambahkan'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      context.pop();
    } on FormatException catch (e) {
      // Model melempar error, halaman ini yang menangkap dan menampilkannya
      messenger.showSnackBar(
        SnackBar(content: Text(e.message), behavior: SnackBarBehavior.floating),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Tugas'),
        scrolledUnderElevation: 0,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextField(
                controller: _judul,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Judul tugas',
                  prefixIcon: Icon(Icons.edit_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _mataKuliah,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Mata kuliah',
                  prefixIcon: Icon(Icons.menu_book_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _pilihTanggal,
                icon: const Icon(Icons.event),
                label: Text('Tenggat: ${formatTanggal(_tenggat)}'),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _simpan,
                icon: const Icon(Icons.check),
                label: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
