import 'package:flutter/material.dart';
import '../models/grid_column.dart';

/// A filter widget for the grid with DevExtreme-style features
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
  
  /// Whether to show filter panel
  final bool showFilterPanel;
  
  /// Whether to show filter builder
  final bool showFilterBuilder;
  
  /// Current filter expression
  final String? filterExpression;
  
  /// Callback when filter expression changes
  final void Function(String expression)? onFilterExpressionChanged;
  
  /// Whether filter sync is enabled
  final bool filterSyncEnabled;
  
  /// Custom filter operations
  final Map<String, List<String>> customFilterOperations;

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
    this.showFilterPanel = false,
    this.showFilterBuilder = false,
    this.filterExpression,
    this.onFilterExpressionChanged,
    this.filterSyncEnabled = true,
    this.customFilterOperations = const {},
  });

  @override
  State<GridFilterWidget> createState() => _GridFilterWidgetState();
}

class _GridFilterWidgetState extends State<GridFilterWidget> {
  bool _showFilters = false;
  bool _showFilterPanel = false;
  bool _showFilterBuilder = false;
  String _currentFilterExpression = '';
  Map<String, String> _filterBuilderValues = {};
  Map<String, String> _filterBuilderOperations = {};

  @override
  void initState() {
    super.initState();
    _currentFilterExpression = widget.filterExpression ?? '';
    _filterBuilderValues = Map.from(widget.filters);
    _filterBuilderOperations = {};
  }

  @override
  void didUpdateWidget(GridFilterWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.filterExpression != oldWidget.filterExpression) {
      _currentFilterExpression = widget.filterExpression ?? '';
    }
    if (widget.filters != oldWidget.filters) {
      _filterBuilderValues = Map.from(widget.filters);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.visible) return const SizedBox.shrink();

