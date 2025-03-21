import 'package:flutter/material.dart';
import 'package:sibadeanmob_v2/models/userModel.dart';
import 'package:sibadeanmob_v2/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String? _errorMessage;
  UserModel? _user;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  UserModel? get user => _user;

  // 🟢 LOGIN
  Future<bool> login(String nik, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    UserModel? response = await _authService.login(nik, password);
    
    _isLoading = false;

    if (response != null) {
      _user = response;
      notifyListeners();
      return true;
    } else {
      _errorMessage = "Login gagal, periksa NIK dan password";
      notifyListeners();
      return false;
    }
  }

  // 🟢 REGISTER
  Future<bool> register(Map<String, dynamic> data) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    var response = await _authService.register(data);
    
    _isLoading = false;

    if (response != null && response.containsKey("user")) {
      notifyListeners();
      return true;
    } else {
      _errorMessage = response?["error"] ?? "Terjadi kesalahan";
      notifyListeners();
      return false;
    }
  }

  // 🟢 VERIFIKASI NIK
  Future<bool> verifikasiNik(String nik) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    var response = await _authService.verifikasiNik(nik);
    
    _isLoading = false;

    if (response != null && response.containsKey("message")) {
      return true;
    } else {
      _errorMessage = response?["error"] ?? "Terjadi kesalahan";
      notifyListeners();
      return false;
    }
  }

  // 🟢 AKTIVASI AKUN
Future<bool> aktivasiAkun(String nik, String code) async {
  _isLoading = true;
  _errorMessage = null;
  notifyListeners();

  var response = await _authService.aktivasiAkun(nik, code); // ✅ Kirim NIK & kode aktivasi

  _isLoading = false;

  if (response != null && response.containsKey("message")) {
    return true;
  } else {
    _errorMessage = response?["error"] ?? "Terjadi kesalahan";
    notifyListeners();
    return false;
  }
}
}
