import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workout_tracker/widgets/weakly_card.dart';

import '../scoped_models/workouts.dart';
import '../scoped_models/exercises.dart';
import '../widgets/workout_calendar.dart';
import '../widgets/exercises.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();

    // Initialize after super.initState() completes
    _widgetOptions = [
      _buildDashboardContent(),
      const WorkoutCalendar(),
      const Exercises(),
    ];
WidgetsBinding.instance.addPostFrameCallback((_) {
    _loadInitialData();
  });
     }
Future<void> _loadInitialData() async {
  try {
    await ScopedModel.of<WorkoutsModel>(context).loadWorkouts();
    await ScopedModel.of<ExercisesModel>(context).loadExercises();
  } catch (e) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Error'),
        content: const Text('Failed to load data'),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
    )
    );
  }
}
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  Widget _buildProgressCard() {
    return ScopedModelDescendant<WorkoutsModel>(
      builder: (context, child, model) {
        if (model.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        final todayExercises = model.getTodayExercises();
        final totalWeightLifted = model.calculateTotalWeightLifted();
        final weightChangePercentage = model.calculateWeightChangePercentage();

        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Today\'s Progress',
                      style: GoogleFonts.roboto(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      weightChangePercentage >= 0
                          ? '+${weightChangePercentage.toStringAsFixed(1)}%'
                          : '${weightChangePercentage.toStringAsFixed(1)}%',
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        color:
                            weightChangePercentage >= 0
                                ? Colors.green
                                : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (todayExercises.isEmpty)
                  const Center(
                    child: Text(
                      'No exercises logged today.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                else
                  Column(
                    children: [
                      Text(
                        'Total Weight Lifted: $totalWeightLifted lbs',
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...todayExercises.map(
                        (exercise) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                exercise['name'],
                                style: GoogleFonts.roboto(fontSize: 14),
                              ),
                              Text(
                                '${exercise['totalWeight']} lbs',
                                style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMetricRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.roboto(fontSize: 16)),
        Text(
          value,
          style: GoogleFonts.roboto(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildDashboardContent() {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
         
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildProgressCard(),
            const SizedBox(height: 20),
            WeeklyProgressCard(),
          ],
        ),
      ),
    );
  }

  Widget homeView() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Workout Tracker',
          style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.red,
        elevation: 0,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeader() {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const CircleAvatar(
        radius: 25,
        backgroundImage: AssetImage('assets/images/images (3).jpeg'),
      ),
      title: Text(
        'Good Morning,',
        style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        'Ready for your workout?',
        style: GoogleFonts.roboto(color: Colors.grey),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            color: _selectedIndex == 0 ? Colors.red : Colors.grey,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.calendar_today,
            color: _selectedIndex == 1 ? Colors.red : Colors.grey,
          ),
          label: 'Calendar',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.directions_bike,
            color: _selectedIndex == 2 ? Colors.red : Colors.grey,
          ),
          label: 'Exercises',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.red,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      elevation: 10,
      onTap: _onItemTapped,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<WorkoutsModel>(
      builder: (context, child, workoutsModel) {
        if (workoutsModel.loading) {
          return  Scaffold(
            
            body: Center(
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.cover,
              ),
            ),
          );
        } else {
          return homeView();
        }
      },
    );
  }
}
