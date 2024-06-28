import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wellnash_4/models/user.dart';
import 'package:wellnash_4/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:wellnash_4/providers/user_provider.dart';

void main() {
  testWidgets('HomeScreen test', (WidgetTester tester) async {
    // Create a user provider with some test data
    final userProvider = UserProvider();
    userProvider.setUserFromModel(User(
      id: '1',
      name: 'Test User',
      email: 'test@example.com',
      token: '',
      password: '',
    ));

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<UserProvider>.value(value: userProvider),
        ],
        child: MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );

    // Verify if HomeScreen displays correct information
    expect(find.text('Welcome, Test User!'), findsOneWidget);
    expect(find.text('test@example.com'), findsOneWidget);
  });
}
