
import 'package:flutter/material.dart';

import '../../modul_06/services/auth_api.dart';
import '../../modul_06/services/sesi_memori.dart';
import 'controllers/sesi_controller.dart';
import 'repositories/aman_sesi_repository.dart';
import 'repositories/memori_sesi_repository.dart';
import 'repositories/prefs_sesi_repository.dart';
import 'repositories/sesi_repository.dart';
import 'screens/beranda_pengayaan_screen.dart';
import 'screens/login_pengayaan_screen.dart';
import 'storage/penyimpanan_aman_platform.dart';
import 'widgets/gerbang_sesi.dart';

class Modul06PengayaanApp extends StatefulWidget {
  const Modul06PengayaanApp({super.key});

  @override
  State<Modul06PengayaanApp> createState() =>
      _Modul06PengayaanAppState();
}

class _Modul06PengayaanAppState
    extends State<Modul06PengayaanApp> {
  late final SesiMemori _memori;
  late final AuthApi _api;
  late final List<SesiRepository> _repositories;
  late SesiController _controller;

  int _pilihanPenyimpanan = 2;

  @override
  void initState() {
    super.initState();

    _memori = SesiMemori();
    _api = AuthApi();

    _repositories = [
      MemoriSesiRepository(_memori),
      PrefsSesiRepository(),
      AmanSesiRepository(PenyimpananAmanPlatform()),
    ];

    _controller = SesiController(
      api: _api,
      repository: _repositories[_pilihanPenyimpanan],
    );

    _controller.pulihkan();
  }

  void _gantiPenyimpanan(int pilihan) {
    if (pilihan == _pilihanPenyimpanan) {
      return;
    }

    setState(() {
      _pilihanPenyimpanan = pilihan;

      _controller.dispose();

      _controller = SesiController(
        api: _api,
        repository: _repositories[pilihan],
      );
    });

    _controller.pulihkan();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Modul 06 Fase B',
      theme: ThemeData(
        colorSchemeSeed: Colors.pink,
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Modul 06 Fase B'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 12),
              const Text(
                'Tempat penyimpanan sesi',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: SegmentedButton<int>(
                  segments: const [
                    ButtonSegment<int>(
                      value: 0,
                      label: Text('Memori'),
                      icon: Icon(Icons.memory),
                    ),
                    ButtonSegment<int>(
                      value: 1,
                      label: Text('Prefs'),
                      icon: Icon(Icons.storage),
                    ),
                    ButtonSegment<int>(
                      value: 2,
                      label: Text('Aman'),
                      icon: Icon(Icons.lock),
                    ),
                  ],
                  selected: {_pilihanPenyimpanan},
                  onSelectionChanged: (pilihan) {
                    _gantiPenyimpanan(pilihan.first);
                  },
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: GerbangSesi(
                  controller: _controller,
                  halamanLogin: (context) =>
                      LoginPengayaanScreen(
                    controller: _controller,
                  ),
                  halamanBeranda: (context, sesi) =>
                      BerandaPengayaanScreen(
                    controller: _controller,
                    sesi: sesi,
                    repositories: _repositories,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const Modul06PengayaanApp());
}
