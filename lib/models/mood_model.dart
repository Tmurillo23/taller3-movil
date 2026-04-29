class MoodModel {
  final int? id;
  final String nombre;
  final String emocion;
  final String? nota;
  final DateTime fechaCreacion;
  final bool pendingSync;

  const MoodModel({
    this.id,
    required this.nombre,
    required this.emocion,
    this.nota,
    required this.fechaCreacion,
    required this.pendingSync,
  });

  MoodModel copyWith({
    int? id,
    String? nombre,
    String? emocion,
    String? nota,
    DateTime? fechaCreacion,
    bool? pendingSync,
  }) {
    return MoodModel(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      emocion: emocion ?? this.emocion,
      nota: nota ?? this.nota,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      pendingSync: pendingSync ?? this.pendingSync,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'nombre': nombre,
      'emocion': emocion,
      'nota': nota,
      'fechaCreacion': fechaCreacion.toIso8601String(),
    };
  }

  factory MoodModel.fromFirestore(Map<String, dynamic> map, {required int id}) {
  return MoodModel(
    id: id,
    nombre: map['nombre'] as String? ?? '',
    emocion: map['emocion'] as String? ?? '',
    nota: map['nota'] as String? ?? '',
    fechaCreacion:
        DateTime.tryParse(map['fechaCreacion'] as String? ?? '') ??
        DateTime.now(),
    pendingSync: map['pendingSync'] as bool? ?? false,
  );
}
}