    return Column(
      children: [
        // Filter Panel
        if (widget.showFilterPanel) ...[
          _buildFilterPanel(),
          const SizedBox(height: 16),
        ],
        
        // Filter Builder
        if (widget.showFilterBuilder && _showFilterBuilder) ...[
          _buildFilterBuilder(),
          const SizedBox(height: 16),
        ],
        
        // Main Filter Section
        if (_showFilters) ...[
          _buildFilterSection(),
        ],
        
        // Filter Controls
        _buildFilterControls(),
      ],
    );
  }

  Widget _buildFilterPanel() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        border: Border.all(color: Colors.blue.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.filter_list, color: Colors.blue.shade600),
              const SizedBox(width: 8),
              Text(
                'Filter Panel',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
              const Spacer(),
              if (_currentFilterExpression.isNotEmpty) ...[
                TextButton(
                  onPressed: _showFilterBuilderDialog,
                  child: Text('Edit'),
                ),
                TextButton(
                  onPressed: _clearFilterExpression,
                  child: Text('Clear'),
                ),
              ],
            ],
          ),
          if (_currentFilterExpression.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.blue.shade300),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  Icon(Icons.filter_list, size: 16, color: Colors.blue.shade600),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _currentFilterExpression,
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            const SizedBox(height: 8),
            Text(
              'No filter expression applied',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterBuilder() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.build, color: Colors.blue.shade600),
              const SizedBox(width: 8),
              Text(
                'Filter Builder',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => setState(() => _showFilterBuilder = false),
                icon: Icon(Icons.close),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Filter builder content
          ...widget.columns.where((col) => col.filterable).map((column) {
            return _buildFilterBuilderRow(column);
          }).toList(),
          
          const SizedBox(height: 16),
          
          Row(
            children: [
              ElevatedButton(
                onPressed: _applyFilterBuilder,
                child: Text('Apply Filters'),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: _clearFilterBuilder,
                child: Text('Clear All'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBuilderRow(GridColumn column) {
    final currentValue = _filterBuilderValues[column.id] ?? '';
    final currentOperation = _filterBuilderOperations[column.id] ?? 'contains';
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              column.title,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(width: 8),
          DropdownButton<String>(
            value: currentOperation,
            items: _getFilterOperations(column).map((op) {
              return DropdownMenuItem(
                value: op,
                child: Text(_getOperationDisplayName(op)),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _filterBuilderOperations[column.id] = value;
                });
              }
            },
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Enter value...',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              controller: TextEditingController(text: currentValue),
              onChanged: (value) {
                setState(() {
                  _filterBuilderValues[column.id] = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  List<String> _getFilterOperations(GridColumn column) {
    // Use custom operations if available, otherwise use default
    return widget.customFilterOperations[column.id] ?? 
           ['contains', 'equals', 'startsWith', 'endsWith', 'notContains'];
  }

  String _getOperationDisplayName(String operation) {
    switch (operation) {
      case 'contains': return 'Contains';
      case 'equals': return 'Equals';
      case 'startsWith': return 'Starts With';
      case 'endsWith': return 'Ends With';
      case 'notContains': return 'Not Contains';
      case 'isEmpty': return 'Is Empty';
      case 'isNotEmpty': return 'Is Not Empty';
      default: return operation;
    }
  }

  void _showFilterBuilderDialog() {
    setState(() {
      _showFilterBuilder = true;
    });
  }

  void _applyFilterBuilder() {
    // Apply all filter builder values
    for (final entry in _filterBuilderValues.entries) {
      if (entry.value.isNotEmpty) {
        widget.onFilter(entry.key, entry.value);
      }
    }
    
    // Update filter expression
    final expression = _buildFilterExpression();
    _currentFilterExpression = expression;
    widget.onFilterExpressionChanged?.call(expression);
    
    setState(() {
      _showFilterBuilder = false;
    });
  }

  void _clearFilterBuilder() {
    setState(() {
      _filterBuilderValues.clear();
      _filterBuilderOperations.clear();
    });
  }

  void _clearFilterExpression() {
    setState(() {
      _currentFilterExpression = '';
    });
    widget.onFilterExpressionChanged?.call('');
    widget.onClearAll?.call();
  }

  String _buildFilterExpression() {
    final expressions = <String>[];
    
    for (final entry in _filterBuilderValues.entries) {
      if (entry.value.isNotEmpty) {
        final operation = _filterBuilderOperations[entry.key] ?? 'contains';
        final column = widget.columns.firstWhere((col) => col.id == entry.key);
        expressions.add('${column.title} $operation "${entry.value}"');
      }
    }
    
    return expressions.join(' AND ');
  }

  Widget _buildFilterSection() {
    final filterableColumns = widget.columns.where((col) => col.filterable).toList();
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.filter_list, color: Colors.blue.shade600),
              const SizedBox(width: 8),
              Text(
                'Advanced Filters',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              const Spacer(),
              if (widget.filters.isNotEmpty) ...[
                TextButton(
                  onPressed: () {
                    widget.onClearAll?.call();
                  },
                  child: const Text('Clear Filters'),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          
          if (widget.showFilterChips) ...[
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: filterableColumns.map((column) {
                return _buildFilterChip(column);
              }).toList(),
            ),
          ] else ...[
            ...filterableColumns.map((column) {
              return _buildFilterRow(column);
            }).toList(),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterChip(GridColumn column) {
    final currentFilter = widget.filters[column.id] ?? '';
    final isActive = currentFilter.isNotEmpty;
    
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(column.title),
          if (isActive) ...[
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                currentFilter,
                style: TextStyle(
                  color: Colors.grey.shade800,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
      selected: isActive,
      onSelected: (selected) {
        if (selected) {
          _showFilterDialog(column);
        } else {
          widget.onFilter(column.id, '');
        }
      },
      selectedColor: Colors.grey.shade200,
      checkmarkColor: Colors.grey.shade700,
      backgroundColor: Colors.grey.shade100,
      side: BorderSide(
        color: isActive ? Colors.grey.shade400 : Colors.grey.shade300,
        width: 1,
      ),
    );
  }

  Widget _buildFilterRow(GridColumn column) {
    final currentFilter = widget.filters[column.id] ?? '';
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              column.title,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Filter ${column.title}...',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              controller: TextEditingController(text: currentFilter),
              onChanged: (value) {
                widget.onFilter(column.id, value);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterControls() {
    return Row(
      children: [
        if (widget.showFilterPanel) ...[
          TextButton.icon(
            onPressed: () => setState(() => _showFilterPanel = !_showFilterPanel),
            icon: Icon(_showFilterPanel ? Icons.visibility_off : Icons.visibility),
            label: Text(_showFilterPanel ? 'Hide Panel' : 'Show Panel'),
          ),
        ],
        if (widget.showFilterBuilder) ...[
          TextButton.icon(
            onPressed: () => setState(() => _showFilterBuilder = !_showFilterBuilder),
            icon: Icon(_showFilterBuilder ? Icons.build_circle : Icons.build),
            label: Text(_showFilterBuilder ? 'Hide Builder' : 'Show Builder'),
          ),
        ],
        TextButton.icon(
          onPressed: () => setState(() => _showFilters = !_showFilters),
          icon: Icon(_showFilters ? Icons.filter_alt : Icons.filter_alt_outlined),
          label: Text(_showFilters ? 'Hide Filters' : 'Show Filters'),
        ),
      ],
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
                  decoration: InputDecoration(
                    labelText: 'Filter value',
                    border: OutlineInputBorder(),
                  ),
                  controller: controller,
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
            ElevatedButton(
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