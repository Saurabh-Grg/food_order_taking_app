import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/menu_category.dart';

class MenuManagementController extends GetxController with GetSingleTickerProviderStateMixin {
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt selectedCategoryIndex = 0.obs;
  final RxList<MenuCategory> categories = <MenuCategory>[].obs;
  final RxList<MenuItem> menuItems = <MenuItem>[].obs;

  // Search functionality
  final RxBool isSearchActive = false.obs;
  final RxString searchQuery = ''.obs;
  final TextEditingController searchController = TextEditingController();

  // Sort functionality
  final RxString sortBy = 'name'.obs; // 'name', 'price_low', 'price_high'

  // Filter functionality
  final RxDouble minPrice = 0.0.obs;
  final RxDouble maxPrice = 1000.0.obs;
  final RxBool showOnlyAvailable = false.obs;

  // Edit item form key
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    refreshMenu();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void onClose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.onClose();
  }

  void _onSearchChanged() {
    searchQuery.value = searchController.text;
  }

  // Refresh menu data
  Future<void> refreshMenu() async {
    isLoading.value = true;
    hasError.value = false;

    try {
      // Fetch categories and menu items from backend
      await Future.delayed(const Duration(milliseconds: 800));

      // Mock data for demonstration
      categories.value = [
        MenuCategory(id: '1', name: 'Appetizers'),
        MenuCategory(id: '2', name: 'Main Course'),
        MenuCategory(id: '3', name: 'Desserts'),
        MenuCategory(id: '4', name: 'Beverages'),
        MenuCategory(id: '5', name: 'Specials'),
      ];

      menuItems.value = [
        MenuItem(
          id: '1',
          categoryId: '1',
          name: 'Crispy Spring Rolls',
          description: 'Vegetable filled spring rolls served with sweet chili sauce',
          price: 150,
          imageUrl: 'https://redhousespice.com/wp-content/uploads/2021/12/whole-spring-rolls-and-halved-ones-scaled.jpg',
          isAvailable: true,
        ),
        MenuItem(
          id: '2',
          categoryId: '1',
          name: 'Momo Platter',
          description: 'Steamed dumplings filled with chicken or vegetables',
          price: 220,
          imageUrl: 'https://b.zmtcdn.com/data/dish_photos/111/b64b1166c1770adb94673c0f03fc6111.jpg',
          isAvailable: true,
        ),
        MenuItem(
          id: '3',
          categoryId: '2',
          name: 'Butter Chicken',
          description: 'Tender chicken in a rich tomato and butter gravy',
          price: 350,
          imageUrl: 'https://static01.nyt.com/images/2024/10/29/multimedia/Butter-Chickenrex-tbvz/Butter-Chickenrex-tbvz-mediumSquareAt3X.jpg',
          isAvailable: false,
        ),
        MenuItem(
          id: '4',
          categoryId: '3',
          name: 'Chocolate Brownie',
          description: 'Warm chocolate brownie with vanilla ice cream',
          price: 180,
          imageUrl: 'https://www.recipetineats.com/tachyon/2020/03/Brownies_0-SQ.jpg',
          isAvailable: true,
        ),
        MenuItem(
          id: '5',
          categoryId: '4',
          name: 'Mango Lassi',
          description: 'Refreshing yogurt drink with mango pulp',
          price: 120,
          imageUrl: 'https://media.bluediamond.com/uploads/2023/01/24175942/14_Dairy-Free_Mango_Lassi-2430x1620.jpg',
          isAvailable: true,
        ),
      ];

      // Set min and max price for filter
      if (menuItems.isNotEmpty) {
        minPrice.value = menuItems.map((item) => item.price).reduce((a, b) => a < b ? a : b);
        maxPrice.value = menuItems.map((item) => item.price).reduce((a, b) => a > b ? a : b);
      }

    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to load menu: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  // Get filtered and sorted menu items
  List<MenuItem> get filteredMenuItems {
    if (categories.isEmpty) return [];

    // Start with the basic category filter
    final selectedCategory = categories[selectedCategoryIndex.value];
    List<MenuItem> filtered = menuItems.where((item) => item.categoryId == selectedCategory.id).toList();

    // Apply search filter if active
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((item) =>
      item.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          item.description.toLowerCase().contains(searchQuery.value.toLowerCase())
      ).toList();
    }

    // Apply availability filter if active
    if (showOnlyAvailable.value) {
      filtered = filtered.where((item) => item.isAvailable).toList();
    }

    // Apply price filter
    filtered = filtered.where((item) =>
    item.price >= minPrice.value &&
        item.price <= maxPrice.value
    ).toList();

    // Apply sorting
    switch (sortBy.value) {
      case 'name':
        filtered.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'price_low':
        filtered.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_high':
        filtered.sort((a, b) => b.price.compareTo(a.price));
        break;
    }

    return filtered;
  }


  double getMinimumPrice() {
    if (menuItems.isEmpty) return 0;
    return menuItems.map((item) => item.price).reduce((a, b) => a < b ? a : b);
  }

  double getMaximumPrice() {
    if (menuItems.isEmpty) return 1000;
    return menuItems.map((item) => item.price).reduce((a, b) => a > b ? a : b);
  }

// For the category selection issue, make sure the selectCategory method is properly updating the state:
  void selectCategory(int index) {
    if (index >= 0 && index < categories.length) {
      selectedCategoryIndex.value = index;
      // Force UI refresh if needed
      update();
    }
  }

  // Show search bar
  void showSearchBar() {
    isSearchActive.value = !isSearchActive.value;
    if (!isSearchActive.value) {
      searchController.clear();
      searchQuery.value = '';
    }
  }

  // Toggle sort order
  void toggleSortOrder(String order) {
    sortBy.value = order;
    Get.snackbar(
      'Sorted',
      'Menu items sorted by ${order.replaceAll('_', ' ')}',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
    );
  }

  // Show filter options
  void showFilterOptions() {
    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setState) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filter Menu Items',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Get.back(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Price range filter
                  Text(
                    'Price Range: NRS ${minPrice.value.toInt()} - NRS ${maxPrice.value.toInt()}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Obx(() => RangeSlider(
                    min: menuItems.isEmpty ? 0 : menuItems.map((item) => item.price).reduce((a, b) => a < b ? a : b),
                    max: menuItems.isEmpty ? 1000 : menuItems.map((item) => item.price).reduce((a, b) => a > b ? a : b),
                    values: RangeValues(minPrice.value, maxPrice.value),
                    divisions: 20,
                    labels: RangeLabels(
                        'NRS ${minPrice.value.toInt()}',
                        'NRS ${maxPrice.value.toInt()}'
                    ),
                    onChanged: (RangeValues values) {
                      minPrice.value = values.start;
                      maxPrice.value = values.end;
                    },
                  )),

                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),

                  // Availability filter
                  Obx(() => CheckboxListTile(
                    title: const Text('Show only available items'),
                    value: showOnlyAvailable.value,
                    onChanged: (val) {
                      showOnlyAvailable.value = val ?? false;
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  )),

                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),

                  // Sort options
                  const Text(
                    'Sort By:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Obx(() => Column(
                    children: [
                      RadioListTile<String>(
                        title: const Text('Name'),
                        value: 'name',
                        groupValue: sortBy.value,
                        onChanged: (value) {
                          sortBy.value = value!;
                        },
                        contentPadding: EdgeInsets.zero,
                      ),
                      RadioListTile<String>(
                        title: const Text('Price - Low to High'),
                        value: 'price_low',
                        groupValue: sortBy.value,
                        onChanged: (value) {
                          sortBy.value = value!;
                        },
                        contentPadding: EdgeInsets.zero,
                      ),
                      RadioListTile<String>(
                        title: const Text('Price - High to Low'),
                        value: 'price_high',
                        groupValue: sortBy.value,
                        onChanged: (value) {
                          sortBy.value = value!;
                        },
                        contentPadding: EdgeInsets.zero,
                      ),
                    ],
                  )),

                  const SizedBox(height: 24),
                  // Apply/Reset buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          // Reset all filters
                          minPrice.value = menuItems.map((item) => item.price).reduce((a, b) => a < b ? a : b);
                          maxPrice.value = menuItems.map((item) => item.price).reduce((a, b) => a > b ? a : b);
                          showOnlyAvailable.value = false;
                          sortBy.value = 'name';
                          Get.back();
                        },
                        child: const Text('Reset Filters'),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          // Apply filters
                          Get.back();
                          Get.snackbar(
                            'Filters Applied',
                            'Menu items filtered successfully',
                            snackPosition: SnackPosition.BOTTOM,
                            duration: const Duration(seconds: 1),
                          );
                        },
                        child: const Text('Apply'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      isScrollControlled: true,
    );
  }

  // Add new menu item
  void addNewMenuItem() {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final priceController = TextEditingController();
    final imageUrlController = TextEditingController();
    String selectedCategoryId = categories[selectedCategoryIndex.value].id;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(16),
          width: Get.width * 0.9,
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add New Menu Item',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Category dropdown
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    value: selectedCategoryId,
                    items: categories.map((category) {
                      return DropdownMenuItem<String>(
                        value: category.id,
                        child: Text(category.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      selectedCategoryId = value!;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a category';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Name field
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Description field
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Price field
                  TextFormField(
                    controller: priceController,
                    decoration: const InputDecoration(
                      labelText: 'Price (NRS)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a price';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Image URL field
                  TextFormField(
                    controller: imageUrlController,
                    decoration: const InputDecoration(
                      labelText: 'Image URL (optional)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            // Create new menu item
                            final newMenuItem = MenuItem(
                              id: DateTime.now().millisecondsSinceEpoch.toString(),
                              categoryId: selectedCategoryId,
                              name: nameController.text,
                              description: descriptionController.text,
                              price: double.parse(priceController.text),
                              imageUrl: imageUrlController.text.isNotEmpty ? imageUrlController.text : null,
                              isAvailable: true,
                            );

                            // Add to list
                            menuItems.add(newMenuItem);

                            Get.back();
                            Get.snackbar(
                              'Success',
                              'Menu item added successfully',
                              snackPosition: SnackPosition.BOTTOM,
                            );

                            // Select the category of the new item
                            final newCategoryIndex = categories.indexWhere((c) => c.id == selectedCategoryId);
                            if (newCategoryIndex != -1) {
                              selectedCategoryIndex.value = newCategoryIndex;
                            }
                          }
                        },
                        child: const Text('Add Item'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Edit menu item
  void editMenuItem(MenuItem item) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: item.name);
    final descriptionController = TextEditingController(text: item.description);
    final priceController = TextEditingController(text: item.price.toString());
    final imageUrlController = TextEditingController(text: item.imageUrl ?? '');
    RxString selectedCategoryId = item.categoryId.obs;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(16),
          width: Get.width * 0.9,
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Edit Menu Item',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Category dropdown
                  Obx(() => DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    value: selectedCategoryId.value,
                    items: categories.map((category) {
                      return DropdownMenuItem<String>(
                        value: category.id,
                        child: Text(category.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      selectedCategoryId.value = value!;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a category';
                      }
                      return null;
                    },
                  )),
                  const SizedBox(height: 16),

                  // Name field
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Description field
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Price field
                  TextFormField(
                    controller: priceController,
                    decoration: const InputDecoration(
                      labelText: 'Price (NRS)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a price';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Image URL field
                  TextFormField(
                    controller: imageUrlController,
                    decoration: const InputDecoration(
                      labelText: 'Image URL (optional)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            // Update menu item
                            final updatedIndex = menuItems.indexWhere((i) => i.id == item.id);
                            if (updatedIndex != -1) {
                              menuItems[updatedIndex] = MenuItem(
                                id: item.id,
                                categoryId: selectedCategoryId.value,
                                name: nameController.text,
                                description: descriptionController.text,
                                price: double.parse(priceController.text),
                                imageUrl: imageUrlController.text.isNotEmpty ? imageUrlController.text : null,
                                isAvailable: item.isAvailable,
                              );

                              // If category changed, update selected category
                              if (item.categoryId != selectedCategoryId.value) {
                                final newCategoryIndex = categories.indexWhere(
                                        (c) => c.id == selectedCategoryId.value);
                                if (newCategoryIndex != -1) {
                                  selectedCategoryIndex.value = newCategoryIndex;
                                }
                              }
                            }

                            Get.back();
                            Get.snackbar(
                              'Success',
                              'Menu item updated successfully',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          }
                        },
                        child: const Text('Save Changes'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Toggle item availability
  void toggleAvailability(MenuItem item) {
    final index = menuItems.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      final updatedItem = MenuItem(
        id: item.id,
        categoryId: item.categoryId,
        name: item.name,
        description: item.description,
        price: item.price,
        imageUrl: item.imageUrl,
        isAvailable: !item.isAvailable,
      );

      menuItems[index] = updatedItem;

      // In a real app, make API call here

      Get.snackbar(
        'Updated',
        'Item availability updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 1),
      );
    }
  }

  // Delete menu item
  void deleteMenuItem(MenuItem item) {
    Get.dialog(
      AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Are you sure you want to delete "${item.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Remove the item
              menuItems.removeWhere((i) => i.id == item.id);

              Get.back();
              Get.snackbar(
                'Deleted',
                'Menu item deleted successfully',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}