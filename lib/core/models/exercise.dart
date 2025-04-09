import 'package:hive/hive.dart';
part 'exercise.g.dart';

@HiveType(typeId: 0)
class Exercise extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  String name;
  
  @HiveField(2)
  String muscleGroup;
  
  @HiveField(3)
  bool isFavorite;
  
  @HiveField(4)
  String? notes;
  
  @HiveField(5)
  bool isCustom;
  
  @HiveField(6)
  String? iconPath;
  
  Exercise({
    required this.id,
    required this.name,
    required this.muscleGroup,
    this.isFavorite = false,
    this.notes,
    this.isCustom = false,
    this.iconPath,
  });
}
