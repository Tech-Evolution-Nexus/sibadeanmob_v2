import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sibadeanmob_v2/widgets/costum_scaffold1.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController nikController = TextEditingController();
  final TextEditingController noKkController = TextEditingController();
  final TextEditingController tempatLahirController = TextEditingController();
  final TextEditingController tanggalLahirController = TextEditingController();
  String? selectedGender;
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController pekerjaanController = TextEditingController();
  String? selectedAgama;
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  void _nextPage() {
    if (_formKey.currentState!.validate()) {
      if (_currentPage < 3) {
        _pageController.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut);
      }
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    }
  }

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        tanggalLahirController.text =
            DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    }
  }

  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentPage > 0)
            ElevatedButton(
              onPressed: _prevPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Sebelumnya",
                  style: TextStyle(color: Colors.black)),
            )
          else
            const SizedBox(width: 120),
          ElevatedButton(
            onPressed: _nextPage,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[300],
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(_currentPage == 3 ? "Selesai" : "Selanjutnya"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          const SizedBox(height: 50),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 40),
              padding: const EdgeInsets.fromLTRB(25.0, 40.0, 25.0, 20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: Column(
                children: [
                  const Text("Daftar Akun",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      )),
                  const SizedBox(height: 20),
                  Image.asset('assets/images/req.png',
                      height: 190, fit: BoxFit.contain),
                  SizedBox(height: 20),
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: PageView(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        onPageChanged: (index) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        children: [
                          _buildFormPage1(),
                          _buildFormPage2(),
                          _buildFormPage3(),
                          _buildFormPage4(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildFormPage1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Data Diri",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        _buildTextField("Nama Lengkap", fullNameController, validator: (value) {
          if (value!.isEmpty) return "Nama Lengkap tidak boleh kosong!";
          if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(value))
            return "Nama Lengkap hanya boleh huruf!";
          return null;
        }),
        const SizedBox(height: 15),
        _buildTextField("NIK", nikController,
            keyboardType: TextInputType.number, validator: (value) {
          if (value!.isEmpty) return "NIK tidak boleh kosong!";
          if (!RegExp(r"^\d{16}$").hasMatch(value))
            return "NIK harus berupa 16 digit angka!";
          return null;
        }),
        const SizedBox(height: 15),
        _buildTextField("No. Kartu Keluarga", noKkController,
            keyboardType: TextInputType.number, validator: (value) {
          if (value!.isEmpty) return "No. Kartu Keluarga tidak boleh kosong!";
          if (!RegExp(r"^\d+$").hasMatch(value))
            return "No. Kartu Keluarga hanya boleh angka!";
          return null;
        }),
      ],
    );
  }

  Widget _buildFormPage2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Informasi Lahir",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        _buildTextField("Tempat Lahir", tempatLahirController,
            validator: (value) {
          if (value!.isEmpty) return "Tempat Lahir tidak boleh kosong!";
          if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(value))
            return "Tempat Lahir hanya boleh huruf!";
          return null;
        }),
        const SizedBox(height: 15),
        TextFormField(
          controller: tanggalLahirController,
          readOnly: true,
          decoration: InputDecoration(
            labelText: "Tanggal Lahir",
            border: OutlineInputBorder(),
            suffixIcon: Icon(Icons.calendar_today),
          ),
          onTap: _selectDate,
          validator: (value) => value == null || value.isEmpty
              ? "Tanggal Lahir tidak boleh kosong!"
              : null,
        ),
        const SizedBox(height: 15),
        DropdownButtonFormField<String>(
          value: selectedGender,
          items: ["Laki-laki", "Perempuan"].map((String gender) {
            return DropdownMenuItem(value: gender, child: Text(gender));
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedGender = value;
            });
          },
          decoration: const InputDecoration(
              labelText: "Jenis Kelamin", border: OutlineInputBorder()),
          validator: (value) => value == null ? "Pilih jenis kelamin!" : null,
        ),
      ],
    );
  }

  Widget _buildFormPage3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField("Alamat", alamatController, maxLines: 2,
            validator: (value) {
          if (value!.isEmpty) return "Alamat tidak boleh kosong!";
          return null;
        }),
        const SizedBox(height: 15),
        _buildTextField("Pekerjaan", pekerjaanController, validator: (value) {
          if (value!.isEmpty) return "Pekerjaan tidak boleh kosong!";
          return null;
        }),
        const SizedBox(height: 15),
        DropdownButtonFormField<String>(
          value: selectedAgama,
          items: ["Islam", "Kristen", "Katolik", "Hindu", "Buddha", "Konghucu"]
              .map((String agama) {
            return DropdownMenuItem(value: agama, child: Text(agama));
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedAgama = value;
            });
          },
          decoration: const InputDecoration(
              labelText: "Agama", border: OutlineInputBorder()),
          validator: (value) => value == null ? "Pilih agama!" : null,
        ),
      ],
    );
  }

  Widget _buildFormPage4() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Informasi Kontak",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        _buildTextField("Nomor Telepon", phoneController,
            keyboardType: TextInputType.phone, validator: (value) {
          if (value!.isEmpty) return "Nomor Telepon tidak boleh kosong!";
          if (!RegExp(r"^\d{10,15}$").hasMatch(value))
            return "Nomor Telepon tidak valid!";
          return null;
        }),
        const SizedBox(height: 15),
        _buildTextField("Email", emailController,
            keyboardType: TextInputType.emailAddress, validator: (value) {
          if (value!.isEmpty) return "Email tidak boleh kosong!";
          if (!RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$").hasMatch(value))
            return "Email tidak valid!";
          return null;
        }),
        const SizedBox(height: 15),
        _buildTextField("Password", passwordController,
            keyboardType: TextInputType.visiblePassword, validator: (value) {
          if (value!.isEmpty) return "Password tidak boleh kosong!";
          if (value.length < 6) return "Password harus lebih dari 6 karakter!";
          return null;
        }),
        const SizedBox(height: 15),
        _buildTextField("Konfirmasi Password", confirmPasswordController,
            keyboardType: TextInputType.visiblePassword, validator: (value) {
          if (value!.isEmpty) return "Konfirmasi Password tidak boleh kosong!";
          if (value != passwordController.text)
            return "Konfirmasi Password tidak cocok!";
          return null;
        }),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1,
      TextInputType keyboardType = TextInputType.text,
      String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration:
          InputDecoration(labelText: label, border: OutlineInputBorder()),
      validator: validator ??
          (value) => value == null || value.isEmpty
              ? "$label tidak boleh kosong!"
              : null,
    );
  }
}
