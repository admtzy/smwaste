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
  State<LoginPage> createState() =>
      _LoginPageState();
}

class _LoginPageState
    extends State<LoginPage> {
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
      final profile =
          await profileService.getProfile();

      if (profile == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              "Profile tidak ditemukan",
            ),
          ),
        );

        return;
      }

      final role = profile['role'];
      final complete =
          profile['is_profile_complete'];

      // =========================
      // ADMIN
      // =========================

      if (role == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                const AdminDashboard(),
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
            builder: (_) =>
                const CompleteProfilePage(),
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
            builder: (_) =>
                const PenjualDashboard(),
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
            builder: (_) =>
                const PembeliDashboard(),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            TextField(
              controller: emailC,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: passwordC,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,

              child: ElevatedButton(
                onPressed:
                    isLoading ? null : login,

                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Login"),
              ),
            ),

            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const RegisterPage(),
                  ),
                );
              },

              child: const Text(
                "Belum punya akun?",
              ),
            )
          ],
        ),
      ),
    );
  }
}