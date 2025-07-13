import 'package:flutter/material.dart';
import '../models/grid_column.dart';
import '../models/grid_row.dart';
import '../models/grid_config.dart';
import '../models/grid_actions.dart';
import 'grid_search_widget.dart';
import 'grid_filter_widget.dart';
import 'grid_pagination_widget.dart';
import 'grid_actions_widget.dart';

/// A comprehensive custom grid widget with search, filter, pagination, and other features
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

  @override
  void initState() {
    super.initState();
    _initializeState();
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
    _filteredRows = List.from(widget.rows);
    
    // Apply search
    if (_searchTerm != null && _searchTerm!.isNotEmpty) {
      _filteredRows = _filteredRows.where((row) {
        return widget.columns.any((column) {
          if (!column.searchable) return false;
          final value = row.getValue(column.id);
          if (value == null) return false;
          return value.toString().toLowerCase().contains(_searchTerm!.toLowerCase());
        });
      }).toList();
    }
    
    // Apply filters
    for (final entry in _filters.entries) {
      if (entry.value.isNotEmpty) {
        _filteredRows = _filteredRows.where((row) {
          final column = widget.columns.firstWhere((col) => col.id == entry.key);
          if (!column.filterable) return true;
          final value = row.getValue(column.id);
          if (value == null) return false;
          if (column.filterFunction != null) {
            return column.filterFunction!(value, entry.value);
          }
          return value.toString().toLowerCase().contains(entry.value.toLowerCase());
        }).toList();
      }
    }
    
    // Apply sorting
    if (_sortColumn != null) {
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
    }
    
    // Apply pagination
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    _displayedRows = _filteredRows.sublist(
      startIndex.clamp(0, _filteredRows.length),
      endIndex.clamp(0, _filteredRows.length),
    );
  }

  void _onSearch(String searchTerm) {
    setState(() {
      _searchTerm = searchTerm;
      _currentPage = 1;
    });
    _updateFilteredRows();
    widget.actions.onSearch?.call(searchTerm);
  }

  void _onFilter(String columnId, String filterValue) {
    setState(() {
      if (filterValue.isEmpty) {
        _filters.remove(columnId);
      } else {
        _filters[columnId] = filterValue;
      }
      _currentPage = 1;
    });
    _updateFilteredRows();
    widget.actions.onFilter?.call(columnId, filterValue);
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

    return Container(
      width: widget.config.gridWidth,
      height: widget.config.gridHeight,
      margin: widget.config.margin,
      decoration: BoxDecoration(
        color: widget.config.backgroundColor,
        borderRadius: widget.config.borderRadius,
        border: widget.config.border,
        boxShadow: widget.config.shadow,
      ),
      child: Column(
        children: [
          // Toolbar
          if (widget.showToolbar && widget.config.showSearch) ...[
            widget.customToolbar ??
                GridSearchWidget(
                  searchTerm: _searchTerm ?? '',
                  placeholder: widget.config.searchPlaceholder,
                  onSearch: _onSearch,
                  columns: widget.columns.where((col) => col.searchable).toList(),
                  onFilter: _onFilter,
                  filters: _filters,
                  showFilter: widget.config.showFilter,
                ),
            const SizedBox(height: 8),
          ],

          // Header
          if (widget.showHeader && widget.config.showHeader) ...[
            widget.customHeader ?? _buildHeader(),
            const SizedBox(height: 8),
          ],

          // Grid content
          Expanded(
            child: _buildGridContent(),
          ),

          // Footer
          if (widget.showFooter && widget.config.showPagination) ...[
            const SizedBox(height: 8),
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
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: widget.config.headerHeight,
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
              width: 50,
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
            const SizedBox(width: 8),
          ],
          ...widget.columns.where((col) => col.visible).map((column) {
            return Expanded(
              flex: column.width?.toInt() ?? 1,
              child: _buildHeaderCell(column),
            );
          }),
          if (widget.config.showActions) ...[
            const SizedBox(width: 50),
          ],
        ],
      ),
    );
  }

  Widget _buildHeaderCell(GridColumn column) {
    final isSorted = _sortColumn == column.id;
    final isAscending = _sortAscending == true;

    return InkWell(
      onTap: column.sortable ? () => _onSort(column.id, !isAscending) : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: column.headerBuilder?.call(context, column.title) ??
                  Text(
                    column.title,
                    style: TextStyle(
                      color: widget.config.headerTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            ),
            if (column.sortable) ...[
              const SizedBox(width: 4),
              Icon(
                isSorted
                    ? (isAscending ? Icons.arrow_upward : Icons.arrow_downward)
                    : Icons.arrow_upward,
                size: 16,
                color: isSorted ? Colors.blue : Colors.grey,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildGridContent() {
    return ListView.separated(
      itemCount: _displayedRows.length,
      separatorBuilder: (context, index) => Container(
        height: widget.config.rowSpacing,
        color: widget.config.rowBorderColor ?? Colors.grey.shade200,
      ),
      itemBuilder: (context, index) {
        final row = _displayedRows[index];
        return _buildRow(row, index);
      },
    );
  }

  Widget _buildRow(GridRow row, int index) {
    final isSelected = _selectedRowIds.contains(row.id);
    final isHovered = false; // TODO: Implement hover state

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _onRowTap(row.id, index),
        onDoubleTap: () => _onRowDoubleTap(row.id, index),
        child: Container(
          height: widget.config.rowHeight,
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
                  width: 50,
                  child: Checkbox(
                    value: isSelected,
                    onChanged: row.selectable
                        ? (value) => _onRowSelected(row.id, value ?? false)
                        : null,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              ...widget.columns.where((col) => col.visible).map((column) {
                return Expanded(
                  flex: column.width?.toInt() ?? 1,
                  child: _buildCell(row, column, index),
                );
              }),
              if (widget.config.showActions && row.actions != null) ...[
                const SizedBox(width: 50),
                GridActionsWidget(
                  actions: row.actions!,
                  rowId: row.id,
                  onActionTriggered: _onActionTriggered,
                  showOnHover: row.showActionsOnHover,
                  actionBuilder: row.actionBuilder,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCell(GridRow row, GridColumn column, int index) {
    final value = row.getValue(column.id);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      alignment: column.alignment,
      child: column.cellBuilder?.call(context, value, index) ??
          Text(
            value?.toString() ?? '',
            style: TextStyle(
              color: _selectedRowIds.contains(row.id)
                  ? widget.config.selectedRowTextColor
                  : widget.config.rowTextColor,
            ),
            overflow: TextOverflow.ellipsis,
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
} 