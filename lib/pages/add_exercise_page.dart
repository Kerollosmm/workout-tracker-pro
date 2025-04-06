import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/exercise.dart';
import '../scoped_models/exercises.dart';

const List<String> muscleGroups = [
  'Chest',
  'Back',
  'Legs',
  'Shoulders',
  'Arms',
  'Core',
  'Other',
];

class AddExercisePage extends StatefulWidget {
  final Exercise? initialExercise;
  const AddExercisePage({super.key, this.initialExercise});

  @override
  _AddExercisePageState createState() => _AddExercisePageState();
}

class _AddExercisePageState extends State<AddExercisePage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _form = {'name': '', 'muscleGroup': 'Other'};

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
     _form = {
    'name': widget.initialExercise?.name ?? '',
    'muscleGroup': widget.initialExercise?.muscleGroup ?? 'Other',
  };

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();
  }

  void _submitForm(BuildContext context, Function(Exercise) addExercise) {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    final exercise = Exercise(
      name: _form['name'] as String,
      muscleGroup: _form['muscleGroup'] as String,
    );
    addExercise(exercise);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Exercise',
          style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6366F1), Color(0xFF818CF8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        shadowColor: Colors.indigo.withOpacity(0.3),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8FAFC), Color(0xFFF1F5F9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.indigo.withOpacity(0.1),
                          blurRadius: 20,
                          spreadRadius: 2,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              key: const Key('name'),
                              style: GoogleFonts.poppins(),
                              decoration: InputDecoration(
                                labelText: 'Exercise Name',
                                labelStyle: GoogleFonts.poppins(
                                  color: Colors.grey.shade600,
                                ),
                                floatingLabelStyle: GoogleFonts.poppins(
                                  color: const Color(0xFF6366F1),
                                ),
                                prefixIcon: Icon(
                                  Icons.sports_gymnastics,
                                  color: Colors.grey.shade600,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade50,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF6366F1),
                                    width: 1.5,
                                  ),
                                ),
                              ),
                              validator:
                                  (value) =>
                                      value?.isEmpty ?? true
                                          ? 'Please enter a name'
                                          : null,
                              onSaved: (value) => _form['name'] = value ?? '',
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: DropdownButtonFormField<String>(
                                value: _form['muscleGroup'],
                                decoration: InputDecoration(
                                  labelText: 'Muscle Group',
                                  labelStyle: GoogleFonts.poppins(
                                    color: Colors.grey.shade600,
                                  ),
                                  floatingLabelStyle: GoogleFonts.poppins(
                                    color: const Color(0xFF6366F1),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.fitness_center,
                                    color: Colors.grey.shade600,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                ),
                                items:
                                    muscleGroups.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: GoogleFonts.poppins(),
                                        ),
                                      );
                                    }).toList(),
                                onChanged:
                                    (value) => setState(
                                      () => _form['muscleGroup'] = value!,
                                    ),
                                validator:
                                    (value) =>
                                        value?.isEmpty ?? true
                                            ? 'Please select a muscle group'
                                            : null,
                                onSaved:
                                    (value) =>
                                        _form['muscleGroup'] = value ?? 'Other',
                              ),
                            ),
                            const SizedBox(height: 32),
                            ScopedModelDescendant<ExercisesModel>(
                              builder:
                                  (context, child, model) => ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                        horizontal: 24,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      backgroundColor: const Color(0xFF6366F1),
                                      shadowColor: Colors.indigo.withOpacity(
                                        0.3,
                                      ),
                                      elevation: 8,
                                    ),
                                    onPressed:
                                        () => _submitForm(
                                          context,
                                          model.addExercise,
                                        ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.add_circle_outline,
                                          size: 20,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          'Create Exercise',
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Keep your workouts organized\nwith clear exercise names',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
