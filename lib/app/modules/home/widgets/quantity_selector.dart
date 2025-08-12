import 'package:flutter/material.dart';

class QuantitySelector extends StatelessWidget {
  final int count;
  final VoidCallback onAdd;
  final VoidCallback onSubtract;

  const QuantitySelector({
    super.key,
    required this.count,
    required this.onAdd,
    required this.onSubtract,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48, // Match the height of your CustomButton
      decoration: BoxDecoration(
        color: Colors.red, // Background color
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            child: IconButton(
              icon: const Icon(Icons.remove, color: Colors.white),
              onPressed: onSubtract,
            ),
          ),
          Text(
            count.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Flexible(
            child: IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: onAdd,
            ),
          ),
        ],
      ),
    );
  }
}
