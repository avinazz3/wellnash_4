import 'package:flutter/material.dart';
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
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _loadUserData();
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

  Future<void> _signOut() async {
    await supabase.auth.signOut();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()),
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
            child: Text('Sign Out'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildProfileHeader(context, user!),
            SizedBox(height: 24),
            _buildUserInfoSection(context),
            SizedBox(height: 24),
            _buildBodyDetailsSection(context),
            SizedBox(height: 24),
            _buildWorkoutSection(context),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _signOut,
              child: Text('Sign Out'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
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
              ? Icon(Icons.person, size: 50)
              : null,
        ),
        SizedBox(height: 16),
        Text(user.name),
        Text(user.email ?? 'Email not available'),
      ],
    );
  }

  Widget _buildUserInfoSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Personal Information'),
        SizedBox(height: 8),
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
          user!.email!,
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
        Text('Body Details'),
        SizedBox(height: 8),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Workout Information'),
        SizedBox(height: 8),
        _buildUserInfoField(
          context,
          'Goals',
          user!.goals ?? 'Not set',
          (value) => _updateUser('goals', value),
          icon: Icons.flag,
        ),
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
        title: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
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
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: Text('Save'),
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

  Widget _buildBottomNavigationBar(BuildContext context) {
    return NavigationBar(
      selectedIndex: 2,
      onDestinationSelected: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
            break;
          case 1:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HistoryScreen()),
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