import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:perfume_app/app/modules/widgets/text_widget.dart';
import 'auth_controller.dart';

class AuthView extends GetView<AuthController> {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF4444),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.local_florist,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 32),
              TextWidget(
                text: 'Welcome to Perfume',
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 16),
              TextWidget(
                text: 'Discover and explore the world of fragrances',
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
              const SizedBox(height: 48),
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        controller.isLoading.value
                            ? null
                            : controller.performAnonymousLogin,
                    child:
                        controller.isLoading.value
                            ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                            : const TextWidget(
                              text: 'Get Started',
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
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
