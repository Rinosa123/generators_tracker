import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/generator.dart';

class ReportScreen extends StatelessWidget {
  final Generator generator;

  const ReportScreen({super.key, required this.generator});

  Future<void> exportCSV(BuildContext context) async {
    final now = DateTime.now();
    final filename = 'generator_report_${generator.code}_${now.millisecondsSinceEpoch}.csv';

    // Create CSV content
    String csv = '''
Generator: ${generator.name} (${generator.code})
Fuel usage (estimated): ${generator.usage} liters/hour
Fuel usage (actual): ${generator.usage} liters/hour
Fuel capacity: ${generator.fuel} liters

Date,Run time (hr),Fuel usage (l),Fuel balance (l)
${now.toIso8601String().split('T').first},${generator.runtime},${double.tryParse(generator.runtime)! * double.tryParse(generator.usage)!},${generator.remaining}
''';

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$filename');
    await file.writeAsString(csv);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('CSV exported to ${file.path}')));
      await Share.shareXFiles([XFile(file.path)], text: 'Generator Report');
    }
  }

  @override
  Widget build(BuildContext context) {
    final fuelUsed = double.tryParse(generator.runtime)! * double.tryParse(generator.usage)!;

    return Scaffold(
      appBar: AppBar(title: const Text("Report")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(generator.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Code: ${generator.code}"),
            Text("Fuel Capacity: ${generator.fuel} L"),
            Text("Usage Rate: ${generator.usage} L/hour"),
            Text("Runtime: ${generator.runtime} hrs"),
            Text("Fuel Remaining: ${generator.remaining} L"),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            const Text("CSV Summary Preview:", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Table(
              border: TableBorder.all(),
              children: [
                const TableRow(children: [
                  Padding(padding: EdgeInsets.all(8), child: Text("Date")),
                  Padding(padding: EdgeInsets.all(8), child: Text("Runtime")),
                  Padding(padding: EdgeInsets.all(8), child: Text("Fuel Used")),
                  Padding(padding: EdgeInsets.all(8), child: Text("Remaining")),
                ]),
                TableRow(children: [
                  Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(DateTime.now().toIso8601String().split('T').first)),
                  Padding(padding: const EdgeInsets.all(8), child: Text(generator.runtime)),
                  Padding(padding: const EdgeInsets.all(8), child: Text(fuelUsed.toStringAsFixed(1))),
                  Padding(padding: const EdgeInsets.all(8), child: Text(generator.remaining)),
                ]),
              ],
            ),
            const Spacer(),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => exportCSV(context),
                icon: const Icon(Icons.download),
                label: const Text("Export & Share CSV"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
