import 'package:hive/hive.dart';
part 'user_settings.g.dart';

@HiveType(typeId: 4)
class UserSettings extends HiveObject {
  @HiveField(0)
  String language;
  
  @HiveField(1)
  String weightUnit; // kg or lbs
  
  @HiveField(2)
  bool isDarkMode;
  
  @HiveField(3)
  List<String> notificationDays;
  
  @HiveField(4)
  String? notificationTime;
  
  UserSettings({
    this.language = 'en',
    this.weightUnit = 'kg',
    this.isDarkMode = false,
    this.notificationDays = const [],
    this.notificationTime,
  });
}
