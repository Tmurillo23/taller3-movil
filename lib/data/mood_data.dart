import '../models/mood_model.dart';

List<MoodModel> moods = [
  MoodModel(
    id: 1,
    nombre: 'Ana',
    emocion: 'Feliz',
    nota: 'Hoy tuve un gran día en la universidad',
    fechaCreacion: DateTime(2026, 4, 28),
    pendingSync: false,
  ),

  MoodModel(
    id: 2,
    nombre: 'Carlos',
    emocion: 'Triste',
    nota: 'Me sentí muy cansado hoy',
    fechaCreacion: DateTime(2026, 4, 29),
    pendingSync: false,
  ),

  MoodModel(
    id: 3,
    nombre: 'Laura',
    emocion: 'Ansioso',
    nota: 'Tengo muchos trabajos pendientes',
    fechaCreacion: DateTime(2026, 4, 29),
    pendingSync: true,
  ),

  MoodModel(
    id: 4,
    nombre: 'Miguel',
    emocion: 'Tranquilo',
    nota: 'Descansé toda la tarde',
    fechaCreacion: DateTime(2026, 4, 27),
    pendingSync: false,
  ),

  MoodModel(
    id: 5,
    nombre: 'Sofía',
    emocion: 'Enojado',
    nota: 'Tuve problemas en el trabajo',
    fechaCreacion: DateTime(2026, 4, 26),
    pendingSync: true,
  ),
];