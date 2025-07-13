import 'package:flutter/material.dart';
import '../models/grid_column.dart';
import 'grid_filter_widget.dart';
import 'dart:async';

/// A search widget for the grid with optional filter functionality
class GridSearchWidget extends StatefulWidget {
  /// Current search term
  final String searchTerm;
  
  /// Placeholder text for the search field
  final String placeholder;
  
  /// Callback when search is performed
  final void Function(String searchTerm) onSearch;
  
  /// List of columns that can be searched
  final List<GridColumn> columns;
  
  /// Callback when filter is applied
  final void Function(String columnId, String filterValue)? onFilter;
  
  /// Current filters
  final Map<String, String> filters;
  
  /// Whether to show filter functionality
  final bool showFilter;
  
  /// Whether to show advanced search options
  final bool showAdvancedSearch;
  
  /// Whether to show search suggestions
  final bool showSuggestions;
  
  /// Custom search field widget
  final Widget? customSearchField;
  
  /// Custom filter widget
  final Widget? customFilterWidget;
  
  /// Search suggestions
  final List<String>? suggestions;
  
  /// Callback to get search suggestions
  final Future<List<String>> Function(String query)? getSuggestions;

  const GridSearchWidget({
    super.key,
    required this.searchTerm,
    required this.placeholder,
    required this.onSearch,
    required this.columns,
    this.onFilter,
    this.filters = const {},
    this.showFilter = true,
    this.showAdvancedSearch = false,
    this.showSuggestions = false,
    this.customSearchField,
    this.customFilterWidget,
    this.suggestions,
    this.getSuggestions,
  });

  @override
  State<GridSearchWidget> createState() => _GridSearchWidgetState();
}

enum FilterType { contains, exact, startsWith, endsWith }

String filterTypeLabel(FilterType type) {
  switch (type) {
    case FilterType.contains:
      return 'Contains';
    case FilterType.exact:
      return 'Exact Match';
    case FilterType.startsWith:
      return 'Starts With';
    case FilterType.endsWith:
      return 'Ends With';
  }
}

