import 'package:flutter/material.dart';
import '../models/grid_row.dart';

/// A widget for displaying row actions in the grid
class GridActionsWidget extends StatefulWidget {
  /// List of actions available for the row
  final List<GridAction> actions;
  
  /// ID of the row
  final String rowId;
  
  /// Callback when an action is triggered
  final void Function(String actionId, String rowId) onActionTriggered;
  
  /// Whether to show actions on hover
  final bool showOnHover;
  
  /// Custom action widget builder
  final Widget Function(BuildContext context, List<GridAction> actions, int rowIndex)? actionBuilder;
  
  /// Whether to show action tooltips
  final bool showTooltips;
  
  /// Whether to show action icons
  final bool showIcons;
  
  /// Whether to show action text
  final bool showText;
  
  /// Whether to show action menu
  final bool showMenu;
  
  /// Whether to show action buttons
  final bool showButtons;
  
  /// Custom action menu widget
  final Widget? customActionMenu;

  const GridActionsWidget({
    super.key,
    required this.actions,
    required this.rowId,
    required this.onActionTriggered,
    this.showOnHover = true,
    this.actionBuilder,
    this.showTooltips = true,
    this.showIcons = true,
    this.showText = false,
    this.showMenu = true,
    this.showButtons = false,
    this.customActionMenu,
  });

  @override
  State<GridActionsWidget> createState() => _GridActionsWidgetState();
}

class _GridActionsWidgetState extends State<GridActionsWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final visibleActions = widget.actions.where((action) => action.visible).toList();
    
    if (visibleActions.isEmpty) {
      return const SizedBox.shrink();
    }

    if (widget.actionBuilder != null) {
      return widget.actionBuilder!(context, visibleActions, 0);
    }

    return MouseRegion(
      onEnter: (_) {
        if (widget.showOnHover) {
          setState(() {
            _isHovered = true;
          });
        }
      },
      onExit: (_) {
        if (widget.showOnHover) {
          setState(() {
            _isHovered = false;
          });
        }
      },
      child: AnimatedOpacity(
        opacity: widget.showOnHover ? (_isHovered ? 1.0 : 0.0) : 1.0,
        duration: const Duration(milliseconds: 200),
        child: widget.showButtons
            ? _buildActionButtons(visibleActions)
            : widget.showMenu
                ? _buildActionMenu(visibleActions)
                : _buildActionIcons(visibleActions),
      ),
    );
  }

  Widget _buildActionButtons(List<GridAction> actions) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: actions.map((action) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Tooltip(
            message: widget.showTooltips ? action.title : '',
            child: ElevatedButton.icon(
              onPressed: action.enabled ? () => _onActionTriggered(action.id) : null,
              icon: widget.showIcons && action.icon != null
                  ? Icon(action.icon, size: 16)
                  : const SizedBox.shrink(),
              label: widget.showText
                  ? Text(action.title)
                  : const SizedBox.shrink(),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: const Size(32, 32),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionMenu(List<GridAction> actions) {
    return widget.customActionMenu ??
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          tooltip: 'Actions',
          itemBuilder: (context) {
            return actions.map((action) {
              return PopupMenuItem<String>(
                value: action.id,
                enabled: action.enabled,
                child: Row(
                  children: [
                    if (widget.showIcons && action.icon != null) ...[
                      Icon(action.icon, size: 16),
                      const SizedBox(width: 8),
                    ],
                    Expanded(
                      child: Text(action.title),
                    ),
                  ],
                ),
              );
            }).toList();
          },
          onSelected: _onActionTriggered,
        );
  }

  Widget _buildActionIcons(List<GridAction> actions) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: actions.map((action) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: IconButton(
            onPressed: action.enabled ? () => _onActionTriggered(action.id) : null,
            icon: action.icon != null
                ? Icon(action.icon, size: 16)
                : const Icon(Icons.more_horiz, size: 16),
            tooltip: widget.showTooltips ? action.title : null,
            color: action.enabled ? Colors.blue : Colors.grey,
            splashRadius: 16,
          ),
        );
      }).toList(),
    );
  }

  void _onActionTriggered(String actionId) {
    widget.onActionTriggered(actionId, widget.rowId);
  }
} 