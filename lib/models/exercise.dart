class Exercise {
  final String name;
  final String muscleGroup; // Added field

  Exercise({
    required this.name,
    required this.muscleGroup, // New required parameter
  });

  /// Custom comparator logic below so that even if two objects
  /// are not the same instance they will return true when compared
  /// if their members are equal.
  /// https://medium.com/@ayushpguptaapg/demystifying-and-hashcode-in-dart-2f328d1ab1bc
  @override
  int get hashCode => Object.hash(name, muscleGroup); // Updated hashCodee

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Exercise &&
          name == other.name &&
          muscleGroup == other.muscleGroup; // Updated equality check

  /// Helper to map the object to valid JSON
  Map<String, Object> toJson() {
    return {
      "name": name,
      "muscleGroup": muscleGroup, // Added field to JSON
    };
  }

  /// Helper to create an exercise instance from JSON
  static Exercise fromJson(Map<String, dynamic> json) {
    return Exercise(
      name: json['name'] as String,
      muscleGroup: json['muscleGroup'] as String? ?? 'Other', // Handle legacy data
    );
  }
}
