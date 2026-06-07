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
    final accountService =
        AccountService();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Akun Saya",
        ),
      ),

      body: Padding(
        padding:
            const EdgeInsets.all(20),

        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 50,

              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const EditProfilePage(),
                    ),
                  );
                },

                child: const Text(
                  "Edit Profile",
                ),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,

              child: ElevatedButton(
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.red,
                ),

                onPressed: () async {
                  try {
                    await accountService
                        .deleteMyAccount();

                    if (!context.mounted) {
                      return;
                    }

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const LoginPage(),
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}