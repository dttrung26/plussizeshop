// TODO: 5-Update Google Admob or Facebook Ads
/// Ads layout type for Admob and Facebook Ads
enum kAdType {
  googleBanner,
  googleInterstitial,
  googleReward,
  facebookBanner,
  facebookInterstitial,
  facebookNative,
  facebookNativeBanner,
}

const kAdConfig = {
  "enable": true,
  "isGoogleBannerEnable": true,

  ///false,
  //do not set "type": kAdType.googleBanner.
  "type": kAdType.googleInterstitial,

  /// ----------------- Facebook Ads  -------------- ///
  "hasdedIdTestingDevice": "9dd4404c-5278-46ba-9851-e2dfcccdddb6",
  "bannerAndroidPlacementId": "430258564493822_489007588618919",
  "interstitialAndroidPlacementId": "430258564493822_489092398610438",
  "nativeAndroidPlacementId": "430258564493822_489092738610404",
  "nativeBannerAndroidPlacementId": "430258564493822_489092925277052",
  "banneriOSPlacementId": "430258564493822_489007588618919",
  "interstitialiOSPlacementId": "430258564493822_489092398610438",
  "nativeiOSPlacementId": "430258564493822_489092738610404",

  /// ------------------ Google Admob  -------------- ///
  "androidAppId": "ca-app-pub-2101182411274198~6793075614",
  "androidUnitBanner": "ca-app-pub-2101182411274198/4052745095",
  "androidUnitInterstitial": "ca-app-pub-2101182411274198/7131168728",
  "androidUnitReward": "ca-app-pub-2101182411274198/6939597036",
  "iosAppId": "ca-app-pub-4607450770813571~5435708636",
  "iosUnitBanner": "ca-app-pub-4607450770813571/9760491675",
  "iosUnitInterstitial": "ca-app-pub-4607450770813571/6942756648",
  "iosUnitReward": "a-app-pub-4607450770813571/9377348292",
  "waitingTimeToDisplayInterstitial": 10,
  "waitingTimeToDisplayReward": 10,
};
