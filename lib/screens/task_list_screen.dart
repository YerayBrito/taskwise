import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/custom_cards.dart';
import '../widgets/filter_widgets.dart';
import '../widgets/custom_buttons.dart';
import '../models/task.dart';
import 'task_edit_screen.dart';
import 'dashboard_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showFilters = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TaskWise'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.dashboard),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const DashboardScreen(),
                ),
              );
            },
            tooltip: 'Dashboard',
          ),
          IconButton(
            icon: Icon(_showFilters ? Icons.filter_list_off : Icons.filter_list),
            onPressed: () {
              setState(() {
                _showFilters = !_showFilters;
              });
            },
            tooltip: 'Filtros',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: AppSearchBar(
              hint: 'Buscar tareas...',
              controller: _searchController,
              onChanged: (query) {
                Provider.of<TaskProvider>(context, listen: false).setSearchQuery(query);
              },
              onClear: () {
                _searchController.clear();
                Provider.of<TaskProvider>(context, listen: false).setSearchQuery('');
              },
            ),
          ),

          if (_showFilters) _buildFiltersSection(),

          Expanded(
            child: Consumer<TaskProvider>(
              builder: (context, taskProvider, child) {
                final tasks = taskProvider.filteredTasks;
                
                if (tasks.isEmpty) {
                  return _buildEmptyState(context, taskProvider);
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return TaskCard(
                      task: task,
                      onTap: () => _showTaskDetails(context, task),
                      onEdit: () => _editTask(context, task),
                      onDelete: () => _deleteTask(context, task),
                      onToggleComplete: (value) {
                        taskProvider.toggleTaskStatus(task);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: AppFloatingButton(
        icon: Icons.add,
        onPressed: () => _addNewTask(context),
      ),
    );
  }

  Widget _buildFiltersSection() {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.filter_list, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Filtros',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      taskProvider.clearAllFilters();
                    },
                    child: const Text('Limpiar'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              FilterChipGroup(
                title: 'Estado',
                options: ['All', 'Pending', 'Completed'],
                selectedValue: taskProvider.filterStatus,
                onChanged: (value) {
                  if (value != null) {
                    taskProvider.setFilterByStatus(value);
                  }
                },
                icon: Icons.check_circle,
              ),
              
              const SizedBox(height: 16),
              
              FilterChipGroup(
                title: 'Categoría',
                options: taskProvider.categories,
                selectedValue: taskProvider.filterCategory,
                onChanged: (value) {
                  taskProvider.setFilterByCategory(value);
                },
                icon: Icons.category,
              ),
              
              const SizedBox(height: 16),
              
              PriorityFilter(
                selectedPriority: taskProvider.filterPriority,
                onChanged: (priority) {
                  taskProvider.setFilterByPriority(priority);
                },
              ),
              
              const SizedBox(height: 16),
              
              DateRangeFilter(
                selectedRange: taskProvider.filterDateRange,
                onChanged: (range) {
                  taskProvider.setFilterByDateRange(range);
                },
              ),
              
              const SizedBox(height: 16),
              
              SortOptions(
                selectedSort: taskProvider.sortBy,
                onChanged: (sortBy) {
                  taskProvider.setSortBy(sortBy);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, TaskProvider taskProvider) {
    final hasFilters = taskProvider.filterStatus != 'All' ||
                      taskProvider.filterCategory != null ||
                      taskProvider.filterPriority != null ||
                      taskProvider.filterDateRange != null ||
                      taskProvider.searchQuery.isNotEmpty;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            hasFilters ? Icons.filter_list_off : Icons.task_alt,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            hasFilters ? 'No se encontraron tareas' : 'No hay tareas',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            hasFilters 
                ? 'Intenta ajustar los filtros o crear una nueva tarea'
                : 'Comienza creando tu primera tarea',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          if (!hasFilters)
            PrimaryButton(
              text: 'Crear Primera Tarea',
              icon: Icons.add,
              onPressed: () => _addNewTask(context),
            )
          else
            SecondaryButton(
              text: 'Limpiar Filtros',
              icon: Icons.clear_all,
              onPressed: () {
                taskProvider.clearAllFilters();
                _searchController.clear();
              },
            ),
        ],
      ),
    );
  }

  void _addNewTask(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const TaskEditScreen(),
      ),
    );
  }

  void _editTask(BuildContext context, Task task) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TaskEditScreen(task: task),
      ),
    );
  }

  void _deleteTask(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Confirmar Eliminación'),
          content: Text('¿Estás seguro de que quieres eliminar la tarea "${task.title}"?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
            TextButton(
              child: const Text('Eliminar'),
              onPressed: () {
                Provider.of<TaskProvider>(context, listen: false).deleteTask(task.id!);
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Tarea eliminada'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showTaskDetails(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(task.title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (task.description.isNotEmpty) ...[
                Text(
                  'Descripción:',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(task.description),
                const SizedBox(height: 16),
              ],
              _buildDetailRow('Categoría', task.category),
              _buildDetailRow('Prioridad', _getPriorityText(task.priority)),
              _buildDetailRow('Fecha de vencimiento', _formatDate(task.dueDate)),
              _buildDetailRow('Estado', task.isCompleted ? 'Completada' : 'Pendiente'),
              if (task.tags.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'Etiquetas:',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Wrap(
                  spacing: 4,
                  children: task.tags.map((tag) => Chip(
                    label: Text(tag),
                    backgroundColor: Colors.blue[50],
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  )).toList(),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _editTask(context, task);
            },
            child: const Text('Editar'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  String _getPriorityText(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return 'Baja';
      case TaskPriority.medium:
        return 'Media';
      case TaskPriority.high:
        return 'Alta';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
} 