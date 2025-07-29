import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/metrics_overview.dart';
import '../widgets/revenue_chart.dart';
import '../widgets/trends_bar_chart.dart';
import '../widgets/revenue_pie_chart.dart';
import '../widgets/monthly_leads_chart.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/filter_dialog.dart';
import '../widgets/sort_dropdown.dart';
import '../widgets/sales_data_table.dart';
import '../utils/responsive_helper.dart';
import '../models/sales_data.dart';
import '../services/api_service.dart';
import '../services/theme_service.dart';
import '../services/export_service.dart';

class EnhancedDashboardScreen extends StatefulWidget {
  const EnhancedDashboardScreen({super.key});

  @override
  State<EnhancedDashboardScreen> createState() =>
      _EnhancedDashboardScreenState();
}

class _EnhancedDashboardScreenState extends State<EnhancedDashboardScreen>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late TabController _tabController;

  List<SalesData> _salesData = [];
  bool _isLoading = false;

  DashboardFilter _currentFilter = DashboardFilter();
  SortField _currentSortField = SortField.revenue;
  String _currentSortOrder = 'desc';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadSalesData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadSalesData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final data = await ApiService.fetchSalesDashboard(filter: _currentFilter);
      setState(() {
        _salesData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _currentFilter = DashboardFilter(
        search: query.isEmpty ? null : query,
        cities: _currentFilter.cities,
        statuses: _currentFilter.statuses,
        industries: _currentFilter.industries,
        startDate: _currentFilter.startDate,
        endDate: _currentFilter.endDate,
        minRevenue: _currentFilter.minRevenue,
        maxRevenue: _currentFilter.maxRevenue,
        minProbability: _currentFilter.minProbability,
        maxProbability: _currentFilter.maxProbability,
        sortBy: _currentSortField.value,
        sortOrder: _currentSortOrder,
        limit: _currentFilter.limit,
        offset: 0,
      );
    });
    _loadSalesData();
  }

  void _onFilterChanged(DashboardFilter filter) {
    setState(() {
      _currentFilter = DashboardFilter(
        search: filter.search,
        cities: filter.cities,
        statuses: filter.statuses,
        industries: filter.industries,
        startDate: filter.startDate,
        endDate: filter.endDate,
        minRevenue: filter.minRevenue,
        maxRevenue: filter.maxRevenue,
        minProbability: filter.minProbability,
        maxProbability: filter.maxProbability,
        sortBy: _currentSortField.value,
        sortOrder: _currentSortOrder,
        limit: filter.limit,
        offset: 0,
      );
    });
    _loadSalesData();
  }

  void _onSortChanged(SortField field, String order) {
    setState(() {
      _currentSortField = field;
      _currentSortOrder = order;
      _currentFilter = DashboardFilter(
        search: _currentFilter.search,
        cities: _currentFilter.cities,
        statuses: _currentFilter.statuses,
        industries: _currentFilter.industries,
        startDate: _currentFilter.startDate,
        endDate: _currentFilter.endDate,
        minRevenue: _currentFilter.minRevenue,
        maxRevenue: _currentFilter.maxRevenue,
        minProbability: _currentFilter.minProbability,
        maxProbability: _currentFilter.maxProbability,
        sortBy: field.value,
        sortOrder: order,
        limit: _currentFilter.limit,
        offset: _currentFilter.offset,
      );
    });
    _loadSalesData();
  }

  Future<void> _exportData() async {
    try {
      String filePath;

      // Try API export first, fallback to local export
      try {
        filePath = await ApiService.exportData(
          format: 'csv',
          filter: _currentFilter,
        );
      } catch (e) {
        // Fallback to local export if API fails
        filePath = await ExportService.exportSalesDataToCsv(_salesData);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data exported to: $filePath'),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: 'View',
              onPressed: () {
                // Could implement file opening here
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper.isDesktop(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final isMobile = ResponsiveHelper.isMobile(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(context, isMobile),
      body: Column(
        children: [
          if (_selectedIndex == 0) _buildSearchAndFilters(),
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                _buildDashboardTab(isDesktop, isTablet, isMobile),
                _buildAnalyticsTab(isDesktop, isTablet, isMobile),
                _buildDataTab(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: isMobile ? _buildBottomNav() : null,
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isMobile) {
    final themeService = Provider.of<ThemeService>(context);

    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      surfaceTintColor: Colors.transparent,
      title: Text(
        "Sales Dashboard",
        style: GoogleFonts.poppins(
          fontSize: isMobile ? 18 : 20,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).appBarTheme.foregroundColor,
        ),
      ),
      actions: [
        if (!isMobile) ...[
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadSalesData,
            tooltip: 'Refresh Data',
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _exportData,
            tooltip: 'Export Data',
          ),
          const SizedBox(width: 8),
        ],
        IconButton(
          icon: Icon(
            themeService.isDarkMode ? Icons.light_mode : Icons.dark_mode,
          ),
          onPressed: themeService.toggleTheme,
          tooltip: 'Toggle Theme',
        ),
        if (!isMobile) ...[
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
            tooltip: 'Notifications',
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
            tooltip: 'Settings',
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            radius: 18,
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
            child: Text(
              'U',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ],
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: SearchBarWidget(
                  onSearchChanged: _onSearchChanged,
                  initialValue: _currentFilter.search,
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => FilterDialog(
                      currentFilter: _currentFilter,
                      onApplyFilter: _onFilterChanged,
                    ),
                  );
                },
                tooltip: 'Filters',
              ),
              IconButton(
                icon: const Icon(Icons.download),
                onPressed: _exportData,
                tooltip: 'Export',
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              SortDropdown(
                selectedField: _currentSortField,
                sortOrder: _currentSortOrder,
                onSortChanged: _onSortChanged,
              ),
              const Spacer(),
              if (_hasActiveFilters())
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _currentFilter = DashboardFilter();
                    });
                    _loadSalesData();
                  },
                  icon: const Icon(Icons.clear, size: 16),
                  label: const Text('Clear Filters'),
                ),
            ],
          ),
        ],
      ),
    );
  }

  bool _hasActiveFilters() {
    return _currentFilter.search != null ||
        _currentFilter.cities.isNotEmpty ||
        _currentFilter.statuses.isNotEmpty ||
        _currentFilter.industries.isNotEmpty ||
        _currentFilter.startDate != null ||
        _currentFilter.endDate != null ||
        _currentFilter.minRevenue != null ||
        _currentFilter.maxRevenue != null ||
        _currentFilter.minProbability != null ||
        _currentFilter.maxProbability != null;
  }

  Widget _buildDashboardTab(bool isDesktop, bool isTablet, bool isMobile) {
    return RefreshIndicator(
      onRefresh: _loadSalesData,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          _buildWelcomeHeader(context, isMobile),
          const MetricsOverview(),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: _buildChartsSection(
                context,
                isDesktop,
                isTablet,
                isMobile,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsTab(bool isDesktop, bool isTablet, bool isMobile) {
    return RefreshIndicator(
      onRefresh: _loadSalesData,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  if (isMobile) ...[
                    const RevenueChart(),
                    const SizedBox(height: 16),
                    const TrendsBarChart(),
                    const SizedBox(height: 16),
                    const RevenuePieChart(),
                    const SizedBox(height: 16),
                    const MonthlyLeadsChart(),
                  ] else if (isTablet) ...[
                    Row(
                      children: [
                        const Expanded(child: RevenueChart()),
                        const SizedBox(width: 16),
                        const Expanded(child: TrendsBarChart()),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Expanded(child: RevenuePieChart()),
                        const SizedBox(width: 16),
                        const Expanded(child: MonthlyLeadsChart()),
                      ],
                    ),
                  ] else ...[
                    const RevenueChart(),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Expanded(child: TrendsBarChart()),
                        const SizedBox(width: 16),
                        const Expanded(child: RevenuePieChart()),
                        const SizedBox(width: 16),
                        const Expanded(child: MonthlyLeadsChart()),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SalesDataTable(
        salesData: _salesData,
        isLoading: _isLoading,
        onSort: _onSortChanged,
        currentSortField: _currentSortField,
        currentSortOrder: _currentSortOrder,
      ),
    );
  }

  SliverToBoxAdapter _buildWelcomeHeader(BuildContext context, bool isMobile) {
    return SliverToBoxAdapter(
      child: Container(
        margin: ResponsiveHelper.getScreenPadding(context),
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: isMobile ? _buildMobileWelcome() : _buildDesktopWelcome(),
      ),
    );
  }

  Widget _buildMobileWelcome() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.dashboard_rounded, color: Colors.white, size: 24),
            const SizedBox(width: 8),
            Text(
              'Welcome Back!',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Track your sales performance and analytics',
          style: GoogleFonts.poppins(
            color: Colors.white.withOpacity(0.9),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopWelcome() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome Back to Your Dashboard!',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Monitor your sales metrics, track performance, and analyze trends all in one place.',
                style: GoogleFonts.poppins(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.dashboard_rounded,
            color: Colors.white,
            size: 32,
          ),
        ),
      ],
    );
  }

  Widget _buildChartsSection(
    BuildContext context,
    bool isDesktop,
    bool isTablet,
    bool isMobile,
  ) {
    final spacing = ResponsiveHelper.getCardSpacing(context);

    return Column(
      children: [
        SizedBox(height: spacing),
        const RevenueChart(),
        SizedBox(height: spacing),
        if (isMobile) ...[
          const TrendsBarChart(),
          SizedBox(height: spacing),
          const RevenuePieChart(),
        ] else if (isTablet) ...[
          Row(
            children: [
              const Expanded(child: TrendsBarChart()),
              SizedBox(width: spacing),
              const Expanded(child: RevenuePieChart()),
            ],
          ),
        ] else ...[
          Row(
            children: [
              const Expanded(flex: 2, child: TrendsBarChart()),
              SizedBox(width: spacing),
              const Expanded(child: RevenuePieChart()),
            ],
          ),
        ],
        SizedBox(height: spacing * 2),
      ],
    );
  }

  Widget? _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Theme.of(
        context,
      ).bottomNavigationBarTheme.backgroundColor,
      selectedItemColor: Theme.of(
        context,
      ).bottomNavigationBarTheme.selectedItemColor,
      unselectedItemColor: Theme.of(
        context,
      ).bottomNavigationBarTheme.unselectedItemColor,
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.analytics),
          label: 'Analytics',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.table_view), label: 'Data'),
      ],
    );
  }
}
