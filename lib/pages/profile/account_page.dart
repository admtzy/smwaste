import 'package:flutter/material.dart';

import '../../services/account_service.dart';

import '../auth/login_page.dart';
import 'edit_profile_page.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final accountService = AccountService();

    // Definisi Palet Warna Konsisten (SMARTWASTE Theme)
    const colorBackground = Color(0xFFFCF9F8); // bg-background
    const colorSurface = Color(0xFFFCF9F8); // bg-surface
    const colorOnSurface = Color(0xFF1C1B1B); // text-on-surface
    const colorPrimary = Color(0xFF004E3B); // primary green
    const colorOnPrimary = Color(0xFFFFFFFF); // text-on-primary
    const colorError = Color(0xFFBA1A1A); // error/destructive red

    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        backgroundColor: colorSurface,
        elevation: 0,
        title: const Text(
          "Akun Saya",
          style: TextStyle(
            color: colorOnSurface,
            fontFamily: 'Hanken Grotesk',
            fontSize: 20, // text-headline-md
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0), // px-lg dari desain dasar
          child: Column(
            children: [
              /// ========================
              /// BUTTON EDIT PROFILE
              /// ========================
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorPrimary,
                    foregroundColor: colorOnPrimary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // rounded-lg
                    ),
                  ),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const EditProfilePage(),
                      ),
                    );

                    if (!context.mounted) return;
                  },
                  child: const Text(
                    "Edit Profile",
                    style: TextStyle(
                      fontFamily: 'Hanken Grotesk',
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16), // gap-md

              /// ========================
              /// BUTTON DELETE ACCOUNT
              /// ========================
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorError,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // rounded-lg
                    ),
                  ),
                  onPressed: () async {
                    try {
                      await accountService.deleteMyAccount();

                      if (!context.mounted) {
                        return;
                      }

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoginPage(),
                        ),
                        (route) => false,
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(
                        SnackBar(
                          content: Text(
                            e.toString(),
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    "Delete Account",
                    style: TextStyle(
                      fontFamily: 'Hanken Grotesk',
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
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
}