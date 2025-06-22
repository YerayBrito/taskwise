import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../widgets/custom_form_fields.dart';
import '../widgets/custom_buttons.dart';

class TaskEditScreen extends StatefulWidget {
  final Task? task;

  const TaskEditScreen({super.key, this.task});

  @override
  _TaskEditScreenState createState() => _TaskEditScreenState();
}

class _TaskEditScreenState extends State<TaskEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late String _category;
  late DateTime _dueDate;
  late TaskPriority _priority;
  late List<String> _tags;

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _title = widget.task!.title;
      _description = widget.task!.description;
      _category = widget.task!.category;
      _dueDate = widget.task!.dueDate;
      _priority = widget.task!.priority;
      _tags = List.from(widget.task!.tags);
    } else {
      _title = '';
      _description = '';
      _category = '';
      _dueDate = DateTime.now().add(const Duration(days: 1));
      _priority = TaskPriority.medium;
      _tags = [];
    }
    _titleController.text = _title;
    _descriptionController.text = _description;
    _categoryController.text = _category;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);

      final newTask = Task(
        id: widget.task?.id,
        title: _title,
        description: _description,
        category: _category,
        dueDate: _dueDate,
        priority: _priority,
        tags: _tags,
        isCompleted: widget.task?.isCompleted ?? false,
        createdAt: widget.task?.createdAt,
        completedAt: widget.task?.completedAt,
      );

      try {
        if (widget.task == null) {
          await taskProvider.addTask(newTask);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Tarea creada exitosamente'),
                backgroundColor: Colors.green,
              ),
            );
          }
        } else {
          await taskProvider.updateTask(newTask);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Tarea actualizada exitosamente'),
                backgroundColor: Colors.blue,
              ),
            );
          }
        }
        if (mounted) {
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Nueva Tarea' : 'Editar Tarea'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveForm,
            tooltip: 'Guardar',
          ),
        ],
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: <Widget>[
                // Título
                CustomTextField(
                  label: 'Título',
                  hint: 'Ingresa el título de la tarea',
                  controller: _titleController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Por favor ingresa un título';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _title = value!.trim();
                  },
                  prefixIcon: const Icon(Icons.title),
                ),

                // Descripción
                CustomTextField(
                  label: 'Descripción',
                  hint: 'Describe la tarea (opcional)',
                  controller: _descriptionController,
                  maxLines: 3,
                  onSaved: (value) {
                    _description = value?.trim() ?? '';
                  },
                  prefixIcon: const Icon(Icons.description),
                ),

                // Categoría
                CustomDropdownField<String>(
                  label: 'Categoría',
                  value: _category.isEmpty ? null : _category,
                  items: taskProvider.categories.where((cat) => cat != 'All').toList(),
                  itemToString: (category) => category,
                  onChanged: (value) {
                    setState(() {
                      _category = value ?? '';
                    });
                  },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Por favor selecciona una categoría';
                    }
                    return null;
                  },
                  prefixIcon: const Icon(Icons.category),
                ),

                // Prioridad
                PrioritySelector(
                  value: _priority,
                  onChanged: (priority) {
                    setState(() {
                      _priority = priority;
                    });
                  },
                ),

                // Fecha de vencimiento
                CustomDateField(
                  label: 'Fecha de Vencimiento',
                  value: _dueDate,
                  onChanged: (date) {
                    setState(() {
                      _dueDate = date;
                    });
                  },
                ),

                // Etiquetas
                TagsInputField(
                  tags: _tags,
                  availableTags: taskProvider.tags,
                  onChanged: (tags) {
                    setState(() {
                      _tags = tags;
                    });
                  },
                ),

                const SizedBox(height: 32),

                // Botones de acción
                Row(
                  children: [
                    Expanded(
                      child: SecondaryButton(
                        text: 'Cancelar',
                        icon: Icons.cancel,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: PrimaryButton(
                        text: widget.task == null ? 'Crear' : 'Actualizar',
                        icon: widget.task == null ? Icons.add : Icons.save,
                        onPressed: _saveForm,
                      ),
                    ),
                  ],
                ),

                if (widget.task != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Información de la Tarea',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('Creada: ${_formatDate(widget.task!.createdAt)}'),
                        if (widget.task!.completedAt != null)
                          Text('Completada: ${_formatDate(widget.task!.completedAt!)}'),
                        Text('Estado: ${widget.task!.isCompleted ? "Completada" : "Pendiente"}'),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
} 