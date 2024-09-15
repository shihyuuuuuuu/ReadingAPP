import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reading_app/data/models/user_book.dart';
import 'package:reading_app/service/navigation.dart';
import 'package:reading_app/view_models/userbooks_vm.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _StatItem(
                    icon: Icons.local_fire_department,
                    color: Colors.red,
                    count: 142,
                  ),
                  _StatItem(
                    icon: Icons.book,
                    color: Colors.brown,
                    count: 87,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Your weekly report',
                style: textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ReportItem(
                    title: 'Books read',
                    count: 3,
                    change: 2,
                    rise: true,
                  ),
                  _ReportItem(
                    title: 'Reading time',
                    count: '5h 15m',
                    change: '1h 24m',
                    rise: false,
                  ),
                  _ReportItem(
                    title: 'Notes taken',
                    count: 6,
                    change: 2,
                    rise: true,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Now reading',
                style: textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 320,
                child: Consumer<UserBooksViewModel>(
                  builder: (context, viewModel, _) {
                    List<UserBook> userBooks = viewModel.userBooks;

                    if (userBooks.isEmpty) {
                      return const Center(child: Text('No books.'));
                    } else {
                      return ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: userBooks.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 20),
                        itemBuilder: (context, index) {
                          return _BookCard(
                            userBook: userBooks[index],
                            // TODO: get real 'totalTime' and 'notes'
                            totalTime: '35',
                            notes: 5,
                          );
                        },
                        clipBehavior: Clip.none,
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Challenges',
                style: textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.local_fire_department,
                      color: Colors.red,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '200 Days Reading Streak',
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final int count;

  const _StatItem({
    required this.icon,
    required this.color,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: color,
          size: 24,
        ),
        const SizedBox(width: 4),
        Text(
          '$count',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _ReportItem extends StatelessWidget {
  final String title;
  final dynamic count;
  final dynamic change;
  final bool rise;

  const _ReportItem({
    required this.title,
    required this.count,
    required this.change,
    required this.rise,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    Color changeColor = Colors.red;
    IconData icon = Icons.arrow_downward;
    if (rise) {
      changeColor = Colors.green;
      icon = Icons.arrow_upward;
    }

    return Column(
      children: [
        Text(
          title,
          style: textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        Text(
          count.toString(),
          style:
              textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: changeColor,
            ),
            Text(
              change.toString(),
              style: TextStyle(color: changeColor),
            ),
          ],
        ),
      ],
    );
  }
}

class _BookCard extends StatelessWidget {
  final UserBook userBook;
  final String totalTime;
  final int notes;

  const _BookCard({
    required this.userBook,
    required this.totalTime,
    required this.notes,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final nav = Provider.of<NavigationService>(context, listen: false);
    final startDate = DateFormat('yyyy-MM-dd').format(userBook.startDate);

    return SizedBox(
      height: 320,
      width: 320,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          nav.goBookDetail(userBook.id!);
                        },
                        child: Image.network(
                          userBook.book.coverImage!,
                          width: 115,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'From $startDate',
                            style: textTheme.bodyMedium,
                          ),
                          Text(
                            'Total $totalTime',
                            style: textTheme.bodyMedium,
                          ),
                          Row(
                            children: [
                              const Icon(Icons.edit, size: 16),
                              const SizedBox(width: 4),
                              Text('$notes notes'),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      userBook.book.title,
                      style: textTheme.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.grey),
              onPressed: () {
                // TODO: Tap icon to remove book from reading list
              },
            ),
          ),
          Positioned(
            bottom: -12,
            right: 12,
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(27),
              ),
              child: Row(
                children: [
                  const Icon(Icons.timer, color: Colors.white),
                  const VerticalDivider(
                    width: 20,
                    thickness: 1,
                    indent: 0,
                    endIndent: 0,
                    color: Colors.white,
                  ),
                  GestureDetector(
                    onTap: () => nav.goEditNote("-", userBook.id as String),
                    child: const Icon(Icons.edit, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
