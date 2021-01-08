import 'dart:core';

import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorPayment extends StatefulWidget {
  final Function onFinish;
  final String razorKey;
  final double amount;
  final String name;
  final String currency;
  final String contact;
  final String email;

  RazorPayment(
      {this.onFinish,
      this.razorKey,
      this.amount,
      this.name,
      this.currency,
      this.contact,
      this.email});

  @override
  State<StatefulWidget> createState() {
    return RazorPaymentState();
  }
}

class RazorPaymentState extends State<RazorPayment> {
  Razorpay _razorpay;

  @override
  void initState() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    super.initState();
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  _handlePaymentSuccess(PaymentSuccessResponse response) {
    debugPrint('Razor Payment succeeds: ${response.paymentId}');
    widget.onFinish(response.paymentId);
    Navigator.pop(context);
  }

  _handlePaymentError(PaymentFailureResponse response) {
    debugPrint("Razor Payment fails: ${response.code} - ${response.message}");
    widget.onFinish(null);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    var options = {
      'key': widget.razorKey,
      'amount': widget.amount,
      'name': widget.name,
      'currency': widget.currency,
      'prefill': {'contact': widget.contact, 'email': widget.email}
    };
    _razorpay.open(options);
    return Container();
  }
}
