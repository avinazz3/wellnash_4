import 'package:flutter/material.dart';
import 'package:multiselect/multiselect.dart';
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
  List<String> injuryOptions = [];
  List<String> selectedInjuries = [];
  String? selectedGoal;
  String? selectedActivityLvl;

  final List<String> goals = ['Hypertrophy', 'Strength', 'Endurance', 'Hybrid'];
  final List<String> activityLvl = ['Sedentary', 'Lightly Active', 'Moderately Active', 'Very Active', 'Super Active'];

  @override
  void initState() {
    super.initState();
    //_fetchInjuries();
  }

Future<void> _fetchInjuries() async {
  try {
    final List<Map<String, dynamic>> response = await supabase.from('injuries').select('name');

    if (mounted) {
      if (response.isNotEmpty) {
        setState(() {
          injuryOptions = List<String>.from(response.map((injury) => injury['name']));
        });
      } else {
        _showSnackBar('No injuries found', isError: true);
      }
    }
  } on PostgrestException catch (error) {
    if (mounted) {
      _showSnackBar(error.message, isError: true);
    }
  } catch (error) {
    if (mounted) {
      _showSnackBar('Unexpected error occurred', isError: true);
    }
  }
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
    print("Starting user update");

    // Perform the update
    await supabase.from('users').update({
      'height': height,
      'weight': weight,
      'goals': goal,
      'activity_level': activitylvl,
    }).eq('id', userId!);

    print("User update completed");

    // Process injuries
    print("Selected injuries: $selectedInjuries");

    if (selectedInjuries.isNotEmpty) {
      for (var injury in selectedInjuries) {
        print("Processing injury: $injury");
        final response = await supabase.from('injuries').select('id').eq('name', injury).single();
        print("Injury query response: $response");
        final injuryId = response['id'];
        print("Injury ID: $injuryId");
        print("User ID: $userId");

        await supabase.from('user_injuries').insert({
          'user_id': userId,
          'injury_id': injuryId,
        });
        print("Injury inserted for user");
      }
    } else {
      print("No injuries selected");
    }

    if (mounted) {
      _showSnackBar('Details updated successfully');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WorkoutPreferences()),
      );
    }
  } catch (error) {
    print("Error: $error");
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
        backgroundColor: Color.fromARGB(0, 244, 115, 2),
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
                  _buildDropDownMultiSelect(),
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
            offset: Offset(0, 5),
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

  Widget _buildDropDownMultiSelect() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: DropDownMultiSelect(
        decoration: InputDecoration(
          fillColor: Colors.transparent,
          focusColor: Colors.transparent,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        options: injuryOptions,
        selectedValues: selectedInjuries,
        onChanged: (List<String> value) {
          setState(() {
            selectedInjuries = value;
          });
        },
        whenEmpty: 'Select Injuries',
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
            offset: Offset(0, 5),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 15),
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