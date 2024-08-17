import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reading_app/service/navigation.dart';

class PopupEvent{
  final Icon icon;
  final String text;
  final void Function() onPressed;

  PopupEvent({
    required this.icon, 
    required this.text, 
    required this.onPressed
  });
}

void showPopup(BuildContext context, List<PopupEvent> popUpEvent) async {
  
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return _PopupDialog(options: popUpEvent,);
    },
  );
}

class _PopupDialog extends StatelessWidget{

  final String? title;
  final List<PopupEvent> options;

  const _PopupDialog({
    super.key, 
    this.title, 
    required this.options
  });

  @override
  Widget build(BuildContext context) {
    
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final nav = Provider.of<NavigationService>(context, listen: false);

    void onPressed(PopupEvent item){
      Navigator.of(context).pop();
      item.onPressed();
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
                    title: Text(item.text, style: textTheme.labelLarge),
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
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: Text(text, style: textTheme.headlineSmall),
        ),
        Divider(),
      ],
    );
  }
}