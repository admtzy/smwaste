import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../services/profile_service.dart';

import '../admin/admin_dashboard.dart';
import '../pembeli/pembeli_dashboard.dart';
import '../penjual/penjual_dashboard.dart';
import '../profile/complete_profile_page.dart';

import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final authService = AuthService();
  final profileService = ProfileService();

  final emailC = TextEditingController();
  final passwordC = TextEditingController();

  bool isLoading = false;

  Future<void> login() async {
    setState(() {
      isLoading = true;
    });

    final result = await authService.login(
      email: emailC.text.trim(),
      password: passwordC.text.trim(),
    );

    if (result == null) {
      final profile = await profileService.getProfile();

      if (profile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Profile tidak ditemukan",
            ),
          ),
        );
        setState(() {
          isLoading = false;
        });
        return;
      }

      final role = profile['role'];
      final complete = profile['is_profile_complete'];

      // =========================
      // ADMIN
      // =========================
      if (role == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const AdminDashboard(),
          ),
        );
      }
      // =========================
      // PROFILE BELUM LENGKAP
      // =========================
      else if (complete == false) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const CompleteProfilePage(),
          ),
        );
      }
      // =========================
      // PENJUAL
      // =========================
      else if (role == 'penjual') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const PenjualDashboard(),
          ),
        );
      }
      // =========================
      // PEMBELI
      // =========================
      else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const PembeliDashboard(),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result),
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Definisi warna sesuai gambar UI kamu
    const primaryGreen = Color(0xFF236652);
    const lightGreenBg = Color(0xFFD6E8DB);

    return Scaffold(
      backgroundColor: primaryGreen,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header Area: Logo & Nama Aplikasi
              const SizedBox(height: 30),
              Column(
                children: [
                  const Icon(
                    Icons.all_inclusive, // Menggunakan icon bawaan sebagai placeholder logo infinity
                    size: 50,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Smart Leaf",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // White Card Container (Form)
              Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 180,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title "Login" / "Create New Account"
                    const Center(
                      child: Text(
                        "Login Account",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Tombol switch ke register page (Menggantikan TextButton bawah agar rapi di atas)
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RegisterPage(),
                            ),
                          );
                        },
                        child: const Text(
                          "Belum punya akun? Daftar di sini.",
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 35),

                    // Label Email
                    const Text(
                      "EMAIL",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Input Email
                    TextField(
                      controller: emailC,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: lightGreenBg,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Label Password
                    const Text(
                      "PASSWORD",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Input Password
                    TextField(
                      controller: passwordC,
                      obscureText: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: lightGreenBg,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 35),

                    // Button Login
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryGreen,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "Login",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}