import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wellnash_4/screens/profile_screen.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Mock Supabase client
class MockSupabaseClient extends Mock implements SupabaseClient {}

void main() {
  group('ProfileScreen User Info Tests', () {
    late MockSupabaseClient mockSupabaseClient;

    setUp(() {
      mockSupabaseClient = MockSupabaseClient();
      // Set up mock responses here
    });

    testWidgets('User can edit name', (WidgetTester tester) async {
      // Arrange
      // Set up mock user data

      // Act
      await tester.pumpWidget(MaterialApp(home: ProfileScreen()));
      await tester.pump();
      await tester.tap(find.text('John Doe'));
      await tester.pump();
      await tester.enterText(find.byType(TextField), 'Jane Doe');
      await tester.tap(find.text('Save'));
      await tester.pump();

      // Assert
      expect(find.text('Jane Doe'), findsOneWidget);
    });

    testWidgets('Email field is not editable', (WidgetTester tester) async {
      // Arrange
      // Set up mock user data

      // Act
      await tester.pumpWidget(MaterialApp(home: ProfileScreen()));
      await tester.pump();

      // Assert
      expect(find.byIcon(Icons.edit), findsNWidgets(1)); // Assuming only name is editable
    });
  });
}