import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sibadeanmob_v2/helper/constant.dart';

class API {
  // Method POST untuk request ke API
  Future<http.Response> postRequest({
    required String route,
    required Map<String, String> data,
  }) async {
    String url = apiUrl + route;
    try {
      return await http.post(
        Uri.parse(url),
        body: jsonEncode(data),
        headers: _header(),
      );
    } catch (e) {
      print("Error: ${e.toString()}");
      return http.Response(jsonEncode({'error': e.toString()}), 500);
    }
  }

  // Login User
  Future<http.Response> loginUser({
    required String email,
    required String password,
  }) async {
    Map<String, String> data = {
      "email": email,
      "password": password,
    };

    return await postRequest(route: "/login", data: data);
  }

  // Register User
  Future<http.Response> registerUser({
    required String fullName,
    required String nik,
    required String noKk,
    required String tempatLahir,
    required String tanggalLahir,
    required String jenisKelamin,
    required String alamat,
    required String pekerjaan,
    required String agama,
    required String phone,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    Map<String, String> data = {
      "nama_lengkap": fullName,
      "nik": nik,
      "no_kk": noKk,
      "tempat_lahir": tempatLahir,
      "tanggal_lahir": tanggalLahir,
      "jenis_kelamin": jenisKelamin,
      "alamat": alamat,
      "pekerjaan": pekerjaan,
      "agama": agama,
      "no_hp": phone,
      "email": email,
      "password": password,
      "password_confirmation": confirmPassword,
    };

    return await postRequest(route: "/register", data: data);
  }

  // Header untuk request ke API
  Map<String, String> _header() {
    return {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
  }
}
