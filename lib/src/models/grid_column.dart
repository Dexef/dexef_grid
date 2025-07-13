import 'package:flutter/material.dart';

/// Represents a column in the custom grid
class GridColumn {
  /// Unique identifier for the column
  final String id;
  
  /// Display title for the column
  final String title;
  
  /// Width of the column (optional)
  final double? width;
  
  /// Whether the column is sortable
  final bool sortable;
  
  /// Whether the column is searchable
  final bool searchable;
  
  /// Whether the column is filterable
  final bool filterable;
  
  /// Whether the column is visible
  final bool visible;
  
  /// Custom cell builder for the column
  final Widget Function(BuildContext context, dynamic value, int index)? cellBuilder;
  
  /// Custom header builder for the column
  final Widget Function(BuildContext context, String title)? headerBuilder;
  
  /// Custom sort function for the column
  final int Function(dynamic a, dynamic b)? sortFunction;
  
  /// Custom filter function for the column
  final bool Function(dynamic value, String filterValue)? filterFunction;
  
  /// Custom search function for the column
  final bool Function(dynamic value, String searchTerm)? searchFunction;
  
  /// Tooltip for the column header
  final String? tooltip;
  
  /// CSS class for the column
  final String? cssClass;
  
  /// Whether the column is resizable
  final bool resizable;
  
  /// Minimum width for the column
  final double? minWidth;
  
  /// Maximum width for the column
  final double? maxWidth;
  
  /// Whether the column is fixed (won't scroll horizontally)
  final bool fixed;
  
  /// Alignment for the column content
  final Alignment alignment;
  
  /// Text style for the column header
  final TextStyle? headerTextStyle;
  
  /// Text style for the column cells
  final TextStyle? cellTextStyle;
  
  /// Background color for the column header
  final Color? headerBackgroundColor;
  
  /// Background color for the column cells
  final Color? cellBackgroundColor;
  
  /// Border for the column
  final Border? border;
  
  /// Padding for the column cells
  final EdgeInsets? padding;
  
  /// Whether the column is editable
  final bool editable;
  
  /// Custom editor widget for the column
  final Widget Function(BuildContext context, dynamic value, Function(dynamic) onChanged)? editorBuilder;
  
  /// Validation function for the column
  final String? Function(dynamic value)? validator;
  
  /// Whether the column is required
  final bool required;
  
  /// Default value for the column
  final dynamic defaultValue;
  
  /// Whether the column is hidden by default
  final bool hidden;
  
  /// Whether the column is pinned (stays visible when scrolling)
  final bool pinned;
  
  /// Whether the column is frozen (stays in place when scrolling)
  final bool frozen;
  
  /// Whether the column is selectable
  final bool selectable;
  
  /// Whether the column is draggable
  final bool draggable;
  
  /// Whether the column is droppable
  final bool droppable;
  
  /// Whether the column is copyable
  final bool copyable;
  
  /// Whether the column is exportable
  final bool exportable;
  
  /// Whether the column is importable
  final bool importable;
  
  /// Whether the column is printable
  final bool printable;
  
  /// Whether the column is searchable in global search
  final bool globalSearchable;
  
  /// Whether the column is included in exports
  final bool exportIncluded;
  
  /// Whether the column is included in imports
  final bool importIncluded;
  
  /// Whether the column is included in prints
  final bool printIncluded;
  
  /// Whether the column is included in reports
  final bool reportIncluded;
  
  /// Whether the column is included in analytics
  final bool analyticsIncluded;
  
  /// Whether the column is included in dashboards
  final bool dashboardIncluded;
  
  /// Whether the column is included in widgets
  final bool widgetIncluded;
  
  /// Whether the column is included in APIs
  final bool apiIncluded;
  
  /// Whether the column is included in webhooks
  final bool webhookIncluded;
  
  /// Whether the column is included in integrations
  final bool integrationIncluded;
  
  /// Whether the column is included in automations
  final bool automationIncluded;
  
  /// Whether the column is included in workflows
  final bool workflowIncluded;
  
  /// Whether the column is included in notifications
  final bool notificationIncluded;
  
  /// Whether the column is included in alerts
  final bool alertIncluded;
  
