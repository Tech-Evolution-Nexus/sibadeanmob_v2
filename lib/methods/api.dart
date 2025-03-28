import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

import 'package:sibadeanmob_v2/helper/constant.dart';

class API {
  get baseUrl => null;

  // Request POST umum
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

  // Login User menggunakan NIK
  Future<http.Response> loginUser({
    required String nik, // Ubah dari email ke nik
    required String password,
  }) async {
    Map<String, String> data = {
      "nik": nik, // Sesuai dengan API Laravel
      "password": password,
    };

    return await postRequest(route: "/login", data: data);
  }

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
    required dynamic kkGambar, // Bisa File atau Uint8List untuk Web
  }) async {
    var url = Uri.parse("$apiUrl/register");
    var request = http.MultipartRequest("POST", url);

    request.fields["nama_lengkap"] = fullName;
    request.fields["nik"] = nik;
    request.fields["no_kk"] = noKk;
    request.fields["tempat_lahir"] = tempatLahir;
    request.fields["tanggal_lahir"] = tanggalLahir;
    request.fields["jenis_kelamin"] = jenisKelamin;
    request.fields["alamat"] = alamat;
    request.fields["pekerjaan"] = pekerjaan;
    request.fields["agama"] = agama;
    request.fields["phone"] = phone; // Perbaikan dari no_hp ke phone
    request.fields["email"] = email;
    request.fields["password"] = password;

    if (!kIsWeb) {
      if (kkGambar is File && kkGambar.existsSync()) {
        request.files.add(
          await http.MultipartFile.fromPath(
            "kk_gambar",
            kkGambar.path,
            filename: basename(kkGambar.path),
          ),
        );
      }
    } else {
      if (kkGambar != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            "kk_gambar",
            kkGambar,
            filename: "kk_gambar.jpg",
          ),
        );
      }
    }

    var streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }

  // Header untuk request ke API
  Map<String, String> _header() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

Future<http.Response> aktivasiAkun({required String nik}) async {
  Map<String, String> data = {
    "nik": nik, // Sesuai dengan API Laravel
  };

  return await postRequest(route: "/activateAccount", data: data);
}

}
