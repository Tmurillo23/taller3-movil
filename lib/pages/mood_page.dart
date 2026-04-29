import 'package:flutter/material.dart';
import '../models/mood_model.dart';
import '../services/app_logger.dart';
import '../services/mood_repository.dart';
import '../widgets/mood_form_dialog.dart';
import '../widgets/mood_tile.dart';

class MoodsPage extends StatefulWidget {
  final MoodRepository repository;
  const MoodsPage({super.key, required this.repository});

  @override
  State<MoodsPage> createState() => _MoodsPageState();
}

class _MoodsPageState extends State<MoodsPage> {
  bool _loading = true;
  String? _errorMessage;
  int _reloadKey = 0;

  @override
  void initState() {
    super.initState();
    AppLogger.info('MoodsPage abierta');
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });
    try {
      await widget.repository.loadInitialData();
    } catch (e, st) {
      AppLogger.error('Error en carga inicial', error: e, stackTrace: st);
      _errorMessage = 'No se pudieron cargar los datos. Intenta nuevamente.';
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _reloadStream() => setState(() => _reloadKey++);

  Future<void> _goToAddMood() async {
    final result = await showDialog<MoodFormResult>(
      context: context,
      builder: (_) => const MoodFormDialog(),
    );
    if (result == null) return;

    try {
      await widget.repository.addMood(
        nombre: result.nombre!,
        emocion: result.emocion!,
        nota: result.nota,
      );
      _showSnackBar('Estado de ánimo creado correctamente.');
    } catch (e, st) {
      AppLogger.error('Error al crear estado de ánimo', error: e, stackTrace: st);
      _showSnackBar('No se pudo crear el estado de ánimo.');
    }
  }

  Future<void> _editMoodNote(MoodModel mood) async {
    final result = await showDialog<MoodFormResult>(
      context: context,
      builder: (_) => MoodFormDialog(mood: mood),
    );
    if (result == null) return;

    try {
      await widget.repository.updateMoodNote(
        mood: mood,
        nota: result.nota,
      );
      _showSnackBar('Nota actualizada correctamente.');
    } catch (e, st) {
      AppLogger.error('Error al actualizar la nota', error: e, stackTrace: st);
      _showSnackBar('No se pudo actualizar la nota.');
    }
  }

  Future<void> _refreshFromRemote() async {
    try {
      await widget.repository.refreshFromRemote();
      _showSnackBar('Datos actualizados desde Firebase.');
    } catch (e, st) {
      AppLogger.error('Error al actualizar desde Firebase', error: e, stackTrace: st);
      _showSnackBar('No se pudieron actualizar los datos.');
    }
  }

  Future<void> _syncPending() async {
    try {
      await widget.repository.syncPendingMoods();
      _showSnackBar('Sincronización pendiente ejecutada.');
    } catch (e, st) {
      AppLogger.error('Error al sincronizar pendientes', error: e, stackTrace: st);
      _showSnackBar('No se pudieron sincronizar las tareas pendientes.');
    }
  }

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