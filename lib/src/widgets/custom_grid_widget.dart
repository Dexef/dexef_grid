import 'package:flutter/material.dart';
import '../models/grid_column.dart';
import '../models/grid_row.dart';
import '../models/grid_config.dart';
import '../models/grid_actions.dart';
import '../utils/column_type_detector.dart';
import 'grid_search_widget.dart';
import 'grid_filter_widget.dart';
import 'grid_pagination_widget.dart';
import 'grid_actions_widget.dart';
import 'dart:async';

/// A group of values for header filter display
class ValueGroup {
  final String title;
  final List<String> values;
  
  const ValueGroup(this.title, this.values);
}

/// A comprehensive custom grid widget with DevExtreme-style features
class CustomGridWidget extends StatefulWidget {
  /// List of columns defining the grid structure
  final List<GridColumn> columns;
  
  /// List of rows containing the data
  final List<GridRow> rows;
  
  /// Configuration for the grid behavior and appearance
  final GridConfig config;
  
  /// Callbacks for grid events
  final GridActions actions;
  
  /// Whether the grid is loading
  final bool isLoading;
  
  /// Whether the grid has an error
  final bool hasError;
  
  /// Error message if any
  final String? errorMessage;
  
  /// Total number of items (for pagination)
  final int totalItems;
  
  /// Current page
  final int currentPage;
  
  /// Items per page
  final int itemsPerPage;
  
  /// Search term
  final String? searchTerm;
  
  /// Applied filters
  final Map<String, String> filters;
  
  /// Sort column
  final String? sortColumn;
  
  /// Sort direction (true for ascending, false for descending)
  final bool? sortAscending;
  
  /// Selected row IDs
  final List<String> selectedRowIds;
  
  /// Whether to show the toolbar
  final bool showToolbar;
  
  /// Whether to show the header
  final bool showHeader;
  
  /// Whether to show the footer
  final bool showFooter;
  
  /// Custom toolbar widget
  final Widget? customToolbar;
  
  /// Custom header widget
  final Widget? customHeader;
  
  /// Custom footer widget
  final Widget? customFooter;
  
  /// Custom empty state widget
  final Widget? customEmptyState;
  
  /// Custom loading state widget
  final Widget? customLoadingState;
  
  /// Custom error state widget
  final Widget? customErrorState;

  /// Whether to show header filters (DevExtreme style)
  final bool showHeaderFilters;
  
  /// Whether to show grouping
  final bool showGrouping;
  
  /// Whether to show summaries
  final bool showSummaries;
  
  /// Whether to show master-detail
  final bool showMasterDetail;
  
  /// Whether to enable virtual scrolling
  final bool enableVirtualScrolling;

  const CustomGridWidget({
    super.key,
    required this.columns,
    required this.rows,
    required this.config,
    required this.actions,
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage,
    this.totalItems = 0,
    this.currentPage = 1,
    this.itemsPerPage = 10,
    this.searchTerm,
    this.filters = const {},
    this.sortColumn,
    this.sortAscending,
    this.selectedRowIds = const [],
    this.showToolbar = true,
    this.showHeader = true,
    this.showFooter = true,
    this.customToolbar,
    this.customHeader,
    this.customFooter,
    this.customEmptyState,
    this.customLoadingState,
    this.customErrorState,
    this.showHeaderFilters = true,
    this.showGrouping = true,
    this.showSummaries = true,
    this.showMasterDetail = false,
    this.enableVirtualScrolling = false,
  });

  @override
  State<CustomGridWidget> createState() => _CustomGridWidgetState();
}

class _CustomGridWidgetState extends State<CustomGridWidget> {
  late List<GridRow> _filteredRows;
  late List<GridRow> _displayedRows;
  late List<String> _selectedRowIds;
  late String? _searchTerm;
  late Map<String, String> _filters;
  late String? _sortColumn;
  late bool? _sortAscending;
  late int _currentPage;
  late int _itemsPerPage;
  late ScrollController _horizontalScrollController;
  late ScrollController _verticalScrollController;
  bool _showAdvancedFilters = false;
  Map<String, String> _autoFilterValues = {}; // Auto filter row values
  Map<String, String> _autoFilterOperations = {}; // Auto filter operations
  Map<String, String> _headerFilterValues = {}; // Header filter values
  Map<String, String> _headerFilterOperations = {}; // Header filter operations
  Map<String, bool> _expandedRows = {}; // Master-detail expanded rows
  List<String> _groupedColumns = []; // Grouped columns
  Map<String, dynamic> _groupSummaries = {}; // Group summaries
  
  // Performance optimization variables
  Timer? _debounceTimer;
  Map<String, List<String>> _columnValueCache = {};
  bool _isFiltering = false;

  // Add a new state variable for filter apply mode (auto or onClick)
  bool _autoApplyFilter = true; // true: auto, false: onClick
  Map<String, String> _pendingFilterValues = {}; // For onClick mode
  Map<String, String> _pendingFilterOperations = {}; // For onClick mode

