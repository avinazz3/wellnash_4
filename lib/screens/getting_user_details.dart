import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wellnash_4/providers/user_provider.dart';
import 'package:wellnash_4/services/auth_services.dart';
import 'package:wellnash_4/screens/workout_preferences.dart';

class GettingUserDetails extends StatefulWidget {
  @override
  _GettingUserDetailsState createState() => _GettingUserDetailsState();
}

class _GettingUserDetailsState extends State<GettingUserDetails> {
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final List<String> injuries = [
    'Tennis Elbow',
    'Hip Flexor Strain',
    'Wrist Sprain',
    'Ankle Sprain',
    'Shin Splints',
    'Back Pain',
    'Groin Pull',
    'Dislocated Shoulder',
    'Achilles Sprain',
    'Neck Sprain',
    'Hamstring Sprain',
    'Broken Leg',
    'Broken Arm',
    'ACL Tear',
    'Slip Disc',
  ];
  String? selectedInjury;
  final AuthService authService = AuthService();
 

  void _submitDetails() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.user.id;
    final height = _heightController.text;
    final weight = _weightController.text;
    final injuries = selectedInjury ?? 'No Injury';

    authService.updateUserDetails(
      context: context,
      userId: userId,
      height: double.parse(height),
      weight: double.parse(weight),
      injuries: injuries,
    ).then((_) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WorkoutPreferences()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _heightController,
              decoration: InputDecoration(labelText: 'Height (cm)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _weightController,
              decoration: InputDecoration(labelText: 'Weight (kg)'),
              keyboardType: TextInputType.number,
            ),
            DropdownButton<String>(
              value: selectedInjury,
              hint: Text('Select Injury'),
              onChanged: (newValue) {
                setState(() {
                  selectedInjury = newValue;
                });
              },
              items: injuries.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitDetails,
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
