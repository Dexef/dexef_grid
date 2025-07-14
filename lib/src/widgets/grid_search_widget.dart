import 'package:flutter/material.dart';
import '../models/grid_column.dart';
import 'grid_filter_widget.dart';
import 'dart:async';

/// A search widget for the grid with DevExtreme-style features
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
  
  /// Whether the search panel is visible
  final bool visible;
  
  /// Whether to enable search in specific columns
  final Map<String, bool>? columnSearchEnabled;
  
  /// Predefined search value
  final String? predefinedSearchValue;
  
  /// Whether to show search statistics
  final bool showSearchStats;
  
  /// Callback when search is cleared
  final VoidCallback? onSearchCleared;
  
  /// Callback when search statistics are requested
  final void Function(String searchTerm, int resultCount)? onSearchStats;

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
    this.visible = true,
    this.columnSearchEnabled,
    this.predefinedSearchValue,
    this.showSearchStats = false,
    this.onSearchCleared,
    this.onSearchStats,
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
  Timer? _debounceTimer;
  int _searchResultCount = 0;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchTerm);
    _searchFocusNode = FocusNode();
    
    // Set predefined search value if provided
    if (widget.predefinedSearchValue != null && widget.predefinedSearchValue!.isNotEmpty) {
      _searchController.text = widget.predefinedSearchValue!;
      widget.onSearch(widget.predefinedSearchValue!);
    }
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
    
    // Update predefined search value if changed
    if (widget.predefinedSearchValue != oldWidget.predefinedSearchValue && 
        widget.predefinedSearchValue != null && 
        widget.predefinedSearchValue!.isNotEmpty) {
      _searchController.text = widget.predefinedSearchValue!;
      widget.onSearch(widget.predefinedSearchValue!);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    // Debounce search to improve performance
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      widget.onSearch(value);
      _loadSuggestions(value);
      _updateSearchStats(value);
    });
  }

  void _onSearchSubmitted(String value) {
    _debounceTimer?.cancel();
    widget.onSearch(value);
    _searchFocusNode.unfocus();
    _updateSearchStats(value);
  }

  void _onClearSearch() {
    _searchController.clear();
    widget.onSearch('');
    widget.onSearchCleared?.call();
    setState(() {
      _suggestions.clear();
      _searchResultCount = 0;
    });
  }

  void _updateSearchStats(String searchTerm) {
    if (widget.showSearchStats && widget.onSearchStats != null) {
      // Calculate search result count based on searchable columns
      final searchableColumns = widget.columns.where((col) => 
        col.searchable && (widget.columnSearchEnabled?[col.id] ?? true)
      ).toList();
      
      // This is a simplified calculation - in a real implementation,
      // you would get the actual result count from the data source
      final estimatedCount = searchTerm.isEmpty ? 0 : 
        (searchableColumns.length * 10); // Simplified estimation
      
      setState(() {
        _searchResultCount = estimatedCount;
      });
      
      widget.onSearchStats?.call(searchTerm, estimatedCount);
    }
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
        children: [
          Row(
            children: [
              // Search icon
              Icon(Icons.search, color: Colors.grey.shade600),
              const SizedBox(width: 8),
              
              // Search field
              Expanded(
                child: widget.customSearchField ?? _buildSearchField(),
              ),
              
              // Clear button
              if (_searchController.text.isNotEmpty) ...[
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _onClearSearch,
                  icon: Icon(Icons.clear, color: Colors.grey.shade600),
                  tooltip: 'Clear search',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
              
              // Advanced search toggle
              if (widget.showAdvancedSearch) ...[
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _toggleAdvancedSearch,
                  icon: Icon(
                    _showAdvancedSearch ? Icons.expand_less : Icons.expand_more,
                    color: Colors.grey.shade600,
                  ),
                  tooltip: 'Advanced search',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
              
              // Filter toggle
              if (widget.showFilter) ...[
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _toggleFilters,
                  icon: Icon(
                    _showFilters ? Icons.filter_alt : Icons.filter_alt_outlined,
                    color: Colors.grey.shade600,
                  ),
                  tooltip: 'Show filters',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ],
          ),
          
          // Search statistics
          if (widget.showSearchStats && _searchController.text.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 14, color: Colors.blue.shade600),
                  const SizedBox(width: 4),
                  Text(
                    'Found approximately $_searchResultCount results',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
          
          // Search suggestions
          if (widget.showSuggestions && _suggestions.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              constraints: const BoxConstraints(maxHeight: 200),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(4),
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
            ),
          ],
          
          // Advanced search options
          if (_showAdvancedSearch) ...[
            const SizedBox(height: 16),
            _buildAdvancedSearchOptions(),
          ],
          
          // Filter options
          if (_showFilters) ...[
            const SizedBox(height: 16),
            _buildFilterOptions(),
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
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blue.shade500),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        isDense: true,
      ),
      onChanged: _onSearchChanged,
      onSubmitted: _onSearchSubmitted,
    );
  }

  Widget _buildAdvancedSearchOptions() {
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
            'Advanced Search Options',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 12),
          
          // Column-specific search options
          ...widget.columns.where((col) => 
            col.searchable && (widget.columnSearchEnabled?[col.id] ?? true)
          ).map((column) {
            return CheckboxListTile(
              title: Text(column.title),
              subtitle: Text('Search in ${column.title}'),
              value: widget.columnSearchEnabled?[column.id] ?? true,
              onChanged: (value) {
                // This would need to be handled by the parent widget
                // For now, we'll just show the current state
              },
              dense: true,
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildFilterOptions() {
    return widget.customFilterWidget ?? 
      GridFilterWidget(
        columns: widget.columns,
        filters: widget.filters,
        onFilter: widget.onFilter ?? (_, __) {},
        visible: true,
        showFilterChips: true,
        showFilterDialog: true,
      );
  }
} 