

part of 'generator.dart';


// TypeAdapterGenerator


class GeneratorAdapter extends TypeAdapter<Generator> {
  @override
  final int typeId = 0;

  @override
  Generator read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Generator(
      name: fields[0] as String,
      code: fields[1] as String,
      fuel: fields[2] as String,
      usage: fields[3] as String,
      runtime: fields[4] as String,
      remaining: fields[5] as String,
      imagePath: fields[6] as String?,
      latitude: fields[7] as double?,
      longitude: fields[8] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, Generator obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.code)
      ..writeByte(2)
      ..write(obj.fuel)
      ..writeByte(3)
      ..write(obj.usage)
      ..writeByte(4)
      ..write(obj.runtime)
      ..writeByte(5)
      ..write(obj.remaining)
      ..writeByte(6)
      ..write(obj.imagePath)
      ..writeByte(7)
      ..write(obj.latitude)
      ..writeByte(8)
      ..write(obj.longitude);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GeneratorAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
