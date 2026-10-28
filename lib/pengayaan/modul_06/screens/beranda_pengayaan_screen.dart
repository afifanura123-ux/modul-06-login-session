
import 'dart:async';

import 'package:flutter/material.dart';

import '../../../modul_06/models/sesi_pengguna.dart';
import '../controllers/sesi_controller.dart';
import '../repositories/sesi_repository.dart';
import '../widgets/papan_diagnostik_penyimpanan.dart';
import 'mode_penyerang_screen.dart';

class BerandaPengayaanScreen extends StatefulWidget {
  final SesiController controller;
  final SesiPengguna sesi;
  final List<SesiRepository> repositories;

  const BerandaPengayaanScreen({
    super.key,
    required this.controller,
    required this.sesi,
    required this.repositories,
  });

  @override
  State<BerandaPengayaanScreen> createState() =>
      _BerandaPengayaanScreenState();
}

class _BerandaPengayaanScreenState
    extends State<BerandaPengayaanScreen> {
  Timer? _timer;
  DateTime _sekarang = DateTime.now();

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        if (mounted) {
          setState(() {
            _sekarang = DateTime.now();
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatSisaWaktu() {
    final kedaluwarsa = DateTime.tryParse(
      widget.sesi.kedaluwarsaPada,
    );

    if (kedaluwarsa == null) {
      return 'Waktu sesi tidak valid';
    }

    final sisa = kedaluwarsa.difference(_sekarang);

    if (sisa.isNegative || sisa == Duration.zero) {
      return 'Sesi telah kedaluwarsa';
    }

    final jam = sisa.inHours;
    final menit = sisa.inMinutes.remainder(60);
    final detik = sisa.inSeconds.remainder(60);

    return 'Sisa waktu: '
        '${jam.toString().padLeft(2, '0')}:'
        '${menit.toString().padLeft(2, '0')}:'
        '${detik.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final kedaluwarsa = DateTime.tryParse(
      widget.sesi.kedaluwarsaPada,
    );

    final sisa = kedaluwarsa == null
        ? Duration.zero
        : kedaluwarsa.difference(_sekarang);

    final warnaSisaWaktu =
        sisa <= const Duration(minutes: 5)
            ? Colors.red
            : Colors.green;

    final repositoryAktif = widget.repositories.firstWhere(
      (repository) => repository.bertahanSetelahRestart,
      orElse: () => widget.repositories.first,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda Pengayaan'),
        actions: [
          IconButton(
            tooltip: 'Keluar',
            onPressed: widget.controller.keluar,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Icon(
            Icons.account_circle,
            size: 72,
          ),
          const SizedBox(height: 12),
          Text(
            'Selamat datang, ${widget.sesi.nama}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Informasi Sesi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('Nama: ${widget.sesi.nama}'),
                  const SizedBox(height: 8),
                  Text('Email: ${widget.sesi.email}'),
                  const SizedBox(height: 8),
                  Text('Repository: ${repositoryAktif.nama}'),
                  const SizedBox(height: 8),
                  Text(
                    'Kedaluwarsa: ${widget.sesi.kedaluwarsaPada}',
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _formatSisaWaktu(),
                    style: TextStyle(
                      color: warnaSisaWaktu,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: widget.controller.perbaruiSesi,
            icon: const Icon(Icons.refresh),
            label: const Text('Perbarui Sesi'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ModePenyerangScreen(
                    repositories: widget.repositories,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.security),
            label: const Text('Simulasi Token Dicuri'),
          ),
          const SizedBox(height: 20),
          PapanDiagnostikPenyimpanan(
            repositories: widget.repositories,
          ),
        ],
      ),
    );
  }
}
