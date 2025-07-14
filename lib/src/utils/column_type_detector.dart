import '../models/grid_column.dart';

/// Utility class for detecting column types automatically
class ColumnTypeDetector {
  /// Detects the type of a column based on its data
  static ColumnType detectType(List<dynamic> values) {
    if (values.isEmpty) return ColumnType.string;
    
    // Remove null values for analysis
    final nonNullValues = values.where((value) => value != null).toList();
    if (nonNullValues.isEmpty) return ColumnType.string;
    
    // Check if all values are booleans
    if (_isBooleanColumn(nonNullValues)) {
      return ColumnType.boolean;
    }
    
    // Check if all values are numbers
    if (_isNumberColumn(nonNullValues)) {
      return ColumnType.number;
    }
    
    // Check if all values are dates
    if (_isDateColumn(nonNullValues)) {
      return ColumnType.date;
    }
    
    // Check if all values are emails
    if (_isEmailColumn(nonNullValues)) {
      return ColumnType.email;
    }
    
    // Check if all values are URLs
    if (_isUrlColumn(nonNullValues)) {
      return ColumnType.url;
    }
    
    // Check if all values are phone numbers
    if (_isPhoneColumn(nonNullValues)) {
      return ColumnType.phone;
    }
    
    // Check if all values are currency
    if (_isCurrencyColumn(nonNullValues)) {
      return ColumnType.currency;
    }
    
    // Check if all values are percentages
    if (_isPercentageColumn(nonNullValues)) {
      return ColumnType.percentage;
    }
    
    return ColumnType.string;
  }
  
  /// Gets available filter operations for a column type
  static List<String> getFilterOperations(ColumnType type) {
    switch (type) {
      case ColumnType.string:
        return ['contains', 'equals', 'startsWith', 'endsWith', 'notContains', 'isEmpty', 'isNotEmpty'];
      case ColumnType.number:
        return ['equals', 'greaterThan', 'lessThan', 'between', 'isNull', 'isNotNull'];
      case ColumnType.date:
        return ['equals', 'before', 'after', 'between', 'today', 'thisWeek', 'thisMonth', 'thisYear'];
      case ColumnType.boolean:
        return ['equals', 'isTrue', 'isFalse'];
      case ColumnType.email:
        return ['contains', 'equals', 'domainEquals', 'isValidEmail'];
      case ColumnType.url:
        return ['contains', 'equals', 'domainEquals', 'protocolEquals'];
      case ColumnType.phone:
        return ['contains', 'equals', 'startsWith', 'endsWith'];
      case ColumnType.currency:
        return ['equals', 'greaterThan', 'lessThan', 'between'];
      case ColumnType.percentage:
        return ['equals', 'greaterThan', 'lessThan', 'between'];
      case ColumnType.unknown:
        return ['contains', 'equals', 'startsWith', 'endsWith'];
    }
  }
  
  /// Gets default filter operation for a column type
  static String getDefaultOperation(ColumnType type) {
    switch (type) {
      case ColumnType.string:
      case ColumnType.email:
      case ColumnType.url:
      case ColumnType.phone:
        return 'contains';
      case ColumnType.number:
      case ColumnType.currency:
      case ColumnType.percentage:
        return 'equals';
      case ColumnType.date:
        return 'equals';
      case ColumnType.boolean:
        return 'equals';
      case ColumnType.unknown:
        return 'contains';
    }
  }
  
  /// Checks if values are boolean
  static bool _isBooleanColumn(List<dynamic> values) {
    return values.every((value) => 
      value is bool || 
      (value is String && ['true', 'false', 'yes', 'no', '1', '0'].contains(value.toLowerCase()))
    );
  }
  
  /// Checks if values are numbers
  static bool _isNumberColumn(List<dynamic> values) {
    return values.every((value) {
      if (value is num) return true;
      if (value is String) {
        try {
          double.parse(value.replaceAll(',', ''));
          return true;
        } catch (e) {
          return false;
        }
      }
      return false;
    });
  }
  
  /// Checks if values are dates
  static bool _isDateColumn(List<dynamic> values) {
    final datePatterns = [
      RegExp(r'^\d{4}-\d{2}-\d{2}$'), // YYYY-MM-DD
      RegExp(r'^\d{2}/\d{2}/\d{4}$'), // MM/DD/YYYY
      RegExp(r'^\d{2}-\d{2}-\d{4}$'), // MM-DD-YYYY
      RegExp(r'^\d{4}/\d{2}/\d{2}$'), // YYYY/MM/DD
    ];
    
    return values.every((value) {
      if (value is DateTime) return true;
      if (value is String) {
        return datePatterns.any((pattern) => pattern.hasMatch(value));
      }
      return false;
    });
  }
  
  /// Checks if values are emails
  static bool _isEmailColumn(List<dynamic> values) {
    final emailPattern = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return values.every((value) => 
      value is String && emailPattern.hasMatch(value)
    );
  }
  
  /// Checks if values are URLs
  static bool _isUrlColumn(List<dynamic> values) {
    final urlPattern = RegExp(r'^https?://[^\s/$.?#].[^\s]*$');
    return values.every((value) => 
      value is String && urlPattern.hasMatch(value)
    );
  }
  
  /// Checks if values are phone numbers
  static bool _isPhoneColumn(List<dynamic> values) {
    final phonePattern = RegExp(r'^[\+]?[1-9][\d]{0,15}$');
    return values.every((value) => 
      value is String && phonePattern.hasMatch(value.replaceAll(RegExp(r'[\s\-\(\)]'), ''))
    );
  }
  
  /// Checks if values are currency
  static bool _isCurrencyColumn(List<dynamic> values) {
    final currencyPattern = RegExp(r'^\$[\d,]+\.?\d*$');
    return values.every((value) => 
      value is String && currencyPattern.hasMatch(value)
    );
  }
  
  /// Checks if values are percentages
  static bool _isPercentageColumn(List<dynamic> values) {
    final percentagePattern = RegExp(r'^\d+\.?\d*%$');
    return values.every((value) => 
      value is String && percentagePattern.hasMatch(value)
    );
  }
} 