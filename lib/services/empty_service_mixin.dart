import 'dart:async';

import '../models/entities/prediction.dart';
import '../models/index.dart';
import 'base_services.dart';

mixin EmptyServiceMixin implements BaseServices {
  @override
  Future updateOrder(orderId, {status, token}) async {}

  /// Auth
  @override
  Future<User> getUserInfo(cookie) async {
    return null;
  }

  Future<Map<String, dynamic>> updateUserInfo(
      Map<String, dynamic> json, String token) async {
    return null;
  }

  Future<Stream<Product>> streamProductsLayout({config}) async {
    return null;
  }

  @override
  Future<Product> getProduct(id, {lang}) async {
    return null;
  }

  @override
  Future<Coupons> getCoupons() async {
    return null;
  }

  @override
  Future<AfterShip> getAllTracking() async {
    return null;
  }

  Future<Map<String, dynamic>> getHomeCache(String lang) async {
    return null;
  }

  @override
  Future<User> loginGoogle({String token}) async {
    return null;
  }

  @override
  Future getCategoryWithCache() async {
    return null;
  }

  Future<Map<String, dynamic>> getCategoryCache(categoryIds) async {
    return null;
  }

  @override
  Future<List<FilterTag>> getFilterTags() async {
    return null;
  }

  @override
  Future<String> getCheckoutUrl(
      Map<String, dynamic> params, String lang) async {
    return null;
  }

  @override
  Future<String> submitForgotPassword(
      {String forgotPwLink, Map<String, dynamic> data}) async {
    return null;
  }

  @override
  Future logout() {
    return null;
  }

  @override
  checkoutWithCreditCard(String vaultId, CartModel cartModel, Address address,
          PaymentSettingsModel paymentSettingsModel) =>
      null;

  @override
  addCreditCard(PaymentSettingsModel paymentSettingsModel,
      CreditCardModel creditCardModel) {
    throw UnimplementedError();
  }

  @override
  getPaymentSettings() {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> getCurrencyRate() {
    return null;
  }

  @override
  Future getCartInfo(String token) {
    return null;
  }

  @override
  Future syncCartToWebsite(CartModel cartModel, User user) {
    return null;
  }

  Future<Map<String, dynamic>> getCustomerInfo(String id) {
    return null;
  }

  @override
  Future<Map<String, dynamic>> getTaxes(CartModel cartModel) {
    return null;
  }

  @override
  Future<Map<String, Tag>> getTags({String lang}) {
    return null;
  }

  //For vendor
  @override
  Future<Store> getStoreInfo(storeId) {
    return null;
  }

  @override
  Future<bool> pushNotification({receiverEmail, senderName, message}) {
    return null;
  }

  @override
  Future<List<Review>> getReviewsStore({storeId}) {
    return null;
  }

  @override
  Future<List<Product>> getProductsByStore({storeId, page}) {
    return null;
  }

  @override
  Future<List<Store>> searchStores({String keyword, int page}) {
    return null;
  }

  @override
  Future<List<Store>> getFeaturedStores() {
    return null;
  }

  @override
  Future<List<Order>> getVendorOrders({UserModel userModel, int page}) {
    return null;
  }

  @override
  Future<Product> createProduct(String cookie, Map<String, dynamic> data) {
    return null;
  }

  @override
  Future<List<Product>> getOwnProducts(String cookie, {int page, int perPage}) {
    return null;
  }

  @override
  Future<dynamic> uploadImage(dynamic data) {
    return null;
  }

  @override
  Future<List<OrderNote>> getOrderNote(
      {UserModel userModel, String orderId}) async {
    return null;
  }

  @override
  Future<Null> createReview(
      {String productId, Map<String, dynamic> data}) async {
    return null;
  }

  @override
  Future<List<FilterAttribute>> getFilterAttributes() async {
    return null;
  }

  @override
  Future<List<SubAttribute>> getSubAttributes({int id}) async {
    return null;
  }

  Future getStatesByCountryId(countryId) async {
    return null;
  }

  @override
  Future<User> loginFacebook({String token}) async {
    return null;
  }

  @override
  Future<User> loginSMS({String token}) async {
    return null;
  }

  @override
  Future<User> loginApple({String email, String fullName}) async {
    return null;
  }

  @override
  Future<List<Review>> getReviews(productId) async {
    return null;
  }

  @override
  Future<Order> createOrder(
      {CartModel cartModel, UserModel user, bool paid}) async {
    return null;
  }

  Future getCountries() async {
    return null;
  }

  @override
  Future<List<ProductVariation>> getProductVariations(Product product,
      {String lang = 'en'}) async {
    return null;
  }

  @override
  Future<Point> getMyPoint(String token) {
    return null;
  }

  @override
  Future updatePoints(String token, Order order) {
    return null;
  }

  @override
  Future<dynamic> bookService({userId, value, message}) => null;

  @override
  Future<List<Product>> getProductNearest(location) => null;

  /// BOOKING FEATURE
  @override
  Future<bool> createBooking(dynamic bookingInfo) => null;

  @override
  Future<List<dynamic>> getListStaff(String idProduct) => null;

  @override
  Future<List<String>> getSlotBooking(
          String idProduct, String idStaff, String date) =>
      null;

  @override
  Future<List<ListingBooking>> getBooking({userId, page, perPage}) => null;

  @override
  Future<Map<String, dynamic>> checkBookingAvailability({data}) => null;

  @override
  Future<List<Store>> getNearbyStores(Prediction prediction) => null;

  @override
  Future<Prediction> getPlaceDetail(
          Prediction prediction, String sessionToken) =>
      null;

  @override
  Future<List<Prediction>> getAutoCompletePlaces(
          String term, String sessionToken) =>
      null;

  @override
  Future<List<dynamic>> getLocations() => null;
}
