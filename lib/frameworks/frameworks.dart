import 'package:flutter/material.dart';

import '../models/index.dart'
    show
        AddonsOption,
        CartModel,
        Country,
        CountryState,
        Coupons,
        Order,
        PaymentMethod,
        Product,
        ProductAttribute,
        ProductVariation,
        TaxModel,
        User;

abstract class BaseFrameworks {
  bool get enableProductReview;

  Future<void> doCheckout(
    BuildContext context, {
    Function success,
    Function error,
    Function loading,
  });

  Future<void> applyCoupon(
    BuildContext context, {
    Coupons coupons,
    String code,
    Function success,
    Function error,
  });

  Future<void> createOrder(
    BuildContext context, {
    Function onLoading,
    Function success,
    Function error,
    bool paid = false,
    bool cod = false,
  });

  void placeOrder(
    BuildContext context, {
    CartModel cartModel,
    PaymentMethod paymentMethod,
    Function onLoading,
    Function success,
    Function error,
  });

  Map<dynamic, dynamic> getPaymentUrl(context);

  /// For Cart Screen
  Widget renderCartPageView({
    BuildContext context,
    bool isModal,
    bool isBuyNow,
    PageController pageController,
  });

  Widget renderVariantCartItem(
    ProductVariation variation,
    Map<String, dynamic> options,
  );

  String getPriceItemInCart(
    Product product,
    ProductVariation variation,
    Map<String, dynamic> currencyRate,
    String currency, {
    List<AddonsOption> selectedOptions,
  });

  /// For Update User Screen
  void updateUserInfo({
    User loggedInUser,
    BuildContext context,
    Function onError,
    Function onSuccess,
    String currentPassword,
    String userDisplayName,
    String userEmail,
    String userNiceName,
    String userUrl,
    String userPassword,
  });

  Widget renderCurrentPassInputforEditProfile(
      {BuildContext context, TextEditingController currentPasswordController});

  /// For app model
  Future<void> onLoadedAppConfig(String lang, Function callback);

  /// For Shipping Address checkout
  void loadShippingMethods(
      BuildContext context, CartModel cartModel, bool beforehand);

  /// For Order Detail Screen
  Future<Order> cancelOrder(BuildContext context, Order order);

  Widget renderButtons(
      BuildContext context, Order order, cancelOrder, createRefund);

  /// For product variant
  Future<void> getProductVariations({
    BuildContext context,
    Product product,
    Function onLoad({
      Product productInfo,
      List<ProductVariation> variations,
      Map<String, String> mapAttribute,
      ProductVariation variation,
    }),
  });

  Future<void> getProductAddons({
    BuildContext context,
    Product product,
    Function(
            {Product productInfo,
            Map<String, Map<String, AddonsOption>> selectedOptions})
        onLoad,
    Map<String, Map<String, AddonsOption>> selectedOptions,
  });

  bool couldBePurchased(
    List<ProductVariation> variations,
    ProductVariation productVariation,
    Product product,
    Map<String, String> mapAttribute,
  );

  void onSelectProductVariant({
    ProductAttribute attr,
    String val,
    List<ProductVariation> variations,
    Map<String, String> mapAttribute,
    Function onFinish,
  });

  List<Widget> getProductAttributeWidget(
    String lang,
    Product product,
    Map<String, String> mapAttribute,
    Function onSelectProductVariant,
    List<ProductVariation> variations,
  );

  List<Widget> getProductAddonsWidget({
    BuildContext context,
    Map<String, Map<String, AddonsOption>> selectedOptions,
    String lang,
    Product product,
    Function onSelectProductAddons,
  });

  List<Widget> getProductTitleWidget(
      BuildContext context, ProductVariation productVariation, Product product);

  List<Widget> getBuyButtonWidget(
    BuildContext context,
    ProductVariation productVariation,
    Product product,
    Map<String, String> mapAttribute,
    int maxQuantity,
    int quantity,
    Function addToCart,
    Function onChangeQuantity,
    List<ProductVariation> variations,
  );

  void addToCart(BuildContext context, Product product, int quantity,
      ProductVariation productVariation, Map<String, String> mapAttribute,
      [bool buyNow = false, bool inStock = false]);

  /// Load countries for shipping address
  Future<List<Country>> loadCountries(BuildContext context);

  /// Load states for shipping address
  Future<List<CountryState>> loadStates(Country country);

  Future<void> resetPassword(BuildContext context, String username);

  Widget renderShippingPaymentTitle(BuildContext context, String title);

  Future<Product> getProductDetail(BuildContext context, Product product);

//Sync cart from website
  Future<void> syncCartFromWebsite(String token, BuildContext context);

//Sync cart to website
  Future<void> syncCartToWebsite(CartModel cartModel);

  Widget renderTaxes(TaxModel taxModel, BuildContext context);

  /// For Vendor
  Product updateProductObject(Product product, Map json);

  void OnFinishOrder(BuildContext context, Function onSuccess, Order order);

  /// render vendor default on product detail screen
  Widget renderVendorInfo(Product product);

  /// vendor menu order from vendor on Setting page
  Widget renderVendorOrder(BuildContext context);

  /// feature vendor on home screen
  Widget renderFeatureVendor(config);

  ///render shipping methods screen when checkout
  Widget renderShippingMethods(BuildContext context,
      {Function onBack, Function onNext});

  /// render screen for Category Vendor
  Widget renderVendorCategoriesScreen(data);

  /// render screen for Map
  Widget renderMapScreen();

  ///render shipping method info in review screen
  Widget renderShippingMethodInfo(BuildContext context);

  ///render reward info in review screen
  Widget renderRewardInfo(BuildContext context);

  /// render Search Screen
  Widget renderSearchScreen(context, {showChat});

  /// get country name
  Future<String> getCountryName(context, countryCode);

  /// get admin vendor url
  Widget getAdminVendorScreen(context, dynamic user);

  ///render timeline tracking on order detail screen
  Widget renderOrderTimelineTracking(BuildContext context, Order order);

  ///----- For FluxStore Listing -----///
  /// render Booking History
  Widget renderBookingHistory(context);

  /// render Add new Listing screen
  Widget renderNewListing(context);

  /// render the Product or Listing Detail screen
  Widget renderDetailScreen(context, product, layoutType);

  /// render product card view widget
  Widget renderProductCardView({
    Product item,
    double width,
    double maxWidth,
    double height,
    bool showCart,
    bool showHeart,
    bool showProgressBar,
    double marginRight,
    double ratioProductImage,
  });

  /// render vendor dashboard
  Widget renderVendorDashBoard();

  /// render vendor dashboard
  Widget renderAddonsOptionsCartItem(
      context, List<AddonsOption> selectedOptions);

  /// render Vendor from config banner
  Widget renderVendorScreen(String storeID);
}
