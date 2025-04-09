import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/user_settings.dart';
import '../services/notification_service.dart';

class SettingsProvider with ChangeNotifier {
  late Box<UserSettings> _settingsBox;
  late UserSettings _settings;
  final NotificationService _notificationService = NotificationService();
  
  SettingsProvider() {
    _init();
  }
  
  Future<void> _init() async {
    _settingsBox = Hive.box<UserSettings>('settings');
    
    if (_settingsBox.isEmpty) {
      // Create default settings
      _settings = UserSettings(
        language: 'en',
        weightUnit: 'kg',
        isDarkMode: false,
        notificationDays: [],
        notificationTime: '08:00',
      );
      await _settingsBox.add(_settings);
    } else {
      _settings = _settingsBox.getAt(0)!;
    }
    
    notifyListeners();
  }
  
  // Getters
  String get language => _settings.language;
  String get weightUnit => _settings.weightUnit;
  bool get isDarkMode => _settings.isDarkMode;
  List<String> get notificationDays => _settings.notificationDays;
  String? get notificationTime => _settings.notificationTime;
  
  // Setters
  Future<void> setLanguage(String language) async {
    _settings.language = language;
    await _updateSettings();
  }
  
  Future<void> setWeightUnit(String unit) async {
    _settings.weightUnit = unit;
    await _updateSettings();
  }
  
  Future<void> setDarkMode(bool isDarkMode) async {
    _settings.isDarkMode = isDarkMode;
    await _updateSettings();
  }
  
  Future<void> setNotificationDays(List<String> days) async {
    _settings.notificationDays = days;
    await _updateSettings();
    _updateNotifications();
  }
  
  Future<void> setNotificationTime(String time) async {
    _settings.notificationTime = time;
    await _updateSettings();
    _updateNotifications();
  }
  
  Future<void> _updateSettings() async {
    await _settingsBox.putAt(0, _settings);
    notifyListeners();
  }
  
  void _updateNotifications() {
    if (_settings.notificationDays.isEmpty || _settings.notificationTime == null) {
      // Cancel all notifications if disabled
      _notificationService.cancelAll();
    } else {
      // Schedule notifications for selected days
      _notificationService.scheduleWeeklyNotifications(
        days: _settings.notificationDays,
        time: _settings.notificationTime!,
        title: 'Time to workout!',
        body: 'Don\'t miss your workout today. Stay consistent!',
      );
    }
  }
}
