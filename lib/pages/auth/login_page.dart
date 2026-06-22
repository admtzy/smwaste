import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

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
  bool _obscurePassword = true;

  final Color _colorPrimary = const Color(0xFF276955);
  final Color _colorSageMint = const Color(0xFFd5e7da);
  final Color _colorSurface = const Color(0xFFfcf9f8);
  final Color _colorOnSurface = const Color(0xFF1c1b1b);
  final Color _colorOnSurfaceVariant = const Color(0xFF3f4944);

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
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Profile tidak ditemukan")),
          );
        }
        setState(() {
          isLoading = false;
        });
        return;
      }

      final role = profile['role'];
      final complete = profile['is_profile_complete'];

      if (!mounted) return;

      if (role == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminDashboard()),
        );
      } else if (complete == false) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const CompleteProfilePage()),
        );
      } else if (role == 'penjual') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const PenjualDashboard()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const PembeliDashboard()),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(result)));
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: _colorPrimary,
      body: SingleChildScrollView(
        child: SizedBox(
          height: screenHeight,
          child: Column(
            children: [
              SizedBox(
                height: screenHeight * 0.3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(4),
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/logo.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const Text(
                      'SMARTWASTE',
                      style: TextStyle(
                        fontFamily: 'Hanken Grotesk',
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: _colorSurface,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 20,
                        offset: Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 24.0,
                      right: 24.0,
                      top: 32.0,
                      bottom: 24.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Masuk Akun',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Hanken Grotesk',
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: _colorOnSurface,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Silakan masuk untuk melanjutkan.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Hanken Grotesk',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: _colorOnSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 32),

                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel('EMAIL'),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: emailC,
                                  keyboardType: TextInputType.emailAddress,
                                  style: TextStyle(
                                    fontFamily: 'Hanken Grotesk',
                                    color: _colorOnSurface,
                                    fontSize: 14,
                                  ),
                                  decoration: _inputDecoration(
                                    'contoh@email.com',
                                  ),
                                ),
                                const SizedBox(height: 16),

                                _buildLabel('PASSWORD'),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: passwordC,
                                  obscureText: _obscurePassword,
                                  style: TextStyle(
                                    fontFamily: 'Hanken Grotesk',
                                    color: _colorOnSurface,
                                    fontSize: 14,
                                  ),
                                  decoration: _inputDecoration('••••••••')
                                      .copyWith(
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscurePassword
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            color: _colorOnSurfaceVariant,
                                            size: 20,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _obscurePassword =
                                                  !_obscurePassword;
                                            });
                                          },
                                        ),
                                      ),
                                ),

                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {
                                    },
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                        horizontal: 0,
                                      ),
                                      minimumSize: Size.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: Text(
                                      'Lupa Kata Sandi?',
                                      style: TextStyle(
                                        fontFamily: 'Hanken Grotesk',
                                        color: _colorPrimary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: isLoading ? null : login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _colorPrimary,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 0,
                                ),
                                child: isLoading
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 3,
                                        ),
                                      )
                                    : const Text(
                                        'Masuk Sekarang',
                                        style: TextStyle(
                                          fontFamily: 'Hanken Grotesk',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: 'Belum punya akun? ',
                                style: TextStyle(
                                  fontFamily: 'Hanken Grotesk',
                                  color: _colorOnSurfaceVariant,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Daftar di sini',
                                    style: TextStyle(
                                      fontFamily: 'Hanken Grotesk',
                                      color: _colorPrimary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const RegisterPage(),
                                          ),
                                        );
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Hanken Grotesk',
        fontSize: 13,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.2,
        color: _colorOnSurface,
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        fontFamily: 'Hanken Grotesk',
        color: _colorOnSurfaceVariant.withOpacity(0.5),
        fontSize: 14,
      ),
      filled: true,
      fillColor: _colorSageMint,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: _colorPrimary, width: 2),
      ),
    );
  }
}
