import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/sales_data.dart';

class PerformanceSummary extends StatefulWidget {
  const PerformanceSummary({super.key});

  @override
  State<PerformanceSummary> createState() => _PerformanceSummaryState();
}

class _PerformanceSummaryState extends State<PerformanceSummary> {
  List<MonthlySalesData> monthlySales = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    try {
      final data = await ApiService.fetchMonthlySales();
      setState(() {
        monthlySales = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (monthlySales.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: Text('No performance data available')),
        ),
      );
    }

    final latest = monthlySales.last;
    final previous = monthlySales.length > 1
        ? monthlySales[monthlySales.length - 2]
        : latest;

    final revenueGrowth = previous.revenue != 0
        ? ((latest.revenue - previous.revenue) / previous.revenue * 100)
        : 0.0;
    final leadsGrowth = previous.leads != 0
        ? ((latest.leads - previous.leads) / previous.leads * 100)
        : 0.0;
    final conversionGrowth = latest.conversionRate - previous.conversionRate;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Performance Summary',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Monthly comparison',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildPerformanceItem(
                    'Revenue Growth',
                    '${revenueGrowth.toStringAsFixed(1)}%',
                    revenueGrowth >= 0
                        ? Icons.trending_up
                        : Icons.trending_down,
                    revenueGrowth >= 0 ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildPerformanceItem(
                    'Leads Growth',
                    '${leadsGrowth.toStringAsFixed(1)}%',
                    leadsGrowth >= 0 ? Icons.trending_up : Icons.trending_down,
                    leadsGrowth >= 0 ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildPerformanceItem(
                    'Conversion Rate',
                    '${latest.conversionRate.toStringAsFixed(1)}%',
                    conversionGrowth >= 0
                        ? Icons.trending_up
                        : Icons.trending_down,
                    conversionGrowth >= 0 ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildPerformanceItem(
                    'Satisfaction',
                    '${latest.satisfactionScore.toStringAsFixed(1)}/5.0',
                    latest.satisfactionScore >= 4.0
                        ? Icons.sentiment_very_satisfied
                        : Icons.sentiment_neutral,
                    latest.satisfactionScore >= 4.0
                        ? Colors.green
                        : Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.insights, color: Colors.blue[600], size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Key Insight',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getInsight(latest, revenueGrowth, leadsGrowth),
                          style: TextStyle(
                            color: Colors.blue[700],
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceItem(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(icon, color: color, size: 16),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _getInsight(
    MonthlySalesData latest,
    double revenueGrowth,
    double leadsGrowth,
  ) {
    if (revenueGrowth > 10 && leadsGrowth > 10) {
      return 'Excellent performance! Both revenue and leads are growing strongly.';
    } else if (revenueGrowth > 0 && leadsGrowth > 0) {
      return 'Positive growth trend in both revenue and lead generation.';
    } else if (revenueGrowth > leadsGrowth) {
      return 'Revenue is outpacing lead growth - good conversion efficiency.';
    } else if (leadsGrowth > revenueGrowth) {
      return 'Strong lead generation - focus on improving conversion rates.';
    } else {
      return 'Performance needs attention - consider reviewing strategies.';
    }
  }
}
