
import 'package:flutter/material.dart';
import '../models/sesi_pengguna.dart';

class KartuSesi extends StatelessWidget {
  final SesiPengguna sesi;
  final DateTime sekarang;
  final VoidCallback? onKeluar;
  final bool sedangKeluar;
  final bool tampilkanToken;

  const KartuSesi({
    super.key,
    required this.sesi,
    required this.sekarang,
    this.onKeluar,
    this.sedangKeluar = false,
    this.tampilkanToken = false,
  });

  static String samarkanToken(String token) {
    if (token.isEmpty) return '(kosong)';
    if (token.length <= 6) return _titik(token.length);
    return '${token.substring(0, 6)}${_titik(12)}';
  }

  static String _titik(int jumlah) =>
      List<String>.filled(jumlah, '\u2022').join();

  static String formatWaktu(String iso) {
    const List<String> bulan = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
    ];

    final DateTime? waktu = DateTime.tryParse(iso);
    if (waktu == null) return 'tidak diketahui';

    final String jam = waktu.hour.toString().padLeft(2, '0');
    final String menit = waktu.minute.toString().padLeft(2, '0');

    return '${waktu.day} ${bulan[waktu.month - 1]} '
        '${waktu.year}, $jam:$menit';
  }

  static String formatSisa(Duration sisa) {
    if (sisa.inSeconds <= 0) return 'sudah berakhir';
    if (sisa.inMinutes < 1) return '${sisa.inSeconds} detik';
    if (sisa.inHours < 1) return '${sisa.inMinutes} menit';

    final int menit = sisa.inMinutes.remainder(60);
    return menit == 0
        ? '${sisa.inHours} jam'
        : '${sisa.inHours} jam $menit menit';
  }

  @override
  Widget build(BuildContext context) {
    final Duration sisa = sesi.sisaWaktu(sekarang);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.account_circle, size: 56),
            const SizedBox(height: 12),
            Text(
              sesi.nama,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text('Email: ${sesi.email}'),
            Text('Peran: ${SesiPengguna.labelPeran(sesi.peran)}'),
            Text('Waktu masuk: ${formatWaktu(sesi.masukPada)}'),
            Text('Sisa sesi: ${formatSisa(sisa)}'),
            const SizedBox(height: 8),
            Text(
              'Token: ${tampilkanToken ? sesi.token : samarkanToken(sesi.token)}',
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: sedangKeluar ? null : onKeluar,
                icon: sedangKeluar
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.logout),
                label: Text(sedangKeluar ? 'Keluar…' : 'Keluar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
