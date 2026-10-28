
import 'package:flutter_test/flutter_test.dart';
import 'package:modul_06_login_session/modul_06/modul_06_app.dart';

void main() {
  testWidgets('Aplikasi Modul 06 dapat dibuka', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const Modul06App());

    expect(find.text('Modul 06 — Login & Session Dasar'), findsOneWidget);

    await tester.pumpAndSettle();
  });
}
