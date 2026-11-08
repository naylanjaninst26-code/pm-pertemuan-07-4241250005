import 'package:material_ui/material_ui.dart';
import 'package:pm_pertemuan_07/planner_model.dart';
import 'package:provider/provider.dart';

class HalamanStatistik extends StatelessWidget {
  const HalamanStatistik({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<PlannerModel>();
    final warna = Theme.of(context).colorScheme;
    final teks = Theme.of(context).textTheme;
    final persen = model.persenSelesai;

    // Rekap per mata kuliah: total tugas dan yang sudah selesai
    final perMataKuliah = <String, ({int total, int selesai})>{};
    for (final t in model.semua) {
      final lama = perMataKuliah[t.mataKuliah] ?? (total: 0, selesai: 0);
      perMataKuliah[t.mataKuliah] = (
        total: lama.total + 1,
        selesai: lama.selesai + (t.selesai ? 1 : 0),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistik'),
        centerTitle: true,
        scrolledUnderElevation: 0,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  Expanded(
                    child: KotakAngka(angka: '${model.total}', label: 'Total'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: KotakAngka(
                      angka: '${model.jumlahSelesai}',
                      label: 'Selesai',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: KotakAngka(
                      angka: '${model.jumlahAktif}',
                      label: 'Aktif',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 0,
                margin: EdgeInsets.zero,
                color: warna.surfaceContainerLow,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Progres', style: teks.titleMedium),
                      const SizedBox(height: 12),
                      LinearProgressIndicator(
                        value: persen / 100,
                        minHeight: 10,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${persen.toStringAsFixed(0)}% selesai',
                        style: teks.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text('Per mata kuliah', style: teks.titleMedium),
              const SizedBox(height: 8),
              if (perMataKuliah.isEmpty)
                Text('Belum ada data.', style: teks.bodyMedium)
              else
                for (final e in perMataKuliah.entries)
                  Card(
                    elevation: 0,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: warna.surfaceContainerLow,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    child: ListTile(
                      title: Text(e.key),
                      trailing: Text(
                        '${e.value.selesai}/${e.value.total} selesai',
                        style: teks.labelLarge?.copyWith(color: warna.primary),
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

class KotakAngka extends StatelessWidget {
  const KotakAngka({super.key, required this.angka, required this.label});

  final String angka;
  final String label;

  @override
  Widget build(BuildContext context) {
    final warna = Theme.of(context).colorScheme;
    final teks = Theme.of(context).textTheme;
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: warna.primaryContainer,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Text(
              angka,
              style: teks.headlineMedium?.copyWith(
                color: warna.onPrimaryContainer,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              label,
              style: teks.bodySmall?.copyWith(color: warna.onPrimaryContainer),
            ),
          ],
        ),
      ),
    );
  }
}
