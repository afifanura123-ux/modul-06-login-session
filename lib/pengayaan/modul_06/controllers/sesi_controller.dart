
import 'package:flutter/foundation.dart';

import '../../../modul_06/models/sesi_pengguna.dart';
import '../../../modul_06/services/auth_api.dart';
import '../repositories/sesi_repository.dart';

enum StatusSesi {
  memeriksa,
  keluar,
  memproses,
  masuk,
  gagal,
  kedaluwarsa,
}

class SesiController extends ChangeNotifier {
  final AuthApi api;
  final SesiRepository repository;
  final DateTime Function() jam;

  StatusSesi _status = StatusSesi.memeriksa;
  SesiPengguna? _sesi;
  String? _pesan;

  SesiController({
    required this.api,
    required this.repository,
    DateTime Function()? jam,
  }) : jam = jam ?? DateTime.now;

  StatusSesi get status => _status;
  SesiPengguna? get sesi => _sesi;
  String? get pesan => _pesan;

  void _ubah(
    StatusSesi status, {
    SesiPengguna? sesi,
    String? pesan,
    bool bersihkanPesan = false,
  }) {
    _status = status;
    _sesi = sesi;

    if (bersihkanPesan) {
      _pesan = null;
    } else if (pesan != null) {
      _pesan = pesan;
    }

    notifyListeners();
  }

  Future<void> pulihkan() async {
    _ubah(StatusSesi.memeriksa, bersihkanPesan: true);

    try {
      final SesiPengguna? tersimpan = await repository.baca();

      if (tersimpan == null) {
        _ubah(StatusSesi.keluar);
        return;
      }

      if (tersimpan.sudahKedaluwarsa(jam())) {
        await repository.hapus();
        _ubah(
          StatusSesi.kedaluwarsa,
          pesan: 'Sesi Anda sudah berakhir. Silakan masuk kembali.',
        );
        return;
      }

      _ubah(StatusSesi.masuk, sesi: tersimpan);
    } catch (e) {
      _ubah(
        StatusSesi.gagal,
        pesan: 'Sesi gagal dipulihkan. Silakan coba lagi.',
      );
    }
  }

  Future<void> masuk({
    required String email,
    required String sandi,
  }) async {
    if (_status == StatusSesi.memproses) return;

    _ubah(StatusSesi.memproses, bersihkanPesan: true);

    try {
      final SesiPengguna hasil = await api.masuk(
        email: email,
        sandi: sandi,
      );

      await repository.simpan(hasil);

      _ubah(StatusSesi.masuk, sesi: hasil);
    } on AuthException catch (e) {
      _ubah(StatusSesi.gagal, pesan: e.pesan);
    } catch (e) {
      _ubah(
        StatusSesi.gagal,
        pesan: 'Terjadi kesalahan saat masuk. Coba lagi.',
      );
    }
  }

  Future<void> keluar() async {
    try {
      await repository.hapus();
      _ubah(StatusSesi.keluar, bersihkanPesan: true);
    } catch (e) {
      _ubah(
        StatusSesi.gagal,
        pesan: 'Gagal menghapus sesi. Coba lagi.',
      );
    }
  }

  Future<void> perbaruiSesi({
    Duration masaBerlaku = const Duration(hours: 2),
  }) async {
    final SesiPengguna? sekarang = _sesi;

    if (sekarang == null) return;

    if (sekarang.sudahKedaluwarsa(jam())) {
      await repository.hapus();
      _ubah(
        StatusSesi.kedaluwarsa,
        pesan: 'Sesi sudah berakhir dan tidak dapat diperbarui.',
      );
      return;
    }

    try {
      final SesiPengguna baru = await api.perbaruiSesi(
        sekarang,
        masaBerlaku: masaBerlaku,
      );

      await repository.simpan(baru);
      _ubah(StatusSesi.masuk, sesi: baru);
    } on AuthException catch (e) {
      _ubah(StatusSesi.gagal, pesan: e.pesan);
    } catch (e) {
      _ubah(
        StatusSesi.gagal,
        pesan: 'Gagal memperbarui sesi.',
      );
    }
  }
}
