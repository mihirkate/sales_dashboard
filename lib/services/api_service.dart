import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../models/sales_data.dart';

class ApiService {
  static const String baseUrl =
      'https://dashboard-server-kvj9.onrender.com/api/v1/dashboard';

  static Future<List<SalesData>> fetchSalesDashboard({
    DashboardFilter? filter,
  }) async {
    String url = '$baseUrl/sales-dashboard';

    if (filter != null) {
      final params = filter.toQueryParams();
      if (params.isNotEmpty) {
        url += '?' + params.entries.map((e) => '${e.key}=${e.value}').join('&');
      }
    }

    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      final List<dynamic> data = json.decode(res.body)['data'];
      return data.map((e) => SalesData.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch sales dashboard data');
    }
  }

  static Future<DashboardSummary> fetchMetrics() async {
    const url = '$baseUrl/metrics';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      return DashboardSummary.fromJson(jsonBody);
    } else {
      throw Exception('Failed to fetch metrics');
    }
  }

  static Future<List<MonthlySalesData>> fetchMonthlySales() async {
    final res = await http.get(
      Uri.parse('$baseUrl/monthly-sales?period=month&year=2024'),
    );
    if (res.statusCode == 200) {
      final List<dynamic> data = json.decode(res.body)['data'];
      return data.map((e) => MonthlySalesData.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch monthly sales');
    }
  }

  static Future<List<TrendsData>> fetchTrends() async {
    final res = await http.get(Uri.parse('$baseUrl/trends'));
    if (res.statusCode == 200) {
      final List<dynamic> data = json.decode(res.body)['data'];
      return data.map((e) => TrendsData.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch trends');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchAnalytics({
    String groupBy = 'month',
    String metric = 'revenue',
  }) async {
    final res = await http.get(
      Uri.parse('$baseUrl/analytics?groupBy=$groupBy&metric=$metric'),
    );
    if (res.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(res.body)['data']);
    } else {
      throw Exception('Failed to fetch analytics');
    }
  }

  static Future<FilterOptions> fetchAdvancedFilters() async {
    final res = await http.get(Uri.parse('$baseUrl/advanced-filter'));
    if (res.statusCode == 200) {
      return FilterOptions.fromJson(json.decode(res.body)['data']);
    } else {
      throw Exception('Failed to fetch filter options');
    }
  }

  static Future<List<SearchSuggestion>> fetchSearchSuggestions({
    String? query,
  }) async {
    String url = '$baseUrl/search-suggestions';
    if (query != null && query.isNotEmpty) {
      url += '?query=$query';
    }

    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      final List<dynamic> data = json.decode(res.body)['data'];
      return data.map((e) => SearchSuggestion.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch search suggestions');
    }
  }

  static Future<String> exportData({
    String format = 'csv',
    String fields = 'name,revenue,city,sales,status,industry',
    DashboardFilter? filter,
  }) async {
    String url = '$baseUrl/export?format=$format&fields=$fields';

    if (filter != null) {
      final params = filter.toQueryParams();
      params.forEach((key, value) {
        url += '&$key=$value';
      });
    }

    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      // Save file to downloads directory
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'sales_data_$timestamp.$format';
      final file = File('${directory.path}/$fileName');
      await file.writeAsString(res.body);
      return file.path;
    } else {
      throw Exception('Failed to export data');
    }
  }
}
