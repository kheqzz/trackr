import 'package:flutter/material.dart';

import 'package:trackr/helper/helper.dart';

class IconWord extends StatefulWidget {
  final Color? iconColor;
  final void Function()? onTap;
  final String? presetsName;
  const IconWord({
    super.key,
    required this.iconColor,
    this.onTap,
    this.presetsName,
  });

  @override
  State<IconWord> createState() => _IconWordState();
}

class _IconWordState extends State<IconWord> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Color(0xffd7d5cd)),
          ),
          child: Row(
            spacing: 5,
            children: [
              SizedBox(
                height: 28,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: widget.iconColor,
                    ),
                    child: Center(
                      child: Text(
                        widget.presetsName!.toInitials(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
