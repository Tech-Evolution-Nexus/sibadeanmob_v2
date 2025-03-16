import 'package:flutter/material.dart';
import 'package:sibadeanmob_v2/services/auth_sevice.dart';
import 'package:sibadeanmob_v2/theme/theme.dart';
import 'package:sibadeanmob_v2/widgets/costum_scaffold1.dart';
import 'package:sibadeanmob_v2/views/auth/register.dart';
import 'package:sibadeanmob_v2/views/auth/aktivasi.dart';

class Verifikasi extends StatefulWidget {
  const Verifikasi({super.key});

  @override
  State<Verifikasi> createState() => _VerifikasiState();
}

class _VerifikasiState extends State<Verifikasi> {
  final TextEditingController nikController = TextEditingController();

  Future<void> _verifikasiNIK() async {
    String nik = nikController.text;
    if (nik.isEmpty) {
      _showAlertDialog("Peringatan", "Harap masukkan NIK Anda!", () {
        Navigator.pop(context);
      });
      return;
    }

    // Validasi panjang NIK (harus 16 digit)
    if (nik.length != 16) {
      _showAlertDialog("Peringatan", "NIK harus terdiri dari 16 digit.", () {
        Navigator.pop(context);
      });
      return;
    }

    // Menggunakan AuthService untuk melakukan verifikasi NIK
    AuthService authService = AuthService();
    var response = await authService.verifyNIK(nik);

    if (response != null) {
      if (response.containsKey('error')) {
        _showAlertDialog("Error", response['error'], () {
          Navigator.pop(context);
        });
      } else if (response.containsKey('message') &&
          response['message'] == 'NIK Terdaftar') {
        // Jika NIK terdaftar, masuk ke halaman aktivasi dan kirim NIK
        _showAlertDialog(
          "NIK Terdaftar",
          "NIK Anda sudah terdaftar. Silakan aktivasi akun Anda.",
          () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    Aktivasi(nik: nik), // Kirim NIK ke halaman aktivasi
              ),
            );
          },
        );
      } else {
        // Jika NIK belum terdaftar, masuk ke halaman register
        _showAlertDialog(
          "NIK Belum Terdaftar",
          "NIK Anda belum terdaftar. Silakan melakukan pendaftaran.",
          () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Register()),
            );
          },
        );
      }
    } else {
      // Jika request gagal, tampilkan error
      _showAlertDialog("Error", "Terjadi kesalahan. Coba lagi nanti.", () {
        Navigator.pop(context);
      });
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Verifikasi NIK Anda",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              "Masukkan Nomor Induk Kependudukan (NIK) untuk memverifikasi apakah Anda sudah terdaftar atau belum.",
              style: TextStyle(fontSize: 16, color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            TextField(
              controller: nikController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                labelText: "NIK",
                prefixIcon:
                    Icon(Icons.credit_card, color: lightColorScheme.primary),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _verifikasiNIK,
                child: const Text("Verifikasi"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
