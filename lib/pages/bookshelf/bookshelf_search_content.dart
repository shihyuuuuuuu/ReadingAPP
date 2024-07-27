
import 'package:flutter/material.dart';
import 'package:reading_app/pages/bookshelf/bookshelf_search_return_model.dart';

import 'bookshelf_filter_model.dart';

class BookshelfSearchContent extends StatefulWidget {
  @override
  State<BookshelfSearchContent> createState() => _BookshelfSearchContentState();
}

class _BookshelfSearchContentState extends State<BookshelfSearchContent> {


  final BookSearchReturn _searchCondition = BookSearchReturn();
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AlertDialog(
      contentPadding: const EdgeInsets.all(20),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: '輸入書名、作者或標籤',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onSubmitted: (value){
              _searchCondition.name = value;
              Navigator.of(context).pop(_searchCondition);
            },
            controller: _textController,
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 10,
            children: 
              BookStateFilter.values.map((BookStateFilter bookstate){
                return FilterChip(
                  label: Text(bookstate.str), 
                  selected: _searchCondition.filter.contains(bookstate),
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        _searchCondition.filter.add(bookstate);
                      } else {
                        _searchCondition.filter.remove(bookstate);
                      }
                    });
                  },
                );
              }).toList(),
          ),
          const SizedBox(height: 10.0),
          SizedBox(
            width: double.infinity,
            child: FilledButton.tonal(
              onPressed:(){
                _searchCondition.name = _textController.text;
                Navigator.of(context).pop(_searchCondition);
              } , 
              style: ButtonStyle(
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))
                ),
              ),
              child: Text("搜尋", style: textTheme.labelLarge),
              ),
          ),
        ],
      ),
    );
  }
}