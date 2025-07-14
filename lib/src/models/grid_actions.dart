import 'package:flutter/material.dart';
import 'grid_row.dart';

/// Callbacks for grid events
class GridActions {
  /// Called when a row is selected
  final void Function(String rowId, Map<String, dynamic> rowData)? onRowSelected;
  
  /// Called when a row is deselected
  final void Function(String rowId, Map<String, dynamic> rowData)? onRowDeselected;
  
  /// Called when multiple rows are selected
  final void Function(List<String> rowIds, List<Map<String, dynamic>> rowData)? onMultiRowSelected;
  
  /// Called when a row is tapped
  final void Function(String rowId, Map<String, dynamic> rowData, int rowIndex)? onRowTap;
  
  /// Called when a row is double tapped
  final void Function(String rowId, Map<String, dynamic> rowData, int rowIndex)? onRowDoubleTap;
  
  /// Called when a column header is tapped (for sorting)
  final void Function(String columnId, String columnTitle, bool ascending)? onColumnSort;
  
  /// Called when search is performed
  final void Function(String searchTerm)? onSearch;
  
  /// Called when filter is applied
  final void Function(String columnId, String filterValue)? onFilter;
  
  /// Called when pagination changes
  final void Function(int page, int itemsPerPage)? onPageChanged;
  
  /// Called when items per page changes
  final void Function(int itemsPerPage)? onItemsPerPageChanged;
  
  /// Called when a custom action is triggered
  final void Function(String actionId, String rowId, Map<String, dynamic> rowData)? onActionTriggered;
  
  /// Called when the grid is refreshed
  final VoidCallback? onRefresh;
  
  /// Called when the grid is loaded
  final VoidCallback? onLoad;
  
  /// Called when an error occurs
  final void Function(String error)? onError;
  
  /// Called when the grid state changes
  final void Function(GridState state)? onStateChanged;
  
  /// Called when a row is edited
  final void Function(String rowId, Map<String, dynamic> oldData, Map<String, dynamic> newData)? onRowEdit;
  
  /// Called when a row is deleted
  final void Function(String rowId, Map<String, dynamic> rowData)? onRowDelete;
  
  /// Called when a new row is added
  final void Function(Map<String, dynamic> rowData)? onRowAdd;
  
  /// Called when a column is resized
  final void Function(String columnId, double newWidth)? onColumnResize;
  
  /// Called when columns are reordered
  final void Function(List<String> newColumnOrder)? onColumnReorder;
  
  /// Called when rows are reordered
  final void Function(List<String> newRowOrder)? onRowReorder;
  
  /// Called when the grid is exported
  final void Function(List<GridRow> rows, String format)? onExport;
  
  /// Called when the grid is imported
  final void Function(List<GridRow> rows)? onImport;
  
  /// Called when the grid is printed
  final void Function(List<GridRow> rows)? onPrint;
  
  /// Called when the grid is copied
  final void Function(List<GridRow> rows)? onCopy;
  
  /// Called when the grid is pasted
  final void Function(List<GridRow> rows)? onPaste;
  
  /// Called when the grid is cut
  final void Function(List<GridRow> rows)? onCut;
  
  /// Called when the grid is cleared
  final VoidCallback? onClear;
  
  /// Called when the grid is reset
  final VoidCallback? onReset;
  
  /// Called when the grid is saved
  final void Function(List<GridRow> rows)? onSave;
  
  /// Called when the grid is loaded from storage
  final void Function(List<GridRow> rows)? onLoadFromStorage;
  
  /// Called when grouping changes
  final void Function(List<String> groupedColumns)? onGroupingChanged;

