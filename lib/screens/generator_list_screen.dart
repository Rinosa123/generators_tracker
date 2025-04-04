import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/generator.dart';
import 'add_generator_screen.dart';
import 'generator_details_screen.dart';

class GeneratorListScreen extends StatefulWidget {
  const GeneratorListScreen({super.key});

  @override
  State<GeneratorListScreen> createState() => _GeneratorListScreenState();
}

class _GeneratorListScreenState extends State<GeneratorListScreen> {
  final generatorBox = Hive.box<Generator>('generators');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Generators')),
      body: ValueListenableBuilder(
        valueListenable: generatorBox.listenable(),
        builder: (context, Box<Generator> box, _) {
          if (box.isEmpty) {
            return const Center(child: Text("No generators added yet."));
          }

          final generators = box.values.toList();

          return ListView.builder(
            itemCount: generators.length,
            itemBuilder: (context, index) {
              final gen = generators[index];

              return Dismissible(
                key: Key(gen.code),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (direction) async {
                  return await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Delete Generator"),
                      content: Text("Are you sure you want to delete '${gen.name}'?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text("Delete", style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                },
                onDismissed: (_) {
                  box.deleteAt(index);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("${gen.name} deleted")),
                  );
                },
                child: ListTile(
                  title: Text(gen.name),
                  subtitle: Text("Code: ${gen.code}"),
                  trailing: Text("${gen.fuel} L"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => GeneratorDetailsScreen(generator: gen),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddGeneratorScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
