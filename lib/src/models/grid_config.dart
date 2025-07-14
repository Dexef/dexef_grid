import 'package:flutter/material.dart';

/// Configuration for the custom grid widget
class GridConfig {
  /// Whether to show the footer
  final bool showFooter;
  
  /// Whether to show the toolbar
  final bool showToolbar;
  
  /// Whether to show the header
  final bool showHeader;
  
  /// Whether to show row selection checkboxes
  final bool showSelection;
  
  /// Whether to show search functionality
  final bool showSearch;
  
  /// Whether to show filter functionality
  final bool showFilter;
  
  /// Whether to show auto filter row
  final bool showAutoFilter;
  
  /// Whether to show pagination
  final bool showPagination;
  
  /// Whether to show actions
  final bool showActions;
  
  /// Whether to show row hover effects
  final bool showHoverEffects;
  
  /// Whether to allow multiple row selection
  final bool allowMultiSelection;
  
  /// Whether to allow sorting
  final bool allowSorting;
  
  /// Whether to allow filtering
  final bool allowFiltering;
  
  /// Whether to allow searching
  final bool allowSearching;
  
  /// Whether to allow column resizing
  final bool allowColumnResize;
  
  /// Whether to allow column reordering
  final bool allowColumnReorder;
  
  /// Whether to allow row reordering
  final bool allowRowReorder;
  
  /// Whether to show empty state when no data
  final bool showEmptyState;
  
  /// Whether to show loading state
  final bool showLoadingState;
  
  /// Whether to show error state
  final bool showErrorState;
  
  /// Height of the header row
  final double headerHeight;
  
  /// Height of data rows
  final double rowHeight;
  
  /// Height of the grid container
  final double? gridHeight;
  
  /// Width of the grid container
  final double? gridWidth;
  
  /// Border radius of the grid
  final BorderRadius? borderRadius;
  
  /// Border of the grid
  final Border? border;
  
  /// Background color of the grid
  final Color? backgroundColor;
  
  /// Background color of the header row
  final Color? headerBackgroundColor;
  
  /// Background color of data rows
  final Color? rowBackgroundColor;
  
  /// Background color of selected rows
  final Color? selectedRowBackgroundColor;
  
  /// Background color of hovered rows
  final Color? hoverRowBackgroundColor;
  
  /// Text color of the header
  final Color? headerTextColor;
  
  /// Text color of data rows
  final Color? rowTextColor;
  
  /// Text color of selected rows
  final Color? selectedRowTextColor;
  
  /// Border color of the grid
  final Color? borderColor;
  
  /// Border color of rows
  final Color? rowBorderColor;
  
  /// Border color of the header
  final Color? headerBorderColor;
  
  /// Background color of auto filter row
  final Color? autoFilterBackgroundColor;
  
  /// Text color of auto filter row
  final Color? autoFilterTextColor;
  
  /// Border color of auto filter row
  final Color? autoFilterBorderColor;
  
  /// Shadow of the grid
  final List<BoxShadow>? shadow;
  
  /// Padding of the grid
  final EdgeInsets? padding;
  
  /// Margin of the grid
  final EdgeInsets? margin;
  
  /// Spacing between rows
  final double rowSpacing;
  
  /// Spacing between columns
  final double columnSpacing;
  
  /// Items per page for pagination
  final int itemsPerPage;
  
  /// Available items per page options
  final List<int> itemsPerPageOptions;
  
  /// Search placeholder text
  final String searchPlaceholder;
  
  /// Empty state message
  final String emptyStateMessage;
  
  /// Loading state message
  final String loadingStateMessage;
  
  /// Error state message
  final String errorStateMessage;
  
  /// Custom empty state widget
  final Widget? emptyStateWidget;
  
  /// Custom loading state widget
  final Widget? loadingStateWidget;
  
  /// Custom error state widget
  final Widget? errorStateWidget;
  
  /// Custom header widget
  final Widget? customHeaderWidget;
  
