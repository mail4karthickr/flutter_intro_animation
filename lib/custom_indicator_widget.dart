import 'package:flutter/material.dart';

class CustomIndicator extends StatelessWidget {
  // View Properties
  final int totalPages;
  final int currentPage;
  final Color activeTint;
  final Color inActiveTint;

  CustomIndicator({super.key, 
    required this.totalPages,
    required this.currentPage,
    this.activeTint = Colors.black,
    Color? inActiveTint,
  }) : inActiveTint = inActiveTint?.withOpacity(0.5) ?? Colors.grey.withOpacity(0.5);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(
        totalPages,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: currentPage == index ? activeTint : inActiveTint,
            ),
          ),
        ),
      ),
    );
  }
}
