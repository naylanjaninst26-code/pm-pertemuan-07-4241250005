import 'package:flutter_test/flutter_test.dart';
import 'package:pm_pertemuan_07/main.dart';
import 'package:pm_pertemuan_07/planner_model.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('Halaman daftar kosong menampilkan pesan awal', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => PlannerModel(),
        child: const AplikasiPlanner(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Belum ada tugas'), findsOneWidget);
  });
}
