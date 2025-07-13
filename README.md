# Dexef Grid

A comprehensive, responsive Flutter data grid widget with advanced features for displaying, searching, filtering, sorting, and managing tabular data. Perfect for both mobile and web applications.

## Features

### 🎯 Core Functionality
- **Responsive Design**: Automatically adapts to mobile, tablet, and desktop screens
- **Data Display**: Flexible table/grid layout with customizable columns
- **Row Selection**: Single/multi-select with visual feedback
- **Sorting**: Column-based sorting with custom sort functions
- **Search**: Global search across searchable columns
- **Filtering**: Column-specific filtering with custom filter functions
- **Pagination**: Built-in pagination with configurable items per page

### 🎨 Customization
- **Visual Styling**: Extensive theming options (colors, borders, shadows)
- **Custom Builders**: Custom cell, header, and row builders
- **Responsive Layout**: Adaptive column widths and row heights
- **State Management**: Loading, error, and empty states

### ⚡ Advanced Features
- **Row Actions**: Context menus and action buttons per row
- **Column Configuration**: Resizable, reorderable, and fixed columns
- **Event Handling**: Comprehensive callback system for all interactions
- **Accessibility**: Built-in support for screen readers and keyboard navigation

## Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  dexef_grid: ^1.0.0
```

## Quick Start

```dart
import 'package:dexef_grid/dexef_grid.dart';

class MyGridPage extends StatefulWidget {
  @override
  _MyGridPageState createState() => _MyGridPageState();
}

class _MyGridPageState extends State<MyGridPage> {
  List<GridRow> rows = [];
  List<GridColumn> columns = [];
  GridConfig config = GridConfig();
  GridActions actions = GridActions();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    // Define columns
    columns = [
      GridColumn(
        id: 'name',
        title: 'Name',
        sortable: true,
        searchable: true,
        width: 200.0,
      ),
      GridColumn(
        id: 'email',
        title: 'Email',
        sortable: true,
        searchable: true,
        width: 250.0,
      ),
      GridColumn(
        id: 'status',
        title: 'Status',
        sortable: true,
        filterable: true,
        width: 120.0,
      ),
    ];

    // Define rows
    rows = [
      GridRow(
        id: '1',
        data: {
          'name': 'John Doe',
          'email': 'john@example.com',
          'status': 'Active',
        },
        actions: [
          GridAction(
            id: 'edit',
            title: 'Edit',
            icon: Icons.edit,
            onTap: (rowId, data) => print('Edit: $rowId'),
          ),
          GridAction(
            id: 'delete',
            title: 'Delete',
            icon: Icons.delete,
            onTap: (rowId, data) => print('Delete: $rowId'),
          ),
        ],
      ),
      GridRow(
        id: '2',
        data: {
          'name': 'Jane Smith',
          'email': 'jane@example.com',
          'status': 'Inactive',
        },
        actions: [
          GridAction(
            id: 'edit',
            title: 'Edit',
            icon: Icons.edit,
            onTap: (rowId, data) => print('Edit: $rowId'),
          ),
          GridAction(
            id: 'delete',
            title: 'Delete',
            icon: Icons.delete,
            onTap: (rowId, data) => print('Delete: $rowId'),
          ),
        ],
      ),
    ];

