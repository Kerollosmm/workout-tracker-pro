import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../core/services/notification_service.dart';
import '../widgets/language_selector.dart';
import '../widgets/units_selector.dart';
import '../widgets/theme_selector.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          
          // Weight Unit Settings
          _buildSettingsSection(
            context,
            title: 'Weight Unit',
            child: UnitsSelector(
              selectedUnit: settingsProvider.weightUnit,
              onUnitChanged: (unit) {
                settingsProvider.setWeightUnit(unit);
              },
            ),
          ),
          
          // Theme Settings
          _buildSettingsSection(
            context,
            title: 'Theme',
            child: ThemeSelector(
              isDarkMode: settingsProvider.isDarkMode,
              onThemeChanged: (isDarkMode) {
                settingsProvider.setDarkMode(isDarkMode);
              },
            ),
          ),
          
          // Notifications Settings
          _buildSettingsSection(
            context,
            title: 'Workout Reminders',
            child: _buildNotificationSettings(context, settingsProvider),
          ),
          
          // App Info
          ListTile(
            title: Text('App Version'),
            subtitle: Text('1.0.0'),
            leading: Icon(Icons.info),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSettingsSection(
    BuildContext context, {
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        child,
        Divider(),
      ],
    );
  }
  
  Widget _buildNotificationSettings(BuildContext context, SettingsProvider provider) {
    final List<String> weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    
    return Column(
      children: [
        // Enable/disable reminders
        SwitchListTile(
          title: Text('Enable Reminders'),
          value: provider.notificationDays.isNotEmpty,
          onChanged: (value) {
            if (value) {
              // If enabling, set to all weekdays by default
              provider.setNotificationDays(weekdays);
            } else {
              // If disabling, clear all days
              provider.setNotificationDays([]);
            }
          },
        ),
        
        // Reminder time picker (only show if reminders are enabled)
        if (provider.notificationDays.isNotEmpty)
          ListTile(
            title: Text('Reminder Time'),
            subtitle: Text(provider.notificationTime ?? '8:00 AM'),
            leading: Icon(Icons.access_time),
            onTap: () async {
              final initialTime = provider.notificationTime != null
                  ? TimeOfDay(
                      hour: int.parse(provider.notificationTime!.split(':')[0]),
                      minute: int.parse(provider.notificationTime!.split(':')[1]),
                    )
                  : const TimeOfDay(hour: 8, minute: 0);

              final selectedTime = await showTimePicker(
                context: context,
                initialTime: initialTime,
                builder: (context, child) {
                  return Theme(
                    data: ThemeData.light().copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: Colors.blue,
                        onPrimary: Colors.white,
                        surface: Colors.white,
                        onSurface: Colors.black,
                      ),
                    ),
                    child: child!,
                  );
                },
              );

              if (selectedTime != null) {
                final formattedTime = '${selectedTime.hour}:${selectedTime.minute}';
                provider.setNotificationTime(formattedTime);

                await NotificationService().scheduleWeeklyNotifications(
                  days: provider.notificationDays,
                  time: formattedTime,
                  title: 'Workout Reminder',
                  body: 'Time for your daily workout! 💪',
                );
              }
            },
          ),
        
        // Days selection (only show if reminders are enabled)
        if (provider.notificationDays.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reminder Days',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: weekdays.map((day) {
                    final isSelected = provider.notificationDays.contains(day);
                    return FilterChip(
                      label: Text(day.substring(0, 3)), // Show abbreviated day
                      selected: isSelected,
                      onSelected: (selected) {
                        final updatedDays = List<String>.from(provider.notificationDays);
                        if (selected) {
                          if (!updatedDays.contains(day)) {
                            updatedDays.add(day);
                          }
                        } else {
                          updatedDays.remove(day);
                        }
                        provider.setNotificationDays(updatedDays);
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
