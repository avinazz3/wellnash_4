import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wellnash_4/screens/profile_screen.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Mock Supabase client
class MockSupabaseClient extends Mock implements SupabaseClient {}

void main() {
  group('ProfileScreen Widget Tests', () {
    late MockSupabaseClient mockSupabaseClient;

    setUp(() {
      mockSupabaseClient = MockSupabaseClient();
      // Set up mock responses here
    });

    testWidgets('ProfileScreen shows loading state initially', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(MaterialApp(home: ProfileScreen()));

      // Act
      // Initial build is enough for this test

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('ProfileScreen shows user data when loaded', (WidgetTester tester) async {
      // Arrange
      // Set up mock user data

      // Act
      await tester.pumpWidget(MaterialApp(home: ProfileScreen()));
      await tester.pump(); // Wait for async operations

      // Assert
      expect(find.text('John Doe'), findsOneWidget); // Assuming 'John Doe' is the mock user's name
      expect(find.text('john@example.com'), findsOneWidget);
    });
  });
}