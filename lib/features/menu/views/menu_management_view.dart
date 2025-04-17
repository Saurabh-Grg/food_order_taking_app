import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/menu_category.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/common/error_view.dart';
import '../../../widgets/common/loading_indicator.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/menu_controller.dart';

class MenuManagementView extends StatelessWidget {
  final MenuManagementController controller = Get.find();
  final HomeController homeController = Get.find();

  MenuManagementView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Obx(() => controller.isSearchActive.value
            ? _buildSearchField()
            : const Text('Menu Management')),
        actions: [
          Obx(() => controller.isSearchActive.value
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => controller.showSearchBar(),
                )
              : IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => controller.showSearchBar(),
                )),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => controller.showFilterOptions(),
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const LoadingIndicator();
          }

          if (controller.hasError.value) {
            return ErrorView(
              message: controller.errorMessage.value,
              onRetry: () => controller.refreshMenu(),
            );
          }

          return Column(
            children: [
              // Active filters indicator
              Obx(() {
                final defaultMinPrice = controller.menuItems.isEmpty
                    ? 0.0
                    : controller.menuItems.map((item) => item.price).reduce((a, b) => a < b ? a : b);

                final defaultMaxPrice = controller.menuItems.isEmpty
                    ? 1000.0
                    : controller.menuItems.map((item) => item.price).reduce((a, b) => a > b ? a : b);

                final hasActiveFilters = controller.showOnlyAvailable.value ||
                    (controller.minPrice.value > defaultMinPrice) ||
                    (controller.maxPrice.value < defaultMaxPrice) ||
                    controller.searchQuery.isNotEmpty;

                return hasActiveFilters
                    ? Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  color: theme.primaryColor.withOpacity(0.05),
                  child: Row(
                    children: [
                      Icon(Icons.filter_list,
                          size: 16, color: theme.primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        'Filters active',
                        style: TextStyle(color: theme.primaryColor),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          controller.searchController.clear();
                          controller.searchQuery.value = '';
                          controller.minPrice.value = defaultMinPrice;
                          controller.maxPrice.value = defaultMaxPrice;
                          controller.showOnlyAvailable.value = false;
                          controller.sortBy.value = 'name';
                        },
                        child: const Text('Clear All'),
                      ),
                    ],
                  ),
                )
                    : const SizedBox.shrink();
              }),

              // Category tabs
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 2,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Obx(() {
                  // Force rebuild on selectedCategoryIndex change
                  final currentSelectedIndex = controller.selectedCategoryIndex.value;

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    itemCount: controller.categories.length,
                    itemBuilder: (context, index) {
                      final category = controller.categories[index];
                      final isSelected = currentSelectedIndex == index;

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: InkWell(
                          onTap: () {
                            controller.selectCategory(index);
                            // Add this line to ensure update
                            controller.selectedCategoryIndex.refresh();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: isSelected
                                      ? theme.primaryColor
                                      : Colors.transparent,
                                  width: 3, // Changed from 5 to 3 for better appearance
                                ),
                              ),
                            ),
                            child: Text(
                              category.name,
                              style: TextStyle(
                                color: isSelected
                                    ? theme.primaryColor
                                    : Colors.grey,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),

              // Menu items
              Expanded(
                child: Obx(() {
                  final menuItems = controller.filteredMenuItems;

                  if (menuItems.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.restaurant_menu,
                              size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            'No menu items in this category',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.add),
                            label: const Text('Add Item'),
                            onPressed: () => controller.addNewMenuItem(),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: controller.refreshMenu,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: menuItems.length,
                      itemBuilder: (context, index) {
                        final menuItem = menuItems[index];
                        return _buildMenuItemCard(menuItem, theme);
                      },
                    ),
                  );
                }),
              ),
            ],
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.addNewMenuItem(),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            currentIndex: homeController.currentNavIndex.value,
            onTap: homeController.changeNavPage,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long),
                label: 'Orders',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.restaurant_menu),
                label: 'Menu',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
          )),
    );
  }

  // Search field widget
  Widget _buildSearchField() {
    return TextField(
      controller: controller.searchController,
      autofocus: true,
      decoration: const InputDecoration(
        hintText: 'Search menu items...',
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
      ),
      onSubmitted: (value) {
        // Close keyboard but keep search active
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }

  Widget _buildMenuItemCard(MenuItem menuItem, ThemeData theme) {
    final availability = menuItem.isAvailable ? 'Available' : 'Unavailable';
    final availabilityColor = menuItem.isAvailable ? Colors.green : Colors.red;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Get.toNamed(
          " Routes.MENU_ITEM_DETAIL",
          arguments: menuItem,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Food image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey[200],
                  child: menuItem.imageUrl != null
                      ? Image.network(
                          menuItem.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.image_not_supported,
                            size: 40,
                            color: Colors.grey,
                          ),
                        )
                      : const Icon(
                          Icons.fastfood,
                          size: 40,
                          color: Colors.grey,
                        ),
                ),
              ),
              const SizedBox(width: 16),
              // Menu item details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            menuItem.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: availabilityColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            availability,
                            style: TextStyle(
                              color: availabilityColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      menuItem.description,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'NRS ${menuItem.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: theme.primaryColor,
                            fontSize: 16,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, size: 20),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () =>
                                  controller.editMenuItem(menuItem),
                            ),
                            IconButton(
                              icon: Icon(
                                menuItem.isAvailable
                                    ? Icons.toggle_on
                                    : Icons.toggle_off,
                                size: 24,
                                color: menuItem.isAvailable
                                    ? theme.primaryColor
                                    : Colors.grey,
                              ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () =>
                                  controller.toggleAvailability(menuItem),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  size: 20, color: Colors.red),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () =>
                                  controller.deleteMenuItem(menuItem),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
