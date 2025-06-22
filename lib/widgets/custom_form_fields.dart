import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final int? maxLines;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;
  final VoidCallback? onTap;

  const CustomTextField({
    super.key,
    required this.label,
    this.hint,
    required this.controller,
    this.validator,
    this.maxLines = 1,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        validator: validator,
        maxLines: maxLines,
        keyboardType: keyboardType,
        enabled: enabled,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
          ),
          filled: true,
          fillColor: enabled ? null : Colors.grey[100],
        ),
      ),
    );
  }
}

class CustomDropdownField<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<T> items;
  final String Function(T) itemToString;
  final void Function(T?) onChanged;
  final String? Function(T?)? validator;
  final Widget? prefixIcon;

  const CustomDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.itemToString,
    required this.onChanged,
    this.validator,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<T>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: prefixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
          ),
        ),
        items: items.map((T item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Text(itemToString(item)),
          );
        }).toList(),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }
}

class CustomDateField extends StatelessWidget {
  final String label;
  final DateTime value;
  final ValueChanged<DateTime> onChanged;
  final String? Function(DateTime?)? validator;

  const CustomDateField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () => _selectDate(context),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: const Icon(Icons.calendar_today),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
            ),
          ),
          child: Text(
            DateFormat.yMMMd().format(value),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: value,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != value) {
      onChanged(picked);
    }
  }
}

class PrioritySelector extends StatelessWidget {
  final TaskPriority value;
  final ValueChanged<TaskPriority> onChanged;

  const PrioritySelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Prioridad',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Row(
            children: TaskPriority.values.map((priority) {
              final isSelected = value == priority;
              final color = _getPriorityColor(priority);
              
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: InkWell(
                    onTap: () => onChanged(priority),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? color : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected ? color : Colors.grey[300]!,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            _getPriorityIcon(priority),
                            color: isSelected ? Colors.white : color,
                            size: 24,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _getPriorityText(priority),
                            style: TextStyle(
                              color: isSelected ? Colors.white : color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
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

class TagsInputField extends StatefulWidget {
  final List<String> tags;
  final ValueChanged<List<String>> onChanged;
  final List<String>? availableTags;

  const TagsInputField({
    super.key,
    required this.tags,
    required this.onChanged,
    this.availableTags,
  });

  @override
  State<TagsInputField> createState() => _TagsInputFieldState();
}

class _TagsInputFieldState extends State<TagsInputField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addTag(String tag) {
    if (tag.isNotEmpty && !widget.tags.contains(tag)) {
      final newTags = List<String>.from(widget.tags)..add(tag.trim());
      widget.onChanged(newTags);
      _controller.clear();
    }
  }

  void _removeTag(String tag) {
    final newTags = List<String>.from(widget.tags)..remove(tag);
    widget.onChanged(newTags);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Etiquetas',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          if (widget.tags.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.tags.map((tag) {
                return Chip(
                  label: Text(tag),
                  deleteIcon: const Icon(Icons.close, size: 18),
                  onDeleted: () => _removeTag(tag),
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                );
              }).toList(),
            ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Añadir etiqueta...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  onSubmitted: _addTag,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => _addTag(_controller.text),
                icon: const Icon(Icons.add),
                style: IconButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          if (widget.availableTags != null && widget.availableTags!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Wrap(
                spacing: 4,
                runSpacing: 4,
                children: widget.availableTags!.where((tag) => !widget.tags.contains(tag)).map((tag) {
                  return ActionChip(
                    label: Text(tag),
                    onPressed: () => _addTag(tag),
                    backgroundColor: Colors.grey[200],
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
} 