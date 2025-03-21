import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController nikController = TextEditingController();
  final TextEditingController noKkController = TextEditingController();
  final TextEditingController tempatLahirController = TextEditingController();
  final TextEditingController tanggalLahirController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController pekerjaanController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  String? selectedGender;
  String? selectedAgama;
  File? _selectedImage;
  File? _selectedKK;

  Future<void> _pickImage(bool isKK) async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        isKK ? _selectedKK = File(pickedFile.path) : _selectedImage = File(pickedFile.path);
      });
    }
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool obscureText = false, String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(labelText: label),
      validator: validator,
    );
  }

  void _nextPage() {
    if (_formKey.currentState!.validate()) {
      _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
      setState(() => _currentPage++);
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate() || _selectedImage == null || _selectedKK == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Harap isi semua data dan unggah foto yang diperlukan!')),
      );
      return;
    }
    
    try {
      var formData = FormData.fromMap({
        "nama_lengkap": fullNameController.text,
        "nik": nikController.text,
        "no_kk": noKkController.text,
        "tempat_lahir": tempatLahirController.text,
        "tanggal_lahir": tanggalLahirController.text,
        "jenis_kelamin": selectedGender,
        "alamat": alamatController.text,
        "pekerjaan": pekerjaanController.text,
        "agama": selectedAgama,
        "no_hp": phoneController.text,
        "email": emailController.text,
        "password": passwordController.text,
        "password_confirmation": confirmPasswordController.text,
        "foto_profil": await MultipartFile.fromFile(_selectedImage!.path, filename: "foto_profil.jpg"),
        "file_kk": await MultipartFile.fromFile(_selectedKK!.path, filename: "file_kk.jpg"),
      });

      Response response = await Dio().post(
        'http://your-api-url.com/api/register',
        data: formData,
        options: Options(headers: {"Content-Type": "multipart/form-data"}),
      );

      String message = response.data['message'] ?? 'Registrasi berhasil!';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));

      if (response.statusCode == 200 && response.data['success'] == true) {
        Navigator.pushNamed(context, "/login");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Terjadi kesalahan: ${e.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registrasi")),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: NeverScrollableScrollPhysics(),
                children: [_buildStep1(), _buildStep2(), _buildStep3(), _buildStep4()],
              ),
            ),
            ElevatedButton(
              onPressed: _currentPage == 3 ? _submitForm : _nextPage,
              child: Text(_currentPage == 3 ? "Selesai" : "Selanjutnya"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep1() {
    return Column(
      children: [
        _buildTextField("Nama Lengkap", fullNameController, validator: (value) => value!.isEmpty ? "Nama tidak boleh kosong!" : null),
        _buildTextField("NIK", nikController, validator: (value) => value!.length != 16 ? "NIK harus 16 digit!" : null),
        _buildTextField("No KK", noKkController, validator: (value) => value!.length != 16 ? "No KK harus 16 digit!" : null),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      children: [
        _buildTextField("Tempat Lahir", tempatLahirController),
        _buildTextField("Tanggal Lahir", tanggalLahirController),
        DropdownButtonFormField<String>(
          value: selectedGender,
          items: ["Laki-laki", "Perempuan"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (value) => setState(() => selectedGender = value),
          decoration: InputDecoration(labelText: "Jenis Kelamin"),
        ),
      ],
    );
  }

  Widget _buildStep3() {
    return Column(
      children: [
        _buildTextField("Alamat", alamatController),
        _buildTextField("Pekerjaan", pekerjaanController),
        DropdownButtonFormField<String>(
          value: selectedAgama,
          items: ["Islam", "Kristen", "Hindu", "Buddha", "Konghucu"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (value) => setState(() => selectedAgama = value),
          decoration: InputDecoration(labelText: "Agama"),
        ),
      ],
    );
  }

  Widget _buildStep4() {
    return Column(
      children: [
        _buildTextField("No HP", phoneController),
        _buildTextField("Email", emailController, validator: (value) => !value!.contains('@') ? "Email tidak valid!" : null),
        _buildTextField("Password", passwordController, obscureText: true),
        _buildTextField("Konfirmasi Password", confirmPasswordController, obscureText: true),
      ],
    );
  }
}
