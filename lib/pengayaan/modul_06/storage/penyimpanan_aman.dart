
abstract class PenyimpananAman {
  Future<void> tulis(String kunci, String nilai);

  Future<String?> baca(String kunci);

  Future<void> hapus(String kunci);

  /// Demonstrasi batas API penyimpanan.
  Future<String?> bacaMentah(String kunci);
}
