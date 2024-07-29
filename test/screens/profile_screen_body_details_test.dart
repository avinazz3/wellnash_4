import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wellnash_4/screens/profile_screen.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Mock Supabase client
class MockSupabaseClient extends Mock implements SupabaseClient {}

void main() {
  group('ProfileScreen Body Details Tests', () {
    late MockSupabaseClient mockSupabaseClient;

    setUp(() {
      mockSupabaseClient = MockSupabaseClient();
      // Set up mock responses here
    });

    testWidgets('User can edit height', (WidgetTester tester) async {
      // Arrange
      // Set up mock user data

      // Act
      await tester.pumpWidget(MaterialApp(home: ProfileScreen()));
      await tester.pump();
      await tester.tap(find.text('180.0')); // Assuming initial height is 180.0
      await tester.pump();
      await tester.enterText(find.byType(TextField), '185.0');
      await tester.tap(find.text('Save'));
      await tester.pump();

      // Assert
      expect(find.text('185.0'), findsOneWidget);
    });

    testWidgets('User can edit weight', (WidgetTester tester) async {
      // Arrange
      // Set up mock user data

      // Act
      await tester.pumpWidget(MaterialApp(home: ProfileScreen()));
      await tester.pump();
      await tester.tap(find.text('75.0')); // Assuming initial weight is 75.0
      await tester.pump();
      await tester.enterText(find.byType(TextField), '80.0');
      await tester.tap(find.text('Save'));
      await tester.pump();

      // Assert
      expect(find.text('80.0'), findsOneWidget);
    });
  });
}