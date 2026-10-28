
import 'package:flutter/material.dart';
import '../repositories/sesi_repository.dart';

class PapanDiagnostikPenyimpanan extends StatelessWidget {
  final List<SesiRepository> repositories;

  const PapanDiagnostikPenyimpanan({
    super.key,
    required this.repositories,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Diagnostik Penyimpanan Sesi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...repositories.map(
              (repository) => ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(repository.nama),
                subtitle: Text(repository.keterangan),
                trailing: Icon(
                  repository.bertahanSetelahRestart
                      ? Icons.save
                      : Icons.memory,
                ),
              ),
            ),
            const Divider(),
            const Text(
              'Intip data mentah digunakan untuk demonstrasi '
              'batas API, bukan pemeriksaan forensik perangkat.',
              style: TextStyle(fontSize: 12),
            ),
            ...repositories.map(
              (repository) => FutureBuilder<String?>(
                future: repository.intipMentah(),
                builder: (context, snapshot) {
                  final data = snapshot.data;

                  return ListTile(
                    dense: true,
                    title: Text('${repository.nama} — data mentah'),
                    subtitle: Text(
                      snapshot.connectionState ==
                              ConnectionState.waiting
                          ? 'Memeriksa...'
                          : data == null
                              ? 'Tidak tersedia melalui API ini'
                              : data,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
