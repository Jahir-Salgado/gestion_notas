import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'nota.dart';
import 'notas_service.dart';

class NotasPage extends StatelessWidget {
  const NotasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Notas'),
      ),
      body: StreamProvider<List<Nota>>.value(
        value: NotasService().getNotas(),
        initialData: [],
        child: NotasList(),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showNotaDialog(context),
      ),
    );
  }

  void _showNotaDialog(BuildContext context, [Nota? nota]) {
    final isNew = nota == null;
    final controllerDescripcion = TextEditingController(text: nota?.descripcion);
    final controllerEstado = TextEditingController(text: nota?.estado);
    final controllerFecha = TextEditingController(text: nota?.fecha.toString());
    final controllerImportante = TextEditingController(text: nota?.importante.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isNew ? 'Nueva Nota' : 'Editar Nota'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controllerDescripcion,
                decoration: const InputDecoration(labelText: 'Descripción'),
              ),
              TextField(
                controller: controllerEstado,
                decoration: const InputDecoration(labelText: 'Estado'),
              ),
              TextField(
                controller: controllerFecha,
                decoration: const InputDecoration(labelText: 'Fecha'),
              ),
              TextField(
                controller: controllerImportante,
                decoration: const InputDecoration(labelText: 'Importante (true/false)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text(isNew ? 'Agregar' : 'Actualizar'),
              onPressed: () {
                final descripcion = controllerDescripcion.text;
                final estado = controllerEstado.text;
                final fecha = DateTime.parse(controllerFecha.text);
                final importante = controllerImportante.text.toLowerCase() == 'true';

                if (isNew) {
                  NotasService().addNota(Nota(
                    descripcion: descripcion,
                    fecha: fecha,
                    estado: estado,
                    importante: importante, id: '',
                  ));
                } else {
                  NotasService().updateNota(Nota(
                    id: nota.id,
                    descripcion: descripcion,
                    fecha: fecha,
                    estado: estado,
                    importante: importante,
                  ));
                }

                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}

class NotasList extends StatelessWidget {
  const NotasList({super.key});

  @override
  Widget build(BuildContext context) {
    final notas = Provider.of<List<Nota>>(context);

    void _showNotaDialog(BuildContext context, Nota nota) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // Aquí puedes construir el diálogo para mostrar la nota
          return AlertDialog(
            title: const Text('Detalles de la nota'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Descripción: ${nota.descripcion}'),
                Text('Fecha: ${nota.fecha}'),
                Text('Estado: ${nota.estado}'),
                Text('Importante: ${nota.importante}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cerrar'),
              ),
            ],
          );
        },
      );
    }

    return ListView.builder(
      itemCount: notas.length,
      itemBuilder: (context, index) {
        final nota = notas[index];
        return ListTile(
          title: Text(nota.descripcion),
          subtitle: Text('Fecha: ${nota.fecha}\nEstado: ${nota.estado}\nImportante: ${nota.importante}'),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => NotasService().deleteNota(nota.id),
          ),
          onTap: () => _showNotaDialog(context, nota),
        );
      },
    );
  }
}
