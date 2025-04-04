import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'generator_list_screen.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  String appName = 'Loading...';
  String version = '';

  @override
  void initState() {
    super.initState();
    loadAppInfo();
  }

  Future<void> loadAppInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      appName = info.appName;
      version = '${info.version}+${info.buildNumber}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$appName (version $version)', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            const Text('By\nM.S. Rinosa', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            const Text('Flutter Version: 3.1.4', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            const Text('© 2025 All rights reserved', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/home');
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const GeneratorListScreen()),
            );
          } else if (index == 2) {
            // Already on InfoScreen
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.input),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Generators',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            label: 'Report',
          ),
        ],
      ),
    );
  }
}
