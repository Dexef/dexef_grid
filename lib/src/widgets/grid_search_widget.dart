import 'package:flutter/material.dart';
import '../models/grid_column.dart';
import 'grid_filter_widget.dart';

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

class _GridSearchWidgetState extends State<GridSearchWidget> {
  late TextEditingController _searchController;
  late FocusNode _searchFocusNode;
  bool _showAdvancedSearch = false;
  List<String> _suggestions = [];
  bool _isLoadingSuggestions = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchTerm);
    _searchFocusNode = FocusNode();
  }

  @override
  void didUpdateWidget(GridSearchWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.searchTerm != oldWidget.searchTerm) {
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
  }

  void _toggleAdvancedSearch() {
    setState(() {
      _showAdvancedSearch = !_showAdvancedSearch;
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
          if (widget.showFilter && widget.onFilter != null) ...[
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
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Text(
        column.title,
        style: TextStyle(
          color: Colors.blue.shade700,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
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
            'Filters',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.columns
                .where((col) => col.filterable)
                .map((column) => _buildFilterChip(column))
                .toList(),
          ),
        ],
      ),
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
          widget.onFilter?.call(column.id, '');
        }
      },
      selectedColor: Colors.blue.shade100,
      checkmarkColor: Colors.blue.shade700,
    );
  }

  void _showFilterDialog(GridColumn column) {
    final controller = TextEditingController(text: widget.filters[column.id] ?? '');
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Filter by ${column.title}'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Enter filter value for ${column.title}',
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              widget.onFilter?.call(column.id, controller.text);
              Navigator.of(context).pop();
            },
            child: const Text('Apply'),
          ),
        ],
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