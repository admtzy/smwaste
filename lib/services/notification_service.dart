import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationService {
  final supabase =
      Supabase.instance.client;

  Future<void>
      createNotification({
    required String userId,
    required String title,
    required String message,
  }) async {
    try {
      await supabase
          .from('notifications')
          .insert({
        'user_id': userId,
        'title': title,
        'message': message,
      });
    } catch (e) {
      throw Exception(
        'Gagal membuat notifikasi : $e',
      );
    }
  }

  Future<List<dynamic>>
      getNotifications() async {
    final user =
        supabase.auth.currentUser;

    if (user == null) {
      throw Exception(
        'User belum login',
      );
    }

    return await supabase
        .from('notifications')
        .select()
        .eq('user_id', user.id)
        .order(
          'created_at',
          ascending: false,
        );
  }

  Future<void> readNotif(
    String id,
  ) async {
    await supabase
        .from('notifications')
        .update({
      'is_read': true,
    }).eq('id', id);
  }
}