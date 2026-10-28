
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../modul_06/models/sesi_pengguna.dart';
import 'sesi_repository.dart';

class PrefsSesiRepository implements SesiRepository {
  static const String kunciSesi = 'sesi_pengguna';

  final Future<SharedPreferences> _prefs;

  PrefsSesiRepository({
    Future<SharedPreferences>? prefs,
  }) : _prefs = prefs ?? SharedPreferences.getInstance();

  @override
  String get nama => 'Prefs';

  @override
  String get keterangan =>
      'Sesi bertahan setelah restart, tetapi token dapat dibaca '
      'melalui API preferensi biasa.';

  @override
  bool get bertahanSetelahRestart => true;

  @override
  Future<SesiPengguna?> baca() async {
    final SharedPreferences prefs = await _prefs;
    final String? data = prefs.getString(kunciSesi);

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
    final SharedPreferences prefs = await _prefs;
    await prefs.setString(
      kunciSesi,
      jsonEncode(sesi.toJson()),
    );
  }

  @override
  Future<void> hapus() async {
    final SharedPreferences prefs = await _prefs;
    await prefs.remove(kunciSesi);
  }

  @override
  Future<bool> adaSesi() async {
    final SesiPengguna? sesi = await baca();
    return sesi != null;
  }

  @override
  Future<String?> intipMentah() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(kunciSesi);
  }
}
