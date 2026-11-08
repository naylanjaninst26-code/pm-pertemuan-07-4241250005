import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pm_pertemuan_07/halaman_daftar.dart';
import 'package:pm_pertemuan_07/halaman_statistik.dart';
import 'package:pm_pertemuan_07/halaman_tambah.dart';
import 'package:pm_pertemuan_07/planner_model.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    // Provider di atas pohon: semua halaman bisa mengakses PlannerModel
    ChangeNotifierProvider(
      create: (_) => PlannerModel(),
      child: const AplikasiPlanner(),
    ),
  );
}

// Satu-satunya warna yang ditulis langsung: warna dasar (seed) untuk tema.
const warnaDasar = Color(0xFF5C6BC0);

// Rute: / (daftar) dan /statistik ada di dalam kerangka navigasi,
// /tambah dibuka di atasnya sebagai halaman penuh
final _router = GoRouter(
  initialLocation: '/',
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text('404')),
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.explore_off, size: 64),
          const SizedBox(height: 16),
          Text(
            'Alamat ${state.uri} tidak ditemukan',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => context.go('/'),
            child: const Text('Kembali ke daftar'),
          ),
        ],
      ),
    ),
  ),
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => KerangkaNavigasi(shell: shell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const HalamanDaftar(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/statistik',
              builder: (context, state) => const HalamanStatistik(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/tambah',
      builder: (context, state) => const HalamanTambah(),
    ),
  ],
);

class AplikasiPlanner extends StatelessWidget {
  const AplikasiPlanner({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Planner Tugas Kuliah',
      routerConfig: _router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: warnaDasar),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: warnaDasar,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system,
    );
  }
}

class KerangkaNavigasi extends StatelessWidget {
  const KerangkaNavigasi({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    // select: kerangka ini hanya dibangun ulang bila jumlah tugas aktif berubah
    final aktif = context.select((PlannerModel m) => m.jumlahAktif);

    return Scaffold(
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: (indeks) => shell.goBranch(
          indeks,
          initialLocation: indeks == shell.currentIndex,
        ),
        destinations: [
          NavigationDestination(
            icon: Badge.count(
              count: aktif,
              isLabelVisible: aktif > 0,
              child: const Icon(Icons.checklist),
            ),
            label: 'Tugas',
          ),
          const NavigationDestination(
            icon: Icon(Icons.bar_chart),
            label: 'Statistik',
          ),
        ],
      ),
    );
  }
}
