import 'package:flutter/material.dart';
import 'package:dexef_grid/dexef_grid.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DevExtreme-Style DataGrid Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      home: MyGridPage(),
    );
  }
}

class MyGridPage extends StatefulWidget {
  @override
  _MyGridPageState createState() => _MyGridPageState();
}

class _MyGridPageState extends State<MyGridPage> {
  List<GridRow> rows = [];
  List<GridColumn> columns = [];
  GridConfig config = GridConfig();
  GridActions actions = GridActions();
  
  // State variables
  String searchTerm = '';
  Map<String, String> filters = {};
  String? sortColumn;
  bool? sortAscending;
  List<String> selectedRowIds = [];
  int currentPage = 1;
  int itemsPerPage = 10;
  bool isLoading = false;
  String? filterExpression;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    // Define columns with DevExtreme-style features and filter configurations
    columns = [
      GridColumn(
        id: 'id',
        title: 'ID',
        sortable: true,
        searchable: true,
        filterable: true,
        groupable: true,
        width: 80.0,
        alignment: Alignment.center,
        columnType: ColumnType.number,
        filterConfig: FilterConfig(
          columnType: ColumnType.number,
          availableOperations: ['equals', 'greaterThan', 'lessThan', 'between'],
          defaultOperation: 'equals',
          defaultValue: '',
        ),
        cellBuilder: (context, value, index) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '#$value',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
                fontSize: 12,
              ),
            ),
          );
        },
      ),
      GridColumn(
        id: 'name',
        title: 'Full Name',
        sortable: true,
        searchable: true,
        filterable: true,
        groupable: true,
        width: null,
        columnType: ColumnType.string,
        filterConfig: FilterConfig(
          columnType: ColumnType.string,
          availableOperations: ['contains', 'equals', 'startsWith', 'endsWith'],
          defaultOperation: 'contains',
          defaultValue: '',
        ),
        cellBuilder: (context, value, index) {
          return Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.blue.shade100,
                child: Text(
                  value.toString().substring(0, 1).toUpperCase(),
                  style: TextStyle(
                    color: Colors.blue.shade800,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  value.toString(),
                  style: TextStyle(fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );
        },
      ),
      GridColumn(
        id: 'email',
        title: 'Email Address',
        sortable: true,
        searchable: true,
        filterable: true,
        groupable: true,
        width: null,
        columnType: ColumnType.email,
        filterConfig: FilterConfig(
          columnType: ColumnType.email,
          availableOperations: ['contains', 'equals', 'domainEquals', 'isValidEmail'],
          defaultOperation: 'contains',
          defaultValue: '',
        ),
        cellBuilder: (context, value, index) {
          return Row(
            children: [
              Icon(Icons.email, size: 16, color: Colors.grey.shade600),
              SizedBox(width: 4),
              Expanded(
                child: Text(
                  value.toString(),
                  style: TextStyle(color: Colors.blue.shade600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );
        },
      ),
      GridColumn(
        id: 'status',
        title: 'Status',
        sortable: true,
        filterable: true,
        searchable: true,
        groupable: true,
        width: 120.0,
        columnType: ColumnType.string,
        filterConfig: FilterConfig(
          columnType: ColumnType.string,
          availableOperations: ['equals', 'contains'],
          defaultOperation: 'equals',
          defaultValue: '',
        ),
        cellBuilder: (context, value, index) {
          final isActive = value == 'Active';
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isActive ? Colors.green.shade100 : Colors.red.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isActive ? Colors.green.shade300 : Colors.red.shade300,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isActive ? Icons.check_circle : Icons.cancel,
                  size: 12,
                  color: isActive ? Colors.green.shade700 : Colors.red.shade700,
                ),
                SizedBox(width: 4),
                Text(
                  value.toString(),
                  style: TextStyle(
                    color: isActive ? Colors.green.shade700 : Colors.red.shade700,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        },
      ),
      GridColumn(
        id: 'role',
        title: 'Role',
        sortable: true,
        filterable: true,
        searchable: true,
        groupable: true,
        width: 140.0,
        columnType: ColumnType.string,
        filterConfig: FilterConfig(
          columnType: ColumnType.string,
          availableOperations: ['equals', 'contains'],
          defaultOperation: 'equals',
          defaultValue: '',
        ),
        cellBuilder: (context, value, index) {
          final roleColors = {
            'Admin': Colors.purple,
            'Manager': Colors.orange,
            'Developer': Colors.blue,
            'Designer': Colors.pink,
            'Tester': Colors.teal,
            'Analyst': Colors.indigo,
            'Support': Colors.amber,
          };
          final color = roleColors[value] ?? Colors.grey;
          
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.shade300, width: 1),
            ),
            child: Text(
              value.toString(),
              style: TextStyle(
                color: color.shade700,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          );
        },
      ),
      GridColumn(
        id: 'department',
        title: 'Department',
        sortable: true,
        filterable: true,
        searchable: true,
        groupable: true,
        width: 150.0,
        columnType: ColumnType.string,
        filterConfig: FilterConfig(
          columnType: ColumnType.string,
          availableOperations: ['equals', 'contains'],
          defaultOperation: 'equals',
          defaultValue: '',
        ),
        cellBuilder: (context, value, index) {
          return Row(
            children: [
              Icon(Icons.business, size: 16, color: Colors.grey.shade600),
              SizedBox(width: 4),
              Expanded(
                child: Text(
                  value.toString(),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );
        },
      ),
      GridColumn(
        id: 'lastLogin',
        title: 'Last Login',
        sortable: true,
        filterable: true,
        searchable: true,
        groupable: true,
        width: 160.0,
        columnType: ColumnType.date,
        filterConfig: FilterConfig(
          columnType: ColumnType.date,
          availableOperations: ['equals', 'before', 'after', 'today'],
          defaultOperation: 'equals',
          defaultValue: '',
        ),
        cellBuilder: (context, value, index) {
          return Row(
            children: [
              Icon(Icons.access_time, size: 16, color: Colors.grey.shade600),
              SizedBox(width: 4),
              Expanded(
                child: Text(
                  value.toString(),
                  style: TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );
        },
      ),
      GridColumn(
        id: 'salary',
        title: 'Salary',
        sortable: true,
        filterable: true,
        searchable: true,
        groupable: true,
        width: 120.0,
        columnType: ColumnType.currency,
        filterConfig: FilterConfig(
          columnType: ColumnType.currency,
          availableOperations: ['equals', 'greaterThan', 'lessThan', 'between'],
          defaultOperation: 'greaterThan',
          defaultValue: '',
        ),
        cellBuilder: (context, value, index) {
          final salary = double.tryParse(value.toString()) ?? 0.0;
          return Text(
            '\$${salary.toStringAsFixed(0)}',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.green.shade700,
            ),
          );
        },
      ),
    ];

    // Generate sample data
    rows = List.generate(100, (index) {
      final id = index + 1;
      final names = [
        'John Smith', 'Sarah Johnson', 'Michael Brown', 'Emily Davis', 'David Wilson',
        'Lisa Anderson', 'James Taylor', 'Jennifer Martinez', 'Robert Garcia', 'Amanda Rodriguez',
        'William Lopez', 'Jessica Lee', 'Christopher White', 'Ashley Clark', 'Daniel Hall',
        'Nicole Young', 'Matthew King', 'Stephanie Wright', 'Andrew Green', 'Rachel Baker'
      ];
      final emails = [
        'john.smith@company.com', 'sarah.johnson@company.com', 'michael.brown@company.com',
        'emily.davis@company.com', 'david.wilson@company.com', 'lisa.anderson@company.com',
        'james.taylor@company.com', 'jennifer.martinez@company.com', 'robert.garcia@company.com',
        'amanda.rodriguez@company.com', 'william.lopez@company.com', 'jessica.lee@company.com',
        'christopher.white@company.com', 'ashley.clark@company.com', 'daniel.hall@company.com',
        'nicole.young@company.com', 'matthew.king@company.com', 'stephanie.wright@company.com',
        'andrew.green@company.com', 'rachel.baker@company.com'
      ];
      final statuses = ['Active', 'Inactive', 'Pending'];
      final roles = ['Admin', 'Manager', 'Developer', 'Designer', 'Tester', 'Analyst', 'Support'];
      final departments = ['Engineering', 'Marketing', 'Sales', 'HR', 'Finance', 'Operations'];
      final salaries = [45000, 55000, 65000, 75000, 85000, 95000, 105000, 115000, 125000, 135000];

      return GridRow(
        id: id.toString(),
        data: {
          'id': id,
          'name': names[id % names.length],
          'email': emails[id % emails.length],
          'status': statuses[id % statuses.length],
          'role': roles[id % roles.length],
          'department': departments[id % departments.length],
          'lastLogin': '2024-${(id % 12 + 1).toString().padLeft(2, '0')}-${(id % 28 + 1).toString().padLeft(2, '0')}',
          'salary': salaries[id % salaries.length],
        },
      );
    });

    // Configure actions
    actions = GridActions(
      onSearch: (term) {
        setState(() {
          searchTerm = term;
        });
        print('Search: $term');
      },
      onFilter: (columnId, value) {
        setState(() {
          if (value.isEmpty) {
            filters.remove(columnId);
          } else {
            filters[columnId] = value;
          }
        });
        print('Filter: $columnId = $value');
      },
      onColumnSort: (columnId, title, ascending) {
        setState(() {
          sortColumn = columnId;
          sortAscending = ascending;
        });
        print('Sort: $columnId ($title) ${ascending ? 'asc' : 'desc'}');
      },
      onRowSelected: (rowId, data) {
        setState(() {
          if (selectedRowIds.contains(rowId)) {
            selectedRowIds.remove(rowId);
          } else {
            selectedRowIds.add(rowId);
          }
        });
        print('Row selected: $rowId');
      },
      onRowTap: (rowId, data, index) {
        print('Row tapped: $rowId at index $index');
      },
      onPageChanged: (page, itemsPerPage) {
        setState(() {
          currentPage = page;
        });
        print('Page changed: $page');
      },
      onItemsPerPageChanged: (itemsPerPage) {
        setState(() {
          this.itemsPerPage = itemsPerPage;
          currentPage = 1;
        });
        print('Items per page changed: $itemsPerPage');
      },
      onGroupingChanged: (groupedColumns) {
        print('Grouping changed: $groupedColumns');
      },
    );

    // Configure grid
    config = GridConfig(
      showSelection: true,
      showActions: true,
      showFilter: true,
      showSearch: true,
      showPagination: true,
      showToolbar: true,
      showHeader: true,
      showFooter: true,
      allowMultiSelection: true,
      gridHeight: null, // Take full available height
      gridWidth: null, // Take full available width
      margin: EdgeInsets.zero, // Remove margin to take full space
      padding: EdgeInsets.zero, // Remove padding to take full space
      autoFilterBackgroundColor: Colors.grey.shade50,
      autoFilterBorderColor: Colors.grey.shade300,
      headerBackgroundColor: Colors.white,
      headerTextColor: Colors.grey.shade800,
      rowBackgroundColor: Colors.white,
      rowBorderColor: Colors.grey.shade200,
      mobileBreakpoint: 768,
      tabletBreakpoint: 1024,
      mobileMinColumnWidth: 120,
      tabletMinColumnWidth: 150,
      tabletMaxColumnWidth: 300,
      desktopDefaultColumnWidth: 200,
      emptyStateMessage: 'No data available',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DevExtreme-Style DataGrid'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          // Clear filters button
          IconButton(
            onPressed: () {
              setState(() {
                searchTerm = '';
                filters.clear();
                sortColumn = null;
                sortAscending = null;
                selectedRowIds.clear();
                currentPage = 1;
                filterExpression = null;
              });
            },
            icon: Icon(Icons.clear_all),
            tooltip: 'Clear All Filters',
          ),
          // Export button
          IconButton(
            onPressed: () {
              _showExportDialog();
            },
            icon: Icon(Icons.download),
            tooltip: 'Export Data',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: CustomGridWidget(
              columns: columns,
              rows: rows,
              config: config,
              actions: actions,
              isLoading: isLoading,
              searchTerm: searchTerm,
              filters: filters,
              sortColumn: sortColumn,
              sortAscending: sortAscending,
              selectedRowIds: selectedRowIds,
              currentPage: currentPage,
              itemsPerPage: itemsPerPage,
              showHeaderFilters: true,
              showGrouping: true,
              showSummaries: true,
              showMasterDetail: false,
            ),
          ),
        ],
      ),
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
              SizedBox(width: 8),
              Text('Export Data'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.table_chart, color: Colors.green.shade600),
                title: Text('Excel (.xlsx)'),
                subtitle: Text('Export to Excel format'),
                onTap: () {
                  Navigator.of(context).pop();
                  _exportData('excel');
                },
              ),
              ListTile(
                leading: Icon(Icons.picture_as_pdf, color: Colors.red.shade600),
                title: Text('PDF (.pdf)'),
                subtitle: Text('Export to PDF format'),
                onTap: () {
                  Navigator.of(context).pop();
                  _exportData('pdf');
                },
              ),
              ListTile(
                leading: Icon(Icons.description, color: Colors.blue.shade600),
                title: Text('CSV (.csv)'),
                subtitle: Text('Export to CSV format'),
                onTap: () {
                  Navigator.of(context).pop();
                  _exportData('csv');
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _exportData(String format) {
    // Simulate export
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Exporting data to $format format...'),
        backgroundColor: Colors.green.shade600,
      ),
    );
  }
} 