import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MetricsCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Color? bgColor;
  final String? trend;
  final bool isPositive;

  const MetricsCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.bgColor,
    this.trend,
    this.isPositive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: bgColor != null
              ? LinearGradient(
                  colors: [
                    bgColor!.withOpacity(0.1),
                    bgColor!.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                if (trend != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isPositive
                          ? Colors.green.withOpacity(0.1)
                          : Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isPositive ? Icons.trending_up : Icons.trending_down,
                          color: isPositive ? Colors.green : Colors.red,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          trend!,
                          style: TextStyle(
                            color: isPositive ? Colors.green : Colors.red,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }
}

class MetricsGrid extends StatefulWidget {
  const MetricsGrid({super.key});

  @override
  State<MetricsGrid> createState() => _MetricsGridState();
}

class _MetricsGridState extends State<MetricsGrid> {
  Map<String, dynamic>? metricsData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMetrics();
  }

  Future<void> _loadMetrics() async {
    try {
      // For now, using sample data - replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() {
        metricsData = {
          'totalSales': 8212310,
          'totalWalkIns': 13091,
          'totalRevenue': 26811690.75,
          'conversionRate': '62.73',
          'itemCount': 100,
        };
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  String _formatCurrency(double value) {
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 0);
    return formatter.format(value);
  }

  String _formatNumber(int value) {
    final formatter = NumberFormat('#,###');
    return formatter.format(value);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (metricsData == null) {
      return const Center(child: Text('Failed to load metrics'));
    }

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        MetricsCard(
          title: 'Total Sales',
          value: _formatCurrency(metricsData!['totalSales'].toDouble()),
          subtitle: 'Last 30 days',
          icon: Icons.trending_up,
          color: Colors.green,
          bgColor: Colors.green,
          trend: '+12.5%',
          isPositive: true,
        ),
        MetricsCard(
          title: 'Total Revenue',
          value: _formatCurrency(metricsData!['totalRevenue']),
          subtitle: 'This month',
          icon: Icons.attach_money,
          color: Colors.blue,
          bgColor: Colors.blue,
          trend: '+8.2%',
          isPositive: true,
        ),
        MetricsCard(
          title: 'Walk-ins',
          value: _formatNumber(metricsData!['totalWalkIns']),
          subtitle: 'Total visits',
          icon: Icons.people,
          color: Colors.orange,
          bgColor: Colors.orange,
          trend: '+15.3%',
          isPositive: true,
        ),
        MetricsCard(
          title: 'Conversion Rate',
          value: '${metricsData!['conversionRate']}%',
          subtitle: 'Current period',
          icon: Icons.analytics,
          color: Colors.purple,
          bgColor: Colors.purple,
          trend: '+2.1%',
          isPositive: true,
        ),
      ],
    );
  }
}
