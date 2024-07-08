import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wellnash_4/models/user.dart';
import 'package:wellnash_4/providers/user_provider.dart';
import 'home_screen.dart';
import 'history_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final user = userProvider.user;
        if (user == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
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
                _buildProfileHeader(context, user),
                SizedBox(height: 24),
                _buildUserInfoSection(context, userProvider),
                SizedBox(height: 24),
                _buildBodyDetailsSection(context, userProvider),
                SizedBox(height: 24),
                _buildWorkoutSection(context, userProvider),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    // Implement sign out functionality
                  },
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
      },
    );
  }

  Widget _buildProfileHeader(BuildContext context, User user) {
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
        Text(
          user.name,
          //style: Theme.of(context).textTheme.headline5,
        ),
        Text(
          user.email ?? 'Email not available',
          //style: Theme.of(context).textTheme.subtitle1,
        ),
      ],
    );
  }

  Widget _buildUserInfoSection(BuildContext context, UserProvider userProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Personal Information',
          //style: Theme.of(context).textTheme.headline6,
        ),
        SizedBox(height: 8),
        _buildUserInfoField(
          context,
          'Name',
          userProvider.user!.name,
          (value) => userProvider.updateUser('name', value),
          icon: Icons.person,
        ),
        _buildUserInfoField(
          context,
          'Email',
          userProvider.user!.email!,
          null,
          icon: Icons.email,
          editable: false,
        ),
      ],
    );
  }

  Widget _buildBodyDetailsSection(BuildContext context, UserProvider userProvider) {
    final user = userProvider.user!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Body Details',
          //style: Theme.of(context).textTheme.headline6,
        ),
        SizedBox(height: 8),
        _buildUserInfoField(
          context,
          'Height (cm)',
          user.height.toString() ?? 'Not set',
          (value) => userProvider.updateHeight(double.parse(value)),
          icon: Icons.height,
        ),
        _buildUserInfoField(
          context,
          'Weight (kg)',
          user.weight.toString() ?? 'Not set',
          (value) => userProvider.updateWeight(double.parse(value)),
          icon: Icons.monitor_weight,
        ),
      ],
    );
  }

  Widget _buildWorkoutSection(BuildContext context, UserProvider userProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Workout Information',
          //style: Theme.of(context).textTheme.headline6,
        ),
        SizedBox(height: 8),
        _buildUserInfoField(
          context,
          'Goals',
          userProvider.user!.goals ?? 'Not set',
          (value) => userProvider.updateUser('goals', value),
          icon: Icons.flag,
        ),
        _buildUserInfoField(
          context,
          'Workout Days',
          userProvider.user!.workoutDays.toString() ?? 'Not set',
          (value) => userProvider.updateWorkoutDays(int.parse(value)),
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
        NavigationDestination(icon: Icon(Icons.history), label: 'History'),
        NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}