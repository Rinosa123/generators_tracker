// lib/screens/generator_details_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import '../models/generator.dart';
import 'add_generator_screen.dart';
import 'report_screen.dart';

class GeneratorDetailsScreen extends StatelessWidget {
  final Generator generator;
  const GeneratorDetailsScreen({super.key, required this.generator});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generator Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (generator.imagePath != null && generator.imagePath!.isNotEmpty)
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(File(generator.imagePath!)),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            const SizedBox(height: 16),
            Text(
              generator.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text("Code: ${generator.code}"),
            Text("Fuel Capacity: ${generator.fuel} L"),
            Text("Usage Rate: ${generator.usage} L/hr"),
            Text("Runtime: ${generator.runtime} hrs"),
            Text("Fuel Remaining: ${generator.remaining} L"),
            const SizedBox(height: 12),
            if (generator.latitude != null && generator.longitude != null)
              Text("Location: (${generator.latitude}, ${generator.longitude})"),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.edit),
              label: const Text("Update Generator"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        AddGeneratorScreen(generatorToUpdate: generator),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.insert_chart_outlined),
              label: const Text("View Report"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ReportScreen(generator: generator),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
