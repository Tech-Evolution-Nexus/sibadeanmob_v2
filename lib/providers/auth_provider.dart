import 'package:flutter/foundation.dart';

class AuthProvider with ChangeNotifier {
  String _token = '';

  String get token => _token;

  void setToken(String newToken) {
    _token = newToken;
    notifyListeners(); // Memberi tahu UI untuk update jika ada perubahan
  }
}