  /// Custom footer widget
  final Widget? customFooterWidget;
  
  /// Custom toolbar widget
  final Widget? customToolbarWidget;

  // Responsive configuration
  /// Minimum column width for mobile devices
  final double mobileMinColumnWidth;
  
  /// Maximum column width for mobile devices
  final double mobileMaxColumnWidth;
  
  /// Minimum column width for tablet devices
  final double tabletMinColumnWidth;
  
  /// Maximum column width for tablet devices
  final double tabletMaxColumnWidth;
  
  /// Default column width for desktop devices
  final double desktopDefaultColumnWidth;
  
  /// Whether to enable horizontal scrolling on mobile
  final bool enableMobileHorizontalScroll;
  
  /// Whether to enable horizontal scrolling on tablet
  final bool enableTabletHorizontalScroll;
  
  /// Whether to enable horizontal scrolling on desktop
  final bool enableDesktopHorizontalScroll;
  
  /// Mobile breakpoint width
  final double mobileBreakpoint;
  
  /// Tablet breakpoint width
  final double tabletBreakpoint;
  
  /// Whether to show column headers on mobile
  final bool showMobileHeaders;
  
  /// Whether to show column headers on tablet
  final bool showTabletHeaders;
  
  /// Whether to show column headers on desktop
  final bool showDesktopHeaders;
  
  /// Mobile row height
  final double mobileRowHeight;
  
  /// Tablet row height
  final double tabletRowHeight;
  
  /// Desktop row height
  final double desktopRowHeight;
  
  /// Mobile header height
  final double mobileHeaderHeight;
  
  /// Tablet header height
  final double tabletHeaderHeight;
  
  /// Desktop header height
  final double desktopHeaderHeight;

  GridConfig({
    Color? backgroundColor,
    Color? headerBackgroundColor,
    Color? rowBackgroundColor,
    Color? selectedRowBackgroundColor,
    Color? hoverRowBackgroundColor,
    Color? headerTextColor,
    Color? rowTextColor,
    Color? selectedRowTextColor,
    Color? borderColor,
    Color? rowBorderColor,
    BorderRadius? borderRadius,
    Color? autoFilterBackgroundColor,
    Color? autoFilterTextColor,
    Color? autoFilterBorderColor,
    Color? headerBorderColor,
    this.shadow = const [],
    this.mobileMinColumnWidth = 100.0,
    this.mobileMaxColumnWidth = 200.0,
    this.mobileRowHeight = 60.0,
    this.mobileHeaderHeight = 50.0,
    this.showMobileHeaders = true,
    this.enableMobileHorizontalScroll = true,
    this.tabletMinColumnWidth = 120.0,
    this.tabletMaxColumnWidth = 300.0,
    this.tabletRowHeight = 55.0,
    this.tabletHeaderHeight = 50.0,
    this.showTabletHeaders = true,
    this.enableTabletHorizontalScroll = true,
    this.desktopDefaultColumnWidth = 200.0,
    this.desktopRowHeight = 50.0,
    this.desktopHeaderHeight = 45.0,
    this.showDesktopHeaders = true,
    this.enableDesktopHorizontalScroll = true,
    this.mobileBreakpoint = 768.0,
    this.tabletBreakpoint = 1024.0,
    this.showSelection = false,
    this.showActions = false,
    this.showFilter = false,
    this.showSearch = false,
    this.showAutoFilter = false,
    this.showPagination = false,
    this.showToolbar = false,
    this.showHeader = true,
    this.showFooter = false,
    this.allowMultiSelection = false,
    this.allowSorting = true,
    this.allowFiltering = true,
    this.allowSearching = true,
    this.itemsPerPage = 10,
    this.itemsPerPageOptions = const [5, 10, 20, 50, 100],
    this.searchPlaceholder = 'Search...',
    this.emptyStateMessage = 'No data available',
    this.loadingStateMessage = 'Loading...',
    this.errorStateMessage = 'Error loading data',
    this.showHoverEffects = true,
    this.allowColumnResize = false,
    this.allowColumnReorder = false,
    this.allowRowReorder = false,
    this.showEmptyState = true,
    this.showLoadingState = true,
    this.showErrorState = true,
    this.headerHeight = 50.0,
    this.rowHeight = 50.0,
    this.gridHeight,
    this.gridWidth,
    this.border,
    this.padding,
    this.margin,
    this.rowSpacing = 1.0,
    this.columnSpacing = 10.0,
    this.emptyStateWidget,
    this.loadingStateWidget,
    this.errorStateWidget,
    this.customHeaderWidget,
    this.customFooterWidget,
    this.customToolbarWidget,
  })  :
    backgroundColor = backgroundColor ?? Colors.white,
    headerBackgroundColor = headerBackgroundColor ?? Colors.grey.shade50,
    rowBackgroundColor = rowBackgroundColor ?? Colors.white,
    selectedRowBackgroundColor = selectedRowBackgroundColor ?? Colors.blue.shade50,
    hoverRowBackgroundColor = hoverRowBackgroundColor ?? Colors.grey.shade50,
    headerTextColor = headerTextColor ?? Colors.grey.shade800,
    rowTextColor = rowTextColor ?? Colors.grey.shade900,
    selectedRowTextColor = selectedRowTextColor ?? Colors.blue.shade800,
    borderColor = borderColor ?? Colors.grey.shade200,
    rowBorderColor = rowBorderColor ?? Colors.grey.shade100,
    borderRadius = borderRadius ?? BorderRadius.zero,
    autoFilterBackgroundColor = autoFilterBackgroundColor ?? Colors.grey.shade50,
    autoFilterTextColor = autoFilterTextColor ?? Colors.grey.shade700,
    autoFilterBorderColor = autoFilterBorderColor ?? Colors.grey.shade200,
    headerBorderColor = headerBorderColor ?? Colors.grey.shade200;

