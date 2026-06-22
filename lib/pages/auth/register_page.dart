import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import '../../services/auth_service.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final authService = AuthService();
  final emailC = TextEditingController();
  final passwordC = TextEditingController();
  final nameC = TextEditingController();
  final confirmPasswordC = TextEditingController();

  bool isLoading = false;
  String role = 'pembeli';

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;

  final Color _colorPrimary = const Color(0xFF276955);
  final Color _colorSageMint = const Color(0xFFd5e7da);
  final Color _colorSurface = const Color(0xFFfcf9f8);
  final Color _colorOnSurface = const Color(0xFF1c1b1b);
  final Color _colorOnSurfaceVariant = const Color(0xFF3f4944);

  @override
  void dispose() {
    emailC.dispose();
    passwordC.dispose();
    nameC.dispose();
    confirmPasswordC.dispose();
    super.dispose();
  }

  Future<void> register() async {
    if (emailC.text.isEmpty || passwordC.text.isEmpty) {
      _showSnackBar('Email dan Password wajib diisi');
      return;
    }

    if (passwordC.text != confirmPasswordC.text) {
      _showSnackBar('Konfirmasi Password tidak cocok');
      return;
    }

    if (!_acceptTerms) {
      _showSnackBar('Anda harus menyetujui Syarat & Ketentuan');
      return;
    }

    setState(() {
      isLoading = true;
    });

    final result = await authService.register(
      email: emailC.text.trim(),
      password: passwordC.text.trim(),
      role: role,
    );

    setState(() {
      isLoading = false;
    });

    if (result == null) {
      _showSnackBar('Register berhasil');

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    } else {
      _showSnackBar(result);
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colorPrimary,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Column(
                children: [
                  Container(
                    width: 72,
                    height: 72,
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
                    padding: const EdgeInsets.all(3),
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ClipOval(
                      child: Image.asset('assets/images/logo.jpg', fit: BoxFit.cover),
                    ),
                  ),
                  const Text(
                    'SMARTWASTE',
                    style: TextStyle(
                      fontFamily: 'Hanken Grotesk',
                      color: Colors.white,
                      fontSize: 18,
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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(
                    left: 24.0,
                    right: 24.0,
                    top: 24.0,
                    bottom: 32.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Container(
                          width: 48,
                          height: 6,
                          margin: const EdgeInsets.only(bottom: 24),
                          decoration: BoxDecoration(
                            color: const Color(0xFFe5e2e1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      Text(
                        'Daftar Akun',
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
                        'Silakan lengkapi data diri Anda untuk memulai.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Hanken Grotesk',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: _colorOnSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 32),

                      _buildLabel('PILIH PERAN'),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFe5e2e1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => role = 'pembeli'),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: role == 'pembeli'
                                        ? Colors.white
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: role == 'pembeli'
                                        ? [
                                            const BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 2,
                                            ),
                                          ]
                                        : [],
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Pembeli',
                                    style: TextStyle(
                                      fontFamily: 'Hanken Grotesk',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: role == 'pembeli'
                                          ? _colorPrimary
                                          : _colorOnSurfaceVariant,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => role = 'penjual'),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: role == 'penjual'
                                        ? Colors.white
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: role == 'penjual'
                                        ? [
                                            const BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 2,
                                            ),
                                          ]
                                        : [],
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Penjual',
                                    style: TextStyle(
                                      fontFamily: 'Hanken Grotesk',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: role == 'penjual'
                                          ? _colorPrimary
                                          : _colorOnSurfaceVariant,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      _buildLabel('NAMA LENGKAP'),
                      const SizedBox(height: 8),
                      TextField(
                        controller: nameC,
                        style: TextStyle(
                          fontFamily: 'Hanken Grotesk',
                          color: _colorOnSurface,
                          fontSize: 14,
                        ),
                        decoration: _inputDecoration('Masukkan nama lengkap'),
                      ),
                      const SizedBox(height: 16),

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
                        decoration: _inputDecoration('contoh@email.com'),
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
                        decoration: _inputDecoration('••••••••').copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: _colorOnSurfaceVariant,
                              size: 20,
                            ),
                            onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      _buildLabel('KONFIRMASI PASSWORD'),
                      const SizedBox(height: 8),
                      TextField(
                        controller: confirmPasswordC,
                        obscureText: _obscureConfirmPassword,
                        style: TextStyle(
                          fontFamily: 'Hanken Grotesk',
                          color: _colorOnSurface,
                          fontSize: 14,
                        ),
                        decoration: _inputDecoration('••••••••').copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: _colorOnSurfaceVariant,
                              size: 20,
                            ),
                            onPressed: () => setState(
                              () => _obscureConfirmPassword =
                                  !_obscureConfirmPassword,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: Checkbox(
                              value: _acceptTerms,
                              activeColor: _colorPrimary,
                              side: const BorderSide(color: Color(0xFF707974)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              onChanged: (value) =>
                                  setState(() => _acceptTerms = value ?? false),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontFamily: 'Hanken Grotesk',
                                  color: _colorOnSurfaceVariant,
                                  fontSize: 12,
                                  height: 1.5,
                                ),
                                children: [
                                  const TextSpan(text: 'Saya setuju dengan '),
                                  TextSpan(
                                    text: 'Syarat & Ketentuan',
                                    style: TextStyle(
                                      color: _colorPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {},
                                  ),
                                  const TextSpan(text: ' serta '),
                                  TextSpan(
                                    text: 'Kebijakan Privasi',
                                    style: TextStyle(
                                      color: _colorPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {},
                                  ),
                                  const TextSpan(text: '.'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : register,
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
                                  'Daftar Sekarang',
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
                          text: 'Sudah punya akun? ',
                          style: TextStyle(
                            fontFamily: 'Hanken Grotesk',
                            color: _colorOnSurfaceVariant,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          children: [
                            TextSpan(
                              text: 'Masuk di sini',
                              style: TextStyle(
                                fontFamily: 'Hanken Grotesk',
                                color: _colorPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const LoginPage(),
                                    ),
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Hanken Grotesk',
        fontSize: 12,
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
