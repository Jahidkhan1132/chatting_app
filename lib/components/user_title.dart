import 'package:flutter/material.dart';

class UserTitle extends StatelessWidget {
  final String text;
  final void Function()? onTop;
  final bool hasUnreadMessages;

  const UserTitle({
    super.key,
    required this.text,
    required this.onTop,
    this.hasUnreadMessages = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTop,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            const Icon(Icons.person),
            const SizedBox(width: 20),
            Expanded(child: Text(text)),
            if (hasUnreadMessages)
              Icon(
                Icons.mark_email_unread,
                color: Colors.red,
              ),
          ],
        ),
      ),
    );
  }
}
