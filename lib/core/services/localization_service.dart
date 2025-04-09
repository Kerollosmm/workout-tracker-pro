
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class LocalizationService {
  static final LocalizationService _instance = LocalizationService._internal();
  
  factory LocalizationService() {
    return _instance;
  }
  
  LocalizationService._internal();
  
  // Supported locales
  static const List<Locale> supportedLocales = [
    Locale('en', 'US'), // English
    Locale('ar', 'SA'), // Arabic
  ];
  
  // Default locale
  static const Locale fallbackLocale = Locale('en', 'US');
  
  // Private variables
  late Locale _currentLocale;
  Map<String, Map<String, String>> _localizedValues = {};
  
  // Getters
  Locale get currentLocale => _currentLocale;
  
  // Initialize the service
  Future<void> initialize(String defaultLanguage) async {
    _currentLocale = _getLocaleFromLanguage(defaultLanguage);
    await _loadTranslations();
  }
  
  // Set the current locale
  Future<void> setLocale(String languageCode) async {
    _currentLocale = _getLocaleFromLanguage(languageCode);
    await _loadTranslations();
  }
  
  // Load translations from asset files
  Future<void> _loadTranslations() async {
    _localizedValues = {};
    
    for (final locale in supportedLocales) {
      String jsonContent = await rootBundle.loadString(
        'assets/translations/${locale.languageCode}.json',
      );
      
      Map<String, dynamic> values = json.decode(jsonContent);
      Map<String, String> stringValues = {};
      
      values.forEach((key, value) {
        stringValues[key] = value.toString();
      });
      
      _localizedValues[locale.languageCode] = stringValues;
    }
  }
  
  // Get localized string by key
  String translate(String key) {
    if (_localizedValues.isEmpty || 
        !_localizedValues.containsKey(_currentLocale.languageCode)) {
      return key;
    }
    
    return _localizedValues[_currentLocale.languageCode]?[key] ?? key;
  }
  
  // Get locale from language code
  Locale _getLocaleFromLanguage(String language) {
    for (final locale in supportedLocales) {
      if (locale.languageCode == language) {
        return locale;
      }
    }
    return fallbackLocale;
  }
  
  // Get the text direction based on current locale
  TextDirection get textDirection {
    if (_currentLocale.languageCode == 'ar') {
      return TextDirection.rtl;
    }
    return TextDirection.ltr;
  }
}

// Extension method for easy access
extension TranslateExtension on String {
  String get tr => LocalizationService().translate(this);
}