import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = "http://10.0.2.2:8000/api";

  Future<Map<String, dynamic>?> register({
    required String nama,
    required String nik,
    required String email,
    required String password,
    required String role,
    required String namaAyah,
    required String namaIbu,
    required String jenisKelamin,
    required String alamat,
    required String tglLahir,
    required String agama,
    required String pendidikan,
    required String rt,
    required String rw,
    String? kkGambar,
  }) async {
    try {
      var request = http.MultipartRequest("POST", Uri.parse("$baseUrl/register"));
      request.fields['nama'] = nama;
      request.fields['nik'] = nik;
      request.fields['email'] = email;
      request.fields['password'] = password;
      request.fields['password_confirmation'] = password;
      request.fields['role'] = role;
      request.fields['nama_ayah'] = namaAyah;
      request.fields['nama_ibu'] = namaIbu;
      request.fields['jenis_kelamin'] = jenisKelamin;
      request.fields['alamat'] = alamat;
      request.fields['tgl_lahir'] = tglLahir;
      request.fields['agama'] = agama;
      request.fields['pendidikan'] = pendidikan;
      request.fields['rt'] = rt;
      request.fields['rw'] = rw;

      if (kkGambar != null) {
        request.files.add(await http.MultipartFile.fromPath('kk_gambar', kkGambar));
      }

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        return jsonDecode(responseBody);
      } else {
        return jsonDecode(responseBody);
      }
    } catch (e) {
      return {"error": "Terjadi kesalahan, silakan coba lagi"};
    }
  }

  Future<Map<String, dynamic>?> login(String nik, String password) async {
  try {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "nik": nik,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  } catch (e) {
    return null;
  }
}

Future<Map<String, dynamic>?> verifyNIK(String nik) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/verify-nik"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"nik": nik}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {"error": "NIK tidak ditemukan"};
      }
    } catch (e) {
      return {"error": "Terjadi kesalahan, silakan coba lagi"};
    }
  }

  Future<Map<String, dynamic>?> activateAccount(String nik, String activationCode) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/activate-account"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "nik": nik,
          "activation_code": activationCode,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {"error": "Aktivasi gagal. Kode tidak valid."};
      }
    } catch (e) {
      return {"error": "Terjadi kesalahan, silakan coba lagi"};
    }
  }
}