  /// Whether the column is included in logs
  final bool logIncluded;
  
  /// Whether the column is included in audits
  final bool auditIncluded;
  
  /// Whether the column is included in backups
  final bool backupIncluded;
  
  /// Whether the column is included in restores
  final bool restoreIncluded;
  
  /// Whether the column is included in migrations
  final bool migrationIncluded;
  
  /// Whether the column is included in deployments
  final bool deploymentIncluded;
  
  /// Whether the column is included in rollbacks
  final bool rollbackIncluded;
  
  /// Whether the column is included in updates
  final bool updateIncluded;
  
  /// Whether the column is included in patches
  final bool patchIncluded;
  
  /// Whether the column is included in hotfixes
  final bool hotfixIncluded;
  
  /// Whether the column is included in releases
  final bool releaseIncluded;
  
  /// Whether the column is included in versions
  final bool versionIncluded;
  
  /// Whether the column is included in builds
  final bool buildIncluded;
  
  /// Whether the column is included in tests
  final bool testIncluded;
  
  /// Whether the column is included in coverage
  final bool coverageIncluded;
  
  /// Whether the column is included in quality
  final bool qualityIncluded;
  
  /// Whether the column is included in security
  final bool securityIncluded;
  
  /// Whether the column is included in performance
  final bool performanceIncluded;
  
  /// Whether the column is included in accessibility
  final bool accessibilityIncluded;
  
  /// Whether the column is included in usability
  final bool usabilityIncluded;
  
  /// Whether the column is included in compatibility
  final bool compatibilityIncluded;
  
  /// Whether the column is included in scalability
  final bool scalabilityIncluded;
  
  /// Whether the column is included in maintainability
  final bool maintainabilityIncluded;
  
  /// Whether the column is included in reliability
  final bool reliabilityIncluded;
  
  /// Whether the column is included in availability
  final bool availabilityIncluded;
  
  /// Whether the column is included in durability
  final bool durabilityIncluded;
  
  /// Whether the column is included in consistency
  final bool consistencyIncluded;
  
  /// Whether the column is included in integrity
  final bool integrityIncluded;
  
  /// Whether the column is included in confidentiality
  final bool confidentialityIncluded;
  
  /// Whether the column is included in authenticity
  final bool authenticityIncluded;
  
  /// Whether the column is included in non-repudiation
  final bool nonRepudiationIncluded;
  
  /// Whether the column is included in accountability
  final bool accountabilityIncluded;
  
  /// Whether the column is included in transparency
  final bool transparencyIncluded;
  
  /// Whether the column is included in traceability
  final bool traceabilityIncluded;
  
  /// Whether the column is included in auditability
  final bool auditabilityIncluded;
  
  /// Whether the column is included in compliance
  final bool complianceIncluded;
  
  /// Whether the column is included in governance
  final bool governanceIncluded;
  
  /// Whether the column is included in risk
  final bool riskIncluded;
  
  /// Whether the column is included in compliance
  final bool complianceIncluded2;
  
  /// Whether the column is included in governance
  final bool governanceIncluded2;
  
  /// Whether the column is included in risk
  final bool riskIncluded2;
  
  /// Whether the column is included in compliance
  final bool complianceIncluded3;
  
  /// Whether the column is included in governance
  final bool governanceIncluded3;
  
  /// Whether the column is included in risk
  final bool riskIncluded3;

