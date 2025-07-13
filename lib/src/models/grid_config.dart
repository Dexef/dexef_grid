import 'package:flutter/material.dart';

/// Configuration for the custom grid widget
class GridConfig {
  /// Whether to show the header row
  final bool showHeader;
  
  /// Whether to show row selection checkboxes
  final bool showSelection;
  
  /// Whether to show search functionality
  final bool showSearch;
  
  /// Whether to show filter functionality
  final bool showFilter;
  
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

  const GridConfig({
    this.showHeader = true,
    this.showSelection = true,
    this.showSearch = true,
    this.showFilter = true,
    this.showPagination = true,
    this.showActions = true,
    this.showHoverEffects = true,
    this.allowMultiSelection = true,
    this.allowSorting = true,
    this.allowFiltering = true,
    this.allowSearching = true,
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
    this.borderRadius,
    this.border,
    this.backgroundColor,
    this.headerBackgroundColor,
    this.rowBackgroundColor,
    this.selectedRowBackgroundColor,
    this.hoverRowBackgroundColor,
    this.headerTextColor,
    this.rowTextColor,
    this.selectedRowTextColor,
    this.borderColor,
    this.rowBorderColor,
    this.headerBorderColor,
    this.shadow,
    this.padding,
    this.margin,
    this.rowSpacing = 1.0,
    this.columnSpacing = 10.0,
    this.itemsPerPage = 10,
    this.itemsPerPageOptions = const [5, 10, 20, 50, 100],
    this.searchPlaceholder = 'Search...',
    this.emptyStateMessage = 'No data available',
    this.loadingStateMessage = 'Loading...',
    this.errorStateMessage = 'An error occurred',
    this.emptyStateWidget,
    this.loadingStateWidget,
    this.errorStateWidget,
    this.customHeaderWidget,
    this.customFooterWidget,
    this.customToolbarWidget,
    // Responsive configuration
    this.mobileMinColumnWidth = 80.0,
    this.mobileMaxColumnWidth = 200.0,
    this.tabletMinColumnWidth = 120.0,
    this.tabletMaxColumnWidth = 300.0,
    this.desktopDefaultColumnWidth = 200.0,
    this.enableMobileHorizontalScroll = true,
    this.enableTabletHorizontalScroll = true,
    this.enableDesktopHorizontalScroll = true,
    this.mobileBreakpoint = 768.0,
    this.tabletBreakpoint = 1024.0,
    this.showMobileHeaders = true,
    this.showTabletHeaders = true,
    this.showDesktopHeaders = true,
    this.mobileRowHeight = 60.0,
    this.tabletRowHeight = 55.0,
    this.desktopRowHeight = 50.0,
    this.mobileHeaderHeight = 60.0,
    this.tabletHeaderHeight = 55.0,
    this.desktopHeaderHeight = 50.0,
  });

  /// Creates a copy of this config with updated properties
  GridConfig copyWith({
    bool? showHeader,
    bool? showSelection,
    bool? showSearch,
    bool? showFilter,
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