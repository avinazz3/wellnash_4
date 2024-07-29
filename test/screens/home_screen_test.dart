// test/screens/home_screen_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wellnash_4/models/user.dart' as models;
import 'package:wellnash_4/screens/history_screen.dart';
import 'package:wellnash_4/screens/home_screen.dart';
import 'package:wellnash_4/screens/profile_screen.dart';
import 'package:wellnash_4/screens/select_gym_screen.dart';
import 'package:wellnash_4/utils/custom_datetime_line.dart';
import 'package:wellnash_4/utils/muscle_highlighter.dart';

// Mock Supabase client
class MockSupabaseClient extends Mock implements SupabaseClient {}

void main() {
  group('HomeScreen Widget Tests', () {
    late MockSupabaseClient mockSupabaseClient;

    setUp(() {
      mockSupabaseClient = MockSupabaseClient();
      // Set up mock responses here
    });

    testWidgets('HomeScreen shows loading state initially', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(MaterialApp(home: HomeScreen()));

      // Act
      // Initial build is enough for this test

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Custom date timeline is displayed', (WidgetTester tester) async {
      // Arrange
      // Set up mock user data

      // Act
      await tester.pumpWidget(MaterialApp(home: HomeScreen()));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(CustomDateTimeline), findsOneWidget);
    });

    testWidgets('Muscle highlighter is displayed', (WidgetTester tester) async {
      // Arrange
      // Set up mock user data

      // Act
      await tester.pumpWidget(MaterialApp(home: HomeScreen()));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(MuscleHighlighter), findsOneWidget);
    });

    testWidgets('Start Workout button is displayed and navigates to SelectGymScreen', (WidgetTester tester) async {
      // Arrange
      // Set up mock user data

      // Act
      await tester.pumpWidget(MaterialApp(home: HomeScreen()));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Start Workout'), findsOneWidget);

      // Act
      await tester.tap(find.text('Start Workout'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(SelectGymScreen), findsOneWidget);
    });

    testWidgets('Bottom navigation bar is displayed with correct items', (WidgetTester tester) async {
      // Arrange
      // Set up mock user data

      // Act
      await tester.pumpWidget(MaterialApp(home: HomeScreen()));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('History'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('Tapping History nav item navigates to HistoryScreen', (WidgetTester tester) async {
      // Arrange
      // Set up mock user data

      // Act
      await tester.pumpWidget(MaterialApp(home: HomeScreen()));
      await tester.pumpAndSettle();
      await tester.tap(find.text('History'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(HistoryScreen), findsOneWidget);
    });

    testWidgets('Tapping Profile nav item navigates to ProfileScreen', (WidgetTester tester) async {
      // Arrange
      // Set up mock user data

      // Act
      await tester.pumpWidget(MaterialApp(home: HomeScreen()));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(ProfileScreen), findsOneWidget);
    });
  });
}