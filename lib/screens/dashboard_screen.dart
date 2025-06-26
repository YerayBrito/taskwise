import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/custom_cards.dart';
import '../widgets/custom_buttons.dart';
import '../models/task.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        actions: [
          AppIconButton(
            icon: Icons.refresh,
            onPressed: () {
              Provider.of<TaskProvider>(context, listen: false).loadStatistics();
            },
          ),
        ],
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          final stats = taskProvider.statistics;
          final overdueTasks = taskProvider.getOverdueTasks();
          final todayTasks = taskProvider.getTasksDueToday();
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeSection(context),
                const SizedBox(height: 24),
                _buildStatisticsGrid(context, stats),
                const SizedBox(height: 24),
                _buildQuickActions(context),
                const SizedBox(height: 24),
                _buildPriorityOverview(context, taskProvider),
                const SizedBox(height: 24),
                _buildOverdueTasksSection(context, overdueTasks),
                const SizedBox(height: 24),
                _buildTodayTasksSection(context, todayTasks),
                const SizedBox(height: 24),
                _buildRecentActivity(context, taskProvider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.dashboard,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '¡Bienvenido a TaskWise!',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Mantén el control de tus tareas',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsGrid(BuildContext context, Map<String, dynamic> stats) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        StatCard(
          title: 'Total de Tareas',
          value: '${stats['total'] ?? 0}',
          icon: Icons.task,
          color: Colors.blue,
        ),
        StatCard(
          title: 'Completadas',
          value: '${stats['completed'] ?? 0}',
          icon: Icons.check_circle,
          color: Colors.green,
        ),
        StatCard(
          title: 'Pendientes',
          value: '${stats['pending'] ?? 0}',
          icon: Icons.pending,
          color: Colors.orange,
        ),
        StatCard(
          title: 'Vencidas',
          value: '${stats['overdue'] ?? 0}',
          icon: Icons.warning,
          color: Colors.red,
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Acciones Rápidas',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ActionButton(
                text: 'Nueva Tarea',
                icon: Icons.add,
                onPressed: () {
                  Navigator.pushNamed(context, '/add-task');
                },
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ActionButton(
                text: 'Ver Todas',
                icon: Icons.list,
                onPressed: () {
                  Navigator.pushNamed(context, '/tasks');
                },
                color: Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ActionButton(
                text: 'Filtros',
                icon: Icons.filter_list,
                onPressed: () {
                  _showFilterDialog(context);
                },
                color: Colors.purple,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ActionButton(
                text: 'Estadísticas',
                icon: Icons.analytics,
                onPressed: () {
                  _showDetailedStats(context);
                },
                color: Colors.orange,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPriorityOverview(BuildContext context, TaskProvider taskProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Resumen por Prioridad',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: TaskPriority.values.map((priority) {
            final count = taskProvider.getTaskCountByPriority(priority);
            final color = _getPriorityColor(priority);
            
            return Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    Icon(
                      _getPriorityIcon(priority),
                      color: color,
                      size: 24,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$count',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    Text(
                      _getPriorityText(priority),
                      style: TextStyle(
                        fontSize: 12,
                        color: color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildOverdueTasksSection(BuildContext context, List<Task> overdueTasks) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.warning, color: Colors.red, size: 20),
            const SizedBox(width: 8),
            Text(
              'Tareas Vencidas',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Text(
              '${overdueTasks.length}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (overdueTasks.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 20),
                const SizedBox(width: 8),
                Text(
                  '¡Excelente! No hay tareas vencidas',
                  style: TextStyle(color: Colors.green[700]),
                ),
              ],
            ),
          )
        else
          ...overdueTasks.take(3).map((task) => TaskCard(
            task: task,
            onTap: () => _showTaskDetails(context, task),
            showActions: false,
          )),
        if (overdueTasks.length > 3)
          Center(
            child: TextButton(
              onPressed: () {
                // Navegar a lista de tareas vencidas
              },
              child: Text('Ver ${overdueTasks.length - 3} más'),
            ),
          ),
      ],
    );
  }

  Widget _buildTodayTasksSection(BuildContext context, List<Task> todayTasks) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.today, color: Colors.blue, size: 20),
            const SizedBox(width: 8),
            Text(
              'Tareas de Hoy',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Text(
              '${todayTasks.length}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (todayTasks.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.event, color: Colors.blue, size: 20),
                const SizedBox(width: 8),
                Text(
                  'No hay tareas programadas para hoy',
                  style: TextStyle(color: Colors.blue[700]),
                ),
              ],
            ),
          )
        else
          ...todayTasks.take(3).map((task) => TaskCard(
            task: task,
            onTap: () => _showTaskDetails(context, task),
            showActions: false,
          )),
        if (todayTasks.length > 3)
          Center(
            child: TextButton(
              onPressed: () {
                // Navegar a lista de tareas de hoy
              },
              child: Text('Ver ${todayTasks.length - 3} más'),
            ),
          ),
      ],
    );
  }

  Widget _buildRecentActivity(BuildContext context, TaskProvider taskProvider) {
    final recentTasks = taskProvider.tasks
        .where((task) => task.createdAt.isAfter(DateTime.now().subtract(const Duration(days: 7))))
        .take(5)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Actividad Reciente',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        if (recentTasks.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.info, color: Colors.grey, size: 20),
                const SizedBox(width: 8),
                Text(
                  'No hay actividad reciente',
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),
          )
        else
          ...recentTasks.map((task) => ListTile(
            leading: CircleAvatar(
              backgroundColor: task.isCompleted ? Colors.green : Colors.orange,
              child: Icon(
                task.isCompleted ? Icons.check : Icons.schedule,
                color: Colors.white,
                size: 16,
              ),
            ),
            title: Text(
              task.title,
              style: TextStyle(
                decoration: task.isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
            subtitle: Text(task.category),
            trailing: Text(
              '${task.createdAt.day}/${task.createdAt.month}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            onTap: () => _showTaskDetails(context, task),
          )),
      ],
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filtros'),
        content: const Text('Funcionalidad de filtros avanzados'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showDetailedStats(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Estadísticas Detalladas'),
        content: const Text('Estadísticas avanzadas de tareas'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showTaskDetails(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(task.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Descripción: ${task.description}'),
            const SizedBox(height: 8),
            Text('Categoría: ${task.category}'),
            const SizedBox(height: 8),
            Text('Prioridad: ${_getPriorityText(task.priority)}'),
            const SizedBox(height: 8),
            Text('Fecha de vencimiento: ${task.dueDate.toString().split(' ')[0]}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return Colors.green;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.high:
        return Colors.red;
    }
  }

  IconData _getPriorityIcon(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return Icons.arrow_downward;
      case TaskPriority.medium:
        return Icons.remove;
      case TaskPriority.high:
        return Icons.arrow_upward;
    }
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
} 