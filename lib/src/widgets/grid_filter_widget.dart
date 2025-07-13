import 'package:flutter/material.dart';
import '../models/grid_column.dart';

/// A filter widget for the grid
class GridFilterWidget extends StatefulWidget {
  /// List of columns that can be filtered
  final List<GridColumn> columns;
  
  /// Current filters
  final Map<String, String> filters;
  
  /// Callback when filter is applied
  final void Function(String columnId, String filterValue) onFilter;
  
  /// Callback when all filters are cleared
  final VoidCallback? onClearAll;
  
  /// Whether to show the filter widget
  final bool visible;
  
  /// Custom filter widget builder
  final Widget Function(BuildContext context, GridColumn column, String currentValue)? customFilterBuilder;
  
  /// Filter options for each column
  final Map<String, List<String>> filterOptions;
  
  /// Whether to show filter chips
  final bool showFilterChips;
  
  /// Whether to show filter dialog
  final bool showFilterDialog;

  const GridFilterWidget({
    super.key,
    required this.columns,
    required this.filters,
    required this.onFilter,
    this.onClearAll,
    this.visible = true,
    this.customFilterBuilder,
    this.filterOptions = const {},
    this.showFilterChips = true,
    this.showFilterDialog = true,
  });

  @override
  State<GridFilterWidget> createState() => _GridFilterWidgetState();
}

class _GridFilterWidgetState extends State<GridFilterWidget> {
  bool _showFilters = false;

  @override
  Widget build(BuildContext context) {
    if (!widget.visible) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Filters',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              if (widget.filters.isNotEmpty)
                TextButton(
                  onPressed: widget.onClearAll,
                  child: const Text('Clear All'),
                ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _showFilters = !_showFilters;
                  });
                },
                icon: Icon(_showFilters ? Icons.expand_less : Icons.expand_more),
                tooltip: 'Toggle filters',
              ),
            ],
          ),
          if (_showFilters) ...[
            const SizedBox(height: 8),
            _buildFilterSection(),
          ],
          if (widget.showFilterChips && widget.filters.isNotEmpty) ...[
            const SizedBox(height: 8),
            _buildFilterChips(),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: widget.columns
          .where((col) => col.filterable)
          .map((column) => _buildFilterChip(column))
          .toList(),
    );
  }

  Widget _buildFilterChip(GridColumn column) {
    final currentFilter = widget.filters[column.id] ?? '';
    
    return FilterChip(
      label: Text(column.title),
      selected: currentFilter.isNotEmpty,
      onSelected: (selected) {
        if (selected) {
          _showFilterDialog(column);
        } else {
          widget.onFilter(column.id, '');
        }
      },
      selectedColor: Colors.blue.shade100,
      checkmarkColor: Colors.blue.shade700,
    );
  }

  Widget _buildFilterChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: widget.filters.entries.map((entry) {
        final column = widget.columns.firstWhere((col) => col.id == entry.key);
        return Chip(
          label: Text('${column.title}: ${entry.value}'),
          onDeleted: () => widget.onFilter(entry.key, ''),
          deleteIcon: const Icon(Icons.close, size: 16),
        );
      }).toList(),
    );
  }

  void _showFilterDialog(GridColumn column) {
    final controller = TextEditingController(text: widget.filters[column.id] ?? '');
    String selectedValue = widget.filters[column.id] ?? '';
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Filter by ${column.title}'),
          content: SizedBox(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.filterOptions[column.id] != null) ...[
                  Text(
                    'Select from options:',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.filterOptions[column.id]!.length,
                      itemBuilder: (context, index) {
                        final option = widget.filterOptions[column.id]![index];
                        return RadioListTile<String>(
                          title: Text(option),
                          value: option,
                          groupValue: selectedValue,
                          onChanged: (value) {
                            setState(() {
                              selectedValue = value ?? '';
                              controller.text = value ?? '';
                            });
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),
                ],
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: 'Enter custom filter value for ${column.title}',
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                widget.onFilter(column.id, selectedValue);
                Navigator.of(context).pop();
              },
              child: const Text('Apply'),
            ),
          ],
        ),
      ),
    );
  }
} 