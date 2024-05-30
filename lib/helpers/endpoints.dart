import '../app_config.dart';

class ENDP {
  static const LOGIN = "${AppConfig.BASE_URL}/auth/login";
  static const AddOns = "${AppConfig.BASE_URL}/addon-list";
  static const AddrList = "${AppConfig.BASE_URL}/user/shipping/address";
  static const AddAddr = "${AppConfig.BASE_URL}/user/shipping/create";
  static const UpdateAddr = "${AppConfig.BASE_URL}/user/shipping/update";
  static const UpdateAddrNew = "${AppConfig.BASE_URL}/user/shipping/create-or-update";
  static const UpdateShipAddr =
      "${AppConfig.BASE_URL}/user/shipping/update-location";
  static const ShipDefault = "${AppConfig.BASE_URL}/user/shipping/make_default";
  static const ShipDelete = "${AppConfig.BASE_URL}/user/shipping/delete";
  static const AddrDelete = "${AppConfig.BASE_URL}/zones-by-city";
  static const StateList = "${AppConfig.BASE_URL}/cities-by-country";
  static const CountryList = "${AppConfig.BASE_URL}/areas-by-zone";
  static const ShippingCost = "${AppConfig.BASE_URL}/shipping_cost";
  static const AddrUpdateInCart =
      "${AppConfig.BASE_URL}/update-address-in-cart";
  //Brand Repo
  static const FILTER_PAGE_SKINTYPES = "${AppConfig.BASE_URL}/skin-types";
  static const FILTER_PAGE_BRANDS = "${AppConfig.BASE_URL}/skin-types";

  static const GET_BRANDS = "${AppConfig.BASE_URL}/brands";
  static const BUSINESS_SETTING = "${AppConfig.BASE_URL}/business-settings";
  //CART REPO
  static const GET_CARTS = "${AppConfig.BASE_URL}/carts";
  static const GET_PROCESS = "${AppConfig.BASE_URL}/carts/process";
  static const ADD_CART = "${AppConfig.BASE_URL}/carts/add";
  static const CART_SUMMARY = "${AppConfig.BASE_URL}/cart-summary";
  static const CART_QUANTITY = "${AppConfig.BASE_URL}/carts/change-quantity";
  //CATEGORY REPO..
  static const GET_CATEGORIES = "${AppConfig.BASE_URL}/all-categories";
  static const GET_FEATURED_CATEGORIES =
      "${AppConfig.BASE_URL}/categories/featured";
  static const TOP_CATEGORIES = "${AppConfig.BASE_URL}/categories/top";
  static const FILTER_CATEGORIES = "${AppConfig.BASE_URL}/filter/categories";

  //Chat repo..
  static const GET_CONVERSATION =
      "${AppConfig.BASE_URL}/chat/conversations?page=";
  static const GET_MESSAGE = "${AppConfig.BASE_URL}/chat/messages/";
  static const INSERT_MESSAGE = "${AppConfig.BASE_URL}/chat/insert-message";
  static const NEW_MESSAGE = "${AppConfig.BASE_URL}/chat/get-new-messages/";
  static const CREATE_CONVERSATION =
      "${AppConfig.BASE_URL}/chat/create-conversation";
  //CLUB_POINT

  static const CLUB_POINT = "${AppConfig.BASE_URL}/clubpoint/get-list?page=";
  static const CLUB_POINT_WALLET =
      "${AppConfig.BASE_URL}/clubpoint/convert-into-wallet";
  //COUPON

  static const COUPON_APPLY = "${AppConfig.BASE_URL}/coupon-apply/on-cart";
  static const COUPON_REMOVE = "${AppConfig.BASE_URL}/coupon-remove";
  //EXTRA_REPO
  static const GET_BLOGS = "${AppConfig.BASE_URL}/blogs";
  static const GET_BeautyBLOGS = "${AppConfig.BASE_URL}/beauty-blogs";

  //COMMUNITY POST
  static const COMMUNITY_POSTS = "${AppConfig.BASE_URL}/community-posts";
  static const COMMUNITY_HASH = "${AppConfig.BASE_URL}/community-hashtags";
  static const COMMUNITY_POST_CREATE =
      "${AppConfig.BASE_URL}/community-post-create";
  static const COMMUNITY_POST_COMMENT_CREATE =
      "${AppConfig.BASE_URL}/community-comment-create";
  static const COMMUNITY_POST_LIKE_CREATE =
      "${AppConfig.BASE_URL}/community-like-update";
  static const COMMUNITY_POST_COMMENT =
      "${AppConfig.BASE_URL}/community-comments";

  //File repo
  static const IMAGE_UPLOAD = "${AppConfig.BASE_URL}/file/image-upload";

  static const FLASH_DEAL = "${AppConfig.BASE_URL}/flash-deals";
  static const LANGUAGES = "${AppConfig.BASE_URL}/languages";

  static const PAYMENT_SUBMIT = "${AppConfig.BASE_URL}/offline/payment/submit";

  static const OFFLINE_RECHARGE =
      "${AppConfig.BASE_URL}/wallet/offline-recharge";
  //ORDER REPO
  static const PURCHASE_HISTORY = "${AppConfig.BASE_URL}/purchase-history";
  static const PURCHASE_HISTORY_DETAILS =
      "${AppConfig.BASE_URL}/purchase-history-details/";
  static const PURCHASE_HISTORY_ITEM =
      "${AppConfig.BASE_URL}/purchase-history-items/";
  static const RE_ORDER =
      "${AppConfig.BASE_URL}/reorder/";

  static const deleteAccount = '${AppConfig.BASE_URL}/auth/deactive-account';
}