class _GridSearchWidgetState extends State<GridSearchWidget> {
  late TextEditingController _searchController;
  late FocusNode _searchFocusNode;
  bool _showAdvancedSearch = false;
  bool _showFilters = false;
  List<String> _suggestions = [];
  bool _isLoadingSuggestions = false;
  Map<String, FilterType> _filterTypes = {};

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchTerm);
    _searchFocusNode = FocusNode();
  }

  @override
  void didUpdateWidget(GridSearchWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only update the controller if the search term changed from external source
    // and it's different from what the user is currently typing
    if (widget.searchTerm != oldWidget.searchTerm && 
        widget.searchTerm != _searchController.text) {
      _searchController.text = widget.searchTerm;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    widget.onSearch(value);
    _loadSuggestions(value);
  }

  void _onSearchSubmitted(String value) {
    widget.onSearch(value);
    _searchFocusNode.unfocus();
  }

  void _onClearSearch() {
    _searchController.clear();
    widget.onSearch('');
    setState(() {
      _suggestions.clear();
    });
  }

  void _toggleAdvancedSearch() {
    setState(() {
      _showAdvancedSearch = !_showAdvancedSearch;
    });
  }

  void _toggleFilters() {
    setState(() {
      _showFilters = !_showFilters;
    });
  }

  Future<void> _loadSuggestions(String query) async {
    if (!widget.showSuggestions || query.isEmpty) {
      setState(() {
        _suggestions.clear();
      });
      return;
    }

    setState(() {
      _isLoadingSuggestions = true;
    });

    try {
      List<String> suggestions = [];
      if (widget.getSuggestions != null) {
        suggestions = await widget.getSuggestions!(query);
      } else if (widget.suggestions != null) {
        suggestions = widget.suggestions!
            .where((suggestion) => suggestion.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
      setState(() {
        _suggestions = suggestions;
        _isLoadingSuggestions = false;
      });
    } catch (e) {
      setState(() {
        _suggestions.clear();
        _isLoadingSuggestions = false;
      });
    }
  }

  void _onSuggestionSelected(String suggestion) {
    _searchController.text = suggestion;
    widget.onSearch(suggestion);
    setState(() {
      _suggestions.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: widget.customSearchField ?? _buildSearchField(),
              ),
              const SizedBox(width: 8),
              if (widget.searchTerm.isNotEmpty)
                IconButton(
                  onPressed: _onClearSearch,
                  icon: const Icon(Icons.clear),
                  tooltip: 'Clear search',
                ),
              if (widget.showFilter && widget.onFilter != null)
                IconButton(
                  onPressed: _toggleFilters,
                  icon: Icon(
                    _showFilters ? Icons.filter_list : Icons.filter_list_outlined,
                    color: _showFilters ? Colors.grey.shade700 : null,
                  ),
                  tooltip: 'Toggle filters',
                ),
              if (widget.showAdvancedSearch)
                IconButton(
                  onPressed: _toggleAdvancedSearch,
                  icon: Icon(_showAdvancedSearch ? Icons.expand_less : Icons.expand_more),
                  tooltip: 'Advanced search',
                ),
            ],
          ),
          if (_showAdvancedSearch && widget.showAdvancedSearch) ...[
            const SizedBox(height: 8),
            _buildAdvancedSearch(),
          ],
          if (_showFilters && widget.showFilter && widget.onFilter != null) ...[
            const SizedBox(height: 8),
            widget.customFilterWidget ?? _buildFilterSection(),
          ],
          if (_suggestions.isNotEmpty) ...[
            const SizedBox(height: 8),
            _buildSuggestions(),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      focusNode: _searchFocusNode,
      decoration: InputDecoration(
        hintText: widget.placeholder,
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      onChanged: _onSearchChanged,
      onSubmitted: _onSearchSubmitted,
    );
  }

  Widget _buildAdvancedSearch() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Advanced Search',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.columns
                .where((col) => col.searchable)
                .map((column) => _buildSearchOption(column))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchOption(GridColumn column) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        column.title,
        style: TextStyle(
          color: Colors.grey.shade700,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    final activeFilters = widget.filters.entries.where((e) => e.value.isNotEmpty).length;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.filter_list, color: Colors.grey.shade700),
              const SizedBox(width: 8),
              Text(
                'Filters',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              if (activeFilters > 0) ...[
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$activeFilters active',
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
              const Spacer(),
              if (activeFilters > 0)
                TextButton(
                  onPressed: () {
                    // Clear all filters
                    for (final column in widget.columns.where((col) => col.filterable)) {
                      widget.onFilter?.call(column.id, '');
                    }
                  },
                  child: Text(
                    'Clear All',
                    style: TextStyle(
                      color: Colors.red.shade600,
                      fontSize: 13,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: widget.columns
                .where((col) => col.filterable)
                .map((column) => SizedBox(
                      height: 44,
                      child: _buildFilterChip(column),
                    ))
                .toList(),
          ),
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
        print('Filter chip tapped for column: \'${column.title}\' (selected: $selected)');
        if (selected) {
          _showFilterDialog(column);
        } else {
          widget.onFilter?.call(column.id, '');
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

  void _showFilterDialog(GridColumn column) {
    final controller = TextEditingController(text: widget.filters[column.id] ?? '');
    String selectedValue = widget.filters[column.id] ?? '';
    FilterType selectedType = _filterTypes[column.id] ?? FilterType.contains;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.filter_list, color: Colors.grey.shade700),
              SizedBox(width: 8),
              Expanded(
                child: Text('Filter by ${column.title}', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          content: SizedBox(
            width: 340,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Filter type:', style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
                const SizedBox(height: 8),
                DropdownButtonFormField<FilterType>(
                  value: selectedType,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: FilterType.values.map((type) => DropdownMenuItem(
                    value: type,
                    child: Text(filterTypeLabel(type)),
                  )).toList(),
                  onChanged: (type) {
                    if (type != null) setState(() => selectedType = type);
                  },
                ),
                const SizedBox(height: 16),
                Text('Value:', style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
                const SizedBox(height: 8),
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: 'Enter filter value...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
                    suffixIcon: selectedValue.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear, color: Colors.grey.shade600),
                            onPressed: () {
                              controller.clear();
                              setState(() { selectedValue = ''; });
                            },
                          )
                        : null,
                  ),
                  onChanged: (value) { setState(() { selectedValue = value; }); },
                  autofocus: true,
                ),
                if (selectedValue.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, size: 16, color: Colors.grey.shade600),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Will show rows where ${column.title.toLowerCase()} ${filterTypeLabel(selectedType).toLowerCase()} "$selectedValue"',
                            style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() { _filterTypes[column.id] = selectedType; });
                widget.onFilter?.call('${column.id}|${selectedType.name}', selectedValue);
                Navigator.of(context).pop();
              },
              child: Text('Apply Filter'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestions() {
    return Container(
      constraints: const BoxConstraints(maxHeight: 200),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = _suggestions[index];
          return ListTile(
            dense: true,
            title: Text(suggestion),
            onTap: () => _onSuggestionSelected(suggestion),
          );
        },
      ),
    );
  }
} 