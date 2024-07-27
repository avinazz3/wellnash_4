import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wellnash_4/models/user.dart' as models;
import 'package:wellnash_4/screens/auth_screens/login_screen.dart';
import 'package:wellnash_4/utils/utils.dart';
import 'home_screen.dart';
import 'history_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  models.User? user;
  List<String> selectedInjuries = [];
  List<String> injuryOptions = [];
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetchInjuries();
  }

  Future<void> _loadUserData() async {
    final supabaseUser = supabase.auth.currentUser;
    final userId = supabase.auth.currentUser?.id;
    if (userId != null) {
      final userData = await supabase
          .from('users')
          .select()
          .eq('id', userId)
          .single();
      setState(() {
        user = models.User.fromSupabaseUser(supabaseUser!, userData);
      });
    }
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

  Future<void> _updateUserInjuries() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    try {
      await supabase.from('user_injuries').delete().eq('user_id', userId);

      for (var injury in selectedInjuries) {
        final response = await supabase.from('injuries').select('id').eq('name', injury).single();
        final injuryId = response['id'];

        await supabase.from('user_injuries').insert({
          'user_id': userId,
          'injury_id': injuryId,
        });
      }
      _showSnackBar('Injuries updated successfully');
    } catch (error) {
      _showSnackBar('Failed to update injuries: $error', isError: true);
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

  Future<void> _signOut() async {
    await supabase.auth.signOut();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  Future<void> _updateUser(String field, dynamic value) async {
    try {
      await supabase
          .from('users')
          .update({field: value})
          .eq('id', user!.id);
      await _loadUserData();
      if (mounted) {
        showSnackBar(context, message: 'Updated successfully');
      }
    } catch (e) {
      if (mounted) {
        showErrorSnackBar(context, message: 'Failed to update: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: _signOut,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Sign Out'),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildProfileHeader(context, user!),
            const SizedBox(height: 24),
            _buildUserInfoSection(context),
            const SizedBox(height: 24),
            _buildBodyDetailsSection(context),
            const SizedBox(height: 24),
            _buildWorkoutSection(context),
            const SizedBox(height: 24),
            _buildUserInjuriesSection(context),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _signOut,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Sign Out'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildProfileHeader(BuildContext context, models.User user) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: user.profilePictureUrl != null
              ? NetworkImage(user.profilePictureUrl!)
              : null,
          child: user.profilePictureUrl == null
              ? const Icon(Icons.person, size: 50)
              : null,
        ),
        const SizedBox(height: 16),
        Text(user.name),
        Text(user.email),
      ],
    );
  }

  Widget _buildUserInfoSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Personal Information'),
        const SizedBox(height: 8),
        _buildUserInfoField(
          context,
          'Name',
          user!.name,
          (value) => _updateUser('name', value),
          icon: Icons.person,
        ),
        _buildUserInfoField(
          context,
          'Email',
          user!.email,
          null,
          icon: Icons.email,
          editable: false,
        ),
      ],
    );
  }

  Widget _buildBodyDetailsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Body Details'),
        const SizedBox(height: 8),
        _buildUserInfoField(
          context,
          'Height (cm)',
          user!.height.toString(),
          (value) => _updateUser('height', double.parse(value)),
          icon: Icons.height,
        ),
        _buildUserInfoField(
          context,
          'Weight (kg)',
          user!.weight.toString(),
          (value) => _updateUser('weight', double.parse(value)),
          icon: Icons.monitor_weight,
        ),
      ],
    );
  }

  Widget _buildWorkoutSection(BuildContext context) {
    final List<String> goals = ['Hypertrophy', 'Strength', 'Endurance', 'Hybrid'];
    final List<String> activityLvl = ['Sedentary', 'Lightly Active', 'Moderately Active', 'Very Active', 'Super Active'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Workout Information'),
        const SizedBox(height: 8),
        _buildDropdownButton(
          context,
          'Goals',
          user!.goals ?? 'Not set',
          (value) => _updateUser('goals', value),
          goals,
          Icons.flag,
        ),
        const SizedBox(height: 8),
        _buildDropdownButton(
          context,
          'Activity Level',
          user!.activityLevel ?? 'Not set',
          (value) => _updateUser('activity_level', value),
          activityLvl,
          Icons.fitness_center,
        ),
        const SizedBox(height: 8),
        _buildUserInfoField(
          context,
          'Workout Days',
          user!.workoutDays.toString(),
          (value) => _updateUser('workout_days', int.parse(value)),
          icon: Icons.calendar_today,
        ),
      ],
    );
  }

  Widget _buildDropdownButton(
    BuildContext context,
    String label,
    String currentValue,
    Function(String) onChanged,
    List<String> options,
    IconData icon,
  ) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: DropdownButton<String>(
          isExpanded: true,
          value: currentValue,
          items: options.map((String option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(option),
            );
          }).toList(),
          onChanged: (newValue) {
            if (newValue != null) {
              onChanged(newValue);
            }
          },
        ),
      ),
    );
  }

  Widget _buildUserInfoField(
    BuildContext context,
    String label,
    String value,
    Function(String)? onSave, {
    bool editable = true,
    IconData? icon,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon ?? Icons.info_outline, color: Theme.of(context).primaryColor),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
        trailing: editable ? Icon(Icons.edit, color: Theme.of(context).primaryColor) : null,
        onTap: editable ? () => _showEditDialog(context, label, value, onSave) : null,
      ),
    );
  }

  void _showEditDialog(BuildContext context, String label, String value, Function(String)? onSave) {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController controller = TextEditingController(text: value);
        return AlertDialog(
          title: Text('Edit $label'),
          content: TextField(controller: controller, decoration: InputDecoration(labelText: label)),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () {
                if (onSave != null) {
                  onSave(controller.text);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildUserInjuriesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('User Injuries'),
        const SizedBox(height: 8),
        DropdownSearch<String>.multiSelection(
          items: injuryOptions,
          selectedItems: selectedInjuries,
          onChanged: (value) {
            setState(() {
              selectedInjuries = value;
            });
          },
          popupProps: const PopupPropsMultiSelection.menu(
            showSearchBox: true,
            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(labelText: 'Search Injuries'),
            ),
          ),
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              labelText: 'Select Injuries',
              hintText: 'Select injuries',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.transparent,
            ),
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: _updateUserInjuries,
          child: const Text('Update Injuries'),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8.0,
          children: selectedInjuries.map((injury) => Chip(label: Text(injury))).toList(),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return NavigationBar(
      selectedIndex: 2,
      onDestinationSelected: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
            break;
          case 1:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HistoryScreen()),
            );
            break;
          case 2:
            // Do nothing, we're already on the Profile screen
            break;
        }
      },
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
        NavigationDestination(icon: Icon(Icons.article), label: 'History'),
        NavigationDestination(icon: Icon(Icons.account_circle), label: 'Profile'),
      ],
    );
  }
}