    // Configure actions
    actions = GridActions(
      onRowSelected: (rowId, data) => print('Selected: $rowId'),
      onSearch: (term) => print('Searching: $term'),
      onFilter: (columnId, value) => print('Filtering: $columnId = $value'),
      onPageChanged: (page, itemsPerPage) => print('Page: $page'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dexef Grid Example'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: CustomGridWidget(
          columns: columns,
          rows: rows,
          config: config,
          actions: actions,
        ),
      ),
    );
  }
}
```

## Responsive Configuration

The grid automatically adapts to different screen sizes. You can customize the responsive behavior:

```dart
GridConfig config = GridConfig(
  // Mobile settings
  mobileMinColumnWidth: 80.0,
  mobileMaxColumnWidth: 200.0,
  mobileRowHeight: 60.0,
  mobileHeaderHeight: 60.0,
  showMobileHeaders: true,
  enableMobileHorizontalScroll: true,
  
  // Tablet settings
  tabletMinColumnWidth: 120.0,
  tabletMaxColumnWidth: 300.0,
  tabletRowHeight: 55.0,
  tabletHeaderHeight: 55.0,
  showTabletHeaders: true,
  enableTabletHorizontalScroll: true,
  
  // Desktop settings
  desktopDefaultColumnWidth: 200.0,
  desktopRowHeight: 50.0,
  desktopHeaderHeight: 50.0,
  showDesktopHeaders: true,
  enableDesktopHorizontalScroll: true,
  
  // Breakpoints
  mobileBreakpoint: 768.0,
  tabletBreakpoint: 1024.0,
);
```

## Advanced Usage

### Custom Cell Builders

```dart
GridColumn(
  id: 'status',
  title: 'Status',
  cellBuilder: (context, value, index) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: value == 'Active' ? Colors.green : Colors.red,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        value.toString(),
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  },
)
```

### Custom Row Actions

```dart
GridRow(
  id: '1',
  data: {'name': 'John Doe', 'email': 'john@example.com'},
  actions: [
    GridAction(
      id: 'view',
      title: 'View Details',
      icon: Icons.visibility,
      onTap: (rowId, data) => _showDetails(rowId, data),
    ),
    GridAction(
      id: 'edit',
      title: 'Edit',
      icon: Icons.edit,
      onTap: (rowId, data) => _editRow(rowId, data),
    ),
    GridAction(
      id: 'delete',
      title: 'Delete',
      icon: Icons.delete,
      onTap: (rowId, data) => _deleteRow(rowId, data),
    ),
  ],
)
```

### Custom Styling

```dart
GridConfig config = GridConfig(
  backgroundColor: Colors.white,
  headerBackgroundColor: Colors.blue.shade50,
  rowBackgroundColor: Colors.white,
  selectedRowBackgroundColor: Colors.blue.shade100,
  hoverRowBackgroundColor: Colors.grey.shade50,
  headerTextColor: Colors.blue.shade900,
  rowTextColor: Colors.black87,
  selectedRowTextColor: Colors.blue.shade900,
  borderColor: Colors.grey.shade300,
  borderRadius: BorderRadius.circular(8),
  shadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ],
);
```

## API Reference

### GridColumn

| Property | Type | Description |
|----------|------|-------------|
| `id` | String | Unique identifier for the column |
| `title` | String | Display title for the column |
| `width` | double? | Width of the column |
| `sortable` | bool | Whether the column is sortable |
| `searchable` | bool | Whether the column is searchable |
| `filterable` | bool | Whether the column is filterable |
| `visible` | bool | Whether the column is visible |
| `cellBuilder` | Widget Function? | Custom cell builder |
| `headerBuilder` | Widget Function? | Custom header builder |

### GridRow

| Property | Type | Description |
|----------|------|-------------|
| `id` | String | Unique identifier for the row |
| `data` | Map<String, dynamic> | Data for the row |
| `isSelected` | bool | Whether the row is selected |
| `selectable` | bool | Whether the row is selectable |
| `actions` | List<GridAction>? | Actions available for this row |

### GridConfig

| Property | Type | Description |
|----------|------|-------------|
| `showHeader` | bool | Whether to show the header row |
| `showSelection` | bool | Whether to show row selection checkboxes |
| `showSearch` | bool | Whether to show search functionality |
| `showFilter` | bool | Whether to show filter functionality |
| `showPagination` | bool | Whether to show pagination |
| `allowMultiSelection` | bool | Whether to allow multiple row selection |
| `itemsPerPage` | int | Items per page for pagination |

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
