import 'package:flutter/material.dart';
import 'package:sibadeanmob_v2/services/auth_sevice.dart';
import 'package:sibadeanmob_v2/theme/theme.dart';
import 'package:sibadeanmob_v2/views/auth/splash.dart';
import 'package:sibadeanmob_v2/widgets/costum_scaffold1.dart';

class Aktivasi extends StatefulWidget {
  final String nik; // Terima nik dari halaman sebelumnya

  const Aktivasi({super.key, required this.nik}); // Pastikan nik dikirimkan saat berpindah halaman

  @override
  State<Aktivasi> createState() => _AktivasiState();
}

class _AktivasiState extends State<Aktivasi> {
  final TextEditingController codeController = TextEditingController();

  void _showAlertDialog(String title, String message, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: onConfirm,
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  Future<void> _activateAccount() async {
    if (codeController.text.isEmpty) {
      _showAlertDialog("Peringatan", "Harap masukkan kode aktivasi!", () {
        Navigator.pop(context);
      });
      return;
    }

    String activationCode = codeController.text;

    // Menggunakan AuthService untuk aktivasi akun
    AuthService authService = AuthService();
    var response = await authService.activateAccount(widget.nik, activationCode); // Gunakan nik yang diterima

    if (response != null) {
      if (response.containsKey('error')) {
        _showAlertDialog("Gagal", response['error'], () {
          Navigator.pop(context);
        });
      } else {
        // Jika aktivasi berhasil, tampilkan pesan dan navigasi ke halaman splash
        _showAlertDialog(
          "Aktivasi Berhasil",
          "Akun Anda telah diaktivasi. Anda akan diarahkan ke dashboard.",
          () {
            Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Splash()),
            );
          },
        );
      }
    } else {
      _showAlertDialog("Error", "Terjadi kesalahan. Coba lagi nanti.", () {
        Navigator.pop(context);
      });
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
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              "Masukkan kode aktivasi yang telah dikirimkan ke email atau nomor telepon Anda.",
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
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                labelText: "Kode Aktivasi",
                prefixIcon: Icon(Icons.lock, color: lightColorScheme.primary),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _activateAccount,
                child: const Text("Aktivasi Akun"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
