import 'package:flutter/material.dart';
import 'package:dexef_grid/dexef_grid.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Advanced Dexef Grid Example',
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

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    // Define columns with advanced features
    columns = [
      GridColumn(
        id: 'id',
        title: 'ID',
        sortable: true,
        searchable: true,
        filterable: true,
        width: 80.0,
        alignment: Alignment.center,
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
        width: null,
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
        width: null,
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
        width: 120.0,
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
        width: 140.0,
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
        width: 140.0,
        cellBuilder: (context, value, index) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              value.toString(),
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          );
        },
      ),
      GridColumn(
        id: 'lastLogin',
        title: 'Last Login',
        sortable: true,
        filterable: true,
        width: null,
        cellBuilder: (context, value, index) {
          return Row(
            children: [
              Icon(Icons.access_time, size: 14, color: Colors.grey.shade600),
              SizedBox(width: 4),
              Expanded(
                child: Text(
                  value.toString(),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
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
        width: 120.0,
        cellBuilder: (context, value, index) {
          final salary = double.tryParse(value.toString()) ?? 0.0;
          final isHighSalary = salary > 80000;
          
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isHighSalary ? Colors.green.shade100 : Colors.orange.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '\$${salary.toStringAsFixed(0)}',
              style: TextStyle(
                color: isHighSalary ? Colors.green.shade700 : Colors.orange.shade700,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          );
        },
      ),
    ];

    // Generate sample data with more variety
    rows = _generateSampleData();

    // Configure actions
    actions = GridActions(
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
      onMultiRowSelected: (rowIds, rowData) {
        print('Multiple rows selected: $rowIds');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${rowIds.length} rows selected'),
            duration: Duration(seconds: 2),
          ),
        );
      },
      onSearch: (term) {
        setState(() {
          searchTerm = term;
          currentPage = 1;
        });
        print('Searching for: $term');
      },
      onFilter: (columnId, value) {
        setState(() {
          if (value.isEmpty) {
            // Remove all filters for this column (regardless of filter type)
            filters.removeWhere((key, _) => key.startsWith('${columnId.split('|')[0]}|'));
          } else {
            // Parse the columnId to get the actual column ID and filter type
            final parts = columnId.split('|');
            final actualColumnId = parts[0];
            final filterType = parts.length > 1 ? parts[1] : 'contains';
            
            // Remove any existing filters for this column
            filters.removeWhere((key, _) => key.startsWith('$actualColumnId|'));
            
            // Add the new filter with the correct key format
            filters[columnId] = value;
          }
          currentPage = 1;
        });
        print('Filtering $columnId: $value');
      },
      onColumnSort: (columnId, columnTitle, ascending) {
        setState(() {
          sortColumn = columnId;
          sortAscending = ascending;
        });
        print('Sorting $columnTitle: ${ascending ? 'ascending' : 'descending'}');
      },
      onPageChanged: (page, itemsPerPage) {
        setState(() {
          currentPage = page;
        });
        print('Page changed to: $page');
      },
      onItemsPerPageChanged: (itemsPerPage) {
        setState(() {
          this.itemsPerPage = itemsPerPage;
          currentPage = 1;
        });
        print('Items per page changed to: $itemsPerPage');
      },
      onActionTriggered: (actionId, rowId, rowData) {
        _handleRowAction(actionId, rowId, rowData);
      },
    );

    // Configure advanced responsive settings
    config = GridConfig(
      // Visual styling with modern design
      backgroundColor: Colors.white,
      headerBackgroundColor: Colors.grey.shade50,
      rowBackgroundColor: Colors.white,
      selectedRowBackgroundColor: Colors.blue.shade50,
      hoverRowBackgroundColor: Colors.grey.shade50,
      headerTextColor: Colors.grey.shade800,
      rowTextColor: Colors.grey.shade900,
      selectedRowTextColor: Colors.blue.shade800,
      borderColor: Colors.grey.shade200,
      rowBorderColor: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(12),
      shadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 8,
          offset: Offset(0, 2),
        ),
      ],
      
      // Responsive configuration - Enhanced for all devices
      mobileMinColumnWidth: 100.0,
      mobileMaxColumnWidth: 200.0,
      mobileRowHeight: 70.0,
      mobileHeaderHeight: 60.0,
      showMobileHeaders: true,
      enableMobileHorizontalScroll: true,
      
      tabletMinColumnWidth: 120.0,
      tabletMaxColumnWidth: 300.0,
      tabletRowHeight: 60.0,
      tabletHeaderHeight: 55.0,
      showTabletHeaders: true,
      enableTabletHorizontalScroll: true,
      
      desktopDefaultColumnWidth: 200.0,
      desktopRowHeight: 55.0,
      desktopHeaderHeight: 50.0,
      showDesktopHeaders: true,
      enableDesktopHorizontalScroll: true,
      
      // Breakpoints
      mobileBreakpoint: 768.0,
      tabletBreakpoint: 1024.0,
      
      // Advanced features
      showSelection: true,
      showSearch: true,
      showFilter: true,
      showPagination: true,
      showActions: true,
      allowMultiSelection: true,
      allowSorting: true,
      allowFiltering: true,
      allowSearching: true,
      itemsPerPage: 10,
      itemsPerPageOptions: [5, 10, 20, 50, 100],
      searchPlaceholder: 'Search users, emails, roles...',
      emptyStateMessage: 'No users found matching your criteria',
      loadingStateMessage: 'Loading users...',
      errorStateMessage: 'Error loading users',
    );
  }

  List<GridRow> _generateSampleData() {
    final names = [
      'John Doe', 'Jane Smith', 'Mike Johnson', 'Sarah Wilson', 'David Brown',
      'Emily Davis', 'Robert Miller', 'Lisa Garcia', 'James Rodriguez', 'Maria Martinez',
      'Christopher Lee', 'Jennifer Taylor', 'Daniel Anderson', 'Amanda Thomas', 'Matthew Jackson',
      'Jessica White', 'Andrew Harris', 'Nicole Clark', 'Kevin Lewis', 'Stephanie Walker',
      'Brian Hall', 'Laura Allen', 'Steven Young', 'Michelle King', 'Timothy Wright',
      'Ashley Lopez', 'Jason Hill', 'Rebecca Scott', 'Eric Green', 'Melissa Baker',
      'Adam Adams', 'Kimberly Nelson', 'Ryan Carter', 'Heather Mitchell', 'Jonathan Perez',
    ];

    final roles = ['Admin', 'Manager', 'Developer', 'Designer', 'Tester', 'Analyst', 'Support'];
    final statuses = ['Active', 'Inactive', 'Pending'];
    final departments = ['Engineering', 'Design', 'Marketing', 'Sales', 'Support', 'HR', 'Finance'];
    final domains = ['gmail.com', 'yahoo.com', 'hotmail.com', 'outlook.com', 'company.com'];

    return List.generate(35, (index) {
      final name = names[index];
      final email = '${name.toLowerCase().replaceAll(' ', '.')}@${domains[index % domains.length]}';
      final role = roles[index % roles.length];
      final status = statuses[index % statuses.length];
      final department = departments[index % departments.length];
      final lastLogin = DateTime.now().subtract(Duration(days: index % 30));
      final salary = 50000 + (index * 2000) + (index % 5 * 5000);

      return GridRow(
        id: '${index + 1}',
        data: {
          'id': '${index + 1}',
          'name': name,
          'email': email,
          'status': status,
          'role': role,
          'department': department,
          'lastLogin': _formatDate(lastLogin),
          'salary': salary.toString(),
        },
        actions: [
          GridAction(
            id: 'view',
            title: 'View Details',
            icon: Icons.visibility,
            onTap: (rowId, data) => _showDetails(rowId, data),
          ),
          GridAction(
            id: 'edit',
            title: 'Edit User',
            icon: Icons.edit,
            onTap: (rowId, data) => _editUser(rowId, data),
          ),
          GridAction(
            id: 'delete',
            title: 'Delete User',
            icon: Icons.delete,
            onTap: (rowId, data) => _deleteUser(rowId, data),
          ),
        ],
      );
    });
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _handleRowAction(String actionId, String rowId, Map<String, dynamic> rowData) {
    switch (actionId) {
      case 'view':
        _showDetails(rowId, rowData);
        break;
      case 'edit':
        _editUser(rowId, rowData);
        break;
      case 'delete':
        _deleteUser(rowId, rowData);
        break;
    }
  }

  void _showDetails(String rowId, Map<String, dynamic> rowData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              child: Text(
                rowData['name'].toString().substring(0, 1).toUpperCase(),
                style: TextStyle(color: Colors.blue.shade800, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(width: 12),
            Expanded(child: Text('User Details')),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('ID', rowData['id']),
            _buildDetailRow('Name', rowData['name']),
            _buildDetailRow('Email', rowData['email']),
            _buildDetailRow('Status', rowData['status']),
            _buildDetailRow('Role', rowData['role']),
            _buildDetailRow('Department', rowData['department']),
            _buildDetailRow('Last Login', rowData['lastLogin']),
            _buildDetailRow('Salary', '\$${rowData['salary']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey.shade700),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.grey.shade900),
            ),
          ),
        ],
      ),
    );
  }

  void _editUser(String rowId, Map<String, dynamic> rowData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit User'),
        content: Text('Edit functionality for user: ${rowData['name']}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('User ${rowData['name']} updated successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteUser(String rowId, Map<String, dynamic> rowData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete User'),
        content: Text('Are you sure you want to delete ${rowData['name']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                rows.removeWhere((row) => row.id == rowId);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('User ${rowData['name']} deleted successfully!'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Advanced Grid Example'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (selectedRowIds.isNotEmpty) ...[
            Container(
              margin: EdgeInsets.only(right: 16),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '${selectedRowIds.length} selected',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
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
                  totalItems: rows.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 