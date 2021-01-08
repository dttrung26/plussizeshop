import '../models/entities/listing_booking.dart';
import '../models/entities/prediction.dart';
import '../models/index.dart';
import '../models/vendor/store_model.dart';
import 'wordpress/blognews_api.dart';

export 'empty_service_mixin.dart';

abstract class BaseServices {
  BlogNewsApi blogApi;

  Future<List<Category>> getCategories({lang});

  Future<List<Product>> getProducts({userId});

  Future<List<Product>> fetchProductsLayout({config, lang, userId});

  Future<List<Product>> fetchProductsByCategory(
      {categoryId,
      tagId,
      page,
      minPrice,
      maxPrice,
      orderBy,
      lang,
      order,
      featured,
      onSale,
      attribute,
      attributeTerm,
      listingLocation,
      userId});

  Future<User> loginFacebook({String token});

  Future<User> loginSMS({String token});

  Future<User> loginApple({String email, String fullName});

  Future<User> loginGoogle({String token});

  Future<List<Review>> getReviews(productId);

  Future<List<ProductVariation>> getProductVariations(Product product,
      {String lang});

  Future<List<ShippingMethod>> getShippingMethods(
      {CartModel cartModel, String token, String checkoutId});

  Future<List<PaymentMethod>> getPaymentMethods(
      {CartModel cartModel, ShippingMethod shippingMethod, String token});

  Future<Order> createOrder({CartModel cartModel, UserModel user, bool paid});

  Future<List<Order>> getMyOrders({UserModel userModel, int page});

  Future updateOrder(orderId, {status, token});

  Future<List<Product>> searchProducts({
    name,
    categoryId,
    tag,
    attribute,
    attributeId,
    page,
    lang,
    listingLocation,
    userId,
  });

  Future<User> getUserInfo(cookie);

  Future<User> createUser({
    String firstName,
    String lastName,
    String username,
    String password,
    String phoneNumber,
    bool isVendor = false,
  });

  Future<Map<String, dynamic>> updateUserInfo(
      Map<String, dynamic> json, String token);

  Future<User> login({username, password});

  Future<Product> getProduct(id, {lang});

  Future<Coupons> getCoupons();

  Future<AfterShip> getAllTracking();

  Future<List<OrderNote>> getOrderNote({UserModel userModel, String orderId});

  Future<Null> createReview({String productId, Map<String, dynamic> data});

  Future<Map<String, dynamic>> getHomeCache(String lang);

  Future<List<BlogNews>> fetchBlogLayout({config, lang});

  Future<BlogNews> getPageById(int pageId);

  Future getCategoryWithCache();

  Future<List<FilterAttribute>> getFilterAttributes();

  Future<List<SubAttribute>> getSubAttributes({int id});

  Future<List<FilterTag>> getFilterTags();

  Future<String> getCheckoutUrl(Map<String, dynamic> params, String lang);

  Future<String> submitForgotPassword(
      {String forgotPwLink, Map<String, dynamic> data});

  Future logout();

  checkoutWithCreditCard(String vaultId, CartModel cartModel, Address address,
      PaymentSettingsModel paymentSettingsModel) {}

  getPaymentSettings() {}

  addCreditCard(PaymentSettingsModel paymentSettingsModel,
      CreditCardModel creditCardModel) {}

  Future<Map<String, dynamic>> getCurrencyRate();

  Future getCartInfo(String token);

  Future syncCartToWebsite(CartModel cartModel, User user);

  Future<Map<String, dynamic>> getCustomerInfo(String id);

  Future<Map<String, dynamic>> getTaxes(CartModel cartModel);

  Future<Map<String, Tag>> getTags({String lang});

  Future getCountries();

  Future getStatesByCountryId(countryId);

  Future<Point> getMyPoint(String token);

  Future updatePoints(String token, Order order);

  //For vendor
  Future<Store> getStoreInfo(storeId);

  Future<bool> pushNotification({receiverEmail, senderName, message});

  Future<List<Review>> getReviewsStore({storeId});

  Future<List<Product>> getProductsByStore({storeId, page});

  Future<List<Store>> searchStores({String keyword, int page});

  Future<List<Store>> getFeaturedStores();

  Future<List<Order>> getVendorOrders({UserModel userModel, int page});

  Future<Product> createProduct(String cookie, Map<String, dynamic> data);

  Future<List<Product>> getOwnProducts(String cookie, {int page, int perPage});

  Future<dynamic> uploadImage(dynamic data);

  Future<List<Prediction>> getAutoCompletePlaces(
      String term, String sessionToken);

  Future<Prediction> getPlaceDetail(Prediction prediction, String sessionToken);

  Future<List<Store>> getNearbyStores(Prediction prediction);

  ///----FLUXSTORE LISTING----///
  Future<dynamic> bookService({userId, value, message});

  Future<List<Product>> getProductNearest(location);

  Future<List<ListingBooking>> getBooking({userId, page, perPage});

  Future<Map<String, dynamic>> checkBookingAvailability({data});

  Future<List<dynamic>> getLocations();

  /// BOOKING FEATURE
  Future<bool> createBooking(dynamic bookingInfo);

  Future<List<dynamic>> getListStaff(String idProduct);

  Future<List<String>> getSlotBooking(
      String idProduct, String idStaff, String date);
}
