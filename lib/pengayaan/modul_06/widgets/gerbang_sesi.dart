
import 'package:flutter/material.dart';

import '../../../modul_06/models/sesi_pengguna.dart';
import '../controllers/sesi_controller.dart';

class GerbangSesi extends StatelessWidget {
  final SesiController controller;
  final Widget Function(BuildContext context) halamanLogin;
  final Widget Function(
    BuildContext context,
    SesiPengguna sesi,
  ) halamanBeranda;

  const GerbangSesi({
    super.key,
    required this.controller,
    required this.halamanLogin,
    required this.halamanBeranda,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        switch (controller.status) {
          case StatusSesi.memeriksa:
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );

          case StatusSesi.masuk:
            final sesi = controller.sesi;

            if (sesi != null) {
              return halamanBeranda(context, sesi);
            }

            return halamanLogin(context);

          case StatusSesi.keluar:
          case StatusSesi.memproses:
          case StatusSesi.gagal:
          case StatusSesi.kedaluwarsa:
            return halamanLogin(context);
        }
      },
    );
  }
}
