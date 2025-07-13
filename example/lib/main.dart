import 'package:flutter/material.dart';
import 'package:dexef_grid/dexef_grid.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dexef Grid Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
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
    // Define columns with responsive configuration
    columns = [
      GridColumn(
        id: 'id',
        title: 'ID',
        sortable: true,
        searchable: true,
        width: 100.0, // Fixed width for ID column
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
        width: null, // Will use responsive width calculation
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
        width: null, // Will use responsive width calculation
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
        width: 140.0, // Fixed width for status column
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
        width: 160.0, // Fixed width for role column
        cellBuilder: (context, value, index) {
          final roleColors = {
            'Admin': Colors.purple,
            'Manager': Colors.orange,
            'Developer': Colors.blue,
            'Designer': Colors.pink,
            'Tester': Colors.teal,
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
        id: 'lastLogin',
        title: 'Last Login',
        sortable: true,
        width: null, // Will use responsive width calculation
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
    ];

    // Generate sample data
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

    // Configure responsive settings
    config = GridConfig(
      // Visual styling
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
      borderRadius: BorderRadius.circular(8),
      shadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ],
      
      // Responsive configuration - Mobile optimized
      mobileMinColumnWidth: 120.0, // Increased minimum width
      mobileMaxColumnWidth: 200.0,
      mobileRowHeight: 70.0,
      mobileHeaderHeight: 60.0,
      showMobileHeaders: true,
      enableMobileHorizontalScroll: true, // Always enabled
      
      tabletMinColumnWidth: 140.0, // Increased for better tablet layout
      tabletMaxColumnWidth: 400.0, // Increased max width
      tabletRowHeight: 60.0,
      tabletHeaderHeight: 55.0,
      showTabletHeaders: true,
      enableTabletHorizontalScroll: true,
      
      desktopDefaultColumnWidth: 250.0, // Increased default width
      desktopRowHeight: 55.0,
      desktopHeaderHeight: 50.0,
      showDesktopHeaders: true,
      enableDesktopHorizontalScroll: true,
      
      // Breakpoints
      mobileBreakpoint: 768.0,
      tabletBreakpoint: 1024.0,
      
      // Other settings
      showSelection: true,
      showSearch: true,
      showFilter: true,
      showPagination: true,
      showActions: true,
      allowMultiSelection: true,
      itemsPerPage: 10,
      itemsPerPageOptions: [5, 10, 20, 50],
      searchPlaceholder: 'Search users...',
    );
  }

  List<GridRow> _generateSampleData() {
    final names = [
      'John Doe',
      'Jane Smith',
      'Mike Johnson',
      'Sarah Wilson',
      'David Brown',
      'Emily Davis',
      'Robert Miller',
      'Lisa Garcia',
      'James Rodriguez',
      'Maria Martinez',
      'Christopher Lee',
      'Jennifer Taylor',
      'Daniel Anderson',
      'Amanda Thomas',
      'Matthew Jackson',
    ];

    final roles = ['Admin', 'Manager', 'Developer', 'Designer', 'Tester'];
    final statuses = ['Active', 'Inactive'];
    final domains = ['gmail.com', 'yahoo.com', 'hotmail.com', 'outlook.com'];

    return List.generate(15, (index) {
      final name = names[index];
      final email = '${name.toLowerCase().replaceAll(' ', '.')}@${domains[index % domains.length]}';
      final role = roles[index % roles.length];
      final status = statuses[index % statuses.length];
      final lastLogin = DateTime.now().subtract(Duration(days: index % 30));

      return GridRow(
        id: '${index + 1}',
        data: {
          'id': '${index + 1}',
          'name': name,
          'email': email,
          'status': status,
          'role': role,
          'lastLogin': _formatDate(lastLogin),
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
        title: Text('User Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${rowData['id']}'),
            Text('Name: ${rowData['name']}'),
            Text('Email: ${rowData['email']}'),
            Text('Status: ${rowData['status']}'),
            Text('Role: ${rowData['role']}'),
            Text('Last Login: ${rowData['lastLogin']}'),
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
                SnackBar(content: Text('User updated successfully!')),
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
                SnackBar(content: Text('User deleted successfully!')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _refreshData() {
    setState(() {
      isLoading = true;
    });
    
    // Simulate loading
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
        rows = _generateSampleData();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dexef Grid - Responsive Example'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshData,
            tooltip: 'Refresh Data',
          ),
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () => _showInfo(),
            tooltip: 'Info',
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Info card
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Responsive Grid Demo',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'This grid automatically adapts to different screen sizes. Try resizing your browser window or testing on mobile devices.',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.phone_android, size: 16, color: Colors.green),
                            SizedBox(width: 4),
                            Text('Mobile: < 768px'),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.tablet_android, size: 16, color: Colors.orange),
                            SizedBox(width: 4),
                            Text('Tablet: 768px - 1024px'),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.desktop_windows, size: 16, color: Colors.blue),
                            SizedBox(width: 4),
                            Text('Desktop: > 1024px'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            
            // Grid
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
                totalItems: rows.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('About Dexef Grid'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Features demonstrated:'),
            SizedBox(height: 8),
            Text('• Responsive design (mobile/tablet/desktop)'),
            Text('• Column sorting and filtering'),
            Text('• Global search functionality'),
            Text('• Row selection (single/multi)'),
            Text('• Custom cell builders'),
            Text('• Row actions (view/edit/delete)'),
            Text('• Pagination'),
            Text('• Loading states'),
            Text('• Custom styling'),
            SizedBox(height: 8),
            Text('Try resizing the window to see the responsive behavior!'),
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
} 