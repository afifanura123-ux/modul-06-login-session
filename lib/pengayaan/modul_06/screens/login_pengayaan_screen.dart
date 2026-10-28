
import 'package:flutter/material.dart';

import '../controllers/sesi_controller.dart';

class LoginPengayaanScreen extends StatefulWidget {
  final SesiController controller;

  const LoginPengayaanScreen({
    super.key,
    required this.controller,
  });

  @override
  State<LoginPengayaanScreen> createState() =>
      _LoginPengayaanScreenState();
}

class _LoginPengayaanScreenState
    extends State<LoginPengayaanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _sandiController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _sandiController.dispose();
    super.dispose();
  }

  Future<void> _masuk() async {
    if (!_formKey.currentState!.validate()) return;

    await widget.controller.masuk(
      email: _emailController.text.trim(),
      sandi: _sandiController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final warna = Theme.of(context).colorScheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 20,
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 500,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  Icons.shield_outlined,
                  size: 64,
                  color: warna.primary,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Masuk – Fase B',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Alur login-nya sama. Yang berbeda '
                  'hanya tempat menyimpan sesinya.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: warna.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 28),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email wajib diisi';
                    }
                    if (!value.contains('@')) {
                      return 'Masukkan email yang valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _sandiController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Kata sandi',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Kata sandi wajib diisi';
                    }
                    if (value.length < 6) {
                      return 'Minimal 6 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AnimatedBuilder(
                  animation: widget.controller,
                  builder: (context, child) {
                    final sedangMemproses =
                        widget.controller.status ==
                            StatusSesi.memproses;

                    return Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.stretch,
                      children: [
                        if (widget.controller.pesan != null) ...[
                          Text(
                            widget.controller.pesan!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: warna.error,
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                        SizedBox(
                          height: 44,
                          child: ElevatedButton(
                            onPressed: sedangMemproses
                                ? null
                                : _masuk,
                            child: sedangMemproses
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child:
                                        CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text('Masuk'),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
