
import 'package:flutter/material.dart';

import '../repositories/sesi_repository.dart';

class ModePenyerangScreen extends StatelessWidget {
  final List<SesiRepository> repositories;

  const ModePenyerangScreen({
    super.key,
    required this.repositories,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mode Penyerang'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Icon(
            Icons.security,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 12),
          const Text(
            'Simulasi Token Dicuri',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Halaman ini menunjukkan data sesi yang dapat '
            'dibaca melalui API repository aplikasi.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ...repositories.map(
            (repository) => Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: FutureBuilder(
                  future: repository.baca(),
                  builder: (context, snapshot) {
                    final sesi = snapshot.data;

                    return Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          repository.nama,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (snapshot.connectionState ==
                            ConnectionState.waiting)
                          const Text('Membaca sesi...')
                        else if (snapshot.hasError)
                          const Text('Gagal membaca sesi.')
                        else if (sesi == null)
                          const Text('Tidak ada sesi tersimpan.')
                        else ...[
                          const Text('Token yang terbaca:'),
                          const SizedBox(height: 4),
                          SelectableText(sesi.token),
                          const SizedBox(height: 8),
                          Text('Email: ${sesi.email}'),
                        ],
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Catatan: hasil bergantung pada repository dan '
            'sesi yang tersimpan saat halaman dibuka.',
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
