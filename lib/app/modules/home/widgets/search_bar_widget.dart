import 'package:flutter/material.dart';
import 'package:perfume_app/app/modules/widgets/text_widget.dart';

class SearchBarWidget extends StatelessWidget {
  final Function(String) onChanged;
  final VoidCallback onScanPressed;

  const SearchBarWidget({
    super.key,
    required this.onChanged,
    required this.onScanPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(41),
              border: Border.all(color: Colors.grey[300]!, width: 1),
            ),
            child: TextField(
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: 'Search..',
                hintStyle: TextStyle(color: Colors.grey[500], fontSize: 16),
                prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: GestureDetector(
            onTap: onScanPressed,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFFF4444),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: TextWidget(
                        text: 'Scan Here',
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Image.asset('assets/icons/barcode.png'),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