  /// Creates a copy of this config with updated properties
  GridConfig copyWith({
    bool? showHeader,
    bool? showSelection,
    bool? showSearch,
    bool? showFilter,
    bool? showAutoFilter,
    bool? showPagination,
    bool? showActions,
    bool? showHoverEffects,
    bool? allowMultiSelection,
    bool? allowSorting,
    bool? allowFiltering,
    bool? allowSearching,
    bool? allowColumnResize,
    bool? allowColumnReorder,
    bool? allowRowReorder,
    bool? showEmptyState,
    bool? showLoadingState,
    bool? showErrorState,
    double? headerHeight,
    double? rowHeight,
    double? gridHeight,
    double? gridWidth,
    BorderRadius? borderRadius,
    Border? border,
    Color? backgroundColor,
    Color? headerBackgroundColor,
    Color? rowBackgroundColor,
    Color? selectedRowBackgroundColor,
    Color? hoverRowBackgroundColor,
    Color? headerTextColor,
    Color? rowTextColor,
    Color? selectedRowTextColor,
    Color? borderColor,
    Color? rowBorderColor,
    Color? headerBorderColor,
    Color? autoFilterBackgroundColor,
    Color? autoFilterTextColor,
    Color? autoFilterBorderColor,
    List<BoxShadow>? shadow,
    EdgeInsets? padding,
    EdgeInsets? margin,
    double? rowSpacing,
    double? columnSpacing,
    int? itemsPerPage,
    List<int>? itemsPerPageOptions,
    String? searchPlaceholder,
    String? emptyStateMessage,
    String? loadingStateMessage,
    String? errorStateMessage,
    Widget? emptyStateWidget,
    Widget? loadingStateWidget,
    Widget? errorStateWidget,
    Widget? customHeaderWidget,
    Widget? customFooterWidget,
    Widget? customToolbarWidget,
    // Responsive configuration
    double? mobileMinColumnWidth,
    double? mobileMaxColumnWidth,
    double? tabletMinColumnWidth,
    double? tabletMaxColumnWidth,
    double? desktopDefaultColumnWidth,
    bool? enableMobileHorizontalScroll,
    bool? enableTabletHorizontalScroll,
    bool? enableDesktopHorizontalScroll,
    double? mobileBreakpoint,
    double? tabletBreakpoint,
    bool? showMobileHeaders,
    bool? showTabletHeaders,
    bool? showDesktopHeaders,
    double? mobileRowHeight,
    double? tabletRowHeight,
    double? desktopRowHeight,
    double? mobileHeaderHeight,
    double? tabletHeaderHeight,
    double? desktopHeaderHeight,
  }) {
    return GridConfig(
      showHeader: showHeader ?? this.showHeader,
      showSelection: showSelection ?? this.showSelection,
      showSearch: showSearch ?? this.showSearch,
      showFilter: showFilter ?? this.showFilter,
      showAutoFilter: showAutoFilter ?? this.showAutoFilter,
      showPagination: showPagination ?? this.showPagination,
      showActions: showActions ?? this.showActions,
      showHoverEffects: showHoverEffects ?? this.showHoverEffects,
      allowMultiSelection: allowMultiSelection ?? this.allowMultiSelection,
      allowSorting: allowSorting ?? this.allowSorting,
      allowFiltering: allowFiltering ?? this.allowFiltering,
      allowSearching: allowSearching ?? this.allowSearching,
      allowColumnResize: allowColumnResize ?? this.allowColumnResize,
      allowColumnReorder: allowColumnReorder ?? this.allowColumnReorder,
      allowRowReorder: allowRowReorder ?? this.allowRowReorder,
      showEmptyState: showEmptyState ?? this.showEmptyState,
      showLoadingState: showLoadingState ?? this.showLoadingState,
      showErrorState: showErrorState ?? this.showErrorState,
      headerHeight: headerHeight ?? this.headerHeight,
      rowHeight: rowHeight ?? this.rowHeight,
      gridHeight: gridHeight ?? this.gridHeight,
      gridWidth: gridWidth ?? this.gridWidth,
      borderRadius: borderRadius ?? this.borderRadius,
      border: border ?? this.border,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      headerBackgroundColor: headerBackgroundColor ?? this.headerBackgroundColor,
      rowBackgroundColor: rowBackgroundColor ?? this.rowBackgroundColor,
      selectedRowBackgroundColor: selectedRowBackgroundColor ?? this.selectedRowBackgroundColor,
      hoverRowBackgroundColor: hoverRowBackgroundColor ?? this.hoverRowBackgroundColor,
      headerTextColor: headerTextColor ?? this.headerTextColor,
      rowTextColor: rowTextColor ?? this.rowTextColor,
      selectedRowTextColor: selectedRowTextColor ?? this.selectedRowTextColor,
      borderColor: borderColor ?? this.borderColor,
      rowBorderColor: rowBorderColor ?? this.rowBorderColor,
      headerBorderColor: headerBorderColor ?? this.headerBorderColor,
      autoFilterBackgroundColor: autoFilterBackgroundColor ?? this.autoFilterBackgroundColor,
      autoFilterTextColor: autoFilterTextColor ?? this.autoFilterTextColor,
      autoFilterBorderColor: autoFilterBorderColor ?? this.autoFilterBorderColor,
      shadow: shadow ?? this.shadow,
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
      rowSpacing: rowSpacing ?? this.rowSpacing,
      columnSpacing: columnSpacing ?? this.columnSpacing,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
      itemsPerPageOptions: itemsPerPageOptions ?? this.itemsPerPageOptions,
      searchPlaceholder: searchPlaceholder ?? this.searchPlaceholder,
      emptyStateMessage: emptyStateMessage ?? this.emptyStateMessage,
      loadingStateMessage: loadingStateMessage ?? this.loadingStateMessage,
      errorStateMessage: errorStateMessage ?? this.errorStateMessage,
      emptyStateWidget: emptyStateWidget ?? this.emptyStateWidget,
      loadingStateWidget: loadingStateWidget ?? this.loadingStateWidget,
      errorStateWidget: errorStateWidget ?? this.errorStateWidget,
      customHeaderWidget: customHeaderWidget ?? this.customHeaderWidget,
      customFooterWidget: customFooterWidget ?? this.customFooterWidget,
      customToolbarWidget: customToolbarWidget ?? this.customToolbarWidget,
      // Responsive configuration
      mobileMinColumnWidth: mobileMinColumnWidth ?? this.mobileMinColumnWidth,
      mobileMaxColumnWidth: mobileMaxColumnWidth ?? this.mobileMaxColumnWidth,
      tabletMinColumnWidth: tabletMinColumnWidth ?? this.tabletMinColumnWidth,
      tabletMaxColumnWidth: tabletMaxColumnWidth ?? this.tabletMaxColumnWidth,
      desktopDefaultColumnWidth: desktopDefaultColumnWidth ?? this.desktopDefaultColumnWidth,
      enableMobileHorizontalScroll: enableMobileHorizontalScroll ?? this.enableMobileHorizontalScroll,
      enableTabletHorizontalScroll: enableTabletHorizontalScroll ?? this.enableTabletHorizontalScroll,
      enableDesktopHorizontalScroll: enableDesktopHorizontalScroll ?? this.enableDesktopHorizontalScroll,
      mobileBreakpoint: mobileBreakpoint ?? this.mobileBreakpoint,
      tabletBreakpoint: tabletBreakpoint ?? this.tabletBreakpoint,
      showMobileHeaders: showMobileHeaders ?? this.showMobileHeaders,
      showTabletHeaders: showTabletHeaders ?? this.showTabletHeaders,
      showDesktopHeaders: showDesktopHeaders ?? this.showDesktopHeaders,
      mobileRowHeight: mobileRowHeight ?? this.mobileRowHeight,
      tabletRowHeight: tabletRowHeight ?? this.tabletRowHeight,
      desktopRowHeight: desktopRowHeight ?? this.desktopRowHeight,
      mobileHeaderHeight: mobileHeaderHeight ?? this.mobileHeaderHeight,
      tabletHeaderHeight: tabletHeaderHeight ?? this.tabletHeaderHeight,
      desktopHeaderHeight: desktopHeaderHeight ?? this.desktopHeaderHeight,
    );
  }