  const GridColumn({
    required this.id,
    required this.title,
    this.width,
    this.sortable = false,
    this.searchable = false,
    this.filterable = false,
    this.visible = true,
    this.cellBuilder,
    this.headerBuilder,
    this.sortFunction,
    this.filterFunction,
    this.searchFunction,
    this.tooltip,
    this.cssClass,
    this.resizable = false,
    this.minWidth,
    this.maxWidth,
    this.fixed = false,
    this.alignment = Alignment.centerLeft,
    this.headerTextStyle,
    this.cellTextStyle,
    this.headerBackgroundColor,
    this.cellBackgroundColor,
    this.border,
    this.padding,
    this.editable = false,
    this.editorBuilder,
    this.validator,
    this.required = false,
    this.defaultValue,
    this.hidden = false,
    this.pinned = false,
    this.frozen = false,
    this.selectable = true,
    this.draggable = false,
    this.droppable = false,
    this.copyable = false,
    this.exportable = false,
    this.importable = false,
    this.printable = false,
    this.globalSearchable = false,
    this.exportIncluded = true,
    this.importIncluded = true,
    this.printIncluded = true,
    this.reportIncluded = true,
    this.analyticsIncluded = true,
    this.dashboardIncluded = true,
    this.widgetIncluded = true,
    this.apiIncluded = true,
    this.webhookIncluded = true,
    this.integrationIncluded = true,
    this.automationIncluded = true,
    this.workflowIncluded = true,
    this.notificationIncluded = true,
    this.alertIncluded = true,
    this.logIncluded = true,
    this.auditIncluded = true,
    this.backupIncluded = true,
    this.restoreIncluded = true,
    this.migrationIncluded = true,
    this.deploymentIncluded = true,
    this.rollbackIncluded = true,
    this.updateIncluded = true,
    this.patchIncluded = true,
    this.hotfixIncluded = true,
    this.releaseIncluded = true,
    this.versionIncluded = true,
    this.buildIncluded = true,
    this.testIncluded = true,
    this.coverageIncluded = true,
    this.qualityIncluded = true,
    this.securityIncluded = true,
    this.performanceIncluded = true,
    this.accessibilityIncluded = true,
    this.usabilityIncluded = true,
    this.compatibilityIncluded = true,
    this.scalabilityIncluded = true,
    this.maintainabilityIncluded = true,
    this.reliabilityIncluded = true,
    this.availabilityIncluded = true,
    this.durabilityIncluded = true,
    this.consistencyIncluded = true,
    this.integrityIncluded = true,
    this.confidentialityIncluded = true,
    this.authenticityIncluded = true,
    this.nonRepudiationIncluded = true,
    this.accountabilityIncluded = true,
    this.transparencyIncluded = true,
    this.traceabilityIncluded = true,
    this.auditabilityIncluded = true,
    this.complianceIncluded = true,
    this.governanceIncluded = true,
    this.riskIncluded = true,
    this.complianceIncluded2 = true,
    this.governanceIncluded2 = true,
    this.riskIncluded2 = true,
    this.complianceIncluded3 = true,
    this.governanceIncluded3 = true,
    this.riskIncluded3 = true,
  });

