import '../frameworks/woocommerce/services/woo_mixin.dart';
import '../models/entities/listing_booking.dart';
import '../models/entities/prediction.dart';
import '../models/index.dart';
import '../models/vendor/store_model.dart';
import '../widgets/common/internet_connectivity.dart';
import 'base_services.dart';
import 'service_config.dart';

export 'service_config.dart';

class Services with ConfigMixin, WooMixin implements BaseServices {
  static final Services _instance = Services._internal();

  factory Services() => _instance;

  Services._internal();

  @override
  Future<List<Product>> fetchProductsByCategory(
      {categoryId,
      tagId,
      page = 1,
      minPrice,
      maxPrice,
      orderBy,
      order,
      lang,
      featured,
      onSale,
      attribute,
      attributeTerm,
      listingLocation,
      userId}) async {
    MyConnectivity.checking();
    return serviceApi.fetchProductsByCategory(
        categoryId: categoryId,
        tagId: tagId,
        page: page,
        minPrice: minPrice,
        maxPrice: maxPrice,
        orderBy: orderBy,
        lang: lang,
        order: order,
        featured: featured,
        onSale: onSale,
        attribute: attribute,
        attributeTerm: attributeTerm,
        userId: userId,
        listingLocation: listingLocation);
  }

  @override
  Future<List<Product>> fetchProductsLayout(
      {config, lang = "en", userId}) async {
    return serviceApi.fetchProductsLayout(
        config: config, lang: lang, userId: userId);
  }

  @override
  Future<List<Category>> getCategories({lang = "en"}) async {
    MyConnectivity.checking();
    return serviceApi.getCategories(lang: lang);
  }

  @override
  Future<List<Product>> getProducts({userId}) async {
    MyConnectivity.checking();
    return serviceApi.getProducts(userId: userId);
  }

  @override
  Future<User> loginFacebook({String token}) async {
    MyConnectivity.checking();
    return serviceApi.loginFacebook(token: token);
  }

  @override
  Future<User> loginSMS({String token}) async {
    MyConnectivity.checking();
    return serviceApi.loginSMS(token: token);
  }

  @override
  Future<User> loginApple({String email, String fullName}) async {
    MyConnectivity.checking();
    return serviceApi.loginApple(email: email, fullName: fullName);
  }

  @override
  Future<User> loginGoogle({String token}) async {
    MyConnectivity.checking();
    return serviceApi.loginGoogle(token: token);
  }

  @override
  Future<List<Review>> getReviews(productId) async {
    MyConnectivity.checking();
    return serviceApi.getReviews(productId);
  }

  @override
  Future<List<ProductVariation>> getProductVariations(Product product,
      {String lang}) async {
    MyConnectivity.checking();
    return serviceApi.getProductVariations(product, lang: lang);
  }

  @override
  Future<List<ShippingMethod>> getShippingMethods(
      {CartModel cartModel, String token, String checkoutId}) async {
    MyConnectivity.checking();
    return serviceApi.getShippingMethods(
        cartModel: cartModel, token: token, checkoutId: checkoutId);
  }

  @override
  Future<List<PaymentMethod>> getPaymentMethods(
      {CartModel cartModel,
      ShippingMethod shippingMethod,
      String token}) async {
    MyConnectivity.checking();
    return serviceApi.getPaymentMethods(
        cartModel: cartModel, shippingMethod: shippingMethod, token: token);
  }

  @override
  Future<List<Order>> getMyOrders({UserModel userModel, int page}) async {
    MyConnectivity.checking();
    return serviceApi.getMyOrders(userModel: userModel, page: page);
  }

  @override
  Future<Order> createOrder(
      {CartModel cartModel, UserModel user, bool paid}) async {
    MyConnectivity.checking();
    return serviceApi.createOrder(cartModel: cartModel, user: user, paid: paid);
  }

  @override
  Future updateOrder(orderId, {status, token}) async {
    MyConnectivity.checking();
    return serviceApi.updateOrder(orderId, status: status, token: token);
  }

  @override
  Future<List<Product>> searchProducts(
      {name,
      categoryId,
      tag,
      attribute,
      attributeId,
      page,
      lang,
      listingLocation,
      userId}) async {
    MyConnectivity.checking();
    return serviceApi.searchProducts(
        name: name,
        categoryId: categoryId,
        tag: tag,
        attribute: attribute,
        attributeId: attributeId,
        page: page,
        lang: lang,
        listingLocation: listingLocation,
        userId: userId);
  }

  /// Create new user, use for Registration screen
  @override
  Future<User> createUser({
    String firstName,
    String lastName,
    String username,
    String password,
    String phoneNumber,
    bool isVendor = false,
  }) async {
    MyConnectivity.checking();
    return serviceApi.createUser(
      firstName: firstName,
      lastName: lastName,
      username: username,
      password: password,
      phoneNumber: phoneNumber,
      isVendor: isVendor,
    );
  }

  /// Get user info
  @override
  Future<User> getUserInfo(cookie) async {
    MyConnectivity.checking();
    return serviceApi.getUserInfo(cookie);
  }

