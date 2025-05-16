import 'dart:io';

import '../../exports.dart';

class ErrorHandler extends GetxService {
  static ErrorHandler get to => Get.find<ErrorHandler>();

  final RxString _errorMessage = ''.obs;
  String get errorMessage => _errorMessage.value;

  // Initialize the service
  Future<ErrorHandler> init() async {
    print('ErrorHandler initialized');
    return this;
  }

  Future<void> handleError(dynamic error, {String? customMessage, bool showSnackbar = true}) async {
    String message = customMessage ?? 'An unexpected error occurred.';

    if (error is FirebaseAuthException) {
      message = _handleFirebaseAuthError(error);
    } else if (error is FirebaseException) {
      message = _handleFirebaseError(error);
    } else if (error is SocketException || error is TimeoutException) {
      message = 'Network error. Please check your connection.';
    } else if (error is TypeError) {
      message = 'Type error. Please try again.';
    } else if (error is String) {
      message = error;
    }

    // Store the error message
    _errorMessage.value = message;

    // Show a snackbar with the error message
    if (showSnackbar) {
      Get.snackbar(
        'Error',
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        margin: const EdgeInsets.all(10),
        duration: const Duration(seconds: 4),
        icon: const Icon(Icons.error_outline, color: Colors.white),
      );
    }

    // Log the error (could be integrated with a remote logging service)
    print('Error: $message');
    print('Original error: $error');
  }

  String _handleFirebaseAuthError(FirebaseAuthException error) {
    switch (error.code) {
      case 'user-not-found':
        return 'Account not found. Please check your email or sign up.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'Email already in use. Please use another email or sign in.';
      case 'weak-password':
        return 'Password is too weak. Please use a stronger password.';
      case 'invalid-email':
        return 'Invalid email format. Please enter a valid email.';
      case 'user-disabled':
        return 'Your account has been disabled. Please contact support.';
      case 'too-many-requests':
        return 'Too many unsuccessful login attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'This operation is not allowed. Please contact support.';
      case 'account-exists-with-different-credential':
        return 'An account already exists with the same email but different sign-in credentials.';
      case 'invalid-credential':
        return 'Invalid credentials. Please try again.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      default:
        return 'Authentication error: ${error.message ?? error.code}';
    }
  }

  String _handleFirebaseError(FirebaseException error) {
    switch (error.code) {
      case 'permission-denied':
        return 'Permission denied. You do not have the required permissions.';
      case 'not-found':
        return 'The requested resource was not found.';
      case 'already-exists':
        return 'The resource already exists.';
      case 'failed-precondition':
        return 'Operation failed due to a precondition not being met.';
      case 'unavailable':
        return 'The service is currently unavailable. Please try again later.';
      case 'data-loss':
        return 'Data loss occurred. Please contact support.';
      case 'unauthenticated':
        return 'You are not authenticated. Please sign in and try again.';
      default:
        return 'Firebase error: ${error.message ?? error.code}';
    }
  }

  // Utility method to safely perform database operations
  Future<T?> handleDatabaseOperation<T>({
    required Future<T> Function() operation,
    String? successMessage,
    String? errorMessage,
    bool showSuccessMessage = false,
    bool showErrorMessage = true,
  }) async {
    try {
      final result = await operation();

      if (showSuccessMessage && successMessage != null) {
        Get.snackbar(
          'Success',
          successMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
          margin: const EdgeInsets.all(10),
          duration: const Duration(seconds: 2),
          icon: const Icon(Icons.check_circle, color: Colors.white),
        );
      }

      return result;
    } catch (error) {
      handleError(error, customMessage: errorMessage, showSnackbar: showErrorMessage);
      return null;
    }
  }
}
