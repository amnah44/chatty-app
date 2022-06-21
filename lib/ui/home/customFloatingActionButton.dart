import 'package:flutter/material.dart';

class CustomFloatingActionButton extends StatelessWidget {
  CustomFloatingActionButton({
    Key? key,
    required this.isExtended,
    required this.onClick,
  }) : super(key: key);
  bool isExtended;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: FloatingActionButton.extended(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: Colors.black54,
        onPressed: () => {onClick.call()},
        label: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) =>
              FadeTransition(
            opacity: animation,
            child: SizeTransition(
              child: child,
              sizeFactor: animation,
              axis: Axis.horizontal,
            ),
          ),
          child: isExtended
              ? const Center(
                  child: Icon(Icons.arrow_drop_down),
                )
              : null,
        ),
      ),
    );
  }
}
