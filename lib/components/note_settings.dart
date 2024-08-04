import 'package:flutter/material.dart';

class NoteSettings extends StatelessWidget {
  final void Function()? onEditTap;
  final void Function()? onDeleteTap;
  final void Function()? onAnalyzeTap;

  const NoteSettings({
    super.key,
    required this.onEditTap,
    required this.onDeleteTap,
    required this.onAnalyzeTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize = screenWidth * 0.05; // 화면 너비의 5%로 아이콘 크기 설정

    return Column(
      children: [
        // edit option
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
            onEditTap!();
          },
          child: Container(
            height: 40,
            color: Theme.of(context).colorScheme.surface,
            child: Center(
              child: Text(
                "Edit",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),

        // delete option
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
            onDeleteTap!();
          },
          child: Container(
            height: 40,
            color: Theme.of(context).colorScheme.surface,
            child: Center(
              child: Text(
                "Delete",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),

        // analyze option
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
            if (onAnalyzeTap != null) {
              onAnalyzeTap!();
            }
          },
          child: Container(
            height: 40,
            color: Theme.of(context).colorScheme.surface,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  '/Users/seoin/StudioProjects/note_app_flutter2/assets/icon/google-gemini-icon.png',
                  width: iconSize,
                  height: iconSize,
                ),
                SizedBox(width: 8),
                Text(
                  "Analyze",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
