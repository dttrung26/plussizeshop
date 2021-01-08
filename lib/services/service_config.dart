import '../common/constants.dart';
import '../frameworks/frameworks.dart';
import '../models/cart/cart_model.dart';
import 'base_services.dart';
import 'wordpress/blognews_api.dart';

class Config {
  String type;
  String url;
  String blog;
  String consumerKey;
  String consumerSecret;
  String forgetPassword;
  String accessToken;
  bool isCacheImage;
  bool isBuilder = false;

  static final Config _instance = Config._internal();

  factory Config() => _instance;

  Config._internal();

  bool isListingType() {
    return type == 'listeo' || type == 'listpro' || type == 'mylisting';
  }

  bool isVendorType() {
    return type == 'wcfm' || type == 'dokan';
  }

  void setConfig(config) {
    type = config['type'];
    url = config['url'];
    blog = config['blog'];
    consumerKey = config['consumerKey'];
    consumerSecret = config['consumerSecret'];
    forgetPassword = config['forgetPassword'];
    accessToken = config['accessToken'];
    isCacheImage = config['isCacheImage'];
    isBuilder = config['isBuilder'] ?? false;
  }
}

mixin ConfigMixin {
  BaseServices serviceApi;
  BaseFrameworks widget;
  BlogNewsApi blogApi;

  configOpencart(appConfig) {}
  configMagento(appConfig) {}
  configShopify(appConfig) {}
  configPrestashop(appConfig) {}
  configTrapi(appConfig) {}
  configDokan(appConfig) {}
  configWCFM(appConfig) {}
  configWoo(appConfig) {}
  configListing(appConfig) {}
  configVendorAdmin(appConfig) {}

  void setAppConfig(appConfig) {
    printLog("[Services] setAppConfig: --> ${appConfig["type"]} <--");
    Config().setConfig(appConfig);
    CartInject().init(appConfig);

    switch (appConfig["type"]) {
      case "opencart":
        configOpencart(appConfig);
        break;
      case "magento":
        configMagento(appConfig);
        break;
      case "shopify":
        configShopify(appConfig);
        break;
      case "presta":
        configPrestashop(appConfig);
        break;
      case "strapi":
        configTrapi(appConfig);
        break;
      case "dokan":
        configDokan(appConfig);
        break;
      case "wcfm":
        configWCFM(appConfig);
        break;
      case "listeo":
        configListing(appConfig);
        break;
      case "listpro":
        configListing(appConfig);
        break;
      case "mylisting":
        configListing(appConfig);
        break;
      case "vendorAdmin":
        configVendorAdmin(appConfig);
        break;
      case "woo":
      default:
        configWoo(appConfig);
        break;
    }
  }
}
