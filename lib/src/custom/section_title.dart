
import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String? text;
  final Widget? rightAlignedWidget;
  const SectionTitle(this.text, {super.key, this.rightAlignedWidget});

  @override
  Widget build(BuildContext context) {
    return text != null || text != ""
        ? Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        text!,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    rightAlignedWidget ?? const SizedBox.shrink(),
                  ],
                ),
                const SizedBox(height: 8.0),
                const Divider(),
              ],
            ),
          )
        : Divider();
  }
}
