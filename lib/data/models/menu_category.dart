class MenuCategory {
  final String id;
  final String name;

  MenuCategory({required this.id, required this.name});
}

class MenuItem {
  final String id;
  final String categoryId;
  final String name;
  final String description;
  final double price;
  final bool isAvailable;
  final String? imageUrl;

  MenuItem({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.price,
    this.isAvailable = true,
    this.imageUrl,
  });
}
