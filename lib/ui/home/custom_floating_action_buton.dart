import 'package:flutter/material.dart';

class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton({
    Key? key,
    required this.onClick,
  }) : super(key: key);

  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 50,
      child: FloatingActionButton.extended(
        isExtended: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        backgroundColor: Colors.black54,
        onPressed: () {
          onClick.call();
        },
        label: const Center(
          child: Icon(Icons.arrow_downward),
        ),
      ),
    );
  }
}
