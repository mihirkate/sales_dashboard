import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/sales_data.dart';
import '../utils/responsive_helper.dart';

class SalesDataTable extends StatefulWidget {
  final List<SalesData> salesData;
  final bool isLoading;
  final Function(SortField, String) onSort;
  final SortField currentSortField;
  final String currentSortOrder;

  const SalesDataTable({
    super.key,
    required this.salesData,
    required this.isLoading,
    required this.onSort,
    required this.currentSortField,
    required this.currentSortOrder,
  });

  @override
  State<SalesDataTable> createState() => _SalesDataTableState();
}

class _SalesDataTableState extends State<SalesDataTable> {
  int _rowsPerPage = 10;
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    if (widget.isLoading) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (widget.salesData.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'No data found',
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                Text(
                  'Try adjusting your search or filters',
                  style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Card(
      child: Column(
        children: [
          if (isMobile) _buildMobileView() else _buildDesktopView(),
          _buildPaginationControls(),
        ],
      ),
    );
  }

  Widget _buildMobileView() {
    final startIndex = _currentPage * _rowsPerPage;
    final endIndex = (startIndex + _rowsPerPage).clamp(
      0,
      widget.salesData.length,
    );
    final pageData = widget.salesData.sublist(startIndex, endIndex);

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: pageData.length,
      separatorBuilder: (context, index) => Divider(color: Colors.grey[300]),
      itemBuilder: (context, index) {
        final data = pageData[index];
        return _buildMobileCard(data);
      },
    );
  }

  Widget _buildMobileCard(SalesData data) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: data.avatar.isNotEmpty
                    ? NetworkImage(data.avatar)
                    : null,
                child: data.avatar.isEmpty
                    ? Text(
                        data.name.isNotEmpty ? data.name[0].toUpperCase() : 'N',
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      data.city,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
              ),
              _buildStatusChip(data.status),
            ],
          ),
          const SizedBox(height: 12),
          _buildInfoRow('Revenue', _formatCurrency(data.revenue)),
          _buildInfoRow('Sales', _formatNumber(data.sales.toInt())),
          _buildInfoRow('Walk-ins', _formatNumber(data.walkIns)),
          _buildInfoRow('Industry', data.industry),
          if (data.probability > 0)
            _buildInfoRow(
              'Probability',
              '${data.probability.toStringAsFixed(1)}%',
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopView() {
    final startIndex = _currentPage * _rowsPerPage;
    final endIndex = (startIndex + _rowsPerPage).clamp(
      0,
      widget.salesData.length,
    );
    final pageData = widget.salesData.sublist(startIndex, endIndex);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        sortColumnIndex: _getSortColumnIndex(),
        sortAscending: widget.currentSortOrder == 'asc',
        columns: [
          _buildDataColumn('Name', SortField.name),
          _buildDataColumn('City', SortField.city),
          _buildDataColumn('Revenue', SortField.revenue),
          _buildDataColumn('Sales', SortField.sales),
          _buildDataColumn('Walk-ins', SortField.walkIns),
          _buildDataColumn('Industry', SortField.industry),
          _buildDataColumn('Status', SortField.status),
          _buildDataColumn('Probability', SortField.probability),
          _buildDataColumn('Deal Size', SortField.dealSize),
        ],
        rows: pageData.map((data) {
          return DataRow(
            cells: [
              DataCell(
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundImage: data.avatar.isNotEmpty
                          ? NetworkImage(data.avatar)
                          : null,
                      child: data.avatar.isEmpty
                          ? Text(
                              data.name.isNotEmpty
                                  ? data.name[0].toUpperCase()
                                  : 'N',
                              style: const TextStyle(fontSize: 12),
                            )
                          : null,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(data.name, overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              ),
              DataCell(Text(data.city)),
              DataCell(Text(_formatCurrency(data.revenue))),
              DataCell(Text(_formatNumber(data.sales.toInt()))),
              DataCell(Text(_formatNumber(data.walkIns))),
              DataCell(Text(data.industry)),
              DataCell(_buildStatusChip(data.status)),
              DataCell(
                Text(
                  data.probability > 0
                      ? '${data.probability.toStringAsFixed(1)}%'
                      : '-',
                ),
              ),
              DataCell(
                Text(data.dealSize > 0 ? _formatCurrency(data.dealSize) : '-'),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  DataColumn _buildDataColumn(String label, SortField sortField) {
    return DataColumn(
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      onSort: (columnIndex, ascending) {
        widget.onSort(sortField, ascending ? 'asc' : 'desc');
      },
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'active':
      case 'closed':
        color = Colors.green;
        break;
      case 'pending':
      case 'in progress':
        color = Colors.orange;
        break;
      case 'inactive':
      case 'lost':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildPaginationControls() {
    final totalPages = (widget.salesData.length / _rowsPerPage).ceil();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          Text(
            'Rows per page:',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          const SizedBox(width: 8),
          DropdownButton<int>(
            value: _rowsPerPage,
            underline: const SizedBox(),
            items: [5, 10, 25, 50].map((count) {
              return DropdownMenuItem<int>(
                value: count,
                child: Text(count.toString()),
              );
            }).toList(),
            onChanged: (int? newValue) {
              if (newValue != null) {
                setState(() {
                  _rowsPerPage = newValue;
                  _currentPage = 0;
                });
              }
            },
          ),
          const Spacer(),
          Text(
            '${_currentPage * _rowsPerPage + 1}-${((_currentPage + 1) * _rowsPerPage).clamp(1, widget.salesData.length)} of ${widget.salesData.length}',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          const SizedBox(width: 16),
          IconButton(
            onPressed: _currentPage > 0
                ? () {
                    setState(() {
                      _currentPage--;
                    });
                  }
                : null,
            icon: const Icon(Icons.chevron_left),
          ),
          IconButton(
            onPressed: _currentPage < totalPages - 1
                ? () {
                    setState(() {
                      _currentPage++;
                    });
                  }
                : null,
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }

  int _getSortColumnIndex() {
    switch (widget.currentSortField) {
      case SortField.name:
        return 0;
      case SortField.city:
        return 1;
      case SortField.revenue:
        return 2;
      case SortField.sales:
        return 3;
      case SortField.walkIns:
        return 4;
      case SortField.industry:
        return 5;
      case SortField.status:
        return 6;
      case SortField.probability:
        return 7;
      case SortField.dealSize:
        return 8;
      default:
        return 0;
    }
  }

  String _formatCurrency(double amount) {
    return NumberFormat.currency(symbol: '\$', decimalDigits: 0).format(amount);
  }

  String _formatNumber(int number) {
    return NumberFormat('#,###').format(number);
  }
}
