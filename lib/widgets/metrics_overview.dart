import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../models/sales_data.dart';
import '../utils/responsive_helper.dart';
import 'metrics_card.dart';

class MetricsOverview extends StatefulWidget {
  const MetricsOverview({super.key});

  @override
  State<MetricsOverview> createState() => _MetricsOverviewState();
}

class _MetricsOverviewState extends State<MetricsOverview> {
  DashboardSummary? dashboardData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    try {
      final data = await ApiService.fetchMetrics();
      setState(() {
        dashboardData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  String formatCurrency(double amount) {
    return NumberFormat.currency(symbol: '\$', decimalDigits: 0).format(amount);
  }

  String formatNumber(int number) {
    return NumberFormat('#,###').format(number);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (dashboardData == null) {
      return const SliverToBoxAdapter(
        child: Center(child: Text('Failed to load metrics')),
      );
    }

    final metrics = dashboardData!.summary;

    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        delegate: SliverChildListDelegate([
          MetricsCard(
            title: 'Total Revenue',
            value: formatCurrency(metrics.totalRevenue),
            subtitle: 'Total earnings',
            icon: Icons.attach_money,
            color: Colors.green,
            bgColor: Colors.green,
            trend: '${metrics.conversionRate}%',
            isPositive: true,
          ),
          MetricsCard(
            title: 'Walk-ins',
            value: formatNumber(metrics.totalWalkIns),
            subtitle: 'Store visits',
            icon: Icons.store,
            color: Colors.blue,
            bgColor: Colors.blue,
            trend: '+12.5%',
            isPositive: true,
          ),
          MetricsCard(
            title: 'Total Sales',
            value: formatNumber(metrics.totalSales),
            subtitle: 'Sales count',
            icon: Icons.trending_up,
            color: Colors.orange,
            bgColor: Colors.orange,
            trend: '+8.2%',
            isPositive: true,
          ),
          MetricsCard(
            title: 'Avg Revenue',
            value: formatCurrency(metrics.averageRevenue),
            subtitle: 'Per customer',
            icon: Icons.analytics,
            color: Colors.purple,
            bgColor: Colors.purple,
            trend: '+5.1%',
            isPositive: true,
          ),
        ]),
      ),
    );
  }
}
