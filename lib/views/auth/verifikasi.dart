import 'package:flutter/material.dart';
import 'package:sibadeanmob_v2/services/auth_service.dart'; // Perbaiki typo pada import
import 'package:sibadeanmob_v2/theme/theme.dart';
import 'package:sibadeanmob_v2/widgets/costum_button.dart';
import 'package:sibadeanmob_v2/widgets/costum_scaffold1.dart';
import 'package:sibadeanmob_v2/views/auth/register.dart';
import 'package:sibadeanmob_v2/views/auth/aktivasi.dart';
import 'package:sibadeanmob_v2/widgets/costum_texfield.dart';

class Verifikasi extends StatefulWidget {
  const Verifikasi({super.key});

  @override
  State<Verifikasi> createState() => _VerifikasiState();
}

class _VerifikasiState extends State<Verifikasi> {
  final TextEditingController nikController = TextEditingController();

  Future<void> verifikasiNik() async {
    String nik = nikController.text.trim();

    if (nik.isEmpty) {
      _showAlertDialog("Peringatan", "Harap masukkan NIK Anda!");
      return;
    }

    if (nik.length != 16) {
      _showAlertDialog("Peringatan", "NIK harus terdiri dari 16 digit.");
      return;
    }

    AuthService authService = AuthService();
    var response = await authService.verifikasiNik(nik);
    print("Response dari API: $response"); // Debugging

    if (response != null && response is Map<String, dynamic>) {
      if (response.containsKey('error')) {
        _showAlertDialog("Error", response['error']);
      } else if (response['message'] == 'NIK ditemukan') {
        _showAlertDialog(
          "NIK Terdaftar",
          "NIK Anda sudah terdaftar. Silakan aktivasi akun Anda.",
          onConfirm: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Aktivasi(nik: nik)),
            );
          },
        );
      } else {
        _showAlertDialog(
          "NIK Belum Terdaftar",
          "NIK Anda belum terdaftar. Silakan melakukan pendaftaran.",
          onConfirm: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegisterScreen()),
            );
          },
        );
      }
    } else {
      _showAlertDialog("Error", "Terjadi kesalahan. Coba lagi nanti.");
    }
  }

  void _showAlertDialog(String title, String message,
      {VoidCallback? onConfirm}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (onConfirm != null) onConfirm();
            },
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
            const SizedBox(height: 30.0),

            // Input NIK
            CustomTextField(
              labelText: "Nomor Induk Kependudukan",
              hintText: "Masukkan NIK",
              controller: nikController,
              keyboardType: TextInputType.number,
              prefixIcon: Icons.card_membership,
              validator: (value) => value!.isEmpty ? 'Masukkan NIK Anda' : null,
            ),
            const SizedBox(height: 20),

            // Tombol Verifikasi
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: 'Verifikasi', // Perbaiki typo pada teks tombol
                onPressed: verifikasiNik,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
