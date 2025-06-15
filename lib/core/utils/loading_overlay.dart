import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingOverlay {
  static bool _isShowing = false;
  
  static void show({String? message}) {
    if (_isShowing) return;
    
    _isShowing = true;
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: Material(
          color: Colors.black54,
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  if (message != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      message,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
  
  static void hide() {
    if (_isShowing) {
      _isShowing = false;
      Get.back();
    }
  }
}