  const GridActions({
    this.onRowSelected,
    this.onRowDeselected,
    this.onMultiRowSelected,
    this.onRowTap,
    this.onRowDoubleTap,
    this.onColumnSort,
    this.onSearch,
    this.onFilter,
    this.onPageChanged,
    this.onItemsPerPageChanged,
    this.onActionTriggered,
    this.onRefresh,
    this.onLoad,
    this.onError,
    this.onStateChanged,
    this.onRowEdit,
    this.onRowDelete,
    this.onRowAdd,
    this.onColumnResize,
    this.onColumnReorder,
    this.onRowReorder,
    this.onExport,
    this.onImport,
    this.onPrint,
    this.onCopy,
    this.onPaste,
    this.onCut,
    this.onClear,
    this.onReset,
    this.onSave,
    this.onLoadFromStorage,
    this.onGroupingChanged,
  });

  /// Creates a copy of this actions with updated callbacks
  GridActions copyWith({
    void Function(String rowId, Map<String, dynamic> rowData)? onRowSelected,
    void Function(String rowId, Map<String, dynamic> rowData)? onRowDeselected,
    void Function(List<String> rowIds, List<Map<String, dynamic>> rowData)? onMultiRowSelected,
    void Function(String rowId, Map<String, dynamic> rowData, int rowIndex)? onRowTap,
    void Function(String rowId, Map<String, dynamic> rowData, int rowIndex)? onRowDoubleTap,
    void Function(String columnId, String columnTitle, bool ascending)? onColumnSort,
    void Function(String searchTerm)? onSearch,
    void Function(String columnId, String filterValue)? onFilter,
    void Function(int page, int itemsPerPage)? onPageChanged,
    void Function(int itemsPerPage)? onItemsPerPageChanged,
    void Function(String actionId, String rowId, Map<String, dynamic> rowData)? onActionTriggered,
    VoidCallback? onRefresh,
    VoidCallback? onLoad,
    void Function(String error)? onError,
    void Function(GridState state)? onStateChanged,
    void Function(String rowId, Map<String, dynamic> oldData, Map<String, dynamic> newData)? onRowEdit,
    void Function(String rowId, Map<String, dynamic> rowData)? onRowDelete,
    void Function(Map<String, dynamic> rowData)? onRowAdd,
    void Function(String columnId, double newWidth)? onColumnResize,
    void Function(List<String> newColumnOrder)? onColumnReorder,
    void Function(List<String> newRowOrder)? onRowReorder,
    void Function(List<GridRow> rows, String format)? onExport,
    void Function(List<GridRow> rows)? onImport,
    void Function(List<GridRow> rows)? onPrint,
    void Function(List<GridRow> rows)? onCopy,
    void Function(List<GridRow> rows)? onPaste,
    void Function(List<GridRow> rows)? onCut,
    VoidCallback? onClear,
    VoidCallback? onReset,
    void Function(List<GridRow> rows)? onSave,
    void Function(List<GridRow> rows)? onLoadFromStorage,
    void Function(List<String> groupedColumns)? onGroupingChanged,
  }) {
    return GridActions(
      onRowSelected: onRowSelected ?? this.onRowSelected,
      onRowDeselected: onRowDeselected ?? this.onRowDeselected,
      onMultiRowSelected: onMultiRowSelected ?? this.onMultiRowSelected,
      onRowTap: onRowTap ?? this.onRowTap,
      onRowDoubleTap: onRowDoubleTap ?? this.onRowDoubleTap,
      onColumnSort: onColumnSort ?? this.onColumnSort,
      onSearch: onSearch ?? this.onSearch,
      onFilter: onFilter ?? this.onFilter,
      onPageChanged: onPageChanged ?? this.onPageChanged,
      onItemsPerPageChanged: onItemsPerPageChanged ?? this.onItemsPerPageChanged,
      onActionTriggered: onActionTriggered ?? this.onActionTriggered,
      onRefresh: onRefresh ?? this.onRefresh,
      onLoad: onLoad ?? this.onLoad,
      onError: onError ?? this.onError,
      onStateChanged: onStateChanged ?? this.onStateChanged,
      onRowEdit: onRowEdit ?? this.onRowEdit,
      onRowDelete: onRowDelete ?? this.onRowDelete,
      onRowAdd: onRowAdd ?? this.onRowAdd,
      onColumnResize: onColumnResize ?? this.onColumnResize,
      onColumnReorder: onColumnReorder ?? this.onColumnReorder,
      onRowReorder: onRowReorder ?? this.onRowReorder,
      onExport: onExport ?? this.onExport,
      onImport: onImport ?? this.onImport,
      onPrint: onPrint ?? this.onPrint,
      onCopy: onCopy ?? this.onCopy,
      onPaste: onPaste ?? this.onPaste,
      onCut: onCut ?? this.onCut,
      onClear: onClear ?? this.onClear,
      onReset: onReset ?? this.onReset,
      onSave: onSave ?? this.onSave,
      onLoadFromStorage: onLoadFromStorage ?? this.onLoadFromStorage,
      onGroupingChanged: onGroupingChanged ?? this.onGroupingChanged,
    );
  }
}

