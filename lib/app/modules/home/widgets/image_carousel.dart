// ignore_for_file: must_be_immutable

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:perfume_app/app/domain/entities/home_data_entity.dart';

class PerfumeBanner extends StatefulWidget {
  List<CarouselItemEntity> items = [];
  PerfumeBanner({super.key, required this.items});

  @override
  _PerfumeBannerState createState() => _PerfumeBannerState();
}

class _PerfumeBannerState extends State<PerfumeBanner> {
  int currentIndex = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(milliseconds: 2000), (timer) {
      setState(() {
        currentIndex = (currentIndex + 1) % widget.items.length;
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.23,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            widget.items[currentIndex].image!,
            key: ValueKey<int>(currentIndex),
            fit: BoxFit.fill,
            width: double.infinity,
            height: double.infinity,
            loadingBuilder: (
              BuildContext context,
              Widget child,
              ImageChunkEvent? loadingProgress,
            ) {
              if (loadingProgress == null) {
                return child;
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
