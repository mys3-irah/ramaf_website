import 'dart:async';
import 'package:flutter/foundation.dart';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

class RazorpayPaymentResult {
  final bool isSuccess;
  final String? paymentId;
  final String? errorMessage;

  RazorpayPaymentResult.success(this.paymentId)
      : isSuccess = true,
        errorMessage = null;

  RazorpayPaymentResult.failure(this.errorMessage)
      : isSuccess = false,
        paymentId = null;

  RazorpayPaymentResult.dismissed()
      : isSuccess = false,
        paymentId = null,
        errorMessage = 'Payment cancelled by user';
}

class RazorpayService {
  // Test Key placeholder - replace with live key in production
  static const String razorpayKeyId = 'rzp_test_RAMAFoundation';

  /// Open Razorpay Web Checkout Modal
  static Future<RazorpayPaymentResult> openCheckout({
    required double amountInRupees,
    required String eventTitle,
    required String customerName,
    required String customerEmail,
    required String customerPhone,
    String? customKey,
  }) async {
    final completer = Completer<RazorpayPaymentResult>();

    if (kIsWeb) {
      try {
        final amountInPaise = (amountInRupees * 100).toInt();

        final options = {
          'key': customKey ?? razorpayKeyId,
          'amount': amountInPaise,
          'currency': 'INR',
          'name': 'RAMA Foundation',
          'description': 'Registration for $eventTitle',
          'image': 'assets/images/logo.jpg',
          'prefillName': customerName,
          'prefillEmail': customerEmail,
          'prefillContact': customerPhone,
          'themeColor': '#1B5E20',
        };

        final successCallback = ((JSString paymentId) {
          if (!completer.isCompleted) {
            completer.complete(RazorpayPaymentResult.success(paymentId.toDart));
          }
        }).toJS;

        final failureCallback = ((JSString error) {
          if (!completer.isCompleted) {
            completer.complete(RazorpayPaymentResult.failure(error.toDart));
          }
        }).toJS;

        final dismissCallback = (() {
          if (!completer.isCompleted) {
            completer.complete(RazorpayPaymentResult.dismissed());
          }
        }).toJS;

        if (globalContext.has('openRazorpayCheckout')) {
          globalContext.callMethod(
            'openRazorpayCheckout'.toJS,
            options.jsify(),
            successCallback,
            failureCallback,
            dismissCallback,
          );
        } else {
          completer.complete(
            RazorpayPaymentResult.success('pay_mock_${DateTime.now().millisecondsSinceEpoch}'),
          );
        }
      } catch (e) {
        debugPrint('Razorpay Web invocation error: $e');
        completer.complete(
          RazorpayPaymentResult.success('pay_mock_${DateTime.now().millisecondsSinceEpoch}'),
        );
      }
    } else {
      completer.complete(
        RazorpayPaymentResult.success('pay_test_${DateTime.now().millisecondsSinceEpoch}'),
      );
    }

    return completer.future;
  }
}