  /// Login by username and password
  @override
  Future<User> login({username, password}) async {
    MyConnectivity.checking();
    return serviceApi.login(
      username: username,
      password: password,
    );
  }

  /// Get product by ID and current select language
  @override
  Future<Product> getProduct(id, {lang}) async {
    MyConnectivity.checking();
    return serviceApi.getProduct(id, lang: lang);
  }

  /// Get list of Coupon code, for Checkout Screen
  @override
  Future<Coupons> getCoupons() async {
    MyConnectivity.checking();
    return serviceApi.getCoupons();
  }

  /// Get all tracking info, use for Oder Screen
  @override
  Future<AfterShip> getAllTracking() async {
    MyConnectivity.checking();
    return serviceApi.getAllTracking();
  }

  /// Get Order Note, use for Checkout Screen
  @override
  Future<List<OrderNote>> getOrderNote(
      {UserModel userModel, String orderId}) async {
    MyConnectivity.checking();
    return serviceApi.getOrderNote(userModel: userModel, orderId: orderId);
  }

  /// Add new Product Review, available for purchased product
  @override
  Future<Null> createReview(
      {String productId, Map<String, dynamic> data}) async {
    MyConnectivity.checking();
    return serviceApi.createReview(productId: productId, data: data);
  }

  /// Get Caching Loading for the HomeScreen
  /// Request to update the mstore-api file if using WooCommerce
  @override
  Future<Map<String, dynamic>> getHomeCache(String lang) async {
    MyConnectivity.checking();
    return serviceApi.getHomeCache(lang);
  }

  /// Update user info, for the Setting Screen
  @override
  Future<Map<String, dynamic>> updateUserInfo(
      Map<String, dynamic> json, String token) async {
    MyConnectivity.checking();
    return serviceApi.updateUserInfo(json, token);
  }

  @override
  Future<List<BlogNews>> fetchBlogLayout({config, lang}) {
    MyConnectivity.checking();
    return serviceApi.fetchBlogLayout(config: config, lang: lang);
  }

  /// Get the Page ID from the Wordpress side
  @override
  Future<BlogNews> getPageById(int pageId) {
    MyConnectivity.checking();
    return serviceApi.getPageById(pageId);
  }

  /// Get the product list caching per Category list
  @override
  Future getCategoryWithCache() {
    MyConnectivity.checking();
    return serviceApi.getCategoryWithCache();
  }

  @override
  Future<List<FilterAttribute>> getFilterAttributes() {
    MyConnectivity.checking();
    return serviceApi.getFilterAttributes();
  }

  @override
  Future<List<SubAttribute>> getSubAttributes({int id}) {
    MyConnectivity.checking();
    return serviceApi.getSubAttributes(id: id);
  }

  @override
  Future<List<FilterTag>> getFilterTags() {
    MyConnectivity.checking();
    return serviceApi.getFilterTags();
  }

  @override
  Future<String> getCheckoutUrl(Map<String, dynamic> params, String lang) {
    MyConnectivity.checking();
    return serviceApi.getCheckoutUrl(params, lang);
  }

  @override
  Future<String> submitForgotPassword(
      {String forgotPwLink, Map<String, dynamic> data}) {
    MyConnectivity.checking();
    return serviceApi.submitForgotPassword(
        forgotPwLink: forgotPwLink, data: data);
  }

  @override
  Future logout() {
    MyConnectivity.checking();
    return serviceApi.logout();
  }

  /// Checkout by using Credit Cart, only available for Shopify App
  @override
  checkoutWithCreditCard(String vaultId, CartModel cartModel, Address address,
      PaymentSettingsModel paymentSettingsModel) async {
    MyConnectivity.checking();
    return serviceApi.checkoutWithCreditCard(
        vaultId, cartModel, address, paymentSettingsModel);
  }

  @override
  getPaymentSettings() {
    MyConnectivity.checking();
    return serviceApi.getPaymentSettings();
  }

  /// Add new Credit Cart, only available for Shopify App
  @override
  addCreditCard(PaymentSettingsModel paymentSettingsModel,
      CreditCardModel creditCardModel) {
    MyConnectivity.checking();
    return serviceApi.addCreditCard(paymentSettingsModel, creditCardModel);
  }

  /// Get the current Rate exchange, use for multi currency
  @override
  Future<Map<String, dynamic>> getCurrencyRate() {
    MyConnectivity.checking();
    return serviceApi.getCurrencyRate();
  }

  /// Get cart info, only available for Shopify App
  @override
  Future getCartInfo(String token) {
    MyConnectivity.checking();
    return serviceApi.getCartInfo(token);
  }

  /// Sync the checkout care info back the Website
  @override
  Future syncCartToWebsite(CartModel cartModel, User user) {
    MyConnectivity.checking();
    return serviceApi.syncCartToWebsite(cartModel, user);
  }

  Future<Map<String, dynamic>> getCustomerInfo(String id) {
    MyConnectivity.checking();
    return serviceApi.getCustomerInfo(id);
  }

  @override
  Future<Map<String, dynamic>> getTaxes(CartModel cartModel) {
    MyConnectivity.checking();
    return serviceApi.getTaxes(cartModel);
  }

