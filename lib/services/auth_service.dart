import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final supabase = Supabase.instance.client;

  // =========================
  // REGISTER
  // =========================

  Future<String?> register({
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final response =
          await supabase.auth.signUp(
        email: email,
        password: password,
      );

      final user = response.user;

      if (user == null) {
        return "User gagal dibuat";
      }

      // INSERT PROFILE
      await supabase
          .from('profiles')
          .insert({
        'id': user.id,
        'email': email,
        'role': role,
        'is_profile_complete': false,
      });

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // =========================
  // LOGIN
  // =========================

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await supabase.auth
          .signInWithPassword(
        email: email,
        password: password,
      );

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // =========================
  // LOGOUT
  // =========================

  Future<void> logout() async {
    await supabase.auth.signOut();
  }
}