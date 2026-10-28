
import '../../../modul_06/models/sesi_pengguna.dart';
import '../../../modul_06/services/sesi_memori.dart';
import 'sesi_repository.dart';

class MemoriSesiRepository implements SesiRepository {
  final SesiMemori _memori;

  MemoriSesiRepository(this._memori);

  @override
  String get nama => 'Memori';

  @override
  String get keterangan =>
      'Sesi hanya disimpan selama aplikasi berjalan.';

  @override
  bool get bertahanSetelahRestart => false;

  @override
  Future<SesiPengguna?> baca() async {
    return _memori.baca();
  }

  @override
  Future<void> simpan(SesiPengguna sesi) async {
    await _memori.simpan(sesi);
  }

  @override
  Future<void> hapus() async {
    await _memori.hapus();
  }

  @override
  Future<bool> adaSesi() async {
    return _memori.adaSesi;
  }

  @override
  Future<String?> intipMentah() async {
    return null;
  }
}
