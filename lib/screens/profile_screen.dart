import 'package:flutter/material.dart';
import 'package:recipe_book_app/model/user_preference.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  UserPreferences userPreferences = UserPreferences(
    isDarkMode: false,
    language: 'English',
    enableNotifications: true,
    fontSize: 16.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Settings',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            _buildPreferenceRow(
              'Theme',
              userPreferences.isDarkMode ? 'Dark' : 'Light',
            ),
            _buildPreferenceRow('Language', userPreferences.language),
            _buildPreferenceRow(
              'Notifications',
              userPreferences.enableNotifications ? 'Enabled' : 'Disabled',
            ),
            _buildPreferenceRow(
              'Font Size',
              '${userPreferences.fontSize.round()}px',
            ),

            // SizedBox(height: 32),

            // Center(
            //   child: ElevatedButton(
            //     onPressed: _openSettings,
            //     child: Text('Change Settings'),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferenceRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.w600)),
          Text(value, style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }
}
