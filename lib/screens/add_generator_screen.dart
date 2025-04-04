import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import '../models/generator.dart';

class AddGeneratorScreen extends StatefulWidget {
  final Generator? generatorToUpdate; // ✅ For editing

  const AddGeneratorScreen({super.key, this.generatorToUpdate});

  @override
  State<AddGeneratorScreen> createState() => _AddGeneratorScreenState();
}

class _AddGeneratorScreenState extends State<AddGeneratorScreen> {
  final nameController = TextEditingController();
  final codeController = TextEditingController();
  final fuelController = TextEditingController();
  final usageController = TextEditingController();
  final runtimeController = TextEditingController();

  String? imagePath;
  double? latitude;
  double? longitude;

  final generatorBox = Hive.box<Generator>('generators');

  @override
  void initState() {
    super.initState();
    if (widget.generatorToUpdate != null) {
      final g = widget.generatorToUpdate!;
      nameController.text = g.name;
      codeController.text = g.code;
      fuelController.text = g.fuel;
      usageController.text = g.usage;
      runtimeController.text = g.runtime;
      imagePath = g.imagePath;
      latitude = g.latitude;
      longitude = g.longitude;
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        imagePath = picked.path;
      });
    }
  }

  Future<void> getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Location service not enabled")),
        );
      }
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      final position = await Geolocator.getCurrentPosition();
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
      });
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Location permission denied")),
        );
      }
    }
  }

  void saveGenerator() {
    final name = nameController.text;
    final code = codeController.text;
    final fuel = fuelController.text;
    final usage = usageController.text;
    final runtime = runtimeController.text;

    if (name.isEmpty || code.isEmpty || fuel.isEmpty || usage.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    final newGen = Generator(
      name: name,
      code: code,
      fuel: fuel,
      usage: usage,
      runtime: runtime.isEmpty ? '0' : runtime,
      remaining: fuel,
      imagePath: imagePath,
      latitude: latitude,
      longitude: longitude,
    );

    if (widget.generatorToUpdate != null) {
      final index = generatorBox.values.toList().indexOf(widget.generatorToUpdate!);
      if (index != -1) {
        generatorBox.putAt(index, newGen);
      }
    } else {
      generatorBox.add(newGen);
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.generatorToUpdate != null ? "Update Generator" : "Add Generator"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Generator Name"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: codeController,
              decoration: const InputDecoration(labelText: "Generator Code"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: fuelController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Fuel Capacity (L)"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: usageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Usage Rate (L/hr)"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: runtimeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Initial Runtime (optional)",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.image),
              label: const Text("Select Image"),
              onPressed: pickImage,
            ),
            if (imagePath != null) ...[
              const SizedBox(height: 10),
              Image.file(File(imagePath!), height: 100),
            ],
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.location_on),
              label: const Text("Get Location"),
              onPressed: getLocation,
            ),
            if (latitude != null && longitude != null)
              Text("Location: ($latitude, $longitude)"),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: saveGenerator,
              child: Text(widget.generatorToUpdate != null ? "Update Generator" : "Save Generator"),
            ),
          ],
        ),
      ),
    );
  }
}