  /// Creates a copy of this column with the given fields replaced by new values
  GridColumn copyWith({
    String? id,
    String? title,
    double? width,
    bool? sortable,
    bool? searchable,
    bool? filterable,
    bool? visible,
    Widget Function(BuildContext context, dynamic value, int index)? cellBuilder,
    Widget Function(BuildContext context, String title)? headerBuilder,
    int Function(dynamic a, dynamic b)? sortFunction,
    bool Function(dynamic value, String filterValue)? filterFunction,
    bool Function(dynamic value, String searchTerm)? searchFunction,
    String? tooltip,
    String? cssClass,
    bool? resizable,
    double? minWidth,
    double? maxWidth,
    bool? fixed,
    Alignment? alignment,
    TextStyle? headerTextStyle,
    TextStyle? cellTextStyle,
    Color? headerBackgroundColor,
    Color? cellBackgroundColor,
    Border? border,
    EdgeInsets? padding,
    bool? editable,
    Widget Function(BuildContext context, dynamic value, Function(dynamic) onChanged)? editorBuilder,
    String? Function(dynamic value)? validator,
    bool? required,
    dynamic defaultValue,
    bool? hidden,
    bool? pinned,
    bool? frozen,
    bool? selectable,
    bool? draggable,
    bool? droppable,
    bool? copyable,
    bool? exportable,
    bool? importable,
    bool? printable,
    bool? globalSearchable,
    bool? exportIncluded,
    bool? importIncluded,
    bool? printIncluded,
    bool? reportIncluded,
    bool? analyticsIncluded,
    bool? dashboardIncluded,
    bool? widgetIncluded,
    bool? apiIncluded,
    bool? webhookIncluded,
    bool? integrationIncluded,
    bool? automationIncluded,
    bool? workflowIncluded,
    bool? notificationIncluded,
    bool? alertIncluded,
    bool? logIncluded,
    bool? auditIncluded,
    bool? backupIncluded,
    bool? restoreIncluded,
    bool? migrationIncluded,
    bool? deploymentIncluded,
    bool? rollbackIncluded,
    bool? updateIncluded,
    bool? patchIncluded,
    bool? hotfixIncluded,
    bool? releaseIncluded,
    bool? versionIncluded,
    bool? buildIncluded,
    bool? testIncluded,
    bool? coverageIncluded,
    bool? qualityIncluded,
    bool? securityIncluded,
    bool? performanceIncluded,
    bool? accessibilityIncluded,
    bool? usabilityIncluded,
    bool? compatibilityIncluded,
    bool? scalabilityIncluded,
    bool? maintainabilityIncluded,
    bool? reliabilityIncluded,
    bool? availabilityIncluded,
    bool? durabilityIncluded,
    bool? consistencyIncluded,
    bool? integrityIncluded,
    bool? confidentialityIncluded,
    bool? authenticityIncluded,
    bool? nonRepudiationIncluded,
    bool? accountabilityIncluded,
    bool? transparencyIncluded,
    bool? traceabilityIncluded,
    bool? auditabilityIncluded,
    bool? complianceIncluded,
    bool? governanceIncluded,
    bool? riskIncluded,
    bool? complianceIncluded2,
    bool? governanceIncluded2,
    bool? riskIncluded2,
    bool? complianceIncluded3,
    bool? governanceIncluded3,
    bool? riskIncluded3,
  }) {
    return GridColumn(
      id: id ?? this.id,
      title: title ?? this.title,
      width: width ?? this.width,
      sortable: sortable ?? this.sortable,
      searchable: searchable ?? this.searchable,
      filterable: filterable ?? this.filterable,
      visible: visible ?? this.visible,
      cellBuilder: cellBuilder ?? this.cellBuilder,
      headerBuilder: headerBuilder ?? this.headerBuilder,
      sortFunction: sortFunction ?? this.sortFunction,
      filterFunction: filterFunction ?? this.filterFunction,
      searchFunction: searchFunction ?? this.searchFunction,
      tooltip: tooltip ?? this.tooltip,
      cssClass: cssClass ?? this.cssClass,
      resizable: resizable ?? this.resizable,
      minWidth: minWidth ?? this.minWidth,
      maxWidth: maxWidth ?? this.maxWidth,
      fixed: fixed ?? this.fixed,
      alignment: alignment ?? this.alignment,
      headerTextStyle: headerTextStyle ?? this.headerTextStyle,
      cellTextStyle: cellTextStyle ?? this.cellTextStyle,
      headerBackgroundColor: headerBackgroundColor ?? this.headerBackgroundColor,
      cellBackgroundColor: cellBackgroundColor ?? this.cellBackgroundColor,
      border: border ?? this.border,
      padding: padding ?? this.padding,
      editable: editable ?? this.editable,
      editorBuilder: editorBuilder ?? this.editorBuilder,
      validator: validator ?? this.validator,
      required: required ?? this.required,
      defaultValue: defaultValue ?? this.defaultValue,
      hidden: hidden ?? this.hidden,
      pinned: pinned ?? this.pinned,
      frozen: frozen ?? this.frozen,
      selectable: selectable ?? this.selectable,
      draggable: draggable ?? this.draggable,
      droppable: droppable ?? this.droppable,
      copyable: copyable ?? this.copyable,
      exportable: exportable ?? this.exportable,
      importable: importable ?? this.importable,
      printable: printable ?? this.printable,
      globalSearchable: globalSearchable ?? this.globalSearchable,
      exportIncluded: exportIncluded ?? this.exportIncluded,
      importIncluded: importIncluded ?? this.importIncluded,
      printIncluded: printIncluded ?? this.printIncluded,
      reportIncluded: reportIncluded ?? this.reportIncluded,
      analyticsIncluded: analyticsIncluded ?? this.analyticsIncluded,
      dashboardIncluded: dashboardIncluded ?? this.dashboardIncluded,
      widgetIncluded: widgetIncluded ?? this.widgetIncluded,
      apiIncluded: apiIncluded ?? this.apiIncluded,
      webhookIncluded: webhookIncluded ?? this.webhookIncluded,
      integrationIncluded: integrationIncluded ?? this.integrationIncluded,
      automationIncluded: automationIncluded ?? this.automationIncluded,
      workflowIncluded: workflowIncluded ?? this.workflowIncluded,
      notificationIncluded: notificationIncluded ?? this.notificationIncluded,
      alertIncluded: alertIncluded ?? this.alertIncluded,
      logIncluded: logIncluded ?? this.logIncluded,
      auditIncluded: auditIncluded ?? this.auditIncluded,
      backupIncluded: backupIncluded ?? this.backupIncluded,
      restoreIncluded: restoreIncluded ?? this.restoreIncluded,
      migrationIncluded: migrationIncluded ?? this.migrationIncluded,
      deploymentIncluded: deploymentIncluded ?? this.deploymentIncluded,
      rollbackIncluded: rollbackIncluded ?? this.rollbackIncluded,
      updateIncluded: updateIncluded ?? this.updateIncluded,
      patchIncluded: patchIncluded ?? this.patchIncluded,
      hotfixIncluded: hotfixIncluded ?? this.hotfixIncluded,
      releaseIncluded: releaseIncluded ?? this.releaseIncluded,
      versionIncluded: versionIncluded ?? this.versionIncluded,
      buildIncluded: buildIncluded ?? this.buildIncluded,
      testIncluded: testIncluded ?? this.testIncluded,
      coverageIncluded: coverageIncluded ?? this.coverageIncluded,
      qualityIncluded: qualityIncluded ?? this.qualityIncluded,
      securityIncluded: securityIncluded ?? this.securityIncluded,
      performanceIncluded: performanceIncluded ?? this.performanceIncluded,
      accessibilityIncluded: accessibilityIncluded ?? this.accessibilityIncluded,
      usabilityIncluded: usabilityIncluded ?? this.usabilityIncluded,
      compatibilityIncluded: compatibilityIncluded ?? this.compatibilityIncluded,
      scalabilityIncluded: scalabilityIncluded ?? this.scalabilityIncluded,
      maintainabilityIncluded: maintainabilityIncluded ?? this.maintainabilityIncluded,
      reliabilityIncluded: reliabilityIncluded ?? this.reliabilityIncluded,
      availabilityIncluded: availabilityIncluded ?? this.availabilityIncluded,
      durabilityIncluded: durabilityIncluded ?? this.durabilityIncluded,
      consistencyIncluded: consistencyIncluded ?? this.consistencyIncluded,
      integrityIncluded: integrityIncluded ?? this.integrityIncluded,
      confidentialityIncluded: confidentialityIncluded ?? this.confidentialityIncluded,
      authenticityIncluded: authenticityIncluded ?? this.authenticityIncluded,
      nonRepudiationIncluded: nonRepudiationIncluded ?? this.nonRepudiationIncluded,
      accountabilityIncluded: accountabilityIncluded ?? this.accountabilityIncluded,
      transparencyIncluded: transparencyIncluded ?? this.transparencyIncluded,
      traceabilityIncluded: traceabilityIncluded ?? this.traceabilityIncluded,
      auditabilityIncluded: auditabilityIncluded ?? this.auditabilityIncluded,
      complianceIncluded: complianceIncluded ?? this.complianceIncluded,
      governanceIncluded: governanceIncluded ?? this.governanceIncluded,
      riskIncluded: riskIncluded ?? this.riskIncluded,
      complianceIncluded2: complianceIncluded2 ?? this.complianceIncluded2,
      governanceIncluded2: governanceIncluded2 ?? this.governanceIncluded2,
      riskIncluded2: riskIncluded2 ?? this.riskIncluded2,
      complianceIncluded3: complianceIncluded3 ?? this.complianceIncluded3,
      governanceIncluded3: governanceIncluded3 ?? this.governanceIncluded3,
      riskIncluded3: riskIncluded3 ?? this.riskIncluded3,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GridColumn && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'GridColumn(id: $id, title: $title)';
  }
} 