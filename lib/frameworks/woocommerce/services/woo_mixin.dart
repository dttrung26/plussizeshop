import '../../../services/service_config.dart';
import '../index.dart';
import 'woo_commerce.dart';

mixin WooMixin on ConfigMixin {
  void configWoo(appConfig) {
    serviceApi = WooCommerce();
    widget = WooWidget();
    serviceApi = (WooCommerce()..appConfig(appConfig));
  }
}
