import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';//formatea los mensajes de forma bonita en la consola

//Este archivo es para mostrar logs (mensajes al desarrollador de lo que esta pasando en la app), sin esto el desarrollador 
//no tiene forma de saber que esta pasando
class AppLogger {
  AppLogger._();

//El ._() es un constructor privado. Significa que nadie puede crear un objeto de esta clase con AppLogger()  

//Cuando la app ya este en la tienda ya no tendria sentido mostrar estos mensajes ya que nadie los veria y se gastarian recursos
//de forma innecesaria para eso es la variable kDebugMode todo el tiempo esta pendiente si esta en desarrollo o no 
//Cuando pones Level.debug → el umbral está abajo del todo, entonces ves todo: debug, info, warning y error
//Cuando pones Level.warning → el umbral está más arriba, entonces solo ves lo urgente: warning y error

  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 80,
    ),
    level: kDebugMode ? Level.debug : Level.warning,
  );

//Hay 4 niveles de log: debug, info, warning y error. 
//debug: Detalles internos por ejemplo: "Entrando a insertMood()", 'El mood tiene id: 3'
  static void debug(String message) {
    if (kDebugMode) _logger.d(message);
  }

//info: Cosas que pasaron bien, por ejemplo: "Mood creado correctamente", 'Sincronización completada'
  static void info(String message) {
    if (kDebugMode) _logger.i(message);
  }

//warning: Algo raro pero no crítico, por ejemplo: "El servidor tardó mucho", 'El mood llegó sin nota, se usó valor vacío'
  static void warning(String message) => _logger.w(message);

//error: Algo falló, por ejemplo: "Sin conexión a internet", 'No se pudo guardar en la base de datos'
  static void error(String message, {Object? error, StackTrace? stackTrace}) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }
}