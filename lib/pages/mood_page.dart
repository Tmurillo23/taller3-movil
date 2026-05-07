import 'package:flutter/material.dart';
import '../models/mood_model.dart';
import '../services/mood_repository.dart';
import '../widgets/mood_form_dialog.dart';
import '../widgets/mood_tile.dart';

//Es un StatefulWidget, lo que significa que esta pantalla puede cambiar visualmente según su estado interno (cargando, error, etc).
class MoodsPage extends StatefulWidget {

 //ecibe un repository desde afuera. Ese repositorio es quien sabe cómo obtener, guardar y sincronizar los moods. 
 //La pantalla no lo hace sola, se lo delega a él. 
  final MoodRepository repository;
  const MoodsPage({super.key, required this.repository});

  @override
  State<MoodsPage> createState() => _MoodsPageState();
}

class _MoodsPageState extends State<MoodsPage> {
  //Controla el indicador de carga, empieza en true porque lo primero que hace la pantalla es cargar los datos 
  bool _loading = true;
  //Aqui se guarda el mensaje de error si algo falla, es nulo si todo salio bien 
  String? _errorMessage;
  int _reloadKey = 0;//para actualizar el StreamBuilder en caso de error, se le asigna un nuevo valor cada vez que se quiera recargar el stream.

  @override
  //initState() se caraga una sola vez cuando la pantalla inicia
  void initState() {
    super.initState();
    _loadInitialData();//Aquis se cargan los datos iniciales 
  }

  Future<void> _loadInitialData() async {
    //Activa el indicador de carga y limpia cualquier error previo. setState le dice a Flutter que redibuje la pantalla con estos cambios
    setState(() {
      _loading = true;
      _errorMessage = null;
    });
    try {
      //Llama al repositorio para cargar los datos.
      await widget.repository.loadInitialData();
    } catch (e) {
      //Si hubo un error, guarda el mensaje para mostrarlo en pantalla.
      _errorMessage = 'No se pudieron cargar los datos. Intenta nuevamente.';
    } finally {
      if (mounted) setState(() => _loading = false);
      //finally siempre se ejecuta, haya error o no. Desactiva el indicador de carga. 
      //mounted verifica que despues de que la pantalla cargara los datos esta siguiera abierta si lo esta actaliza los datos de lo contrario no hace nada. 
    }
  }

//Si la variable que escucha en tiempo real a la BD (StreamBuilder) tiene un error esta no se vuelve a actualizar la solucion para esto es (_reloadKey es como el numero de widget que estamos) se aumenta en 1 esta variable para que piense que estamos en una nueva widget y empieza desde cero y el StreamBuilder vuelve a escuchar a la BD 
  void _reloadStream() => setState(() => _reloadKey++);

//Esta funcion sirve para abrir el formulario para crear un nuevo estado de ánimo, y luego de que el usuario lo llene y lo envie, se llama al repositorio para agregar el nuevo estado de ánimo a la BD. Si todo sale bien muestra un mensaje de exito, si algo falla muestra un mensaje de error.  
  Future<void> _goToAddMood() async {
    final result = await showDialog<MoodFormResult>(
      context: context,
      builder: (_) => const MoodFormDialog(),
    );
    //Si el usuario cerró el diálogo sin guardar, result es null y la función termina aquí.
    if (result == null) return;

//Si el usuario sí guardó, llama al repositorio para crear el mood. Luego muestra un mensaje de éxito o error en la parte inferior de la pantalla (SnackBar).
    try {
      await widget.repository.addMood(
        nombre: result.nombre!,
        emocion: result.emocion!,
        nota: result.nota,
      );
      _showSnackBar('Estado de ánimo creado correctamente.');
    } catch (e) {
      _showSnackBar('No se pudo crear el estado de ánimo.');
    }
  }

//Igual que _goToAddMood pero abre el diálogo con los datos del mood existente para editarlo.
  Future<void> _editMoodNote(MoodModel mood) async {
    final result = await showDialog<MoodFormResult>(
      context: context,
      builder: (_) => MoodFormDialog(mood: mood),
    );
    //Si no guardo los cambios o cerró el diálogo, result es null y la función termina aquí.
    if (result == null) return;

//Si el usuario guardó los cambios, llama al repositorio para actualizar solo la nota del mood.
    try {
      await widget.repository.updateMoodNote(
        mood: mood,
        nota: result.nota,
      );
      _showSnackBar('Nota actualizada correctamente.');
    } catch (e) {
      _showSnackBar('No se pudo actualizar la nota.');
    }
  }

//Descarga los moods desde Firebase y los guarda localmente. Es el botón de la nube en la barra superior.
//Actualizar los datos desde Firebase por si el usuario hizo cambios en un dispositivo quiere verlo en otro.
  Future<void> _refreshFromRemote() async {
    try {
      await widget.repository.refreshFromRemote();
      _showSnackBar('Datos actualizados desde Firebase.');
    } catch (e) {
      _showSnackBar('No se pudieron actualizar los datos.');
    }
  }

//Envía al servidor los moods que tienen pendingSync = true. Es el botón de sincronizar en la barra superior.
//Si el usuario creo mood s sin intenet o hizo cambio sin interne, cuando vuelve la conexion busca los objetos que tengan pendingSync = true es decir no se ha guardado en la BD local lo actualiza y luego lo guarda en firebase. 
  Future<void> _syncPending() async {
    try {
      await widget.repository.syncPendingMoods();
      _showSnackBar('Sincronización pendiente ejecutada.');
    } catch (e) {
      _showSnackBar('No se pudieron sincronizar las tareas pendientes.');
    }
  }

//Muestra una barra de mensaje temporal en la parte inferior de la pantalla. Primero verifica que la pantalla siga abierta con mounted.
  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Mis estados de ánimo')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    //Si hubo error → muestra un ícono de error, el mensaje y un botón para reintentar.
    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Mis estados de ánimo')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 56),
                const SizedBox(height: 12),
                Text(_errorMessage!, textAlign: TextAlign.center),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: _loadInitialData,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    //Si todo está bien → muestra la pantalla normal con la barra superior (con los botones de nube y sincronizar) y el botón flotante + para agregar moods.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis estados de ánimo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud_download_outlined),
            tooltip: 'Actualizar desde Firebase',
            onPressed: _refreshFromRemote,
          ),
          IconButton(
            icon: const Icon(Icons.sync),
            tooltip: 'Sincronizar pendientes',
            onPressed: _syncPending,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToAddMood,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<MoodModel>>(
        key: ValueKey(_reloadKey),
        stream: widget.repository.watchMoods(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 56),
                    const SizedBox(height: 12),
                    const Text('Error al cargar datos locales.'),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: _reloadStream,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            );
          }

          final moods = snapshot.data ?? [];
          if (moods.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.inbox_outlined, size: 56),
                  const SizedBox(height: 12),
                  const Text('No hay estados de ánimo registrados.'),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: _goToAddMood,
                    icon: const Icon(Icons.add),
                    label: const Text('Crear primer estado'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: moods.length,
            itemBuilder: (_, i) => MoodTile(
              mood: moods[i],
              onEdit: () => _editMoodNote(moods[i]),
            ),
          );
        },
      ),
    );
  }
}