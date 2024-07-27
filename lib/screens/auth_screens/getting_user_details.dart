import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wellnash_4/screens/auth_screens/workout_preferences.dart';

class GettingUserDetails extends StatefulWidget {
  @override
  _GettingUserDetailsState createState() => _GettingUserDetailsState();
}

class _GettingUserDetailsState extends State<GettingUserDetails> {
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final SupabaseClient supabase = Supabase.instance.client;
  String? selectedGoal;
  String? selectedActivityLvl;
  final List<String> goals = ['Hypertrophy', 'Strength', 'Endurance', 'Hybrid'];
  final List<String> activityLvl = ['Sedentary', 'Lightly Active', 'Moderately Active', 'Very Active', 'Super Active'];

  @override
  void initState() {
    super.initState();
  }

  Future<void> _submitDetails() async {
    final userId = supabase.auth.currentUser?.id;
    final height = double.tryParse(_heightController.text);
    final weight = double.tryParse(_weightController.text);
    final goal = selectedGoal ?? '';
    final activitylvl = selectedActivityLvl ?? '';

    if (height == null || weight == null) {
      _showSnackBar('Please enter valid height and weight', isError: true);
      return;
    }

    try {
      await supabase.from('users').update({
        'height': height,
        'weight': weight,
        'goals': goal,
        'activity_level': activitylvl,
      }).eq('id', userId!);

      if (mounted) {
        _showSnackBar('Details updated successfully');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WorkoutPreferences()),
        );
      }
    } catch (error) {
      if (mounted) {
        _showSnackBar('Error: ${error.toString()}', isError: true);
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red : Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
        backgroundColor: const Color.fromARGB(0, 244, 115, 2),
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('machines-gym.jpg'), 
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 20),
                  _buildTextField(_heightController, 'Height (cm)'),
                  const SizedBox(height: 20),
                  _buildTextField(_weightController, 'Weight (kg)'),
                  const SizedBox(height: 20),
                  _buildDropdownButton('Select Goal', selectedGoal, goals),
                  const SizedBox(height: 20),
                  _buildDropdownButton('Your Activity Level', selectedActivityLvl, activityLvl),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _submitDetails,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    child: const Text('Next'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.transparent,
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }

  Widget _buildDropdownButton(String hint, String? value, List<String> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(hint),
          value: value,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              if (hint == 'Select Goal') {
                selectedGoal = newValue;
              } else {
                selectedActivityLvl = newValue;
              }
            });
          },
        ),
      ),
    );
  }
}
