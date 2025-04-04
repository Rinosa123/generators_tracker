import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/generator.dart';
import 'screens/generator_list_screen.dart';
import 'screens/info_screen.dart';
import 'screens/report_screen.dart';
import 'screens/home_tabs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(GeneratorAdapter());
  await Hive.openBox<Generator>('generators');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Generator Tracker',
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
      routes: {
        '/generator': (context) => const GeneratorListScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/report') {
          final generator = settings.arguments as Generator;
          return MaterialPageRoute(
              builder: (_) => ReportScreen(generator: generator));
        }
        return null;
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Generator Tracker'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Runtime'),
              Tab(text: 'Fuel'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const InfoScreen()),
                );
              },
            ),
          ],
        ),
        body: const TabBarView(
          children: [
            RuntimeTab(),
            FuelTab(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          onTap: (index) {
            if (index == 1) {
              Navigator.pushNamed(context, '/generator');
            } else if (index == 2) {
              final box = Hive.box<Generator>('generators');
              if (box.isNotEmpty) {
                Navigator.pushNamed(context, '/report',
                    arguments: box.values.first);
              }
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.electric_bolt), label: 'Generator'),
            BottomNavigationBarItem(
                icon: Icon(Icons.insert_chart), label: 'Report'),
          ],
        ),
      ),
    );
  }
}
