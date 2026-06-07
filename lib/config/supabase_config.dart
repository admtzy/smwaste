import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static Future<void> init() async {
    await Supabase.initialize(
      url: 'https://wwqykxqtcpxvydvlprhp.supabase.co',
      anonKey: 'sb_publishable_5rWYChMYOkDbzvULYucJkQ_cbepqMoW',
    );
  }
}