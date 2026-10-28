
import 'package:flutter_test/flutter_test.dart';
import '../lib/modul_06/services/auth_api.dart';

void main() {
  group('Pengujian AuthApi', () {
    test('Akun yang belum diaktivasi menghasilkan kode 403', () async {
      final api = AuthApi(
        tunda: Duration.zero,
      );

      expect(
        () => api.masuk(
          email: 'belumaktif@trpl.test',
          sandi: 'belajar123',
        ),
        throwsA(
          isA<AuthException>()
              .having((e) => e.kode, 'kode', 403)
              .having(
                (e) => e.pesan,
                'pesan',
                'Akun belum diaktivasi. Silakan aktivasi akun terlebih dahulu.',
              ),
        ),
      );
    });
  });
}
