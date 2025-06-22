import 'package:flutter/material.dart';
import '../models/task.dart';

class FilterChipGroup extends StatelessWidget {
  final String title;
  final List<String> options;
  final String? selectedValue;
  final ValueChanged<String?> onChanged;
  final IconData? icon;

  const FilterChipGroup({
    super.key,
    required this.title,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16),
              const SizedBox(width: 4),
            ],
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: options.map((option) {
            final isSelected = selectedValue == option;
            return FilterChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (selected) {
                onChanged(selected ? option : null);
              },
              backgroundColor: Colors.grey[200],
              selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
              checkmarkColor: Theme.of(context).primaryColor,
            );
          }).toList(),
        ),
      ],
    );
  }
}

class SearchBar extends StatelessWidget {
  final String hint;
  final ValueChanged<String> onChanged;
  final VoidCallback? onClear;
  final TextEditingController? controller;

  const SearchBar({
    super.key,
    required this.hint,
    required this.onChanged,
    this.onClear,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: controller?.text.isNotEmpty == true
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: onClear,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}

class PriorityFilter extends StatelessWidget {
  final TaskPriority? selectedPriority;
  final ValueChanged<TaskPriority?> onChanged;

  const PriorityFilter({
    super.key,
    required this.selectedPriority,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Filtrar por Prioridad',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            _buildPriorityChip(context, null, 'Todas', Icons.all_inclusive),
            ...TaskPriority.values.map((priority) => _buildPriorityChip(
              context,
              priority,
              _getPriorityText(priority),
              _getPriorityIcon(priority),
            )),
          ],
        ),
      ],
    );
  }

  Widget _buildPriorityChip(
    BuildContext context,
    TaskPriority? priority,
    String label,
    IconData icon,
  ) {
    final isSelected = selectedPriority == priority;
    final color = priority != null ? _getPriorityColor(priority) : Colors.grey;
    
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: isSelected ? Colors.white : color),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        onChanged(selected ? priority : null);
      },
      backgroundColor: Colors.grey[200],
      selectedColor: color,
      checkmarkColor: Colors.white,
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

class DateRangeFilter extends StatelessWidget {
  final String? selectedRange;
  final ValueChanged<String?> onChanged;

  const DateRangeFilter({
    super.key,
    required this.selectedRange,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final ranges = [
      {'value': null, 'label': 'Todas', 'icon': Icons.all_inclusive},
      {'value': 'today', 'label': 'Hoy', 'icon': Icons.today},
      {'value': 'tomorrow', 'label': 'Mañana', 'icon': Icons.event},
      {'value': 'week', 'label': 'Esta semana', 'icon': Icons.view_week},
      {'value': 'overdue', 'label': 'Vencidas', 'icon': Icons.warning},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Filtrar por Fecha',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: ranges.map((range) {
            final isSelected = selectedRange == range['value'];
            return FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(range['icon'] as IconData, size: 16),
                  const SizedBox(width: 4),
                  Text(range['label'] as String),
                ],
              ),
              selected: isSelected,
              onSelected: (selected) {
                onChanged(selected ? range['value'] as String? : null);
              },
              backgroundColor: Colors.grey[200],
              selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
              checkmarkColor: Theme.of(context).primaryColor,
            );
          }).toList(),
        ),
      ],
    );
  }
}

class SortOptions extends StatelessWidget {
  final String selectedSort;
  final ValueChanged<String> onChanged;

  const SortOptions({
    super.key,
    required this.selectedSort,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final sortOptions = [
      {'value': 'dueDate', 'label': 'Fecha de vencimiento', 'icon': Icons.calendar_today},
      {'value': 'priority', 'label': 'Prioridad', 'icon': Icons.priority_high},
      {'value': 'title', 'label': 'Título', 'icon': Icons.sort_by_alpha},
      {'value': 'createdAt', 'label': 'Fecha de creación', 'icon': Icons.create},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ordenar por',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: sortOptions.map((option) {
            final isSelected = selectedSort == option['value'];
            return FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(option['icon'] as IconData, size: 16),
                  const SizedBox(width: 4),
                  Text(option['label'] as String),
                ],
              ),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  onChanged(option['value'] as String);
                }
              },
              backgroundColor: Colors.grey[200],
              selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
              checkmarkColor: Theme.of(context).primaryColor,
            );
          }).toList(),
        ),
      ],
    );
  }
} 