class ApiConstants {
  static const String baseUrl = 'https://yourapi.com/api/v1';
  static const String menuEndpoint = '/menu';
  static const String authEndpoint = '/auth';
  static const int timeoutDuration = 30; // seconds

  // Auth endpoints
  static const String loginEndpoint = '$authEndpoint/login';
  static const String signupEndpoint = '$authEndpoint/signup';

  // Menu endpoints
  static const String menuItemsEndpoint = '$menuEndpoint/items';
  static const String menuCategoriesEndpoint = '$menuEndpoint/categories';
}