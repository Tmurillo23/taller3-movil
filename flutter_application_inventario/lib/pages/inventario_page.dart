import 'package:flutter/material.dart';
import 'package:flutter_application_inventario/data/app_database.dart';
import '../models/inventario_model.dart';
import '../services/inventario_repository.dart';
import '../widgets/producto_form_dialog.dart';
import '../widgets/producto_tile.dart';

class InventarioPage extends StatefulWidget {
  final InventarioRepository repository;
  const InventarioPage({super.key, required this.repository});

  @override
  State<InventarioPage> createState() => _InventarioPageState();
}

class _InventarioPageState extends State<InventarioPage> {
  bool _loading = true;
  String? _errorMessage;
  int _reloadKey = 0;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });
    try {
      await widget.repository.loadInitialData();
    } catch (e) {
      _errorMessage = 'No se pudieron cargar los datos. Intenta nuevamente.';
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _reloadStream() => setState(() => _reloadKey++);

  Future<void> _goToAddProducto() async {
    final result = await showDialog<ProductoFormResult>(
      context: context,
      builder: (_) => const InventarioFormDialog(),
    );
    if (result == null) return;

    try {
      await widget.repository.addProducto(
        nombreProducto: result.nombreProducto!,
        stock: result.stock!,
        categoria: result.categoria!,
      );
      _showSnackBar('Producto creado correctamente.');
    } catch (e) {
      _showSnackBar('No se pudo crear el producto.');
    }
  }

  Future<void> _editProducto(ProductoModel producto) async {
    final result = await showDialog<ProductoFormResult>(
      context: context,
      builder: (_) => InventarioFormDialog(inventario: producto),
    );
    if (result == null) return;

    try {
      await widget.repository.updateProducto(
        producto: producto,
        nombreProducto: result.nombreProducto!,
        stock: result.stock!,
        categoria: result.categoria!,
      );
      _showSnackBar('Producto actualizado correctamente.');
    } catch (e) {
      _showSnackBar('No se pudo actualizar el producto.');
    }
  }

  Future<void> _refreshFromRemote() async {
    try {
      await widget.repository.refreshFromRemote();
      _showSnackBar('Datos actualizados desde Firebase.');
    } catch (e) {
      _showSnackBar('No se pudieron actualizar los datos.');
    }
  }

  Future<void> _syncPending() async {
    try {
      await widget.repository.syncPendingProductos();
      _showSnackBar('Sincronización pendiente ejecutada.');
    } catch (e) {
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
        appBar: AppBar(title: const Text('Mi inventario')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Mi inventario')),
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
        title: const Text('Mi inventario'),
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
        onPressed: _goToAddProducto,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<ProductoModel>>(
        key: ValueKey(_reloadKey),
        stream: widget.repository.watchProductos(),
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

          final productos = snapshot.data ?? [];
          if (productos.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.inbox_outlined, size: 56),
                  const SizedBox(height: 12),
                  const Text('No hay productos registrados.'),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: _goToAddProducto,
                    icon: const Icon(Icons.add),
                    label: const Text('Crear primer producto'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (_, i) => ProductoTile(
              producto: productos[i],
              onEdit: () => _editProducto(productos[i])
            ),
          );
        },
      ),
    );
  }
}