/// Represents the current state of the grid
class GridState {
  /// Whether the grid is loading
  final bool isLoading;
  
  /// Whether the grid has an error
  final bool hasError;
  
  /// Error message if any
  final String? errorMessage;
  
  /// Whether the grid is empty
  final bool isEmpty;
  
  /// Total number of items
  final int totalItems;
  
  /// Current page
  final int currentPage;
  
  /// Items per page
  final int itemsPerPage;
  
  /// Total number of pages
  final int totalPages;
  
  /// Selected row IDs
  final List<String> selectedRowIds;
  
  /// Search term
  final String? searchTerm;
  
  /// Applied filters
  final Map<String, String> filters;
  
  /// Sort column
  final String? sortColumn;
  
  /// Sort direction (true for ascending, false for descending)
  final bool? sortAscending;
  
  /// Whether the grid is editable
  final bool isEditable;
  
  /// Whether the grid is in edit mode
  final bool isEditMode;
  
  /// Whether the grid is in selection mode
  final bool isSelectionMode;
  
  /// Whether the grid is in filter mode
  final bool isFilterMode;
  
  /// Whether the grid is in search mode
  final bool isSearchMode;

  const GridState({
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage,
    this.isEmpty = false,
    this.totalItems = 0,
    this.currentPage = 1,
    this.itemsPerPage = 10,
    this.totalPages = 0,
    this.selectedRowIds = const [],
    this.searchTerm,
    this.filters = const {},
    this.sortColumn,
    this.sortAscending,
    this.isEditable = false,
    this.isEditMode = false,
    this.isSelectionMode = false,
    this.isFilterMode = false,
    this.isSearchMode = false,
  });

  /// Creates a copy of this state with updated properties
  GridState copyWith({
    bool? isLoading,
    bool? hasError,
    String? errorMessage,
    bool? isEmpty,
    int? totalItems,
    int? currentPage,
    int? itemsPerPage,
    int? totalPages,
    List<String>? selectedRowIds,
    String? searchTerm,
    Map<String, String>? filters,
    String? sortColumn,
    bool? sortAscending,
    bool? isEditable,
    bool? isEditMode,
    bool? isSelectionMode,
    bool? isFilterMode,
    bool? isSearchMode,
  }) {
    return GridState(
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
      isEmpty: isEmpty ?? this.isEmpty,
      totalItems: totalItems ?? this.totalItems,
      currentPage: currentPage ?? this.currentPage,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
      totalPages: totalPages ?? this.totalPages,
      selectedRowIds: selectedRowIds ?? this.selectedRowIds,
      searchTerm: searchTerm ?? this.searchTerm,
      filters: filters ?? this.filters,
      sortColumn: sortColumn ?? this.sortColumn,
      sortAscending: sortAscending ?? this.sortAscending,
      isEditable: isEditable ?? this.isEditable,
      isEditMode: isEditMode ?? this.isEditMode,
      isSelectionMode: isSelectionMode ?? this.isSelectionMode,
      isFilterMode: isFilterMode ?? this.isFilterMode,
      isSearchMode: isSearchMode ?? this.isSearchMode,
    );
  }

  @override
  String toString() {
    return 'GridState(isLoading: $isLoading, hasError: $hasError, totalItems: $totalItems, currentPage: $currentPage, selectedRowIds: $selectedRowIds)';
  }
} 