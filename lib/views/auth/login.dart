import 'package:flutter/material.dart';
import 'package:sibadeanmob_v2/services/auth_sevice.dart';
import 'package:sibadeanmob_v2/theme/theme.dart';
import 'package:sibadeanmob_v2/views/auth/verivikasi.dart';
import 'package:sibadeanmob_v2/widgets/costum_scaffold1.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  final _formSignInKey = GlobalKey<FormState>();
  bool rememberPassword = true;
  late AnimationController _animationController;

  final TextEditingController nikController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    nikController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Panggil AuthService untuk login
  Future<void> login() async {
    if (_formSignInKey.currentState!.validate()) {
      final authService = AuthService();
      final user =
          await authService.login(nikController.text, passwordController.text);

      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login Berhasil')),
        );

        // Navigasi ke halaman utama (Dashboard)
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Dashboard()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Login gagal, periksa NIK dan Password!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          const SizedBox(height: 50),
          Expanded(
            flex: 7,
            child: Container(
              padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formSignInKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                          color: Color.fromARGB(255, 12, 35, 95),
                        ),
                      ),

                      SizedBox(height: 20),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 25.0),
                        child: Image.asset(
                          'assets/images/logg.png',
                          height: 170,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 30.0),

                      // Input NIK
                      TextFormField(
                        controller: nikController,
                        validator: (value) =>
                            value!.isEmpty ? 'Masukkan NIK Anda' : null,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.card_membership,
                            color: const Color.fromARGB(255, 3, 6, 71),
                          ),
                          labelText: 'Nomer Induk Kependudukan',
                          hintText: 'Masukkan NIK',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),

                      // Input Password
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        obscuringCharacter: '*',
                        validator: (value) =>
                            value!.isEmpty ? 'Masukkan Password Anda' : null,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock,
                              color: const Color.fromARGB(255, 3, 6, 71)),
                          labelText: 'Password',
                          hintText: 'Masukkan Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),

                      // Checkbox Remember Me & Forgot Password
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: rememberPassword,
                                onChanged: (bool? value) {
                                  setState(() {
                                    rememberPassword = value!;
                                  });
                                },
                                activeColor: Color.fromARGB(255, 12, 35, 95),
                              ),
                              const Text('Ingat Saya',
                                  style: TextStyle(color: Colors.black45)),
                            ],
                          ),
                          GestureDetector(
                            child: Text(
                              'Lupa Password?',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: lightColorScheme.primary),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),

                      // Tombol Login
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: login,
                          child: const Text('Masuk',
                              style: TextStyle(fontSize: 18)),
                        ),
                      ),
                      const SizedBox(height: 20.0),

                      // Daftar Akun
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Belum punya akun? ',
                              style: TextStyle(color: Colors.black45)),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (e) => const Verifikasi()));
                            },
                            child: Text(
                              'Daftar Sekarang',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: lightColorScheme.primary),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
