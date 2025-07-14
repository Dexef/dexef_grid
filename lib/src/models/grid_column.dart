import 'package:flutter/material.dart';

/// Column type for automatic filter detection
enum ColumnType {
  string,
  number,
  date,
  boolean,
  email,
  url,
  phone,
  currency,
  percentage,
  unknown
}

/// Configuration for column filtering
class FilterConfig {
  final ColumnType columnType;
  final List<String> availableOperations;
  final String defaultValue;
  final String defaultOperation;
  final bool allowMultiple;
  final bool allowCustom;
  final Map<String, dynamic> validationRules;

  const FilterConfig({
    this.columnType = ColumnType.string,
    this.availableOperations = const ['contains', 'equals', 'startsWith', 'endsWith', 'notContains'],
    this.defaultValue = '',
    this.defaultOperation = 'contains',
    this.allowMultiple = false,
    this.allowCustom = true,
    this.validationRules = const {},
  });
}

/// A column definition for the grid
class GridColumn {
  /// Unique identifier for the column
  final String id;
  
  /// Display title for the column
  final String title;
  
  /// Whether the column is visible
  final bool visible;
  
  /// Whether the column is sortable
  final bool sortable;
  
  /// Whether the column is searchable
  final bool searchable;
  
  /// Whether the column is filterable
  final bool filterable;
  
  /// Whether the column can be grouped
  final bool groupable;
  
  /// Width of the column (null for auto-width)
  final double? width;
  
  /// Alignment of the column content
  final Alignment alignment;
  
  /// Custom cell builder
  final Widget Function(BuildContext, dynamic, int)? cellBuilder;
  
  /// Custom header builder
  final Widget Function(BuildContext, String)? headerBuilder;
  
  /// Custom sort function
  final int Function(dynamic, dynamic)? sortFunction;
  
  /// Filter configuration for the column
  final FilterConfig filterConfig;
  
  /// Column type for automatic detection
  final ColumnType columnType;

  const GridColumn({
    required this.id,
    required this.title,
    this.visible = true,
    this.sortable = true,
    this.searchable = true,
    this.filterable = true,
    this.groupable = true,
    this.width,
    this.alignment = Alignment.centerLeft,
    this.cellBuilder,
    this.headerBuilder,
    this.sortFunction,
    this.filterConfig = const FilterConfig(),
    this.columnType = ColumnType.unknown,
  });

  /// Creates a copy of this column with updated properties
  GridColumn copyWith({
    String? id,
    String? title,
    bool? visible,
    bool? sortable,
    bool? searchable,
    bool? filterable,
    bool? groupable,
    double? width,
    Alignment? alignment,
    Widget Function(BuildContext, dynamic, int)? cellBuilder,
    Widget Function(BuildContext, String)? headerBuilder,
    int Function(dynamic, dynamic)? sortFunction,
    FilterConfig? filterConfig,
    ColumnType? columnType,
  }) {
    return GridColumn(
      id: id ?? this.id,
      title: title ?? this.title,
      visible: visible ?? this.visible,
      sortable: sortable ?? this.sortable,
      searchable: searchable ?? this.searchable,
      filterable: filterable ?? this.filterable,
      groupable: groupable ?? this.groupable,
      width: width ?? this.width,
      alignment: alignment ?? this.alignment,
      cellBuilder: cellBuilder ?? this.cellBuilder,
      headerBuilder: headerBuilder ?? this.headerBuilder,
      sortFunction: sortFunction ?? this.sortFunction,
      filterConfig: filterConfig ?? this.filterConfig,
      columnType: columnType ?? this.columnType,
    );
  }
} 