
import 'dart:convert';

import '../../../modul_06/models/sesi_pengguna.dart';
import '../storage/penyimpanan_aman.dart';
import 'sesi_repository.dart';

class AmanSesiRepository implements SesiRepository {
  static const String kunciSesi = 'sesi_pengguna';

  final PenyimpananAman penyimpanan;

  AmanSesiRepository(this.penyimpanan);

  @override
  String get nama => 'Aman';

  @override
  String get keterangan =>
      'Sesi disimpan melalui API secure storage. '
      'Perlindungan aktual bergantung pada platform dan konfigurasi.';

  @override
  bool get bertahanSetelahRestart => true;

  @override
  Future<SesiPengguna?> baca() async {
    final String? data = await penyimpanan.baca(kunciSesi);

    if (data == null) return null;

    try {
      final dynamic hasil = jsonDecode(data);

      if (hasil is! Map<String, dynamic>) {
        await hapus();
        return null;
      }

      return SesiPengguna.fromJson(hasil);
    } on FormatException {
      await hapus();
      return null;
    }
  }

  @override
  Future<void> simpan(SesiPengguna sesi) async {
    await penyimpanan.tulis(
      kunciSesi,
      jsonEncode(sesi.toJson()),
    );
  }

  @override
  Future<void> hapus() async {
    await penyimpanan.hapus(kunciSesi);
  }

  @override
  Future<bool> adaSesi() async {
    final SesiPengguna? sesi = await baca();
    return sesi != null;
  }

  @override
  Future<String?> intipMentah() async {
    return penyimpanan.bacaMentah(kunciSesi);
  }
}