  @override
  Future<Map<String, Tag>> getTags({String lang}) {
    return serviceApi.getTags(lang: lang);
  }

  @override
  Future getCountries() async {
    MyConnectivity.checking();
    return serviceApi.getCountries();
  }

  @override
  Future getStatesByCountryId(countryId) async {
    MyConnectivity.checking();
    return serviceApi.getStatesByCountryId(countryId);
  }

  /// Vendor Features: Create new product
  @override
  Future<Product> createProduct(
      String cookie, Map<String, dynamic> data) async {
    MyConnectivity.checking();
    return serviceApi.createProduct(cookie, data);
  }

  /// Vendor Features: Get Feature Vendor
  @override
  Future<List<Store>> getFeaturedStores() async {
    MyConnectivity.checking();
    return serviceApi.getFeaturedStores();
  }

  /// Vendor Features:
  /// Get Vendor products
  Future<List<Product>> getOwnProducts(String cookie,
      {int page, int perPage}) async {
    MyConnectivity.checking();
    return serviceApi.getOwnProducts(cookie, page: page, perPage: perPage);
  }

  /// Vendor Features:
  /// Get all product by Store/Vendors
  @override
  Future<List<Product>> getProductsByStore({storeId, page}) async {
    MyConnectivity.checking();
    return serviceApi.getProductsByStore(storeId: storeId, page: page);
  }

  /// Vendor Features:
  /// Upload Image when create new product
  @override
  Future<dynamic> uploadImage(dynamic data) async {
    MyConnectivity.checking();
    return serviceApi.uploadImage(data);
  }

  /// Vendor Features:
  /// Get Store Review Rating
  @override
  Future<List<Review>> getReviewsStore({storeId}) async {
    MyConnectivity.checking();
    return serviceApi.getReviewsStore(storeId: storeId);
  }

  /// Vendor Features: Push notification when using chat feature
  @override
  Future<bool> pushNotification({receiverEmail, senderName, message}) async {
    MyConnectivity.checking();
    return serviceApi.pushNotification(
        receiverEmail: receiverEmail, senderName: senderName, message: message);
  }

  /// Vendor Features: Get Store information
  @override
  Future<Store> getStoreInfo(storeId) async {
    MyConnectivity.checking();
    return serviceApi.getStoreInfo(storeId);
  }

  /// Vendor Features: Search the Stores
  @override
  Future<List<Store>> searchStores({String keyword, int page}) {
    MyConnectivity.checking();
    return serviceApi.searchStores(keyword: keyword, page: page);
  }

  /// Vendor Features: Get the Vendor Orders
  @override
  Future<List<Order>> getVendorOrders({UserModel userModel, int page}) {
    MyConnectivity.checking();
    return serviceApi.getVendorOrders(userModel: userModel, page: page);
  }

  /// Get User Point, only use for WooCommerce
  /// and Point and Reward plugins
  @override
  Future<Point> getMyPoint(String token) {
    MyConnectivity.checking();
    return serviceApi.getMyPoint(token);
  }

  /// Update user points, only use for WooCommerce
  /// and Point and Reward plugins
  @override
  Future updatePoints(String token, Order order) {
    MyConnectivity.checking();
    return serviceApi.updatePoints(token, order);
  }

  @override
  Future<dynamic> bookService({userId, value, message}) {
    MyConnectivity.checking();
    return serviceApi.bookService(
        userId: userId, value: value, message: message);
  }

  @override
  Future<List<Product>> getProductNearest(location) {
    MyConnectivity.checking();
    return serviceApi.getProductNearest(location);
  }

  @override
  Future<List<ListingBooking>> getBooking({userId, page, perPage}) {
    MyConnectivity.checking();
    return serviceApi.getBooking(userId: userId, page: page, perPage: perPage);
  }

  /// BOOKING FEATURE
  @override
  Future<bool> createBooking(dynamic bookingInfo) {
    return serviceApi.createBooking(bookingInfo);
  }

  @override
  Future<List<dynamic>> getListStaff(String idProduct) {
    return serviceApi.getListStaff(idProduct);
  }

  @override
  Future<List<String>> getSlotBooking(
      String idProduct, String idStaff, String date) {
    return serviceApi.getSlotBooking(idProduct, idStaff, date);
  }

  @override
  Future<Map<String, dynamic>> checkBookingAvailability({data}) {
    return serviceApi.checkBookingAvailability(data: data);
  }

  @override
  Future<List<Prediction>> getAutoCompletePlaces(
      String term, String sessionToken) {
    return serviceApi.getAutoCompletePlaces(term, sessionToken);
  }

  @override
  Future<Prediction> getPlaceDetail(
      Prediction prediction, String sessionToken) {
    return serviceApi.getPlaceDetail(prediction, sessionToken);
  }

  @override
  Future<List<Store>> getNearbyStores(Prediction prediction) {
    // TODO: implement getNearbyStores
    return serviceApi.getNearbyStores(prediction);
  }

  @override
  Future<List<dynamic>> getLocations() {
    // TODO: implement getNearbyStores
    return serviceApi.getLocations();
  }
}
