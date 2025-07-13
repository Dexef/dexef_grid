import 'package:flutter/material.dart';

/// Model representing a row in the grid
class GridRow {
  /// Unique identifier for the row
  final String id;
  
  /// Data for the row (Map of columnId -> value)
  final Map<String, dynamic> data;
  
  /// Whether the row is selected
  final bool isSelected;
  
  /// Whether the row is selectable
  final bool selectable;
  
  /// Custom row widget builder
  final Widget Function(BuildContext context, Map<String, dynamic> data, int index)? rowBuilder;
  
  /// Actions available for this row
  final List<GridAction>? actions;
  
  /// Whether to show actions on hover
  final bool showActionsOnHover;
  
  /// Custom action widget builder
  final Widget Function(BuildContext context, List<GridAction> actions, int rowIndex)? actionBuilder;

  const GridRow({
    required this.id,
    required this.data,
    this.isSelected = false,
    this.selectable = true,
    this.rowBuilder,
    this.actions,
    this.showActionsOnHover = true,
    this.actionBuilder,
  });

  /// Creates a copy of this row with updated properties
  GridRow copyWith({
    String? id,
    Map<String, dynamic>? data,
    bool? isSelected,
    bool? selectable,
    Widget Function(BuildContext context, Map<String, dynamic> data, int index)? rowBuilder,
    List<GridAction>? actions,
    bool? showActionsOnHover,
    Widget Function(BuildContext context, List<GridAction> actions, int rowIndex)? actionBuilder,
  }) {
    return GridRow(
      id: id ?? this.id,
      data: data ?? this.data,
      isSelected: isSelected ?? this.isSelected,
      selectable: selectable ?? this.selectable,
      rowBuilder: rowBuilder ?? this.rowBuilder,
      actions: actions ?? this.actions,
      showActionsOnHover: showActionsOnHover ?? this.showActionsOnHover,
      actionBuilder: actionBuilder ?? this.actionBuilder,
    );
  }

  /// Gets a value from the data map
  dynamic getValue(String columnId) {
    return data[columnId];
  }

  /// Sets a value in the data map
  void setValue(String columnId, dynamic value) {
    data[columnId] = value;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GridRow && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'GridRow(id: $id, data: $data, isSelected: $isSelected)';
  }
}

/// Model representing an action that can be performed on a row
class GridAction {
  /// Unique identifier for the action
  final String id;
  
  /// Display title for the action
  final String title;
  
  /// Icon for the action
  final IconData? icon;
  
  /// Whether the action is enabled
  final bool enabled;
  
  /// Whether the action is visible
  final bool visible;
  
  /// Callback function when action is triggered
  final void Function(String rowId, Map<String, dynamic> rowData)? onTap;
  
  /// Custom action widget builder
  final Widget Function(BuildContext context, String rowId, Map<String, dynamic> rowData)? actionBuilder;

  const GridAction({
    required this.id,
    required this.title,
    this.icon,
    this.enabled = true,
    this.visible = true,
    this.onTap,
    this.actionBuilder,
  });

  /// Creates a copy of this action with updated properties
  GridAction copyWith({
    String? id,
    String? title,
    IconData? icon,
    bool? enabled,
    bool? visible,
    void Function(String rowId, Map<String, dynamic> rowData)? onTap,
    Widget Function(BuildContext context, String rowId, Map<String, dynamic> rowData)? actionBuilder,
  }) {
    return GridAction(
      id: id ?? this.id,
      title: title ?? this.title,
      icon: icon ?? this.icon,
      enabled: enabled ?? this.enabled,
      visible: visible ?? this.visible,
      onTap: onTap ?? this.onTap,
      actionBuilder: actionBuilder ?? this.actionBuilder,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GridAction && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'GridAction(id: $id, title: $title, enabled: $enabled)';
  }
} 