import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/api_service.dart';
import '../models/sales_data.dart';

class MonthlyLeadsChart extends StatefulWidget {
  const MonthlyLeadsChart({super.key});

  @override
  State<MonthlyLeadsChart> createState() => _MonthlyLeadsChartState();
}

class _MonthlyLeadsChartState extends State<MonthlyLeadsChart> {
  List<MonthlySalesData> monthlySales = [];
  bool isLoading = true;
  int touchedIndex = -1;

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
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Monthly Leads',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Lead generation performance',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.purple[50],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.group_add,
                        color: Colors.purple[600],
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Leads',
                        style: TextStyle(
                          color: Colors.purple[600],
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            if (isLoading)
              const SizedBox(
                height: 250,
                child: Center(child: CircularProgressIndicator()),
              )
            else if (monthlySales.isEmpty)
              const SizedBox(
                height: 250,
                child: Center(child: Text('No data available')),
              )
            else
              SizedBox(
                height: 250,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: monthlySales.isNotEmpty
                        ? monthlySales
                                  .map((e) => e.leads)
                                  .reduce((a, b) => a > b ? a : b)
                                  .toDouble() *
                              1.2
                        : 1000,
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          if (groupIndex < monthlySales.length) {
                            final monthData = monthlySales[groupIndex];
                            return BarTooltipItem(
                              '${monthData.month}\n',
                              const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              children: [
                                TextSpan(
                                  text: '${monthData.leads} leads',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            );
                          }
                          return null;
                        },
                      ),
                      touchCallback: (FlTouchEvent event, barTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              barTouchResponse == null ||
                              barTouchResponse.spot == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex =
                              barTouchResponse.spot!.touchedBarGroupIndex;
                        });
                      },
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            const style = TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            );
                            if (value.toInt() < monthlySales.length) {
                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                child: Text(
                                  monthlySales[value.toInt()].month,
                                  style: style,
                                ),
                              );
                            }
                            return const Text('');
                          },
                          reservedSize: 30,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 42,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            return Text(
                              value.toInt().toString(),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: Colors.grey[300]!, width: 1),
                    ),
                    barGroups: monthlySales.asMap().entries.map((entry) {
                      final index = entry.key;
                      final data = entry.value;
                      final isTouched = index == touchedIndex;

                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: data.leads.toDouble(),
                            gradient: LinearGradient(
                              colors: isTouched
                                  ? [Colors.purple[300]!, Colors.purple[600]!]
                                  : [Colors.purple[400]!, Colors.purple[700]!],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                            width: isTouched ? 25 : 20,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(6),
                              topRight: Radius.circular(6),
                            ),
                            backDrawRodData: BackgroundBarChartRodData(
                              show: true,
                              toY: monthlySales.isNotEmpty
                                  ? monthlySales
                                            .map((e) => e.leads)
                                            .reduce((a, b) => a > b ? a : b)
                                            .toDouble() *
                                        1.2
                                  : 1000,
                              color: Colors.grey[200],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 200,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(color: Colors.grey[300], strokeWidth: 1);
                      },
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
