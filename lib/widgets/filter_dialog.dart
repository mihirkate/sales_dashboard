import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/sales_data.dart';
import '../services/api_service.dart';
import '../utils/responsive_helper.dart';

class FilterDialog extends StatefulWidget {
  final DashboardFilter currentFilter;
  final Function(DashboardFilter) onApplyFilter;

  const FilterDialog({
    super.key,
    required this.currentFilter,
    required this.onApplyFilter,
  });

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  late DashboardFilter _filter;
  FilterOptions? _filterOptions;
  bool _isLoading = true;

  final TextEditingController _minRevenueController = TextEditingController();
  final TextEditingController _maxRevenueController = TextEditingController();
  final TextEditingController _minProbabilityController =
      TextEditingController();
  final TextEditingController _maxProbabilityController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _filter = widget.currentFilter;
    _loadFilterOptions();
    _initializeControllers();
  }

  void _initializeControllers() {
    if (_filter.minRevenue != null) {
      _minRevenueController.text = _filter.minRevenue!.toStringAsFixed(0);
    }
    if (_filter.maxRevenue != null) {
      _maxRevenueController.text = _filter.maxRevenue!.toStringAsFixed(0);
    }
    if (_filter.minProbability != null) {
      _minProbabilityController.text = _filter.minProbability!.toStringAsFixed(
        0,
      );
    }
    if (_filter.maxProbability != null) {
      _maxProbabilityController.text = _filter.maxProbability!.toStringAsFixed(
        0,
      );
    }
  }

  Future<void> _loadFilterOptions() async {
    try {
      final options = await ApiService.fetchAdvancedFilters();
      setState(() {
        _filterOptions = options;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _minRevenueController.dispose();
    _maxRevenueController.dispose();
    _minProbabilityController.dispose();
    _maxProbabilityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: isMobile ? double.infinity : 600,
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildContent(),
            ),
            _buildActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.filter_list, color: Colors.white),
          const SizedBox(width: 12),
          const Text(
            'Filter Data',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMultiSelectChips(
            'Cities',
            _filterOptions?.cities ?? [],
            _filter.cities,
            (selected) {
              setState(() {
                _filter = DashboardFilter(
                  search: _filter.search,
                  cities: selected,
                  statuses: _filter.statuses,
                  industries: _filter.industries,
                  startDate: _filter.startDate,
                  endDate: _filter.endDate,
                  minRevenue: _filter.minRevenue,
                  maxRevenue: _filter.maxRevenue,
                  minProbability: _filter.minProbability,
                  maxProbability: _filter.maxProbability,
                  sortBy: _filter.sortBy,
                  sortOrder: _filter.sortOrder,
                  limit: _filter.limit,
                  offset: _filter.offset,
                );
              });
            },
          ),
          const SizedBox(height: 16),
          _buildMultiSelectChips(
            'Status',
            _filterOptions?.statuses ?? [],
            _filter.statuses,
            (selected) {
              setState(() {
                _filter = DashboardFilter(
                  search: _filter.search,
                  cities: _filter.cities,
                  statuses: selected,
                  industries: _filter.industries,
                  startDate: _filter.startDate,
                  endDate: _filter.endDate,
                  minRevenue: _filter.minRevenue,
                  maxRevenue: _filter.maxRevenue,
                  minProbability: _filter.minProbability,
                  maxProbability: _filter.maxProbability,
                  sortBy: _filter.sortBy,
                  sortOrder: _filter.sortOrder,
                  limit: _filter.limit,
                  offset: _filter.offset,
                );
              });
            },
          ),
          const SizedBox(height: 16),
          _buildMultiSelectChips(
            'Industries',
            _filterOptions?.industries ?? [],
            _filter.industries,
            (selected) {
              setState(() {
                _filter = DashboardFilter(
                  search: _filter.search,
                  cities: _filter.cities,
                  statuses: _filter.statuses,
                  industries: selected,
                  startDate: _filter.startDate,
                  endDate: _filter.endDate,
                  minRevenue: _filter.minRevenue,
                  maxRevenue: _filter.maxRevenue,
                  minProbability: _filter.minProbability,
                  maxProbability: _filter.maxProbability,
                  sortBy: _filter.sortBy,
                  sortOrder: _filter.sortOrder,
                  limit: _filter.limit,
                  offset: _filter.offset,
                );
              });
            },
          ),
          const SizedBox(height: 24),
          _buildDateRangeSelector(),
          const SizedBox(height: 24),
          _buildRangeInputs(
            'Revenue Range',
            _minRevenueController,
            _maxRevenueController,
            'Min Revenue',
            'Max Revenue',
            '\$',
          ),
          const SizedBox(height: 16),
          _buildRangeInputs(
            'Probability Range (%)',
            _minProbabilityController,
            _maxProbabilityController,
            'Min Probability',
            'Max Probability',
            '%',
          ),
        ],
      ),
    );
  }

  Widget _buildMultiSelectChips(
    String title,
    List<String> options,
    List<String> selected,
    Function(List<String>) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: options.map((option) {
            final isSelected = selected.contains(option);
            return FilterChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (bool value) {
                List<String> newSelected = List.from(selected);
                if (value) {
                  newSelected.add(option);
                } else {
                  newSelected.remove(option);
                }
                onChanged(newSelected);
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDateRangeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Date Range',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _filter.startDate != null
                        ? DateTime.parse(_filter.startDate!)
                        : DateTime.now().subtract(const Duration(days: 30)),
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setState(() {
                      _filter = DashboardFilter(
                        search: _filter.search,
                        cities: _filter.cities,
                        statuses: _filter.statuses,
                        industries: _filter.industries,
                        startDate: DateFormat('yyyy-MM-dd').format(picked),
                        endDate: _filter.endDate,
                        minRevenue: _filter.minRevenue,
                        maxRevenue: _filter.maxRevenue,
                        minProbability: _filter.minProbability,
                        maxProbability: _filter.maxProbability,
                        sortBy: _filter.sortBy,
                        sortOrder: _filter.sortOrder,
                        limit: _filter.limit,
                        offset: _filter.offset,
                      );
                    });
                  }
                },
                icon: const Icon(Icons.calendar_today),
                label: Text(
                  _filter.startDate ?? 'Start Date',
                  style: TextStyle(
                    color: _filter.startDate != null ? null : Colors.grey[600],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _filter.endDate != null
                        ? DateTime.parse(_filter.endDate!)
                        : DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setState(() {
                      _filter = DashboardFilter(
                        search: _filter.search,
                        cities: _filter.cities,
                        statuses: _filter.statuses,
                        industries: _filter.industries,
                        startDate: _filter.startDate,
                        endDate: DateFormat('yyyy-MM-dd').format(picked),
                        minRevenue: _filter.minRevenue,
                        maxRevenue: _filter.maxRevenue,
                        minProbability: _filter.minProbability,
                        maxProbability: _filter.maxProbability,
                        sortBy: _filter.sortBy,
                        sortOrder: _filter.sortOrder,
                        limit: _filter.limit,
                        offset: _filter.offset,
                      );
                    });
                  }
                },
                icon: const Icon(Icons.calendar_today),
                label: Text(
                  _filter.endDate ?? 'End Date',
                  style: TextStyle(
                    color: _filter.endDate != null ? null : Colors.grey[600],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRangeInputs(
    String title,
    TextEditingController minController,
    TextEditingController maxController,
    String minHint,
    String maxHint,
    String prefix,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: minController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: minHint,
                  prefixText: prefix,
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text(' - '),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: maxController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: maxHint,
                  prefixText: prefix,
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () {
              setState(() {
                _filter = DashboardFilter();
                _minRevenueController.clear();
                _maxRevenueController.clear();
                _minProbabilityController.clear();
                _maxProbabilityController.clear();
              });
            },
            child: const Text('Clear All'),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              // Update filter with range values
              double? minRevenue;
              double? maxRevenue;
              double? minProbability;
              double? maxProbability;

              if (_minRevenueController.text.isNotEmpty) {
                minRevenue = double.tryParse(_minRevenueController.text);
              }
              if (_maxRevenueController.text.isNotEmpty) {
                maxRevenue = double.tryParse(_maxRevenueController.text);
              }
              if (_minProbabilityController.text.isNotEmpty) {
                minProbability = double.tryParse(
                  _minProbabilityController.text,
                );
              }
              if (_maxProbabilityController.text.isNotEmpty) {
                maxProbability = double.tryParse(
                  _maxProbabilityController.text,
                );
              }

              final finalFilter = DashboardFilter(
                search: _filter.search,
                cities: _filter.cities,
                statuses: _filter.statuses,
                industries: _filter.industries,
                startDate: _filter.startDate,
                endDate: _filter.endDate,
                minRevenue: minRevenue,
                maxRevenue: maxRevenue,
                minProbability: minProbability,
                maxProbability: maxProbability,
                sortBy: _filter.sortBy,
                sortOrder: _filter.sortOrder,
                limit: _filter.limit,
                offset: _filter.offset,
              );

              widget.onApplyFilter(finalFilter);
              Navigator.of(context).pop();
            },
            child: const Text('Apply Filters'),
          ),
        ],
      ),
    );
  }
}
