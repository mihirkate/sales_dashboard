import 'package:flutter/material.dart';
import '../models/sales_data.dart';
import '../services/api_service.dart';

class SearchBarWidget extends StatefulWidget {
  final Function(String) onSearchChanged;
  final String? initialValue;

  const SearchBarWidget({
    super.key,
    required this.onSearchChanged,
    this.initialValue,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<SearchSuggestion> _suggestions = [];
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      _controller.text = widget.initialValue!;
    }
    _loadSuggestions();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _loadSuggestions([String? query]) async {
    try {
      final suggestions = await ApiService.fetchSearchSuggestions(query: query);
      setState(() {
        _suggestions = suggestions;
      });
    } catch (e) {
      // Handle error silently
    }
  }

  void _onSearchChanged(String value) {
    widget.onSearchChanged(value);
    if (value.length >= 2) {
      _loadSuggestions(value);
      setState(() {
        _showSuggestions = true;
      });
    } else {
      setState(() {
        _showSuggestions = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search sales data...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _controller.clear();
                        widget.onSearchChanged('');
                        setState(() {
                          _showSuggestions = false;
                        });
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ),
        if (_showSuggestions && _suggestions.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: _suggestions.take(5).map((suggestion) {
                return ListTile(
                  dense: true,
                  leading: Icon(
                    _getIconForType(suggestion.type),
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  title: Text(
                    suggestion.text,
                    style: const TextStyle(fontSize: 14),
                  ),
                  subtitle: suggestion.category != null
                      ? Text(
                          suggestion.category!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        )
                      : null,
                  onTap: () {
                    _controller.text = suggestion.text;
                    widget.onSearchChanged(suggestion.text);
                    setState(() {
                      _showSuggestions = false;
                    });
                    _focusNode.unfocus();
                  },
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  IconData _getIconForType(String type) {
    switch (type.toLowerCase()) {
      case 'name':
        return Icons.person;
      case 'city':
        return Icons.location_city;
      case 'industry':
        return Icons.business;
      case 'status':
        return Icons.flag;
      default:
        return Icons.search;
    }
  }
}
