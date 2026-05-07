//El signo de interrgocion cunado se va 

class MoodModel {
  final int? id;
  final String nombre;
  final String emocion;
  final String? nota;
  final DateTime fechaCreacion;
  final bool pendingSync;

//Los campos con required son obligatorios al crearlo. Los que tienen solo this. (sin required) son opcionales
  const MoodModel({
    this.id,
    required this.nombre,
    required this.emocion,
    this.nota,
    required this.fechaCreacion,
    required this.pendingSync,
  });

//Esta funcion se usa cuando se quiere cambiar un objeto ya creado, por el final no se puede modificar un mood ya creado por eso
//cuando se va a ser un cambio en un mood lo que hace es crear uno nuevo con los mismos datos pero con el cambio del usuario,
//en local se borra el mood anterior y se deja el nuevo, pero en la BD se actualiza el mood con el cambio del usuario.
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

 //Convierte el objeto MoodModel a un mapa paraguardarlo en Firestore, es decir a un Map<String, dynamic>. 
 //Esto es necesario para poder guardar los moods en la BD remota. 
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'nombre': nombre,
      'emocion': emocion,
      'nota': nota,
      'fechaCreacion': fechaCreacion.toIso8601String(),//Convierte la fecha en texto ya 
    };
  }

 //Es un constructor especial (factory). Recibe el map que vino de Firestore y el id por separado, porque el id no 
 //viaja dentro del mapa sino que Firestore lo maneja aparte. 
 //Firestore envia y guarda los datos en formato texto y por eso es necesario convertir el objeto en mapa y el mapa en objeto MoodModel.
  factory MoodModel.fromFirestore(Map<String, dynamic> map, {required int id}) {
  return MoodModel(
    id: id,
    //busca la clave 'nombre' en el mapa, si no la encuentra o es nula, asigna una cadena vacía. Lo mismo para las otras claves.
    //los ?? significan que si valor de la clave es nulo entoces en este caso se le asigna un texto vacio para evitar errores.
    nombre: map['nombre'] as String? ?? '',
    emocion: map['emocion'] as String? ?? '',
    nota: map['nota'] as String? ?? '',
    //trata de convertir a la fecha de texto a formato datatime si no puede convertirlo asigna la fecha actual.
    fechaCreacion:
        DateTime.tryParse(map['fechaCreacion'] as String? ?? '') ??
        DateTime.now(),
    pendingSync: map['pendingSync'] as bool? ?? false,
  );
}
}