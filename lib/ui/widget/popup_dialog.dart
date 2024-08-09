import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reading_app/service/navigation.dart';
import 'package:reading_app/ui/widget/popup_event.dart';

class PopupDialog extends StatelessWidget{

  final String? title;
  final List<popupEvent> options;

  const PopupDialog({
    super.key, 
    this.title, 
    required this.options
  });

  @override
  Widget build(BuildContext context) {
    
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final nav = Provider.of<NavigationService>(context, listen: false);

    void onPressed(popupEvent item){
      item.onPressed();
      Navigator.of(context).pop();
    }

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 5.0,
      backgroundColor: colorScheme.surface,
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            (title!=null)?_HintText(text:title!):SizedBox(),
            Wrap(
              runSpacing: 8.0,
              spacing: 8.0,
              children: options.map((item) => InkWell(
                onTap: ()=>{ onPressed(item)},
                child: ListTile(
                    leading: item.icon,
                    title: Text(item.text, style: textTheme.titleLarge),
                  ),
              )).toList()
            )
          ],
        ),
      ),
    );
  }
}

class _HintText extends StatelessWidget {
  final String text;

  const _HintText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(text),
        Divider(),
      ],
    );
  }
}