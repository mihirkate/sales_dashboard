import 'package:flutter/material.dart';
import '../models/sales_data.dart';

class SortDropdown extends StatelessWidget {
  final SortField selectedField;
  final String sortOrder;
  final Function(SortField, String) onSortChanged;

  const SortDropdown({
    super.key,
    required this.selectedField,
    required this.sortOrder,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.sort, size: 16),
          const SizedBox(width: 8),
          DropdownButton<SortField>(
            value: selectedField,
            underline: const SizedBox(),
            icon: const SizedBox(),
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium?.color,
              fontSize: 14,
            ),
            items: SortField.values.map((field) {
              return DropdownMenuItem<SortField>(
                value: field,
                child: Text(field.displayName),
              );
            }).toList(),
            onChanged: (SortField? newField) {
              if (newField != null) {
                onSortChanged(newField, sortOrder);
              }
            },
          ),
          const SizedBox(width: 4),
          InkWell(
            onTap: () {
              final newOrder = sortOrder == 'asc' ? 'desc' : 'asc';
              onSortChanged(selectedField, newOrder);
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(
                sortOrder == 'asc' ? Icons.arrow_upward : Icons.arrow_downward,
                size: 16,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
