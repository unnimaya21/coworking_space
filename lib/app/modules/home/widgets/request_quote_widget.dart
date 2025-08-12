import 'package:flutter/material.dart';
import 'package:perfume_app/app/modules/home/widgets/custom_button.dart';
import 'package:perfume_app/app/modules/widgets/text_widget.dart';

class RequestQuoteWidget extends StatelessWidget {
  const RequestQuoteWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'assets/images/quote.png',
              fit: BoxFit.contain,
              width: double.infinity,
              height: 180,
            ),
          ),
          Positioned(
            top: 46,
            left: 16,
            child: Column(
              children: [
                TextWidget(
                  text: 'Request for Quote',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.35,
                  height: 40,
                  child: CustomButton(
                    text: 'Create RFQ',
                    backgroundColor: Colors.white,
                    textColor: Colors.black,
                    borderColor: Colors.black,
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
