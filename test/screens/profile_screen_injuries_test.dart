import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wellnash_4/screens/profile_screen.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Mock Supabase client
class MockSupabaseClient extends Mock implements SupabaseClient {}

void main() {
  group('ProfileScreen Injuries Tests', () {
    late MockSupabaseClient mockSupabaseClient;

    setUp(() {
      mockSupabaseClient = MockSupabaseClient();
      // Set up mock responses here
    });

    testWidgets('User can select injuries', (WidgetTester tester) async {
      // Arrange
      // Set up mock user data and injuries list

      // Act
      await tester.pumpWidget(MaterialApp(home: ProfileScreen()));
      await tester.pump();
      await tester.tap(find.text('Select Injuries'));
      await tester.pump();
      await tester.tap(find.text('Knee Injury'));
      await tester.tap(find.text('Back Pain'));
      await tester.tap(find.text('Update Injuries'));
      await tester.pump();

      // Assert
      expect(find.byType(Chip), findsNWidgets(2));
      expect(find.text('Knee Injury'), findsOneWidget);
      expect(find.text('Back Pain'), findsOneWidget);
    });

    testWidgets('User can update injuries', (WidgetTester tester) async {
      // Arrange
      // Set up mock user data with existing injuries

      // Act
      await tester.pumpWidget(MaterialApp(home: ProfileScreen()));
      await tester.pump();
      await tester.tap(find.text('Select Injuries'));
      await tester.pump();
      await tester.tap(find.text('Ankle Sprain')); // Add new injury
      await tester.tap(find.text('Back Pain')); // Remove existing injury
      await tester.tap(find.text('Update Injuries'));
      await tester.pump();

      // Assert
      expect(find.byType(Chip), findsNWidgets(2)); // Assuming 'Knee Injury' was already selected
      expect(find.text('Knee Injury'), findsOneWidget);
      expect(find.text('Ankle Sprain'), findsOneWidget);
      expect(find.text('Back Pain'), findsNothing);
    });
  });
}