import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseClientService {
  static final SupabaseClientService _instance = SupabaseClientService._internal();

  factory SupabaseClientService() {
    return _instance;
  }

  SupabaseClientService._internal();

  Future<void> initialize() async {
    await Supabase.initialize(
      url: 'https://kxkqsyzsudimqrqriguk.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imt4a3FzeXpzdWRpbXFycXJpZ3VrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTk3OTkxNjgsImV4cCI6MjAzNTM3NTE2OH0.jmlbjYldvrSgW-gmJOg7fGvVLrK7bU1BYdP9k7o_yPk',
    );
  }
}
