import 'package:flutter/foundation.dart';
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
    setState(() { _loading = true; _errorMessage = null; });
    try {
      await widget.repository.loadInitialData();
    } catch (e, st) {
      AppLogger.error('Error en carga inicial', error: e, stackTrace: st);
      _errorMessage = 'No se pudieron cargar los datos.';
    } finally {
      if (mounted) setState(() { _loading = false; });
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
        nombre: result.nombre,
        emocion: result.emocion,
        nota: result.nota,
      );
      _showSnackBar('Estado de ánimo creado');
    } catch (e, st) {
      AppLogger.error('Error al crear estado de ánimo', error: e, stackTrace: st);
      _showSnackBar('No se pudo crear');
    }
  }

  Future<void> _refreshFromRemote() async {
    try {
      await widget.repository.refreshFromRemote();
      _showSnackBar('Datos actualizados desde Firebase');
    } catch (e, st) {
      AppLogger.error('Error al actualizar desde Firebase', error: e, stackTrace: st);
      _showSnackBar('No se pudo actualizar');
    }
  }

  Future<void> _syncPending() async {
    try {
      await widget.repository.syncPendingMoods();
      _showSnackBar('Sincronización pendiente ejecutada');
    } catch (e, st) {
      AppLogger.error('Error al sincronizar', error: e, stackTrace: st);
      _showSnackBar('Fallo la sincronización');
    }
  }

  void _showSnackBar(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _runQaAction(String message, Future<void> Function() action) async {
    try {
      await action();
      _showSnackBar(message);
    } catch (e, st) {
      AppLogger.error('Error en acción QA', error: e, stackTrace: st);
      _showSnackBar('Error simulado registrado');
    }
  }

  Widget _buildQaMenu() {
    if (!kDebugMode) return const SizedBox.shrink();
    return PopupMenuButton<String>(
      tooltip: 'Herramientas QA',
      icon: const Icon(Icons.bug_report_outlined),
      onSelected: (value) {
        switch (value) {
          case 'permission_denied':
            _runQaAction('QA: permission-denied simulado', widget.repository.qaCreateMoodWithPermissionDenied);
            break;
          case 'network_error':
            _runQaAction('QA: error de red simulado', widget.repository.qaCreateMoodWithNetworkError);
            break;
          case 'unexpected':
            _runQaAction('QA: error inesperado simulado', widget.repository.qaCreateMoodWithUnexpectedError);
            break;
          case 'long_text':
            _runQaAction('QA: texto largo creado', widget.repository.qaCreateLongTextMood);
            break;
          case 'slow_loading':
            _runQaAction('QA: carga lenta finalizada', widget.repository.qaSimulateSlowOperation);
            break;
          case 'ui_error':
            _runQaAction('QA: error de UI registrado', widget.repository.qaThrowUnexpectedUiError);
            break;
          case 'refresh_remote':
            _refreshFromRemote();
            break;
          case 'sync_pending':
            _syncPending();
            break;
          case 'reload_stream':
            _reloadStream();
            _showSnackBar('Stream recargado');
            break;
        }
      },
      itemBuilder: (_) => const [
        PopupMenuItem(value: 'permission_denied', child: Text('QA: simular permission-denied')),
        PopupMenuItem(value: 'network_error', child: Text('QA: simular error de red')),
        PopupMenuItem(value: 'unexpected', child: Text('QA: simular error inesperado')),
        PopupMenuItem(value: 'long_text', child: Text('QA: crear texto largo')),
        PopupMenuItem(value: 'slow_loading', child: Text('QA: simular carga lenta')),
        PopupMenuItem(value: 'ui_error', child: Text('QA: simular error de UI')),
        PopupMenuDivider(),
        PopupMenuItem(value: 'refresh_remote', child: Text('Actualizar desde Firebase')),
        PopupMenuItem(value: 'sync_pending', child: Text('Sincronizar pendientes')),
        PopupMenuItem(value: 'reload_stream', child: Text('Recargar stream local')),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Mis estados de ánimo'), actions: [_buildQaMenu()]),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Mis estados de ánimo'), actions: [_buildQaMenu()]),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_errorMessage!),
              ElevatedButton(onPressed: _loadInitialData, child: const Text('Reintentar')),
            ],
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
          _buildQaMenu(),
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
            return Center(child: Text('Error al cargar datos locales.'));
          }
          final moods = snapshot.data ?? [];
          if (moods.isEmpty) {
            return const Center(child: Text('No hay estados de ánimo registrados'));
          }
          return ListView.builder(
            itemCount: moods.length,
            itemBuilder: (_, i) => MoodTile(mood: moods[i]),
          );
        },
      ),
    );
  }
}