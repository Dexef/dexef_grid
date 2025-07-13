import 'package:flutter/material.dart';

/// A pagination widget for the grid
class GridPaginationWidget extends StatefulWidget {
  /// Current page
  final int currentPage;
  
  /// Total number of pages
  final int totalPages;
  
  /// Total number of items
  final int totalItems;
  
  /// Items per page
  final int itemsPerPage;
  
  /// Available items per page options
  final List<int> itemsPerPageOptions;
  
  /// Callback when page changes
  final void Function(int page) onPageChanged;
  
  /// Callback when items per page changes
  final void Function(int itemsPerPage) onItemsPerPageChanged;
  
  /// Whether to show the pagination widget
  final bool visible;
  
  /// Whether to show page info
  final bool showPageInfo;
  
  /// Whether to show items per page selector
  final bool showItemsPerPageSelector;
  
  /// Whether to show first/last page buttons
  final bool showFirstLastButtons;
  
  /// Whether to show page numbers
  final bool showPageNumbers;
  
  /// Maximum number of page numbers to show
  final int maxPageNumbers;
  
  /// Custom pagination widget
  final Widget? customPaginationWidget;

  const GridPaginationWidget({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
    required this.itemsPerPageOptions,
    required this.onPageChanged,
    required this.onItemsPerPageChanged,
    this.visible = true,
    this.showPageInfo = true,
    this.showItemsPerPageSelector = true,
    this.showFirstLastButtons = true,
    this.showPageNumbers = true,
    this.maxPageNumbers = 5,
    this.customPaginationWidget,
  });

  @override
  State<GridPaginationWidget> createState() => _GridPaginationWidgetState();
}

class _GridPaginationWidgetState extends State<GridPaginationWidget> {
  @override
  Widget build(BuildContext context) {
    if (!widget.visible) return const SizedBox.shrink();

    return widget.customPaginationWidget ??
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            border: Border(
              top: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          child: Row(
            children: [
              // Page info
              if (widget.showPageInfo) ...[
                Expanded(
                  child: _buildPageInfo(),
                ),
              ],

              // Items per page selector
              if (widget.showItemsPerPageSelector) ...[
                _buildItemsPerPageSelector(),
                const SizedBox(width: 16),
              ],

              // Pagination controls
              _buildPaginationControls(),
            ],
          ),
        );
  }

  Widget _buildPageInfo() {
    final startItem = (widget.currentPage - 1) * widget.itemsPerPage + 1;
    final endItem = (widget.currentPage * widget.itemsPerPage).clamp(0, widget.totalItems);
    
    return Text(
      'Showing ${startItem}-${endItem} of ${widget.totalItems} items',
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }

  Widget _buildItemsPerPageSelector() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Items per page:',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(width: 8),
        DropdownButton<int>(
          value: widget.itemsPerPage,
          items: widget.itemsPerPageOptions.map((value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Text(value.toString()),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              widget.onItemsPerPageChanged(value);
            }
          },
          underline: Container(),
        ),
      ],
    );
  }

  Widget _buildPaginationControls() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // First page button
        if (widget.showFirstLastButtons) ...[
          IconButton(
            onPressed: widget.currentPage > 1 ? () => widget.onPageChanged(1) : null,
            icon: const Icon(Icons.first_page),
            tooltip: 'First page',
          ),
        ],

        // Previous page button
        IconButton(
          onPressed: widget.currentPage > 1 ? () => widget.onPageChanged(widget.currentPage - 1) : null,
          icon: const Icon(Icons.chevron_left),
          tooltip: 'Previous page',
        ),

        // Page numbers
        if (widget.showPageNumbers) ...[
          ..._buildPageNumbers(),
        ],

        // Next page button
        IconButton(
          onPressed: widget.currentPage < widget.totalPages ? () => widget.onPageChanged(widget.currentPage + 1) : null,
          icon: const Icon(Icons.chevron_right),
          tooltip: 'Next page',
        ),

        // Last page button
        if (widget.showFirstLastButtons) ...[
          IconButton(
            onPressed: widget.currentPage < widget.totalPages ? () => widget.onPageChanged(widget.totalPages) : null,
            icon: const Icon(Icons.last_page),
            tooltip: 'Last page',
          ),
        ],
      ],
    );
  }

  List<Widget> _buildPageNumbers() {
    final widgets = <Widget>[];
    final maxNumbers = widget.maxPageNumbers;
    final totalPages = widget.totalPages;
    final currentPage = widget.currentPage;

    if (totalPages <= maxNumbers) {
      // Show all page numbers
      for (int i = 1; i <= totalPages; i++) {
        widgets.add(_buildPageNumber(i));
      }
    } else {
      // Show limited page numbers with ellipsis
      final halfMax = maxNumbers ~/ 2;
      int startPage = currentPage - halfMax;
      int endPage = currentPage + halfMax;

      if (startPage < 1) {
        startPage = 1;
        endPage = maxNumbers;
      } else if (endPage > totalPages) {
        endPage = totalPages;
        startPage = totalPages - maxNumbers + 1;
      }

      // First page
      if (startPage > 1) {
        widgets.add(_buildPageNumber(1));
        if (startPage > 2) {
          widgets.add(_buildEllipsis());
        }
      }

      // Middle pages
      for (int i = startPage; i <= endPage; i++) {
        widgets.add(_buildPageNumber(i));
      }

      // Last page
      if (endPage < totalPages) {
        if (endPage < totalPages - 1) {
          widgets.add(_buildEllipsis());
        }
        widgets.add(_buildPageNumber(totalPages));
      }
    }

    return widgets;
  }

  Widget _buildPageNumber(int page) {
    final isCurrentPage = page == widget.currentPage;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      child: Material(
        color: isCurrentPage ? Colors.blue : Colors.transparent,
        borderRadius: BorderRadius.circular(4),
        child: InkWell(
          onTap: () => widget.onPageChanged(page),
          borderRadius: BorderRadius.circular(4),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              page.toString(),
              style: TextStyle(
                color: isCurrentPage ? Colors.white : Colors.black87,
                fontWeight: isCurrentPage ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEllipsis() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: const Text(
        '...',
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
} 