  @override
  void initState() {
    super.initState();
    _horizontalScrollController = ScrollController();
    _verticalScrollController = ScrollController();
    _initializeState();
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    _verticalScrollController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(CustomGridWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateState();
  }

  void _initializeState() {
    _selectedRowIds = List.from(widget.selectedRowIds);
    _searchTerm = widget.searchTerm;
    _filters = Map.from(widget.filters);
    _sortColumn = widget.sortColumn;
    _sortAscending = widget.sortAscending;
    _currentPage = widget.currentPage;
    _itemsPerPage = widget.itemsPerPage;
    _filteredRows = List.from(widget.rows);
    _displayedRows = List.from(widget.rows);
    _updateFilteredRows();
  }

  void _updateState() {
    if (widget.selectedRowIds != _selectedRowIds) {
      _selectedRowIds = List.from(widget.selectedRowIds);
    }
    if (widget.searchTerm != _searchTerm) {
      _searchTerm = widget.searchTerm;
    }
    if (widget.filters != _filters) {
      _filters = Map.from(widget.filters);
    }
    if (widget.sortColumn != _sortColumn) {
      _sortColumn = widget.sortColumn;
    }
    if (widget.sortAscending != _sortAscending) {
      _sortAscending = widget.sortAscending;
    }
    if (widget.currentPage != _currentPage) {
      _currentPage = widget.currentPage;
    }
    if (widget.itemsPerPage != _itemsPerPage) {
      _itemsPerPage = widget.itemsPerPage;
    }
    _updateFilteredRows();
  }

  void _updateFilteredRows() {
    if (_isFiltering) return; // Prevent concurrent filtering
    
    setState(() {
      _isFiltering = true;
    });
    
    // Cancel any existing debounce timer
    _debounceTimer?.cancel();
    
    // Debounce the filtering operation
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _performFiltering();
    });
  }

  void _performFiltering() {
    if (!mounted) return;
    
    _filteredRows = List.from(widget.rows);
    
    // Apply search with caching
    if (_searchTerm != null && _searchTerm!.isNotEmpty) {
      final searchTermLower = _searchTerm!.toLowerCase().trim();
      _filteredRows = _filteredRows.where((row) {
        return widget.columns.any((column) {
          if (!column.searchable) return false;
          final value = row.getValue(column.id);
          if (value == null) return false;
          final valueStr = value.toString().toLowerCase();
          return valueStr.contains(searchTermLower);
        });
      }).toList();
    }
    
    // Apply advanced filters with caching
    for (final entry in _filters.entries) {
      if (entry.value.isNotEmpty) {
        final parts = entry.key.split('|');
        final columnId = parts[0];
        final filterType = parts.length > 1 ? parts[1] : 'contains';
        final filterValue = entry.value.toLowerCase().trim();
        
        _filteredRows = _filteredRows.where((row) {
          try {
            final column = widget.columns.firstWhere((col) => col.id == columnId);
            if (!column.filterable) return true;
            final value = row.getValue(column.id);
            if (value == null) return false;
            final valueStr = value.toString().toLowerCase();
            return _applyFilterOperation(valueStr, filterValue, filterType);
          } catch (e) {
            return true;
          }
        }).toList();
      }
    }
    
    // Apply auto filters with optimized performance
    for (final entry in _autoFilterValues.entries) {
      if (entry.value.isNotEmpty) {
        final columnId = entry.key;
        final filterValue = entry.value.toLowerCase().trim();
        final filterOperation = _autoFilterOperations[columnId] ?? 'contains';

        _filteredRows = _filteredRows.where((row) {
          try {
            final column = widget.columns.firstWhere((col) => col.id == columnId);
            if (!column.filterable) return true;
            final value = row.getValue(column.id);
            if (value == null) return false;
            final valueStr = value.toString().toLowerCase();
            return _applyFilterOperation(valueStr, filterValue, filterOperation);
          } catch (e) {
            return true;
          }
        }).toList();
      }
    }
    
    // Apply header filters
    for (final entry in _headerFilterValues.entries) {
      if (entry.key.endsWith('_mode')) continue; // Skip mode entries
      
      if (entry.value.isNotEmpty) {
        final columnId = entry.key;
        final filterValue = entry.value.toLowerCase().trim();
        final filterOperation = _headerFilterOperations[columnId] ?? 'contains';
        final includeMode = _headerFilterValues['${columnId}_mode'] != 'exclude';

        _filteredRows = _filteredRows.where((row) {
          try {
            final column = widget.columns.firstWhere((col) => col.id == columnId);
            if (!column.filterable) return true;
            final value = row.getValue(column.id);
            if (value == null) return false;
            final valueStr = value.toString().toLowerCase();
            
            // Handle multiple values (separated by |)
            if (filterValue.contains('|')) {
              final selectedValues = filterValue.split('|');
              final matches = selectedValues.any((selectedValue) => 
                _applyFilterOperation(valueStr, selectedValue, filterOperation)
              );
              return includeMode ? matches : !matches;
            } else {
              final matches = _applyFilterOperation(valueStr, filterValue, filterOperation);
              return includeMode ? matches : !matches;
            }
          } catch (e) {
            return true;
          }
        }).toList();
      }
    }
    
    // Apply sorting with optimized comparison
    if (_sortColumn != null) {
      try {
        final column = widget.columns.firstWhere((col) => col.id == _sortColumn);
        if (column.sortable) {
          _filteredRows.sort((a, b) {
            final aValue = a.getValue(column.id);
            final bValue = b.getValue(column.id);
            if (column.sortFunction != null) {
              return column.sortFunction!(aValue, bValue) * (_sortAscending == true ? 1 : -1);
            }
            if (aValue == null && bValue == null) return 0;
            if (aValue == null) return _sortAscending == true ? -1 : 1;
            if (bValue == null) return _sortAscending == true ? 1 : -1;
            final comparison = aValue.toString().compareTo(bValue.toString());
            return comparison * (_sortAscending == true ? 1 : -1);
          });
        }
      } catch (e) {
        // If column not found, skip sorting
      }
    }
    
    // Apply pagination
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    _displayedRows = _filteredRows.sublist(
      startIndex.clamp(0, _filteredRows.length),
      endIndex.clamp(0, _filteredRows.length),
    );
    
    if (mounted) {
      setState(() {
        _isFiltering = false;
      });
    }
  }

  bool _applyFilterOperation(String value, String filterValue, String operation) {
    switch (operation) {
      case 'contains':
        return value.contains(filterValue);
      case 'equals':
      case 'exact':
        return value == filterValue;
      case 'startsWith':
        return value.startsWith(filterValue);
      case 'endsWith':
        return value.endsWith(filterValue);
      case 'notContains':
        return !value.contains(filterValue);
      case 'isEmpty':
        return value.isEmpty;
      case 'isNotEmpty':
        return value.isNotEmpty;
      default:
        return value.contains(filterValue);
    }
  }

  void _onSearch(String searchTerm) {
    final newSearchTerm = searchTerm.isEmpty ? null : searchTerm;
    
    // Only update if the search term actually changed
    if (_searchTerm != newSearchTerm) {
      setState(() {
        _searchTerm = newSearchTerm;
        _currentPage = 1;
      });
      _updateFilteredRows();
      widget.actions.onSearch?.call(searchTerm);
    }
  }

  void _onFilter(String columnId, String filterValue) {
    final newFilterValue = filterValue.isEmpty ? null : filterValue;
    final currentFilter = _filters[columnId];
    
    // Only update if the filter value actually changed
    if (currentFilter != newFilterValue) {
      setState(() {
        if (newFilterValue == null) {
          _filters.remove(columnId);
        } else {
          _filters[columnId] = newFilterValue;
        }
        _currentPage = 1;
      });
      _updateFilteredRows();
      widget.actions.onFilter?.call(columnId, filterValue);
    }
  }

  void _onSort(String columnId, bool ascending) {
    setState(() {
      if (_sortColumn == columnId && _sortAscending == ascending) {
        _sortColumn = null;
        _sortAscending = null;
      } else {
        _sortColumn = columnId;
        _sortAscending = ascending;
      }
    });
    _updateFilteredRows();
    final column = widget.columns.firstWhere((col) => col.id == columnId);
    widget.actions.onColumnSort?.call(columnId, column.title, ascending);
  }

  void _onRowSelected(String rowId, bool selected) {
    setState(() {
      if (selected) {
        if (!_selectedRowIds.contains(rowId)) {
          if (widget.config.allowMultiSelection) {
            _selectedRowIds.add(rowId);
          } else {
            _selectedRowIds.clear();
            _selectedRowIds.add(rowId);
          }
        }
      } else {
        _selectedRowIds.remove(rowId);
      }
    });
    
    final row = widget.rows.firstWhere((r) => r.id == rowId);
    if (selected) {
      widget.actions.onRowSelected?.call(rowId, row.data);
    } else {
      widget.actions.onRowDeselected?.call(rowId, row.data);
    }
    
    if (widget.config.allowMultiSelection && _selectedRowIds.length > 1) {
      final selectedRows = widget.rows.where((r) => _selectedRowIds.contains(r.id)).toList();
      widget.actions.onMultiRowSelected?.call(
        _selectedRowIds,
        selectedRows.map((r) => r.data).toList(),
      );
    }
  }

  void _onRowTap(String rowId, int rowIndex) {
    final row = widget.rows.firstWhere((r) => r.id == rowId);
    widget.actions.onRowTap?.call(rowId, row.data, rowIndex);
  }

  void _onRowDoubleTap(String rowId, int rowIndex) {
    final row = widget.rows.firstWhere((r) => r.id == rowId);
    widget.actions.onRowDoubleTap?.call(rowId, row.data, rowIndex);
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
    _updateFilteredRows();
    widget.actions.onPageChanged?.call(page, _itemsPerPage);
  }

  void _onItemsPerPageChanged(int itemsPerPage) {
    setState(() {
      _itemsPerPage = itemsPerPage;
      _currentPage = 1;
    });
    _updateFilteredRows();
    widget.actions.onItemsPerPageChanged?.call(itemsPerPage);
  }

  void _onActionTriggered(String actionId, String rowId) {
    final row = widget.rows.firstWhere((r) => r.id == rowId);
    widget.actions.onActionTriggered?.call(actionId, rowId, row.data);
  }

  void _onSelectAll(bool? value) {
    setState(() {
      if (value == true) {
        _selectedRowIds.clear();
        _selectedRowIds.addAll(_displayedRows.map((r) => r.id));
      } else {
        _selectedRowIds.clear();
      }
    });
    
    if (value == true) {
      final selectedRows = _displayedRows;
      widget.actions.onMultiRowSelected?.call(
        _selectedRowIds,
        selectedRows.map((r) => r.data).toList(),
      );
    }
  }

  void _toggleAdvancedFilters() {
    setState(() {
      _showAdvancedFilters = !_showAdvancedFilters;
    });
  }

  /// Get responsive column width based on screen size
  double _getResponsiveColumnWidth(GridColumn column, double availableWidth) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < widget.config.mobileBreakpoint;
    final isTablet = screenWidth >= widget.config.mobileBreakpoint && screenWidth < widget.config.tabletBreakpoint;
    
    if (isMobile) {
      // On mobile, use fixed minimum widths to ensure horizontal scrolling
      // If column has a specific width, use it; otherwise use minimum width
      return column.width ?? widget.config.mobileMinColumnWidth;
    } else if (isTablet) {
      // On tablet, use specified width or calculate based on available space
      if (column.width != null) {
        return column.width!;
      }
      // Calculate proportional width based on available space
      final totalColumns = widget.columns.where((col) => col.visible).length;
      return (availableWidth / totalColumns).clamp(
        widget.config.tabletMinColumnWidth, 
        widget.config.tabletMaxColumnWidth
      );
    } else {
      // On desktop, use specified width or calculate proportional width
      if (column.width != null) {
        return column.width!;
      }
      // Calculate proportional width based on available space
      final totalColumns = widget.columns.where((col) => col.visible).length;
      return (availableWidth / totalColumns).clamp(
        widget.config.desktopDefaultColumnWidth * 0.8, 
        widget.config.desktopDefaultColumnWidth * 1.5
      );
    }
  }

  /// Calculate total width needed for all columns
  double _calculateTotalColumnWidth(double availableWidth) {
    double totalWidth = 0;
    
    // Selection column width
    if (widget.config.showSelection) {
      totalWidth += 60; // Slightly wider for better touch targets on mobile
    }
    
    // Data columns width
    for (final column in widget.columns.where((col) => col.visible)) {
      totalWidth += _getResponsiveColumnWidth(column, availableWidth);
    }
    
    // Actions column width
    if (widget.config.showActions) {
      totalWidth += 80; // Wider for action buttons
    }
    
    return totalWidth;
  }

  /// Check if horizontal scrolling is needed
  bool _needsHorizontalScroll(double availableWidth) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < widget.config.mobileBreakpoint;
    
    // Always enable horizontal scrolling on mobile for better UX
    if (isMobile) {
      return true;
    }
    
    // For tablet and desktop, check if horizontal scrolling should be enabled
    if (!widget.config.shouldEnableHorizontalScroll(screenWidth)) {
      return false;
    }
    
    final totalWidth = _calculateTotalColumnWidth(availableWidth);
    return totalWidth > availableWidth;
  }

  /// Get responsive row height
  double _getResponsiveRowHeight() {
    final screenWidth = MediaQuery.of(context).size.width;
    return widget.config.getResponsiveRowHeight(screenWidth);
  }

  /// Get responsive header height
  double _getResponsiveHeaderHeight() {
    final screenWidth = MediaQuery.of(context).size.width;
    return widget.config.getResponsiveHeaderHeight(screenWidth);
  }

  /// Check if headers should be shown
  bool _shouldShowHeaders() {
    final screenWidth = MediaQuery.of(context).size.width;
    return widget.config.shouldShowHeaders(screenWidth);
  }

  /// Get column width for layout (used in header and row building)
  double _getColumnWidthForLayout(GridColumn column, double availableWidth) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < widget.config.mobileBreakpoint;
    
    if (isMobile) {
      // On mobile, use fixed widths for consistent layout
      return column.width ?? widget.config.mobileMinColumnWidth;
    } else {
      // On tablet and desktop, use responsive calculation
      return _getResponsiveColumnWidth(column, availableWidth);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return _buildLoadingState();
    }

    if (widget.hasError) {
      return _buildErrorState();
    }

    if (widget.rows.isEmpty) {
      return _buildEmptyState();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final availableHeight = constraints.maxHeight;
        final needsHorizontalScroll = _needsHorizontalScroll(availableWidth);
        final totalWidth = _calculateTotalColumnWidth(availableWidth);

        return Container(
          width: widget.config.gridWidth ?? availableWidth,
          height: widget.config.gridHeight ?? availableHeight,
          margin: widget.config.margin,
          decoration: BoxDecoration(
            color: widget.config.backgroundColor,
            borderRadius: widget.config.borderRadius,
            border: widget.config.border,
            boxShadow: widget.config.shadow,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Advanced Toolbar
              if (widget.showToolbar) ...[
                widget.customToolbar ?? _buildAdvancedToolbar(),
              ],

              // Header
              if (widget.showHeader && widget.config.showHeader && _shouldShowHeaders()) ...[
                widget.customHeader ?? _buildHeader(availableWidth, totalWidth, needsHorizontalScroll),
              ],

              // Auto Filter Row
              if (widget.config.showAutoFilter) ...[
                _buildAutoFilterRow(availableWidth, totalWidth, needsHorizontalScroll),
              ],

              // Grid content - takes remaining space
              Expanded(
                child: _buildGridContent(availableWidth, totalWidth, needsHorizontalScroll),
              ),

              // Footer
              if (widget.showFooter) ...[
                // Summary footer
                if (widget.showSummaries) ...[
                  _buildSummaryFooter(),
                ],
                // Pagination
                if (widget.config.showPagination) ...[
                  widget.customFooter ??
                      GridPaginationWidget(
                        currentPage: _currentPage,
                        totalPages: (_filteredRows.length / _itemsPerPage).ceil(),
                        totalItems: _filteredRows.length,
                        itemsPerPage: _itemsPerPage,
                        itemsPerPageOptions: widget.config.itemsPerPageOptions,
                        onPageChanged: _onPageChanged,
                        onItemsPerPageChanged: _onItemsPerPageChanged,
                      ),
                ],
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildAdvancedToolbar() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Main Toolbar Row
          Row(
            children: [
              // Search Panel
              if (widget.config.showSearch) ...[
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Icon(Icons.search, color: Colors.grey.shade600, size: 14),
                        ),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: widget.config.searchPlaceholder,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(vertical: 6),
                            ),
                            textAlign: TextAlign.left,
                            textDirection: TextDirection.ltr,
                            onChanged: _onSearch,
                            controller: TextEditingController(text: _searchTerm ?? ''),
                          ),
                        ),
                        if (_searchTerm?.isNotEmpty == true) ...[
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _searchTerm = null;
                                _currentPage = 1;
                              });
                              _updateFilteredRows();
                            },
                            icon: Icon(Icons.clear, size: 14),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              
              // Action Buttons
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Grouping Button
                  if (widget.showGrouping) ...[
                    _buildToolbarButton(
                      icon: Icons.group_work,
                      label: 'Group',
                      isActive: _groupedColumns.isNotEmpty,
                      onPressed: () => _showGroupingDialog(),
                    ),
                    const SizedBox(width: 4),
                  ],
                  
                  // Filter Button
                  if (widget.config.showFilter) ...[
                    _buildToolbarButton(
                      icon: _showAdvancedFilters ? Icons.filter_alt : Icons.filter_alt_outlined,
                      label: 'Filter',
                      isActive: _showAdvancedFilters,
                      onPressed: _toggleAdvancedFilters,
                    ),
                    const SizedBox(width: 4),
                  ],
                  
                  // Export Button
                  _buildToolbarButton(
                    icon: Icons.download,
                    label: 'Export',
                    isActive: false,
                    onPressed: () => _showExportDialog(),
                  ),
                  const SizedBox(width: 4),
                  
                  // Refresh Button
                  _buildToolbarButton(
                    icon: Icons.refresh,
                    label: 'Refresh',
                    isActive: false,
                    onPressed: () {
                      widget.actions.onRefresh?.call();
                      _updateFilteredRows();
                    },
                  ),
                ],
              ),
              
              const Spacer(),
              
              // Status Indicators
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Selection Info
                  if (widget.config.showSelection && _selectedRowIds.isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle, size: 12, color: Colors.blue.shade700),
                          const SizedBox(width: 4),
                          Text(
                            '${_selectedRowIds.length} selected',
                            style: TextStyle(
                              color: Colors.blue.shade800,
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  
                  // Filtering indicator
                  if (_isFiltering) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.orange.shade200),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 10,
                            height: 10,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.orange.shade700),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Filtering...',
                            style: TextStyle(
                              color: Colors.orange.shade700,
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  
                  // Clear All Button
                  if (_hasActiveFilters()) ...[
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _filters.clear();
                          _searchTerm = null;
                          _autoFilterValues.clear();
                          _autoFilterOperations.clear();
                          _headerFilterValues.clear();
                          _headerFilterOperations.clear();
                          _groupedColumns.clear();
                          _currentPage = 1;
                        });
                        _updateFilteredRows();
                      },
                      icon: const Icon(Icons.clear_all, size: 12),
                      label: const Text('Clear All'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red.shade600,
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          
          // Advanced Filters Section
          if (_showAdvancedFilters && widget.config.showFilter) ...[
            const SizedBox(height: 8),
            _buildAdvancedFiltersSection(),
          ],
          
          // Filter Summary
          if (_hasActiveFilters()) ...[
            const SizedBox(height: 8),
            _buildFilterSummary(),
          ],
        ],
      ),
    );
  }

  Widget _buildToolbarButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onPressed,
  }) {
    return Container(
      height: 32,
      decoration: BoxDecoration(
        color: isActive ? Colors.blue.shade100 : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isActive ? Colors.blue.shade300 : Colors.grey.shade300,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 12,
                  color: isActive ? Colors.blue.shade700 : Colors.grey.shade700,
                ),
                const SizedBox(width: 3),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: isActive ? Colors.blue.shade700 : Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAdvancedFiltersSection() {
    final filterableColumns = widget.columns.where((col) => col.filterable).toList();
    return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.filter_list, color: Colors.blue.shade600, size: 14),
                const SizedBox(width: 6),
                Text(
                  'Advanced Filters',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                if (_filters.isNotEmpty) ...[
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _filters.clear();
                        _currentPage = 1;
                      });
                      _updateFilteredRows();
                    },
                    child: const Text('Clear Filters'),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: filterableColumns.map((column) {
                  final columnFilters = _filters.entries
                      .where((entry) => entry.key.startsWith('${column.id}|'))
                      .toList();
                  final hasFilter = columnFilters.isNotEmpty;
                  
                  return Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: hasFilter ? Colors.blue.shade50 : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: hasFilter ? Colors.blue.shade200 : Colors.grey.shade200,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.filter_alt,
                              size: 12,
                              color: hasFilter ? Colors.blue.shade600 : Colors.grey.shade600,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              column.title,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: hasFilter ? Colors.blue.shade800 : Colors.grey.shade700,
                                fontSize: 11,
                              ),
                            ),
                            if (hasFilter) ...[
                              const Spacer(),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    _filters.removeWhere((key, _) => key.startsWith('${column.id}|'));
                                    _currentPage = 1;
                                  });
                                  _updateFilteredRows();
                                },
                                icon: Icon(Icons.close, size: 12),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 6),
                        _buildFilterInput(
                          column,
                          column.columnType != ColumnType.unknown ? column.columnType : _detectColumnType(column),
                          _autoFilterValues[column.id] ?? '',
                          (_autoFilterValues[column.id] ?? '').isNotEmpty,
                          onChanged: (value) {
                            setState(() {
                              _autoFilterValues[column.id] = value;
                            });
                            _updateFilteredRows();
                          },
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            )
          ],
        ),
      );
  }

  Widget _buildHeader(double availableWidth, double totalWidth, bool needsHorizontalScroll) {
    return Container(
      height: _getResponsiveHeaderHeight() * 0.8, // Reduce height by 20%
      decoration: BoxDecoration(
        color: widget.config.headerBackgroundColor,
        border: Border(
          bottom: BorderSide(
            color: widget.config.headerBorderColor ?? Colors.grey.shade300,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          if (widget.config.showSelection) ...[
            SizedBox(
              width: 60,
              child: Center(
                child: Checkbox(
                  value: _selectedRowIds.length == _displayedRows.length && _displayedRows.isNotEmpty,
                  tristate: true,
                  onChanged: _onSelectAll,
                ),
              ),
            ),
          ],
          ...widget.columns.where((col) => col.visible).map((column) {
            return Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: _buildHeaderCell(column),
              ),
            );
          }),
          if (widget.config.showActions) ...[
            SizedBox(width: 80),
          ],
        ],
      ),
    );
  }

  Widget _buildHeaderRow(double availableWidth) {
    return Row(
      children: [
        if (widget.config.showSelection) ...[
          SizedBox(
            width: 60,
            child: Checkbox(
              value: _selectedRowIds.length == _displayedRows.length && _displayedRows.isNotEmpty,
              tristate: true,
              onChanged: (value) {
                if (value == true) {
                  setState(() {
                    _selectedRowIds.clear();
                    _selectedRowIds.addAll(_displayedRows.map((r) => r.id));
                  });
                } else {
                  setState(() {
                    _selectedRowIds.clear();
                  });
                }
              },
            ),
          ),
        ],
        ...widget.columns.where((col) => col.visible).map((column) {
          return SizedBox(
            width: _getColumnWidthForLayout(column, availableWidth),
            child: _buildHeaderCell(column),
          );
        }),
        if (widget.config.showActions) ...[
          SizedBox(
            width: 80,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: const Text(
                'Actions',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildHeaderCell(GridColumn column) {
    final isSorted = _sortColumn == column.id;
    final isAscending = _sortAscending == true;
    final hasHeaderFilter = _headerFilterValues.containsKey(column.id);
    final isGrouped = _groupedColumns.contains(column.id);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(color: Colors.grey.shade300, width: 1),
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: InkWell(
        onTap: column.sortable ? () => _onSort(column.id, !isAscending) : null,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Main header content
              Row(
                children: [
                  // Group indicator
                  if (isGrouped) ...[
                    Icon(Icons.group_work, size: 12, color: Colors.blue.shade600),
                    const SizedBox(width: 2),
                  ],
                  // Column title
                  Expanded(
                    child: column.headerBuilder?.call(context, column.title) ??
                        Text(
                          column.title,
                          style: TextStyle(
                            color: widget.config.headerTextColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                  ),
                  // Action buttons
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Group button
                      if (widget.showGrouping && column.groupable != false) ...[
                        InkWell(
                          onTap: () => _toggleColumnGrouping(column.id),
                          child: Container(
                            padding: const EdgeInsets.all(1),
                            child: Icon(
                              isGrouped ? Icons.group_work : Icons.group_work_outlined,
                              size: 12,
                              color: isGrouped ? Colors.blue.shade600 : Colors.grey.shade600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 2),
                      ],
                      // Sort indicator
                      if (column.sortable) ...[
                        Icon(
                          isSorted
                              ? (isAscending ? Icons.arrow_upward : Icons.arrow_downward)
                              : Icons.unfold_more,
                          size: 12,
                          color: isSorted ? Colors.blue.shade600 : Colors.grey.shade600,
                        ),
                        const SizedBox(width: 2),
                      ],
                      // Filter button
                      if (column.filterable && widget.showHeaderFilters) ...[
                        InkWell(
                          onTap: () => _showHeaderFilterDialog(column),
                          child: Container(
                            padding: const EdgeInsets.all(1),
                            child: Icon(
                              hasHeaderFilter ? Icons.filter_alt : Icons.filter_alt_outlined,
                              size: 12,
                              color: hasHeaderFilter ? Colors.blue.shade600 : Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
              // Filter indicator
              if (hasHeaderFilter) ...[
                const SizedBox(height: 1),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.blue.shade200, width: 0.5),
                  ),
                  child: Text(
                    'F',
                    style: TextStyle(
                      fontSize: 6,
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridContent(double availableWidth, double totalWidth, bool needsHorizontalScroll) {
    return needsHorizontalScroll
        ? SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: _horizontalScrollController,
            child: SizedBox(
              width: totalWidth,
              child: _buildGridRows(availableWidth),
            ),
          )
        : _buildGridRows(availableWidth);
  }

  Widget _buildGridRows(double availableWidth) {
    if (_groupedColumns.isNotEmpty) {
      return _buildGroupedRows(availableWidth);
    }
    
    return ListView.separated(
      controller: _verticalScrollController,
      itemCount: _displayedRows.length,
      separatorBuilder: (context, index) => Container(
        height: widget.config.rowSpacing,
        color: widget.config.rowBorderColor ?? Colors.grey.shade200,
      ),
      itemBuilder: (context, index) {
        final row = _displayedRows[index];
        return _buildRow(row, index, availableWidth);
      },
    );
  }

  Widget _buildGroupedRows(double availableWidth) {
    // Group rows by the first grouped column
    final groupedData = <String, List<GridRow>>{};
    final groupColumn = widget.columns.firstWhere((col) => col.id == _groupedColumns.first);
    
    for (final row in _displayedRows) {
      final groupValue = row.getValue(groupColumn.id)?.toString() ?? 'Unknown';
      groupedData.putIfAbsent(groupValue, () => []).add(row);
    }
    
    final sortedGroups = groupedData.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    
    return ListView.builder(
      controller: _verticalScrollController,
      itemCount: sortedGroups.length,
      itemBuilder: (context, groupIndex) {
        final group = sortedGroups[groupIndex];
        final groupRows = group.value;
        
        return Column(
          children: [
            // Group header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                border: Border(
                  bottom: BorderSide(color: Colors.blue.shade200),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.group_work, size: 16, color: Colors.blue.shade600),
                  const SizedBox(width: 8),
                  Text(
                    '${groupColumn.title}: ${group.key}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  if (widget.showSummaries) ...[
                    Text(
                      '${groupRows.length} items',
                      style: TextStyle(
                        color: Colors.blue.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Group rows
            ...groupRows.asMap().entries.map((entry) {
              final index = entry.key;
              final row = entry.value;
              return _buildRow(row, index, availableWidth);
            }),
          ],
        );
      },
    );
  }

  Widget _buildRow(GridRow row, int index, double availableWidth) {
    final isSelected = _selectedRowIds.contains(row.id);
    final isHovered = false; // TODO: Implement hover state
    final isExpanded = _expandedRows[row.id] ?? false;

    return Column(
      children: [
        // Main row
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => _onRowTap(row.id, index),
            onDoubleTap: () => _onRowDoubleTap(row.id, index),
            child: Container(
              height: _getResponsiveRowHeight(),
              decoration: BoxDecoration(
                color: isSelected
                    ? widget.config.selectedRowBackgroundColor
                    : isHovered
                        ? widget.config.hoverRowBackgroundColor
                        : widget.config.rowBackgroundColor,
                border: Border(
                  bottom: BorderSide(
                    color: widget.config.rowBorderColor ?? Colors.grey.shade200,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  if (widget.config.showSelection) ...[
                    SizedBox(
                      width: 60,
                      child: Checkbox(
                        value: isSelected,
                        onChanged: row.selectable
                            ? (value) => _onRowSelected(row.id, value ?? false)
                            : null,
                      ),
                    ),
                  ],
                  // Master-detail expand/collapse button
                  if (widget.showMasterDetail) ...[
                    SizedBox(
                      width: 40,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            _expandedRows[row.id] = !isExpanded;
                          });
                        },
                        icon: Icon(
                          isExpanded ? Icons.expand_less : Icons.expand_more,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ),
                  ],
                  ...widget.columns.where((col) => col.visible).map((column) {
                    return Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: _buildCell(row, column, index),
                      ),
                    );
                  }),
                  if (widget.config.showActions && row.actions != null) ...[
                    SizedBox(
                      width: 80,
                      child: GridActionsWidget(
                        actions: row.actions!,
                        rowId: row.id,
                        onActionTriggered: _onActionTriggered,
                        showOnHover: row.showActionsOnHover,
                        actionBuilder: row.actionBuilder,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        // Detail row
        if (isExpanded && widget.showMasterDetail) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: _buildDetailRow(row),
          ),
        ],
      ],
    );
  }

  Widget _buildDetailRow(GridRow row) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.info_outline, size: 16, color: Colors.blue.shade600),
            const SizedBox(width: 8),
            Text(
              'Details for ${row.data['name'] ?? 'User'}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: widget.columns.where((col) => col.visible).map((column) {
            final value = row.getValue(column.id);
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    column.title,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value?.toString() ?? '',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCell(GridRow row, GridColumn column, int index) {
    final value = row.getValue(column.id);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      alignment: Alignment.centerLeft,
      child: column.cellBuilder?.call(context, value, index) ??
          Text(
            value?.toString() ?? '',
            style: TextStyle(
              color: _selectedRowIds.contains(row.id)
                  ? widget.config.selectedRowTextColor
                  : widget.config.rowTextColor,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textAlign: TextAlign.left,
          ),
    );
  }

  Widget _buildLoadingState() {
    return widget.customLoadingState ??
        Container(
          height: 200,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(widget.config.loadingStateMessage),
            ],
          ),
        );
  }

  Widget _buildErrorState() {
    return widget.customErrorState ??
        Container(
          height: 200,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(widget.config.errorStateMessage),
              if (widget.errorMessage != null) ...[
                const SizedBox(height: 8),
                Text(widget.errorMessage!, style: const TextStyle(fontSize: 12)),
              ],
            ],
          ),
        );
  }

  Widget _buildEmptyState() {
    return widget.customEmptyState ??
        Container(
          height: 200,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.inbox_outlined, size: 48, color: Colors.grey),
              const SizedBox(height: 16),
              Text(widget.config.emptyStateMessage),
            ],
          ),
        );
  }

  Widget _buildAutoFilterRow(double availableWidth, double totalWidth, bool needsHorizontalScroll) {
    return Container(
      height: 32, // Reduced height to prevent overflow
      decoration: BoxDecoration(
        color: widget.config.autoFilterBackgroundColor ?? Colors.grey.shade50,
        border: Border(
          bottom: BorderSide(
            color: widget.config.autoFilterBorderColor ?? Colors.grey.shade300,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          if (widget.config.showSelection) ...[
            SizedBox(
              width: 60,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: const Text(
                  'Filter',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          ],
          ...widget.columns.where((col) => col.visible).map((column) {
            return Expanded(
              child: _buildFilterRowCell(column),
            );
          }),
          if (widget.config.showActions) ...[
            SizedBox(width: 80),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterRowCell(GridColumn column) {
    final filterConfig = column.filterConfig;
    final filterValue = _autoApplyFilter
        ? (_autoFilterValues[column.id] ?? filterConfig.defaultValue)
        : (_pendingFilterValues[column.id] ?? _autoFilterValues[column.id] ?? filterConfig.defaultValue);
    final filterOperation = _autoApplyFilter
        ? (_autoFilterOperations[column.id] ?? filterConfig.defaultOperation)
        : (_pendingFilterOperations[column.id] ?? _autoFilterOperations[column.id] ?? filterConfig.defaultOperation);
    final hasFilter = filterValue.isNotEmpty;
    final availableOperations = filterConfig.availableOperations;
    final customEditorOptions = filterConfig.validationRules; // Use for custom editor options

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
      decoration: BoxDecoration(
        color: hasFilter ? Colors.blue.shade50 : Colors.transparent,
        borderRadius: BorderRadius.circular(3),
      ),
      child: Row(
        children: [
          // Magnifier icon with dropdown for filter operations
          Flexible(
            flex: 1,
            child: Row(
              children: [
                Icon(Icons.search, size: 12, color: hasFilter ? Colors.blue.shade600 : Colors.grey.shade600),
                const SizedBox(width: 2),
                DropdownButton<String>(
                  value: availableOperations.contains(filterOperation) ? filterOperation : filterConfig.defaultOperation,
                  underline: const SizedBox(),
                  isDense: true,
                  icon: Icon(Icons.arrow_drop_down, size: 12, color: hasFilter ? Colors.blue.shade600 : Colors.grey.shade600),
                  items: availableOperations.map((operation) {
                    return DropdownMenuItem(
                      value: operation,
                      child: Text(
                        _getOperationDisplayName(operation),
                        style: TextStyle(fontSize: 8, color: hasFilter ? Colors.blue.shade700 : Colors.grey.shade700),
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        if (_autoApplyFilter) {
                          _autoFilterOperations[column.id] = value;
                          _updateFilteredRows();
                        } else {
                          _pendingFilterOperations[column.id] = value;
                        }
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(width: 2),
          // Filter input (pass customEditorOptions)
          Flexible(
            flex: 3,
            child: _buildFilterInput(
              column,
              column.columnType != ColumnType.unknown ? column.columnType : _detectColumnType(column),
              filterValue,
              hasFilter,
              customEditorOptions: customEditorOptions,
              onChanged: (value) {
                setState(() {
                  if (_autoApplyFilter) {
                    _autoFilterValues[column.id] = value;
                    _updateFilteredRows();
                  } else {
                    _pendingFilterValues[column.id] = value;
                  }
                });
              },
            ),
          ),
          if (!_autoApplyFilter) ...[
            const SizedBox(width: 2),
            IconButton(
              icon: const Icon(Icons.check, size: 14, color: Colors.green),
              tooltip: 'Apply Filter',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () {
                setState(() {
                  _autoFilterValues[column.id] = _pendingFilterValues[column.id] ?? '';
                  _autoFilterOperations[column.id] = _pendingFilterOperations[column.id] ?? filterConfig.defaultOperation;
                  _pendingFilterValues.remove(column.id);
                  _pendingFilterOperations.remove(column.id);
                  _updateFilteredRows();
                });
              },
            ),
          ],
        ],
      ),
    );
  }
  
  ColumnType _detectColumnType(GridColumn column) {
    // Extract values for this column from all rows
    final values = widget.rows.map((row) => row.getValue(column.id)).toList();
    return ColumnTypeDetector.detectType(values);
  }
  
  String _getOperationDisplayName(String operation) {
    switch (operation) {
      case 'contains': return 'Cont';
      case 'equals': return 'Eq';
      case 'startsWith': return 'Start';
      case 'endsWith': return 'End';
      case 'notContains': return 'Not';
      case 'isEmpty': return 'Empty';
      case 'isNotEmpty': return '!Empty';
      case 'greaterThan': return '>';
      case 'lessThan': return '<';
      case 'between': return 'Range';
      case 'isNull': return 'Null';
      case 'isNotNull': return '!Null';
      case 'before': return 'Before';
      case 'after': return 'After';
      case 'today': return 'Today';
      case 'thisWeek': return 'Week';
      case 'thisMonth': return 'Month';
      case 'thisYear': return 'Year';
      case 'isTrue': return 'True';
      case 'isFalse': return 'False';
      case 'domainEquals': return 'Domain';
      case 'isValidEmail': return 'Valid';
      case 'protocolEquals': return 'Proto';
      default: return operation;
    }
  }
  
  Widget _buildFilterInput(GridColumn column, ColumnType columnType, String filterValue, bool hasFilter, {Map<String, dynamic>? customEditorOptions, required void Function(String) onChanged}) {
    // Use customEditorOptions for further customization if needed
    switch (columnType) {
      case ColumnType.boolean:
        return DropdownButton<String>(
          value: filterValue.isEmpty ? null : filterValue,
          hint: Text('All', style: TextStyle(fontSize: 10)),
          underline: Container(),
          isDense: true,
          items: [
            DropdownMenuItem(value: 'true', child: Text('True', style: TextStyle(fontSize: 10))),
            DropdownMenuItem(value: 'false', child: Text('False', style: TextStyle(fontSize: 10))),
          ],
          onChanged: (value) => onChanged(value ?? ''),
        );
      case ColumnType.date:
        // Use a date picker or custom date input
        return TextField(
          decoration: InputDecoration(
            hintText: 'Date...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3),
              borderSide: BorderSide(color: hasFilter ? Colors.blue.shade300 : Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3),
              borderSide: BorderSide(color: Colors.blue.shade500, width: 1),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            isDense: true,
          ),
          style: const TextStyle(fontSize: 9),
          onChanged: onChanged,
          controller: TextEditingController(text: filterValue),
        );
      case ColumnType.number:
      case ColumnType.currency:
      case ColumnType.percentage:
        return TextField(
          decoration: InputDecoration(
            hintText: 'Number...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3),
              borderSide: BorderSide(color: hasFilter ? Colors.blue.shade300 : Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3),
              borderSide: BorderSide(color: Colors.blue.shade500, width: 1),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            isDense: true,
          ),
          style: const TextStyle(fontSize: 9),
          keyboardType: TextInputType.number,
          onChanged: onChanged,
          controller: TextEditingController(text: filterValue),
        );
      default:
        return TextField(
          decoration: InputDecoration(
            hintText: 'Filter...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3),
              borderSide: BorderSide(color: hasFilter ? Colors.blue.shade300 : Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3),
              borderSide: BorderSide(color: Colors.blue.shade500, width: 1),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            isDense: true,
          ),
          style: const TextStyle(fontSize: 9),
          onChanged: onChanged,
          controller: TextEditingController(text: filterValue),
        );
    }
  }

  void _toggleColumnGrouping(String columnId) {
    setState(() {
      if (_groupedColumns.contains(columnId)) {
        _groupedColumns.remove(columnId);
      } else {
        _groupedColumns.add(columnId);
      }
    });
    _updateFilteredRows();
    widget.actions.onGroupingChanged?.call(_groupedColumns);
  }

  void _showHeaderFilterDialog(GridColumn column) {
    print('Opening header filter dialog for column: ${column.title}');
    
    final initialFilterValue = _headerFilterValues[column.id] ?? '';
    final initialFilterType = _headerFilterOperations[column.id] ?? 'contains';
    final columnType = column.columnType != ColumnType.unknown 
        ? column.columnType 
        : _detectColumnType(column);
    final availableOperations = ColumnTypeDetector.getFilterOperations(columnType);

    // Get unique values for the column
    final uniqueValues = _getUniqueColumnValues(column);
    final groupedValues = _groupColumnValues(column, uniqueValues);
    
    try {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setDialogState) {
              String currentFilterValue = initialFilterValue;
              String currentFilterType = initialFilterType;
              Set<String> selectedValues = {};
              String searchTerm = '';
              bool includeMode = true; // true: include, false: exclude
              
              // Initialize selected values from current filter
              if (currentFilterValue.isNotEmpty) {
                selectedValues.add(currentFilterValue);
              }

              return AlertDialog(
                title: Row(
                  children: [
                    Icon(Icons.filter_alt, color: Colors.blue.shade600),
                    const SizedBox(width: 8),
                    Text('Header Filter: ${column.title}'),
                  ],
                ),
                content: Container(
                  width: 400,
                  height: 400,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Filter mode toggle (Include/Exclude)
                      Row(
                        children: [
                          Text('Filter Mode:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          const SizedBox(width: 8),
                          ToggleButtons(
                            isSelected: [includeMode, !includeMode],
                            onPressed: (index) {
                              setDialogState(() {
                                includeMode = index == 0;
                              });
                            },
                            children: const [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 6),
                                child: Text('Include', style: TextStyle(fontSize: 11)),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 6),
                                child: Text('Exclude', style: TextStyle(fontSize: 11)),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      
                      // Search in header filter
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Search values',
                          prefixIcon: Icon(Icons.search, size: 16),
                          border: OutlineInputBorder(),
                          hintText: 'Type to search...',
                          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        ),
                        onChanged: (value) {
                          setDialogState(() {
                            searchTerm = value.toLowerCase();
                          });
                        },
                      ),
                      const SizedBox(height: 8),
                      
                      // Filter type dropdown
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Filter Type',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        ),
                        value: currentFilterType,
                        items: availableOperations.map((operation) {
                          return DropdownMenuItem(
                            value: operation,
                            child: Text(_getOperationDisplayName(operation), style: TextStyle(fontSize: 11)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setDialogState(() {
                              currentFilterType = value;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 8),
                      
                      // Values list with grouping
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: groupedValues.isEmpty
                              ? Center(child: Text('No values available', style: TextStyle(fontSize: 12)))
                              : ListView.builder(
                                  itemCount: groupedValues.length,
                                  itemBuilder: (context, index) {
                                    final group = groupedValues[index];
                                    final filteredValues = group.values
                                        .where((value) => value.toLowerCase().contains(searchTerm))
                                        .toList();
                                    
                                    if (filteredValues.isEmpty) return SizedBox.shrink();
                                    
                                    return ExpansionTile(
                                      title: Text(
                                        group.title,
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                      ),
                                      subtitle: Text('${filteredValues.length} values', style: TextStyle(fontSize: 10)),
                                      children: filteredValues.map((value) {
                                        final isSelected = selectedValues.contains(value);
                                        return CheckboxListTile(
                                          title: Text(value, style: TextStyle(fontSize: 11)),
                                          subtitle: Text('${_getValueCount(column, value)} occurrences', style: TextStyle(fontSize: 9)),
                                          value: isSelected,
                                          onChanged: (checked) {
                                            setDialogState(() {
                                              if (checked == true) {
                                                selectedValues.add(value);
                                              } else {
                                                selectedValues.remove(value);
                                              }
                                            });
                                          },
                                          secondary: Icon(
                                            isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                                            color: isSelected ? Colors.blue.shade600 : Colors.grey.shade600,
                                            size: 16,
                                          ),
                                          dense: true,
                                        );
                                      }).toList(),
                                    );
                                  },
                                ),
                        ),
                      ),
                      
                      // Selected values summary
                      if (selectedValues.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline, size: 14, color: Colors.blue.shade600),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  '${selectedValues.length} value(s) selected for ${includeMode ? 'inclusion' : 'exclusion'}',
                                  style: TextStyle(color: Colors.blue.shade700, fontSize: 10),
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
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _headerFilterValues.remove(column.id);
                        _headerFilterOperations.remove(column.id);
                      });
                      Navigator.of(context).pop();
                      _updateFilteredRows();
                    },
                    child: const Text('Clear'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (selectedValues.isNotEmpty) {
                          // For multiple values, use a special format
                          final filterValue = selectedValues.join('|');
                          _headerFilterValues[column.id] = filterValue;
                          _headerFilterOperations[column.id] = currentFilterType;
                          // Store include/exclude mode
                          _headerFilterValues['${column.id}_mode'] = includeMode ? 'include' : 'exclude';
                        } else {
                          _headerFilterValues.remove(column.id);
                          _headerFilterOperations.remove(column.id);
                          _headerFilterValues.remove('${column.id}_mode');
                        }
                      });
                      Navigator.of(context).pop();
                      _updateFilteredRows();
                    },
                    child: const Text('Apply'),
                  ),
                ],
              );
            },
          );
        },
      );
    } catch (e) {
      print('Error opening header filter dialog: $e');
      // Handle the error appropriately
    }
  }

  // Get unique values for a column
  List<String> _getUniqueColumnValues(GridColumn column) {
    final values = widget.rows
        .map((row) => row.getValue(column.id)?.toString() ?? '')
        .where((value) => value.isNotEmpty)
        .toSet()
        .toList();
    
    // Sort by frequency (most common first)
    values.sort((a, b) {
      final aCount = _getValueCount(column, a);
      final bCount = _getValueCount(column, b);
      return bCount.compareTo(aCount);
    });
    
    return values;
  }

  // Get count of a specific value in a column
  int _getValueCount(GridColumn column, String value) {
    return widget.rows
        .where((row) => row.getValue(column.id)?.toString() == value)
        .length;
  }

  // Group column values based on column type
  List<ValueGroup> _groupColumnValues(GridColumn column, List<String> values) {
    final columnType = column.columnType != ColumnType.unknown 
        ? column.columnType 
        : _detectColumnType(column);
    
    switch (columnType) {
      case ColumnType.number:
      case ColumnType.currency:
      case ColumnType.percentage:
        return _groupNumericValues(values);
      case ColumnType.date:
        return _groupDateValues(values);
      default:
        return [ValueGroup('All Values', values)];
    }
  }

  // Group numeric values into ranges
  List<ValueGroup> _groupNumericValues(List<String> values) {
    final numericValues = values
        .map((v) => double.tryParse(v))
        .where((v) => v != null)
        .map((v) => v!)
        .toList();
    
    if (numericValues.isEmpty) {
      return [ValueGroup('All Values', values)];
    }
    
    numericValues.sort();
    final min = numericValues.first;
    final max = numericValues.last;
    final range = max - min;
    
    if (range <= 0) {
      return [ValueGroup('All Values', values)];
    }
    
    // Create 5-10 groups based on the range
    final groupCount = (range / 10).ceil().clamp(5, 10);
    final groupSize = range / groupCount;
    
    final groups = <ValueGroup>[];
    for (int i = 0; i < groupCount; i++) {
      final start = min + (i * groupSize);
      final end = min + ((i + 1) * groupSize);
      final groupValues = values.where((v) {
        final num = double.tryParse(v);
        return num != null && num >= start && num <= end;
      }).toList();
      
      if (groupValues.isNotEmpty) {
        groups.add(ValueGroup(
          '${start.toStringAsFixed(1)} - ${end.toStringAsFixed(1)}',
          groupValues,
        ));
      }
    }
    
    return groups;
  }

  // Group date values by periods
  List<ValueGroup> _groupDateValues(List<String> values) {
    // Simple grouping by year for now
    final yearGroups = <String, List<String>>{};
    
    for (final value in values) {
      // Try to extract year from date string
      final year = _extractYearFromDate(value);
      if (year != null) {
        yearGroups.putIfAbsent(year, () => []).add(value);
      }
    }
    
    if (yearGroups.isEmpty) {
      return [ValueGroup('All Values', values)];
    }
    
    return yearGroups.entries
        .map((entry) => ValueGroup('Year ${entry.key}', entry.value))
        .toList()
      ..sort((a, b) => a.title.compareTo(b.title));
  }

  // Extract year from date string
  String? _extractYearFromDate(String dateStr) {
    // Simple regex to extract year
    final yearMatch = RegExp(r'\b(19|20)\d{2}\b').firstMatch(dateStr);
    return yearMatch?.group(0);
  }

  List<String> _getQuickFilterValues(GridColumn column) {
    // Get unique values from the column for quick filtering
    final values = widget.rows
        .map((row) => row.getValue(column.id)?.toString() ?? '')
        .where((value) => value.isNotEmpty)
        .toSet()
        .toList();
    
    // Return top 10 most common values
    values.sort((a, b) {
      final aCount = widget.rows.where((row) => row.getValue(column.id)?.toString() == a).length;
      final bCount = widget.rows.where((row) => row.getValue(column.id)?.toString() == b).length;
      return bCount.compareTo(aCount);
    });
    
    return values.take(10).toList();
  }

  void _showGroupingDialog() {
    final groupableColumns = widget.columns.where((col) => col.groupable != false).toList();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.group_work, color: Colors.blue.shade600),
              const SizedBox(width: 8),
              const Text('Group Data'),
            ],
          ),
          content: Container(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Select columns to group by:',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 16),
                ...groupableColumns.map((column) {
                  final isGrouped = _groupedColumns.contains(column.id);
                  return CheckboxListTile(
                    title: Text(column.title),
                    subtitle: Text(column.id),
                    value: isGrouped,
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          _groupedColumns.add(column.id);
                        } else {
                          _groupedColumns.remove(column.id);
                        }
                      });
                    },
                    secondary: Icon(
                      isGrouped ? Icons.group_work : Icons.group_work_outlined,
                      color: isGrouped ? Colors.blue.shade600 : Colors.grey.shade600,
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _updateFilteredRows();
                widget.actions.onGroupingChanged?.call(_groupedColumns);
              },
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.download, color: Colors.blue.shade600),
              const SizedBox(width: 8),
              const Text('Export Data'),
            ],
          ),
          content: Container(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Choose export format:',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: Icon(Icons.table_chart, color: Colors.green.shade600),
                  title: const Text('Excel (.xlsx)'),
                  subtitle: const Text('Export to Excel format'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _exportData('excel');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.picture_as_pdf, color: Colors.red.shade600),
                  title: const Text('PDF (.pdf)'),
                  subtitle: const Text('Export to PDF format'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _exportData('pdf');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.description, color: Colors.blue.shade600),
                  title: const Text('CSV (.csv)'),
                  subtitle: const Text('Export to CSV format'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _exportData('csv');
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _exportData(String format) {
    final dataToExport = _filteredRows.isNotEmpty ? _filteredRows : widget.rows;
    widget.actions.onExport?.call(dataToExport, format);
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Data exported successfully to $format format'),
        backgroundColor: Colors.green.shade600,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildSummaryFooter() {
    final totalRows = _filteredRows.length;
    final selectedRows = _selectedRowIds.length;
    final groupedRows = _groupedColumns.isNotEmpty ? _displayedRows.length : 0;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          // Total rows
          Row(
            children: [
              Icon(Icons.table_chart, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 8),
              Text(
                'Total: $totalRows rows',
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(width: 24),
          // Selected rows
          if (selectedRows > 0) ...[
            Row(
              children: [
                Icon(Icons.check_circle, size: 16, color: Colors.blue.shade600),
                const SizedBox(width: 8),
                Text(
                  'Selected: $selectedRows',
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 24),
          ],
          // Grouped rows
          if (groupedRows > 0) ...[
            Row(
              children: [
                Icon(Icons.group_work, size: 16, color: Colors.green.shade600),
                const SizedBox(width: 8),
                Text(
                  'Grouped: $groupedRows',
                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 24),
          ],
          const Spacer(),
          // Filter status
          if (_hasActiveFilters()) ...[
            Row(
              children: [
                Icon(Icons.filter_list, size: 16, color: Colors.orange.shade600),
                const SizedBox(width: 8),
                Text(
                  'Filtered',
                  style: TextStyle(
                    color: Colors.orange.shade700,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  bool _hasActiveFilters() {
    return _filters.isNotEmpty || _autoFilterValues.isNotEmpty || _headerFilterValues.isNotEmpty;
  }

  Widget _buildFilterSummary() {
    final activeFilters = <String, int>{};
    if (_filters.isNotEmpty) {
      activeFilters['Basic Filters'] = _filters.length;
    }
    if (_autoFilterValues.isNotEmpty) {
      activeFilters['Auto Filters'] = _autoFilterValues.length;
    }
    if (_headerFilterValues.isNotEmpty) {
      activeFilters['Header Filters'] = _headerFilterValues.length;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        border: Border(
          top: BorderSide(color: Colors.blue.shade200),
          bottom: BorderSide(color: Colors.blue.shade200),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.filter_list, color: Colors.blue.shade600, size: 20),
          const SizedBox(width: 8),
          Text(
            'Active Filters (${activeFilters.length})',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
            ),
          ),
          const Spacer(),
          if (activeFilters.isNotEmpty) ...[
            TextButton(
              onPressed: () {
                setState(() {
                  _filters.clear();
                  _autoFilterValues.clear();
                  _autoFilterOperations.clear();
                  _headerFilterValues.clear();
                  _headerFilterOperations.clear();
                  _currentPage = 1;
                });
                _updateFilteredRows();
              },
              child: Text(
                'Clear All (${activeFilters.values.reduce((a, b) => a + b)})',
                style: TextStyle(
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Add a toggle in the filter row header (e.g., in the toolbar or above the filter row)
  Widget _buildFilterApplyModeToggle() {
    return Row(
      children: [
        const Icon(Icons.filter_alt, size: 16),
        const SizedBox(width: 4),
        const Text('Apply Filter:'),
        const SizedBox(width: 4),
        DropdownButton<bool>(
          value: _autoApplyFilter,
          items: const [
            DropdownMenuItem(value: true, child: Text('Auto', style: TextStyle(fontSize: 12))),
            DropdownMenuItem(value: false, child: Text('On Click', style: TextStyle(fontSize: 12))),
          ],
          onChanged: (value) {
            if (value != null) setState(() => _autoApplyFilter = value);
          },
          underline: const SizedBox(),
          isDense: true,
        ),
      ],
    );
  }

  // Clear filtering API methods
  void clearSearch() {
    setState(() {
      _searchTerm = null;
      _currentPage = 1;
    });
    _updateFilteredRows();
    widget.actions.onSearch?.call('');
  }

  void clearFilterRow() {
    setState(() {
      _autoFilterValues.clear();
      _autoFilterOperations.clear();
      _pendingFilterValues.clear();
      _pendingFilterOperations.clear();
      _currentPage = 1;
    });
    _updateFilteredRows();
  }

  void clearHeaderFilter() {
    setState(() {
      _headerFilterValues.clear();
      _headerFilterOperations.clear();
      _currentPage = 1;
    });
    _updateFilteredRows();
  }

  void clearAllFilters() {
    setState(() {
      _searchTerm = null;
      _filters.clear();
      _autoFilterValues.clear();
      _autoFilterOperations.clear();
      _pendingFilterValues.clear();
      _pendingFilterOperations.clear();
      _headerFilterValues.clear();
      _headerFilterOperations.clear();
      _currentPage = 1;
    });
    _updateFilteredRows();
    widget.actions.onSearch?.call('');
  }

  // Clear specific filter by name (DevExtreme style)
  void clearFilter(String filterName) {
    switch (filterName.toLowerCase()) {
      case 'search':
        clearSearch();
        break;
      case 'filterrow':
      case 'filter_row':
        clearFilterRow();
        break;
      case 'headerfilter':
      case 'header_filter':
        clearHeaderFilter();
        break;
      case 'all':
        clearAllFilters();
        break;
      default:
        // Clear specific column filter
        setState(() {
          _filters.remove(filterName);
          _autoFilterValues.remove(filterName);
          _autoFilterOperations.remove(filterName);
          _headerFilterValues.remove(filterName);
          _headerFilterOperations.remove(filterName);
          _currentPage = 1;
        });
        _updateFilteredRows();
    }
  }

  // Get combined filter expression (DevExtreme style)
  String getCombinedFilter([bool withDataFields = false]) {
    final expressions = <String>[];
    
    // Add search expression
    if (_searchTerm != null && _searchTerm!.isNotEmpty) {
      expressions.add('Search: "$_searchTerm"');
    }
    
    // Add filter row expressions
    for (final entry in _autoFilterValues.entries) {
      if (entry.value.isNotEmpty) {
        final column = widget.columns.firstWhere((col) => col.id == entry.key);
        final operation = _autoFilterOperations[entry.key] ?? 'contains';
        expressions.add('${column.title} $operation "${entry.value}"');
      }
    }
    
    // Add header filter expressions
    for (final entry in _headerFilterValues.entries) {
      if (entry.key.endsWith('_mode')) continue;
      if (entry.value.isNotEmpty) {
        final column = widget.columns.firstWhere((col) => col.id == entry.key);
        final operation = _headerFilterOperations[entry.key] ?? 'contains';
        final mode = _headerFilterValues['${entry.key}_mode'] ?? 'include';
        expressions.add('${column.title} $operation "${entry.value}" ($mode)');
      }
    }
    
    return expressions.join(' AND ');
  }

  // Build clear filters UI
  Widget _buildClearFiltersUI() {
    final hasActiveFilters = _hasActiveFilters();
    
    if (!hasActiveFilters) return const SizedBox.shrink();
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        border: Border.all(color: Colors.orange.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber, color: Colors.orange.shade600),
              const SizedBox(width: 8),
              Text(
                'Active Filters',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade800,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: clearAllFilters,
                child: Text(
                  'Clear All',
                  style: TextStyle(color: Colors.orange.shade700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Filter summary
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              if (_searchTerm != null && _searchTerm!.isNotEmpty) ...[
                _buildFilterChip('Search', _searchTerm!, clearSearch),
              ],
              ..._autoFilterValues.entries.where((e) => e.value.isNotEmpty).map((entry) {
                final column = widget.columns.firstWhere((col) => col.id == entry.key);
                return _buildFilterChip(
                  'Filter Row: ${column.title}',
                  entry.value,
                  () => clearFilter(entry.key),
                );
              }),
              ..._headerFilterValues.entries.where((e) => !e.key.endsWith('_mode') && e.value.isNotEmpty).map((entry) {
                final column = widget.columns.firstWhere((col) => col.id == entry.key);
                return _buildFilterChip(
                  'Header: ${column.title}',
                  entry.value,
                  () => clearFilter(entry.key),
                );
              }),
            ],
          ),
          
          // Combined filter expression
          if (getCombinedFilter().isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.orange.shade300),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  Icon(Icons.filter_list, size: 16, color: Colors.orange.shade600),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      getCombinedFilter(),
                      style: TextStyle(
                        color: Colors.orange.shade700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, VoidCallback onClear) {
    return Chip(
      label: Text('$label: $value'),
      deleteIcon: Icon(Icons.close, size: 16),
      onDeleted: onClear,
      backgroundColor: Colors.orange.shade100,
      deleteIconColor: Colors.orange.shade700,
      labelStyle: TextStyle(
        color: Colors.orange.shade800,
        fontSize: 12,
      ),
    );
  }
} 