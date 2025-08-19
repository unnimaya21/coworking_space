import 'package:coworking_space_app/app/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coworking_space_app/app/modules/widgets/text_widget.dart';
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
              SizedBox(
                width: 100,
                height: 100,

                child: Image.asset(
                  'assets/logo/logo.png',
                  width: 50,
                  height: 50,
                ),
              ),
              const SizedBox(height: 32),
              TextWidget(
                text: 'Welcome to Coworking Space',
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),

              const SizedBox(height: 48),
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        controller.isLoading.value
                            ? Colors.grey
                            : AppColors.secondaryColor,
                      ),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    onPressed:
                        controller.isLoading.value ? null : controller.goToHome,
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
                              color: Colors.white,
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
