import 'package:flutter/material.dart';

class SlideLoginDots extends StatelessWidget {
  SlideLoginDots({Key? key, required this.isActive}) : super(key: key);

  bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      height: isActive ? 12 : 8,
      width: isActive ? 12 : 8,
      decoration: BoxDecoration(
        color: isActive? Theme.of(context).primaryColorDark : Theme.of(context).primaryColorLight,
        borderRadius: BorderRadius.circular(12)
      ),
    );
  }
}
