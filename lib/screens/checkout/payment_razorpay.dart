/*
 Use this file replace to the payment.dart if using the RazoPay payment
 We have stopped support Razopay from 1.6.6 due to the build issue on latest XCode - https://github.com/razorpay/razorpay-flutter/issues/57
*/

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../common/config.dart';
import '../../common/constants.dart';
import '../../common/tools.dart';
import '../../generated/l10n.dart';
import '../../models/index.dart'
    show AppModel, CartModel, Order, PaymentMethodModel, UserModel;
import '../../services/index.dart' show Services;
import '../../widgets/payment/paypal/index.dart';
import '../../widgets/payment/tap/index.dart';
import 'payment_webview.dart';

class PaymentMethods extends StatefulWidget {
  final Function onBack;
  final Function onFinish;
  final Function(bool) onLoading;

  PaymentMethods({this.onBack, this.onFinish, this.onLoading});

  @override
  _PaymentMethodsState createState() => _PaymentMethodsState();
}

class _PaymentMethodsState extends State<PaymentMethods> {
  String selectedId;
  final _razorpay = Razorpay();

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      final cartModel = Provider.of<CartModel>(context, listen: false);
      final userModel = Provider.of<UserModel>(context, listen: false);
      Provider.of<PaymentMethodModel>(context, listen: false).getPaymentMethods(
          cartModel: cartModel,
          shippingMethod: cartModel.shippingMethod,
          token: userModel.user != null ? userModel.user.cookie : null);
    });

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    createOrder(paid: true);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Tools.showSnackBar(Scaffold.of(context), response.message);
    printLog(response.message);
  }

  @override
  Widget build(BuildContext context) {
    final cartModel = Provider.of<CartModel>(context);
    final paymentMethodModel = Provider.of<PaymentMethodModel>(context);

    return ListenableProvider.value(
        value: paymentMethodModel,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(S.of(context).paymentMethods,
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 5),
            Text(
              S.of(context).chooseYourPaymentMethod,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).accentColor.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 20),
            Consumer<PaymentMethodModel>(builder: (context, model, child) {
              if (model.isLoading) {
                return Container(height: 100, child: kLoadingWidget(context));
              }

              if (model.message != null) {
                return Container(
                  height: 100,
                  child: Center(
                      child: Text(model.message,
                          style: const TextStyle(color: kErrorRed))),
                );
              }

              if (selectedId == null && model.paymentMethods.isNotEmpty) {
                selectedId =
                    model.paymentMethods.firstWhere((item) => item.enabled).id;
              }

              return Column(
                children: <Widget>[
                  for (int i = 0; i < model.paymentMethods.length; i++)
                    model.paymentMethods[i].enabled
                        ? Column(
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedId = model.paymentMethods[i].id;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: model.paymentMethods[i].id ==
                                              selectedId
                                          ? Theme.of(context).primaryColorLight
                                          : Colors.transparent),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 10),
                                    child: Row(
                                      children: <Widget>[
                                        Radio(
                                            value: model.paymentMethods[i].id,
                                            groupValue: selectedId,
                                            onChanged: (i) {
                                              setState(() {
                                                selectedId = i;
                                              });
                                            }),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              if (Payments[model
                                                      .paymentMethods[i].id] !=
                                                  null)
                                                Image.asset(
                                                  Payments[model
                                                      .paymentMethods[i].id],
                                                  width: 120,
                                                  height: 30,
                                                ),
                                              if (Payments[model
                                                      .paymentMethods[i].id] ==
                                                  null)
                                                Text(
                                                  model.paymentMethods[i].title,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Theme.of(context)
                                                        .accentColor
                                                        .withOpacity(0.8),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const Divider(height: 1)
                            ],
                          )
                        : Container()
                ],
              );
            }),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    S.of(context).subtotal,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).accentColor.withOpacity(0.8),
                    ),
                  ),
                  Text(
                      Tools.getCurrencyFormatted(cartModel.getSubTotal(),
                          Provider.of<CartModel>(context).currencyRates,
                          currency: cartModel.currency),
                      style: const TextStyle(fontSize: 14, color: kGrey400))
                ],
              ),
            ),
            kAdvanceConfig['EnableShipping']
                ? Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "${cartModel.shippingMethod.title}",
                          style: TextStyle(
                            fontSize: 14,
                            color:
                                Theme.of(context).accentColor.withOpacity(0.8),
                          ),
                        ),
                        Text(
                          Tools.getCurrencyFormatted(
                              cartModel.getShippingCost(),
                              Provider.of<CartModel>(context).currencyRates,
                              currency: cartModel.currency),
                          style: TextStyle(
                            fontSize: 14,
                            color:
                                Theme.of(context).accentColor.withOpacity(0.8),
                          ),
                        )
                      ],
                    ),
                  )
                : Container(),
            if (cartModel.getCoupon() != '')
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      S.of(context).discount,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).accentColor.withOpacity(0.8),
                      ),
                    ),
                    Text(
                      cartModel.getCoupon(),
                      style: Theme.of(context).textTheme.headline5.copyWith(
                            fontSize: 14,
                            color:
                                Theme.of(context).accentColor.withOpacity(0.8),
                          ),
                    )
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    S.of(context).total,
                    style: TextStyle(
                        fontSize: 16, color: Theme.of(context).accentColor),
                  ),
                  Text(
                    Tools.getCurrencyFormatted(cartModel.getTotal(),
                        Provider.of<CartModel>(context).currencyRates,
                        currency: cartModel.currency),
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(children: [
              Expanded(
                child: ButtonTheme(
                  height: 45,
                  child: RaisedButton(
                    onPressed: () {
                      if (paymentMethodModel.paymentMethods.isNotEmpty) {
                        final paymentMethod = paymentMethodModel.paymentMethods
                            .firstWhere((item) => item.id == selectedId);
                        Provider.of<CartModel>(context, listen: false)
                            .setPaymentMethod(paymentMethod);
                        if (paymentMethod.id
                                .contains(PaypalConfig["paymentMethodId"]) &&
                            PaypalConfig["enabled"] == true) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaypalPayment(
                                onFinish: (number) {
                                  createOrder(paid: true);
                                },
                              ),
                            ),
                          );
                        } else if (paymentMethod.id
                                .contains(RazorpayConfig["paymentMethodId"]) &&
                            RazorpayConfig["enabled"] == true) {
                          var options = {
                            'key': RazorpayConfig["keyId"],
                            'amount': cartModel.getTotal() * 100.toInt(),
                            'name': cartModel.address.firstName +
                                " " +
                                cartModel.address.lastName,
                            'currency': "INR",
                            'prefill': {
                              'contact': cartModel.address.phoneNumber,
                              'email': cartModel.address.email
                            }
                          };
                          _razorpay.open(options);
                        } else if (paymentMethod.id
                                .contains(TapConfig["paymentMethodId"]) &&
                            TapConfig["enabled"] == true) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    TapPayment(onFinish: (number) {
                                      createOrder(paid: true);
                                    })),
                          );
                        } else {
                          if (paymentMethod.id == "cod" ||
                              serverConfig["type"] == "magento") {
                            createOrder(cod: true);
                          } else if (serverConfig["type"] == "woo") {
                            final user =
                                Provider.of<UserModel>(context, listen: false)
                                    .user;
                            var params = Order().toJson(
                                cartModel, user != null ? user.id : null, true);
                            params["token"] = user != null ? user.cookie : null;
                            makePaymentWebview(params);
                          } else if (serverConfig["type"] == "opencart") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PaymentWebview(onFinish: (number) {
                                        widget.onFinish(Order(number: number));
                                      })),
                            );
                          }
                        }
                      }
                    },
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    child: Text(S.of(context).placeMyOrder.toUpperCase()),
                  ),
                ),
              ),
            ]),
            Center(
              child: FlatButton(
                onPressed: () {
                  widget.onBack();
                },
                child: Text(
                  S.of(context).goBackToReview,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: 15,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
            )
          ],
        ));
  }

  Future<void> makePaymentWebview(Map<String, dynamic> params) async {
    try {
      widget.onLoading(true);
      final url = await Services().getCheckoutUrl(
          params, Provider.of<AppModel>(context, listen: false).langCode);
      widget.onLoading(false);
      await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PaymentWebview(
                url: url,
                onFinish: (number) {
                  widget.onFinish(Order(number: number));
                })),
      );
    } catch (e) {
      widget.onLoading(false);

      Tools.showSnackBar(Scaffold.of(context), e.toString());
    }
  }

  Future<void> createOrder({paid = false, cod = false}) async {
    final LocalStorage storage = LocalStorage('data_order');
    var listOrder = [];
    bool isLoggedIn = Provider.of<UserModel>(context, listen: false).loggedIn;

    widget.onLoading(true);
    final cartModel = Provider.of<CartModel>(context, listen: false);
    final userModel = Provider.of<UserModel>(context, listen: false);
    try {
      final order = await Services()
          .createOrder(cartModel: cartModel, user: userModel, paid: paid);
      if (cod && serverConfig["type"] == "woo") {
        await Services().updateOrder(order.id, status: 'processing');
      }
      widget.onLoading(false);
      if (!isLoggedIn) {
        var items = storage.getItem('orders');
        if (items != null) {
          listOrder = items;
        }
        listOrder.add(order.toOrderJson(cartModel, null));
        await storage.setItem('orders', listOrder);
      }

      /// call onFinish Order
      Services().widget.OnFinishOrder(context, widget.onFinish, order);
    } catch (err) {
      widget.onLoading(false);

      Tools.showSnackBar(Scaffold.of(context), err.toString());
    }
  }
}
