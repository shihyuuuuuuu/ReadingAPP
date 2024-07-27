
import 'package:flutter/material.dart';
import 'package:reading_app/pages/bookshelf/bookshelf_search_return_model.dart';

import 'bookshelf_filter_model.dart';

class BookshelfSearchContent extends StatefulWidget {
  @override
  _BookshelfSearchContentState createState() => _BookshelfSearchContentState();
}

class _BookshelfSearchContentState extends State<BookshelfSearchContent> {


  BookSearchReturn _searchCondition = BookSearchReturn();
  TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _textController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AlertDialog(
          contentPadding: EdgeInsets.all(20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: '輸入書名、作者或標籤',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onSubmitted: (value){
                  // if enter is pressed, then use textfield as search condition and search
                  _searchCondition.name = value;
                  Navigator.of(context).pop(_searchCondition);
                },
                controller: _textController,
              ),
              SizedBox(height: 20),
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
                    shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
                  ),
                  child: Text("搜尋", style: textTheme.labelLarge),
                  ),
              ),
            ],
          ),
        );
  }
}