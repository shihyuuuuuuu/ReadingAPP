import 'package:flutter/material.dart';
import 'package:reading_app/ui/bookshelf/book_state.dart';
import 'package:reading_app/ui/bookshelf/book_search_query.dart';
import 'package:reading_app/ui/tags.dart';


class BookshelfPage extends StatefulWidget {
  const BookshelfPage({super.key});

  @override
  State<BookshelfPage> createState() => _BookshelfPageState();
}

class _BookshelfPageState extends State<BookshelfPage> {
  
  BookSearchQuery _searchCondition = BookSearchQuery(); 

  Future<void> _showPopup(BuildContext context) async {
    final result = await showDialog<BookSearchQuery>(
      context: context,
      builder: (BuildContext context) {
        return _SearchingDialog();
      },
    );

    if (result != null) {
      setState(() {
        _searchCondition = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    // will use database in the future
    List<String> img = [
      "https://d1csarkz8obe9u.cloudfront.net/themedlandingpages/tlp_hero_book-cover-adb8a02f82394b605711f8632a44488b.jpg",
      "https://edit.org/images/cat/book-covers-big-2019101610.jpg",
      "https://d1csarkz8obe9u.cloudfront.net/posterpreviews/yellow-business-leadership-book-cover-design-template-dce2f5568638ad4643ccb9e725e5d6ff.jpg",
    ];
    List<String> tags = ["小說","文學","經典"];
    List<String> bookName = ["原子習慣", "小婦人", "小王子"];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        title: Text('書架', style: textTheme.headlineLarge,),
        actions: <Widget>[
          Container(
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.secondaryContainer,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.7),
                  blurRadius: 5.0,
                  offset: const Offset(0, 3), 
                ),
              ],
            ),
            child: IconButton(
              iconSize: 28,
              color: colorScheme.onSecondaryContainer,
              icon: const Icon(Icons.search),
              onPressed: () => _showPopup(context),
            ),
          ),
        ],
      ),
      body: Center(
        child: GridView.count(
          padding: const EdgeInsets.all(28.0),
          mainAxisSpacing: 20.0,
          crossAxisSpacing: 24.0,
          crossAxisCount: 2,
          childAspectRatio: (0.51),
          children: [
            // use this to test data:
            // Text('search condition: ${_searchCondition.name}, with filter ${_searchCondition.filter.map((BookStateFilter e) => e.str).join(', ')}'),
            
            _BookCard(img: img[0], bookName: bookName[0], tags: tags),
            _BookCard(img: img[1], bookName: bookName[1], tags: tags),
            _BookCard(img: img[2], bookName: bookName[2], tags: tags),
            _BookCard(img: img[0], bookName: bookName[0], tags: tags),
            _BookCard(img: img[1], bookName: bookName[1], tags: tags),
            ],
          ),
      
      ),
    );
  }
}


class _BookCard extends StatelessWidget{
  final String img;
  final String bookName;
  final List<String> tags;
  const _BookCard({
    super.key,
    required this.img,
    required this.bookName,
    required this.tags,
    });
  

  @override
  Widget build(BuildContext context) {

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 8,
      color: colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.only(top: 15, right: 10, left: 10, bottom: 5),
        child: (
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(img,),
              const SizedBox(height: 10,),
              Text(
                bookName, 
                style: textTheme.titleMedium,
              ),
              const SizedBox(height: 6,),
              Row(
                children: 
                  tags.map((item) => Tag(text:item)).toList()
                )
            ],)
          ),
      )
      );
  }
}




class _SearchingDialog extends StatefulWidget {
  @override
  State<_SearchingDialog> createState() => _SearchingDialogState();
}

class _SearchingDialogState extends State<_SearchingDialog> {


  final BookSearchQuery _searchCondition = BookSearchQuery();
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
              _searchCondition.queryString = value;
              Navigator.of(context).pop(_searchCondition);
            },
            controller: _textController,
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 10,
            children: 
              BookState.values.map((BookState bookstate){
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
                _searchCondition.queryString = _textController.text;
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