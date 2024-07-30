import 'package:flutter/material.dart';

class SearchingDialog extends StatefulWidget {
  final bool showFilter;
  final List<String> history;
  final String searchHint;
  
  const SearchingDialog({
    super.key, 
    required this.showFilter, 
    required this.history, 
    required this.searchHint,
  });

  @override
  State<SearchingDialog> createState() => SearchingDialogState();
}


class SearchingDialogState extends State<SearchingDialog> {


  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    String _searchQuery;  
    
    return AlertDialog(
      contentPadding: const EdgeInsets.all(20),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: widget.searchHint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onSubmitted: (value){
              _searchQuery = value;
              Navigator.of(context).pop(_searchQuery);
            },
          ),
          Divider( color: colorScheme.outline),
          Text("搜尋紀錄"),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
                alignment: WrapAlignment.start,
                spacing: 8,
                runSpacing: 5,
                children: widget.history.map((tag) {
                  return FilterChip(
                    label: Text(tag, 
                    ),
                    onSelected: (bool value) {
                      _searchQuery = tag;
                      Navigator.of(context).pop(_searchQuery);
                    },
                    labelPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                    labelStyle: TextStyle(fontSize: 14.0),
                  );
                }).toList(),
              ),
          ),
        ],
      ),
    );
  }
}