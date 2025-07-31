
import 'package:flutter/material.dart';

class GpaProgressBar extends StatelessWidget {
  final double userGpa;
  final double requiredGpa;

  const GpaProgressBar({
    Key? key,
    required this.userGpa,
    required this.requiredGpa,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double remainingGpa = (userGpa - requiredGpa).clamp(0.0, double.infinity);
    final totalFlex = requiredGpa + remainingGpa;

    if (totalFlex == 0) {
      return Container(
        height: 10,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(5),
        ),
      );
    }

    return Container(
      height: 10,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Expanded(
            flex: (requiredGpa / totalFlex * 100).toInt(),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                  topRight: remainingGpa == 0 ? Radius.circular(5) : Radius.zero,
                  bottomRight: remainingGpa == 0 ? Radius.circular(5) : Radius.zero,
                ),
              ),
            ),
          ),
          if (remainingGpa > 0)
            Expanded(
              flex: (remainingGpa / totalFlex * 100).toInt(),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
