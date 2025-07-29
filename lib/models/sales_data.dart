class SalesData {
  final String id;
  final String name;
  final String avatar;
  final double sales;
  final double revenue;
  final int walkIns;
  final String city;
  final String status;
  final int createdAt;
  final String customerName;
  final int lastUpdated;
  final double conversionRate;
  final double target;
  final String industry;
  final String department;
  final String region;
  final String phone;
  final String email;
  final String priority;
  final String leadSource;
  final double dealSize;
  final double probability;
  final String expectedCloseDate;
  final List<String> tags;
  final String notes;
  final String lastContactDate;
  final String nextFollowUp;

  SalesData({
    required this.id,
    required this.name,
    required this.avatar,
    required this.sales,
    required this.revenue,
    required this.walkIns,
    required this.city,
    required this.status,
    required this.createdAt,
    required this.customerName,
    required this.lastUpdated,
    required this.conversionRate,
    required this.target,
    required this.industry,
    required this.department,
    required this.region,
    required this.phone,
    required this.email,
    required this.priority,
    required this.leadSource,
    required this.dealSize,
    required this.probability,
    required this.expectedCloseDate,
    required this.tags,
    required this.notes,
    required this.lastContactDate,
    required this.nextFollowUp,
  });

  factory SalesData.fromJson(Map<String, dynamic> json) {
    return SalesData(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      avatar: json['avatar']?.toString() ?? '',
      sales: (json['sales'] as num?)?.toDouble() ?? 0.0,
      revenue: (json['revenue'] as num?)?.toDouble() ?? 0.0,
      walkIns: json['walkIns'] ?? 0,
      city: json['city'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['createdAt'] ?? 0,
      customerName: json['customerName'] ?? '',
      lastUpdated: json['lastUpdated'] ?? 0,
      conversionRate: (json['conversionRate'] as num?)?.toDouble() ?? 0.0,
      target: (json['target'] as num?)?.toDouble() ?? 0.0,
      industry: json['industry'] ?? '',
      department: json['department'] ?? '',
      region: json['region'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      priority: json['priority'] ?? '',
      leadSource: json['leadSource'] ?? '',
      dealSize: (json['dealSize'] as num?)?.toDouble() ?? 0.0,
      probability: (json['probability'] as num?)?.toDouble() ?? 0.0,
      expectedCloseDate: json['expectedCloseDate'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      notes: json['notes'] ?? '',
      lastContactDate: json['lastContactDate'] ?? '',
      nextFollowUp: json['nextFollowUp'] ?? '',
    );
  }
}

class MonthlySalesData {
  final String month;
  final int sales;
  final int target;
  final double growth;
  final String date;
  final int customers;
  final int revenue;
  final int walkIns;
  final double conversionRate;
  final double averageOrderValue;
  final int newCustomers;
  final int returningCustomers;
  final int leads;
  final int closedDeals;
  final int pipeline;
  final double churnRate;
  final double satisfactionScore;

  MonthlySalesData({
    required this.month,
    required this.sales,
    required this.target,
    required this.growth,
    required this.date,
    required this.customers,
    required this.revenue,
    required this.walkIns,
    required this.conversionRate,
    required this.averageOrderValue,
    required this.newCustomers,
    required this.returningCustomers,
    required this.leads,
    required this.closedDeals,
    required this.pipeline,
    required this.churnRate,
    required this.satisfactionScore,
  });

  factory MonthlySalesData.fromJson(Map<String, dynamic> json) {
    return MonthlySalesData(
      month: json['month'] ?? '',
      sales: json['sales'] ?? 0,
      target: json['target'] ?? 0,
      growth: (json['growth'] as num?)?.toDouble() ?? 0.0,
      date: json['date'] ?? '',
      customers: json['customers'] ?? 0,
      revenue: json['revenue'] ?? 0,
      walkIns: json['walkIns'] ?? 0,
      conversionRate: (json['conversionRate'] as num?)?.toDouble() ?? 0.0,
      averageOrderValue: (json['averageOrderValue'] as num?)?.toDouble() ?? 0.0,
      newCustomers: json['newCustomers'] ?? 0,
      returningCustomers: json['returningCustomers'] ?? 0,
      leads: json['leads'] ?? 0,
      closedDeals: json['closedDeals'] ?? 0,
      pipeline: json['pipeline'] ?? 0,
      churnRate: (json['churnRate'] as num?)?.toDouble() ?? 0.0,
      satisfactionScore: (json['satisfactionScore'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class TrendsData {
  final String period;
  final int value;
  final double change;
  final int target;
  final String date;
  final int previousPeriod;
  final int benchmark;
  final int forecast;
  final double confidence;

  TrendsData({
    required this.period,
    required this.value,
    required this.change,
    required this.target,
    required this.date,
    required this.previousPeriod,
    required this.benchmark,
    required this.forecast,
    required this.confidence,
  });

  factory TrendsData.fromJson(Map<String, dynamic> json) {
    return TrendsData(
      period: json['period'] ?? '',
      value: json['value'] ?? 0,
      change: (json['change'] as num?)?.toDouble() ?? 0.0,
      target: json['target'] ?? 0,
      date: json['date'] ?? '',
      previousPeriod: json['previousPeriod'] ?? 0,
      benchmark: json['benchmark'] ?? 0,
      forecast: json['forecast'] ?? 0,
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class MetricsData {
  final int totalSales;
  final int totalWalkIns;
  final double totalRevenue;
  final double averageSales;
  final double averageRevenue;
  final int itemCount;
  final String conversionRate;

  MetricsData({
    required this.totalSales,
    required this.totalWalkIns,
    required this.totalRevenue,
    required this.averageSales,
    required this.averageRevenue,
    required this.itemCount,
    required this.conversionRate,
  });

  factory MetricsData.fromJson(Map<String, dynamic> json) {
    return MetricsData(
      totalSales: json['totalSales'] ?? 0,
      totalWalkIns: json['totalWalkIns'] ?? 0,
      totalRevenue: (json['totalRevenue'] as num?)?.toDouble() ?? 0.0,
      averageSales: (json['averageSales'] as num?)?.toDouble() ?? 0.0,
      averageRevenue: (json['averageRevenue'] as num?)?.toDouble() ?? 0.0,
      itemCount: json['itemCount'] ?? 0,
      conversionRate: json['conversionRate'] ?? '0',
    );
  }
}

class DashboardSummary {
  final MetricsData summary;
  final Map<String, CityMetrics> cityMetrics;

  DashboardSummary({required this.summary, required this.cityMetrics});

  factory DashboardSummary.fromJson(Map<String, dynamic> json) {
    Map<String, CityMetrics> cityMetricsMap = {};
    if (json['cityMetrics'] != null) {
      json['cityMetrics'].forEach((key, value) {
        cityMetricsMap[key] = CityMetrics.fromJson(value);
      });
    }

    return DashboardSummary(
      summary: MetricsData.fromJson(json['summary']),
      cityMetrics: cityMetricsMap,
    );
  }
}

class CityMetrics {
  final double sales;
  final int walkIns;
  final double revenue;
  final int count;

  CityMetrics({
    required this.sales,
    required this.walkIns,
    required this.revenue,
    required this.count,
  });

  factory CityMetrics.fromJson(Map<String, dynamic> json) {
    return CityMetrics(
      sales: (json['sales'] as num?)?.toDouble() ?? 0.0,
      walkIns: json['walkIns'] ?? 0,
      revenue: (json['revenue'] as num?)?.toDouble() ?? 0.0,
      count: json['count'] ?? 0,
    );
  }
}

class FilterOptions {
  final List<String> cities;
  final List<String> statuses;
  final List<String> industries;
  final List<String> departments;
  final List<String> regions;
  final List<String> priorities;
  final List<String> leadSources;
  final double minRevenue;
  final double maxRevenue;
  final double minProbability;
  final double maxProbability;

  FilterOptions({
    required this.cities,
    required this.statuses,
    required this.industries,
    required this.departments,
    required this.regions,
    required this.priorities,
    required this.leadSources,
    required this.minRevenue,
    required this.maxRevenue,
    required this.minProbability,
    required this.maxProbability,
  });

  factory FilterOptions.fromJson(Map<String, dynamic> json) {
    return FilterOptions(
      cities: List<String>.from(json['cities'] ?? []),
      statuses: List<String>.from(json['statuses'] ?? []),
      industries: List<String>.from(json['industries'] ?? []),
      departments: List<String>.from(json['departments'] ?? []),
      regions: List<String>.from(json['regions'] ?? []),
      priorities: List<String>.from(json['priorities'] ?? []),
      leadSources: List<String>.from(json['leadSources'] ?? []),
      minRevenue: (json['minRevenue'] as num?)?.toDouble() ?? 0.0,
      maxRevenue: (json['maxRevenue'] as num?)?.toDouble() ?? 1000000.0,
      minProbability: (json['minProbability'] as num?)?.toDouble() ?? 0.0,
      maxProbability: (json['maxProbability'] as num?)?.toDouble() ?? 100.0,
    );
  }
}

class SearchSuggestion {
  final String text;
  final String type;
  final String? category;

  SearchSuggestion({required this.text, required this.type, this.category});

  factory SearchSuggestion.fromJson(Map<String, dynamic> json) {
    return SearchSuggestion(
      text: json['text'] ?? '',
      type: json['type'] ?? '',
      category: json['category'],
    );
  }
}

class DashboardFilter {
  final String? search;
  final List<String> cities;
  final List<String> statuses;
  final List<String> industries;
  final String? startDate;
  final String? endDate;
  final double? minRevenue;
  final double? maxRevenue;
  final double? minProbability;
  final double? maxProbability;
  final String sortBy;
  final String sortOrder;
  final int limit;
  final int offset;

  DashboardFilter({
    this.search,
    this.cities = const [],
    this.statuses = const [],
    this.industries = const [],
    this.startDate,
    this.endDate,
    this.minRevenue,
    this.maxRevenue,
    this.minProbability,
    this.maxProbability,
    this.sortBy = 'revenue',
    this.sortOrder = 'desc',
    this.limit = 100,
    this.offset = 0,
  });

  Map<String, dynamic> toQueryParams() {
    Map<String, dynamic> params = {};

    if (search != null && search!.isNotEmpty) params['search'] = search;
    if (cities.isNotEmpty) params['cities'] = cities.join(',');
    if (statuses.isNotEmpty) params['statuses'] = statuses.join(',');
    if (industries.isNotEmpty) params['industries'] = industries.join(',');
    if (startDate != null) params['startDate'] = startDate;
    if (endDate != null) params['endDate'] = endDate;
    if (minRevenue != null) params['minRevenue'] = minRevenue.toString();
    if (maxRevenue != null) params['maxRevenue'] = maxRevenue.toString();
    if (minProbability != null)
      params['minProbability'] = minProbability.toString();
    if (maxProbability != null)
      params['maxProbability'] = maxProbability.toString();

    params['sortBy'] = sortBy;
    params['sortOrder'] = sortOrder;
    params['limit'] = limit.toString();
    params['offset'] = offset.toString();

    return params;
  }
}

enum SortField {
  name,
  revenue,
  sales,
  walkIns,
  conversionRate,
  city,
  status,
  industry,
  probability,
  dealSize,
  createdAt,
  lastUpdated,
}

extension SortFieldExtension on SortField {
  String get value {
    switch (this) {
      case SortField.name:
        return 'name';
      case SortField.revenue:
        return 'revenue';
      case SortField.sales:
        return 'sales';
      case SortField.walkIns:
        return 'walkIns';
      case SortField.conversionRate:
        return 'conversionRate';
      case SortField.city:
        return 'city';
      case SortField.status:
        return 'status';
      case SortField.industry:
        return 'industry';
      case SortField.probability:
        return 'probability';
      case SortField.dealSize:
        return 'dealSize';
      case SortField.createdAt:
        return 'createdAt';
      case SortField.lastUpdated:
        return 'lastUpdated';
    }
  }

  String get displayName {
    switch (this) {
      case SortField.name:
        return 'Name';
      case SortField.revenue:
        return 'Revenue';
      case SortField.sales:
        return 'Sales';
      case SortField.walkIns:
        return 'Walk-ins';
      case SortField.conversionRate:
        return 'Conversion Rate';
      case SortField.city:
        return 'City';
      case SortField.status:
        return 'Status';
      case SortField.industry:
        return 'Industry';
      case SortField.probability:
        return 'Probability';
      case SortField.dealSize:
        return 'Deal Size';
      case SortField.createdAt:
        return 'Created Date';
      case SortField.lastUpdated:
        return 'Last Updated';
    }
  }
}
