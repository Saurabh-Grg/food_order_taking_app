import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  // User information
  var userName = 'Restaurant Admin'.obs;
  var userEmail = 'admin@restaurant.com'.obs;
  var profileImage = ''.obs;

  // App settings
  var isDarkMode = false.obs;
  var currentLanguage = 'English'.obs;
  var currentCurrency = 'USD'.obs;
  var appVersion = '1.0.0'.obs;

  // Available options
  final List<String> availableLanguages = [
    'English', 'Spanish', 'French', 'German', 'Chinese', 'Japanese'
  ];

  final List<String> availableCurrencies = [
    'USD', 'EUR', 'GBP', 'CAD', 'AUD', 'JPY', 'CNY', 'INR'
  ];

  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }

  Future<void> loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Load user settings
      userName.value = prefs.getString('userName') ?? 'Restaurant Admin';
      userEmail.value = prefs.getString('userEmail') ?? 'admin@restaurant.com';
      profileImage.value = prefs.getString('profileImage') ?? '';

      // Load app settings
      isDarkMode.value = prefs.getBool('isDarkMode') ?? false;
      currentLanguage.value = prefs.getString('language') ?? 'English';
      currentCurrency.value = prefs.getString('currency') ?? 'USD';

      // Apply theme based on settings
      Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    } catch (e) {
      print('Error loading settings: $e');
    }
  }

  Future<void> saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Save user settings
      prefs.setString('userName', userName.value);
      prefs.setString('userEmail', userEmail.value);
      prefs.setString('profileImage', profileImage.value);

      // Save app settings
      prefs.setBool('isDarkMode', isDarkMode.value);
      prefs.setString('language', currentLanguage.value);
      prefs.setString('currency', currentCurrency.value);
    } catch (e) {
      print('Error saving settings: $e');
    }
  }

  void toggleDarkMode(bool value) {
    isDarkMode.value = value;
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
    saveSettings();
  }

  void showLanguageSelection() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Language',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...availableLanguages.map((language) => ListTile(
              title: Text(language),
              trailing: language == currentLanguage.value
                  ? Icon(Icons.check, color: Get.theme.primaryColor)
                  : null,
              onTap: () {
                currentLanguage.value = language;
                saveSettings();
                Get.back();
              },
            )).toList(),
          ],
        ),
      ),
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  void showCurrencySelection() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Currency',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...availableCurrencies.map((currency) => ListTile(
              title: Text(currency),
              trailing: currency == currentCurrency.value
                  ? Icon(Icons.check, color: Get.theme.primaryColor)
                  : null,
              onTap: () {
                currentCurrency.value = currency;
                saveSettings();
                Get.back();
              },
            )).toList(),
          ],
        ),
      ),
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  void logout() {
    Get.dialog(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              // Clear user session
              Get.offAllNamed('/login');
            },
            child: const Text('LOGOUT'),
          ),
        ],
      ),
    );
  }

  void updateProfile({String? name, String? email, String? image}) {
    if (name != null) userName.value = name;
    if (email != null) userEmail.value = email;
    if (image != null) profileImage.value = image;
    saveSettings();
  }
}