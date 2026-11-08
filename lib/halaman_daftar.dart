import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pm_pertemuan_07/format_tanggal.dart';
import 'package:pm_pertemuan_07/planner_model.dart';
import 'package:pm_pertemuan_07/tugas_kuliah.dart';
import 'package:provider/provider.dart';

enum FilterTugas {
  semua('Semua'),
  aktif('Aktif'),
  selesai('Selesai');

  const FilterTugas(this.label);
  final String label;

  bool cocok(TugasKuliah t) => switch (this) {
    FilterTugas.semua => true,
    FilterTugas.aktif => !t.selesai,
    FilterTugas.selesai => t.selesai,
  };
}

class HalamanDaftar extends StatefulWidget {
  const HalamanDaftar({super.key});

  @override
  State<HalamanDaftar> createState() => _HalamanDaftarState();
}

class _HalamanDaftarState extends State<HalamanDaftar> {
  // State lokal: filter hanya dipakai halaman ini, jadi cukup setState
  FilterTugas _filter = FilterTugas.semua;

  @override
  Widget build(BuildContext context) {
    // watch: halaman ini dibangun ulang setiap kali data tugas berubah
    final model = context.watch<PlannerModel>();
    final tampil = model.semua.where(_filter.cocok).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Planner Tugas'),
        centerTitle: true,
        scrolledUnderElevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/tambah'),
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 8,
                children: [
                  for (final f in FilterTugas.values)
                    FilterChip(
                      label: Text(f.label),
                      selected: _filter == f,
                      onSelected: (_) => setState(() => _filter = f),
                    ),
                ],
              ),
            ),
          ),
          Expanded(
            child: tampil.isEmpty
                ? KosongTugas(
                    pesan: _filter == FilterTugas.semua
                        ? 'Belum ada tugas'
                        : 'Tidak ada tugas di filter ${_filter.label}',
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
                    itemCount: tampil.length,
                    itemBuilder: (context, i) => KartuTugas(tugas: tampil[i]),
                  ),
          ),
        ],
      ),
    );
  }
}

class KosongTugas extends StatelessWidget {
  const KosongTugas({super.key, required this.pesan});

  final String pesan;

  @override
  Widget build(BuildContext context) {
    final warna = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.event_available, size: 64, color: warna.primary),
          const SizedBox(height: 12),
          Text(pesan, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}

class KartuTugas extends StatelessWidget {
  const KartuTugas({super.key, required this.tugas});

  final TugasKuliah tugas;

  @override
  Widget build(BuildContext context) {
    final warna = Theme.of(context).colorScheme;
    final teks = Theme.of(context).textTheme;
    final sekarang = DateTime.now();
    final hariIni = DateTime(sekarang.year, sekarang.month, sekarang.day);
    final terlambat = !tugas.selesai && tugas.tenggat.isBefore(hariIni);

    return Card(
      elevation: 0,
      color: warna.surfaceContainerLow,
      margin: const EdgeInsets.symmetric(vertical: 5),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(8, 4, 4, 4),
        leading: Checkbox(
          value: tugas.selesai,
          // read: dipakai di callback, tidak perlu mendengarkan perubahan
          onChanged: (nilai) => context.read<PlannerModel>().tandaiSelesai(
            tugas.id,
            selesai: nilai ?? false,
          ),
        ),
        title: Text(
          tugas.judul,
          style: teks.titleMedium?.copyWith(
            decoration: tugas.selesai ? TextDecoration.lineThrough : null,
            color: tugas.selesai ? warna.onSurfaceVariant : null,
          ),
        ),
        subtitle: Text(
          '${tugas.mataKuliah} · ${formatTanggal(tugas.tenggat)}'
          '${terlambat ? ' · Terlambat' : ''}',
          style: teks.bodySmall?.copyWith(
            color: terlambat ? warna.error : null,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          tooltip: 'Hapus',
          onPressed: () {
            final messenger = ScaffoldMessenger.of(context);
            context.read<PlannerModel>().hapus(tugas.id);
            messenger
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text('${tugas.judul} dihapus'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
          },
        ),
      ),
    );
  }
}
