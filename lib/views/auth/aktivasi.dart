import 'package:flutter/material.dart';
import 'package:sibadeanmob_v2/services/auth_service.dart';
import 'package:sibadeanmob_v2/theme/theme.dart';
import 'package:sibadeanmob_v2/views/auth/splash.dart';
import 'package:sibadeanmob_v2/widgets/costum_scaffold1.dart';
import 'package:sibadeanmob_v2/widgets/costum_texfield.dart';

class Aktivasi extends StatefulWidget {
  final String nik; // Menerima NIK dari halaman sebelumnya

  const Aktivasi({super.key, required this.nik});

  @override
  State<Aktivasi> createState() => _AktivasiState();
}

class _AktivasiState extends State<Aktivasi> {
  final TextEditingController codeController = TextEditingController();
  bool _isLoading = false; // Tambahkan indikator loading

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar( // ✅ Perbaikan penulisan
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }
Future<void> _aktivasiAkun() async {
  String code = codeController.text.trim();
  
  if (code.isEmpty) {
    _showSnackBar("Harap masukkan kode aktivasi!", isError: true);
    return;
  }

  AuthService authService = AuthService();
  setState(() {
    _isLoading = true;
  });

  var response = await authService.aktivasiAkun(widget.nik, code); // ✅ Kirim kode aktivasi
  print("Response Aktivasi: $response");

  setState(() {
    _isLoading = false;
  });

  if (response != null && response is Map<String, dynamic>) {
    if (response.containsKey('error')) {
      _showSnackBar(response['error'], isError: true);
    } else {
      _showSnackBar("Akun Anda telah diaktivasi!", isError: false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Splash()),
      );
    }
  } else {
    _showSnackBar("Terjadi kesalahan. Coba lagi nanti.", isError: true);
  }
}
 @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Aktivasi Akun",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              "Masukkan kode aktivasi yang telah dikirim ke email atau nomor telepon Anda.",
              style: TextStyle(fontSize: 16, color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            TextField(
              controller: codeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                labelText: "Kode Aktivasi",
                prefixIcon: Icon(Icons.lock, color: lightColorScheme.primary),
                contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              ),
            ),

          CustomTextField(
          labelText: "Kode Aktivasi",
          hintText: "Masukkan kode aktivasi",
          controller: codeController,
          keyboardType: TextInputType.number,
          prefixIcon: Icons.vpn_key,
          validator: (value) =>
              value!.isEmpty ? 'Masukkan kode aktivasi Anda' : null,
        ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _aktivasiAkun,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Aktivasi Akun"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
