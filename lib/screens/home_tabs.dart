import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../models/generator.dart';


// Runtime Tab

class RuntimeTab extends StatefulWidget {
  const RuntimeTab({super.key});

  @override
  State<RuntimeTab> createState() => _RuntimeTabState();
}

class _RuntimeTabState extends State<RuntimeTab> {
  String? selectedCode;
  final runtimeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final generatorBox = Hive.box<Generator>('generators');
    final generators = generatorBox.values.toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          DropdownButton<String>(
            isExpanded: true,
            value: selectedCode,
            hint: const Text("Select Generator"),
            items: generators.map((gen) {
              return DropdownMenuItem(
                value: gen.code,
                child: Text(gen.name),
              );
            }).toList(),
            onChanged: (val) {
              setState(() {
                selectedCode = val;
              });
            },
          ),
          const SizedBox(height: 10),
          TextField(
            controller: runtimeController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: "Runtime (hours)"),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (selectedCode != null && runtimeController.text.isNotEmpty) {
                final genIndex = generators.indexWhere((g) => g.code == selectedCode);
                if (genIndex != -1) {
                  final gen = generators[genIndex];
                  gen.runtime = runtimeController.text;

                  final double fuel = double.tryParse(gen.fuel) ?? 0;
                  final double usage = double.tryParse(gen.usage) ?? 0;
                  final double runtime = double.tryParse(gen.runtime) ?? 0;

                  gen.remaining = (fuel - (usage * runtime)).toStringAsFixed(1);
                  generatorBox.putAt(genIndex, gen);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Runtime saved and remaining fuel updated!")),
                  );

                  runtimeController.clear();
                  setState(() {});
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please select generator and enter runtime")),
                );
              }
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }
}

// for the fuel tab
class FuelTab extends StatefulWidget {
  const FuelTab({super.key});

  @override
  State<FuelTab> createState() => _FuelTabState();
}

class _FuelTabState extends State<FuelTab> {
  Generator? selectedGenerator;
  final fuelController = TextEditingController();
  final rateController = TextEditingController();
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    final generatorBox = Hive.box<Generator>('generators');
    final generators = generatorBox.values.toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          DropdownButton<Generator>(
            isExpanded: true,
            hint: const Text("Select Generator"),
            value: selectedGenerator,
            items: generators.map((gen) {
              return DropdownMenuItem(
                value: gen,
                child: Text(gen.name),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedGenerator = value;
              });
            },
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2023),
                lastDate: DateTime(2030),
              );
              if (picked != null) {
                setState(() {
                  selectedDate = picked;
                });
              }
            },
            icon: const Icon(Icons.calendar_today),
            label: Text(
              selectedDate == null
                  ? "Select Date"
                  : DateFormat('yyyy-MM-dd').format(selectedDate!),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: fuelController,
            decoration: const InputDecoration(labelText: "Fuel Added (L)"),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: rateController,
            decoration: const InputDecoration(labelText: "Fuel Rate (LKR/L)"),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              if (selectedGenerator == null ||
                  selectedDate == null ||
                  fuelController.text.isEmpty ||
                  rateController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please complete all fields")),
                );
                return;
              }

              final index = generators.indexOf(selectedGenerator!);
              selectedGenerator!.fuel = fuelController.text;
              generatorBox.putAt(index, selectedGenerator!);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Fuel info saved")),
              );

              fuelController.clear();
              rateController.clear();
              selectedDate = null;

              setState(() {
                selectedGenerator = null;
              });
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }
}
