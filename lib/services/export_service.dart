import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import '../models/sales_data.dart';

class ExportService {
  static Future<String> exportSalesDataToCsv(
    List<SalesData> salesData, {
    List<String>? selectedFields,
  }) async {
    // Default fields if none specified
    final fields =
        selectedFields ??
        [
          'name',
          'city',
          'revenue',
          'sales',
          'walkIns',
          'industry',
          'status',
          'probability',
          'dealSize',
          'customerName',
          'phone',
          'email',
          'priority',
          'leadSource',
          'region',
          'department',
        ];

    // Create CSV data
    List<List<dynamic>> csvData = [];

    // Add headers
    csvData.add(fields.map((field) => _getFieldDisplayName(field)).toList());

    // Add data rows
    for (final data in salesData) {
      List<dynamic> row = [];
      for (final field in fields) {
        row.add(_getFieldValue(data, field));
      }
      csvData.add(row);
    }

    // Convert to CSV string
    String csvString = const ListToCsvConverter().convert(csvData);

    // Save to file
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = 'sales_data_export_$timestamp.csv';
    final file = File('${directory.path}/$fileName');
    await file.writeAsString(csvString);

    return file.path;
  }

  static String _getFieldDisplayName(String field) {
    switch (field) {
      case 'name':
        return 'Name';
      case 'city':
        return 'City';
      case 'revenue':
        return 'Revenue';
      case 'sales':
        return 'Sales';
      case 'walkIns':
        return 'Walk-ins';
      case 'industry':
        return 'Industry';
      case 'status':
        return 'Status';
      case 'probability':
        return 'Probability %';
      case 'dealSize':
        return 'Deal Size';
      case 'customerName':
        return 'Customer Name';
      case 'phone':
        return 'Phone';
      case 'email':
        return 'Email';
      case 'priority':
        return 'Priority';
      case 'leadSource':
        return 'Lead Source';
      case 'region':
        return 'Region';
      case 'department':
        return 'Department';
      case 'conversionRate':
        return 'Conversion Rate';
      case 'target':
        return 'Target';
      case 'createdAt':
        return 'Created Date';
      case 'lastUpdated':
        return 'Last Updated';
      case 'expectedCloseDate':
        return 'Expected Close Date';
      case 'lastContactDate':
        return 'Last Contact Date';
      case 'nextFollowUp':
        return 'Next Follow Up';
      case 'notes':
        return 'Notes';
      case 'tags':
        return 'Tags';
      default:
        return field.toUpperCase();
    }
  }

  static dynamic _getFieldValue(SalesData data, String field) {
    switch (field) {
      case 'name':
        return data.name;
      case 'city':
        return data.city;
      case 'revenue':
        return data.revenue;
      case 'sales':
        return data.sales;
      case 'walkIns':
        return data.walkIns;
      case 'industry':
        return data.industry;
      case 'status':
        return data.status;
      case 'probability':
        return data.probability;
      case 'dealSize':
        return data.dealSize;
      case 'customerName':
        return data.customerName;
      case 'phone':
        return data.phone;
      case 'email':
        return data.email;
      case 'priority':
        return data.priority;
      case 'leadSource':
        return data.leadSource;
      case 'region':
        return data.region;
      case 'department':
        return data.department;
      case 'conversionRate':
        return data.conversionRate;
      case 'target':
        return data.target;
      case 'createdAt':
        return data.createdAt > 0
            ? DateTime.fromMillisecondsSinceEpoch(data.createdAt).toString()
            : '';
      case 'lastUpdated':
        return data.lastUpdated > 0
            ? DateTime.fromMillisecondsSinceEpoch(data.lastUpdated).toString()
            : '';
      case 'expectedCloseDate':
        return data.expectedCloseDate;
      case 'lastContactDate':
        return data.lastContactDate;
      case 'nextFollowUp':
        return data.nextFollowUp;
      case 'notes':
        return data.notes;
      case 'tags':
        return data.tags.join(', ');
      default:
        return '';
    }
  }
}