  /// Get responsive row height based on screen width
  double getResponsiveRowHeight(double screenWidth) {
    if (screenWidth < mobileBreakpoint) {
      return mobileRowHeight;
    } else if (screenWidth < tabletBreakpoint) {
      return tabletRowHeight;
    } else {
      return desktopRowHeight;
    }
  }

  /// Get responsive header height based on screen width
  double getResponsiveHeaderHeight(double screenWidth) {
    if (screenWidth < mobileBreakpoint) {
      return mobileHeaderHeight;
    } else if (screenWidth < tabletBreakpoint) {
      return tabletHeaderHeight;
    } else {
      return desktopHeaderHeight;
    }
  }

  /// Check if headers should be shown based on screen width
  bool shouldShowHeaders(double screenWidth) {
    if (screenWidth < mobileBreakpoint) {
      return showMobileHeaders;
    } else if (screenWidth < tabletBreakpoint) {
      return showTabletHeaders;
    } else {
      return showDesktopHeaders;
    }
  }

  /// Check if horizontal scrolling should be enabled based on screen width
  bool shouldEnableHorizontalScroll(double screenWidth) {
    if (screenWidth < mobileBreakpoint) {
      return enableMobileHorizontalScroll;
    } else if (screenWidth < tabletBreakpoint) {
      return enableTabletHorizontalScroll;
    } else {
      return enableDesktopHorizontalScroll;
    }
  }

  @override
  String toString() {
    return 'GridConfig(showHeader: $showHeader, showSearch: $showSearch, showFilter: $showFilter, showPagination: $showPagination)';
  }
} 