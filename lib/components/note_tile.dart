import 'package:flutter/material.dart';
import 'package:note_app_flutter2/components/note_settings.dart';
import 'package:popover/popover.dart';

class NoteTile extends StatelessWidget {
  final String text;
  final void Function()? onEditPressed;
  final void Function()? onDeletePressed;
  final void Function()? onAnalyzePressed;
  const NoteTile({
    super.key,
    required this.text,
    required this.onEditPressed,
    required this.onDeletePressed,
    required this.onAnalyzePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.only(top: 10, left: 25, right: 25),
      child: ListTile(
        title: Text(text),
        trailing: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => showPopover(
              width: 200,
              height: 150,
              backgroundColor: Theme.of(context).colorScheme.surface,
              context: context,
              bodyBuilder: (context) => NoteSettings(
                onEditTap: onEditPressed,
                onDeleteTap: onDeletePressed,
                onAnalyzeTap: onAnalyzePressed,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
