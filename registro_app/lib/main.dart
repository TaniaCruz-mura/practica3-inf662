import 'package:flutter/material.dart';

void main() {
  runApp(const MiAplicacion());
}

class MiAplicacion extends StatelessWidget {
  const MiAplicacion({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registro de Estudiantes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const PantallaRegistro(),
    );
  }
}

// 1. Modelo de Datos (Incluye Reto Personal: semestre)
class Estudiante {
  final String nombre;
  final int edad;
  final String carrera;
  final int semestre; // Campo del reto personal

  const Estudiante(this.nombre, this.edad, this.carrera, this.semestre);
}

// Lista fija de carreras
const carreras = <String>[
  'Ing. Informatica',
  'Ing. de Sistemas',
  'Ing. Civil',
  'Ing. Comercial',
];

// 2. Pantalla Principal con Estado
class PantallaRegistro extends StatefulWidget {
  const PantallaRegistro({super.key});

  @override
  State<PantallaRegistro> createState() => _PantallaRegistroState();
}

class _PantallaRegistroState extends State<PantallaRegistro> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _edadCtrl = TextEditingController();
  final _semestreCtrl = TextEditingController(); // Controlador reto personal

  String? _carrera;
  final List<Estudiante> _estudiantes = [];

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _edadCtrl.dispose();
    _semestreCtrl.dispose();
    super.dispose();
  }

  // Método para registrar estudiante
  void _registrar() {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _estudiantes.add(
        Estudiante(
          _nombreCtrl.text.trim(),
          int.parse(_edadCtrl.text),
          _carrera!,
          int.parse(_semestreCtrl.text),
        ),
      );

      // Limpiar campos y estado del formulario
      _nombreCtrl.clear();
      _edadCtrl.clear();
      _semestreCtrl.clear();
      _carrera = null;
    });

    _formKey.currentState!.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro (${_estudiantes.length})'), // Contador en AppBar
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // FORMULARIO DE REGISTRO
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Campo Nombre
                  TextFormField(
                    controller: _nombreCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Nombre Completo',
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (v) => (v == null || v.trim().length < 3)
                        ? 'Mínimo 3 caracteres'
                        : null,
                  ),
                  const SizedBox(height: 10),

                  // Campo Edad
                  TextFormField(
                    controller: _edadCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Edad',
                      prefixIcon: Icon(Icons.cake),
                    ),
                    validator: (v) {
                      final edad = int.tryParse(v ?? '');
                      if (edad == null || edad < 15 || edad > 99) {
                        return 'Edad válida: 15 a 99';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Dropdown Carrera
                  DropdownButtonFormField<String>(
                    value: _carrera,
                    decoration: const InputDecoration(
                      labelText: 'Carrera',
                      prefixIcon: Icon(Icons.school),
                    ),
                    items: carreras.map((c) {
                      return DropdownMenuItem(value: c, child: Text(c));
                    }).toList(),
                    onChanged: (v) => setState(() => _carrera = v),
                    validator: (v) =>
                        v == null ? 'Elige una carrera' : null,
                  ),
                  const SizedBox(height: 10),

                  // Campo Semestre (RETO PERSONAL)
                  TextFormField(
                    controller: _semestreCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Semestre (1 al 10)',
                      prefixIcon: Icon(Icons.format_list_numbered),
                    ),
                    validator: (v) {
                      final sem = int.tryParse(v ?? '');
                      if (sem == null || sem < 1 || sem > 10) {
                        return 'Semestre válido: 1 a 10';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Botón Registrar
                  ElevatedButton.icon(
                    onPressed: _registrar,
                    icon: const Icon(Icons.add),
                    label: const Text('Registrar Estudiante'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(45),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 30, thickness: 2),

            // LISTA DE ESTUDIANTES
            Expanded(
              child: _estudiantes.isEmpty
                  ? const Center(
                      child: Text(
                        'No hay estudiantes registrados',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _estudiantes.length,
                      itemBuilder: (context, index) {
                        final e = _estudiantes[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text(
                                e.nombre.isNotEmpty ? e.nombre[0].toUpperCase() : '?',
                              ),
                            ),
                            title: Text(e.nombre),
                            subtitle: Text(
                              '${e.carrera} • ${e.edad} años\nSemestre: ${e.semestre}°',
                            ),
                            isThreeLine: true,
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => setState(() {
                                _estudiantes.removeAt(index);
                              }),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}