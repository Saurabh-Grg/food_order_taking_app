import '../models/order_model.dart';
import '../providers/api_provider.dart';

class OrderRepository {
  final ApiProvider apiProvider;

  OrderRepository({required this.apiProvider});

  Future<List<Order>> getOrders() async {
    try {
      // In a real app, you would fetch from API
      // For now, return dummy data
      return _getDummyOrders();
    } catch (e) {
      throw Exception('Failed to load orders: $e');
    }
  }

  Future<Order> getOrderById(String id) async {
    try {
      // In a real app, you would fetch a specific order
      final orders = _getDummyOrders();
      final order = orders.firstWhere(
            (order) => order.id == id,
        orElse: () => throw Exception('Order not found'),
      );
      return order;
    } catch (e) {
      throw Exception('Failed to load order: $e');
    }
  }

  Future<Order> updateOrderStatus(String id, OrderStatus status) async {
    try {
      // In a real app, you would update via API
      // For now, just simulate a successful update
      await Future.delayed(const Duration(seconds: 1));

      // Get the order and update its status
      final orders = _getDummyOrders();
      final orderIndex = orders.indexWhere((order) => order.id == id);

      if (orderIndex == -1) {
        throw Exception('Order not found');
      }

      // In a real app, you would update on the server and get the updated order
      // For now, just return a modified copy
      final originalOrder = orders[orderIndex];

      // Create a new order with updated status (in a real app, you'd have proper model copy methods)
      // This is just a simulation
      return Order(
        id: originalOrder.id,
        customerName: originalOrder.customerName,
        customerPhone: originalOrder.customerPhone,
        customerEmail: originalOrder.customerEmail,
        items: originalOrder.items,
        status: status, // Updated status
        type: originalOrder.type,
        orderTime: originalOrder.orderTime,
        pickupTime: originalOrder.pickupTime,
        specialInstructions: originalOrder.specialInstructions,
        subtotal: originalOrder.subtotal,
        tax: originalOrder.tax,
        deliveryFee: originalOrder.deliveryFee,
        tip: originalOrder.tip,
      );
    } catch (e) {
      throw Exception('Failed to update order: $e');
    }
  }

  Future<Order> updatePickupTime(String id, DateTime pickupTime) async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // Get the order
      final orders = _getDummyOrders();
      final orderIndex = orders.indexWhere((order) => order.id == id);

      if (orderIndex == -1) {
        throw Exception('Order not found');
      }

      // Get original order
      final originalOrder = orders[orderIndex];

      // Return a copy with updated pickup time
      return Order(
        id: originalOrder.id,
        customerName: originalOrder.customerName,
        customerPhone: originalOrder.customerPhone,
        customerEmail: originalOrder.customerEmail,
        items: originalOrder.items,
        status: originalOrder.status,
        type: originalOrder.type,
        orderTime: originalOrder.orderTime,
        pickupTime: pickupTime, // Updated pickup time
        specialInstructions: originalOrder.specialInstructions,
        subtotal: originalOrder.subtotal,
        tax: originalOrder.tax,
        deliveryFee: originalOrder.deliveryFee,
        tip: originalOrder.tip,
      );
    } catch (e) {
      throw Exception('Failed to update pickup time: $e');
    }
  }

  // Generate dummy data for testing
  List<Order> _getDummyOrders() {
    final now = DateTime.now();

    return [
      Order(
        id: 'ORD12345',
        customerName: 'John Doe',
        customerPhone: '555-123-4567',
        customerEmail: 'john@example.com',
        items: [
          OrderItem(
            id: 'ITEM1',
            name: 'Chicken Parmesan',
            quantity: 2,
            price: 15.99,
            modifiers: ['Extra cheese', 'No onions'],
          ),
          OrderItem(
            id: 'ITEM2',
            name: 'Garden Salad',
            quantity: 1,
            price: 8.99,
          ),
        ],
        status: OrderStatus.pending,
        type: OrderType.pickup,
        orderTime: now.subtract(const Duration(minutes: 15)),
        specialInstructions: 'Please include extra napkins',
        subtotal: 40.97,
        tax: 3.28,
        deliveryFee: 0.0,
        tip: 5.00,
      ),
      Order(
        id: 'ORD12346',
        customerName: 'Sarah Williams',
        customerPhone: '555-987-6543',
        customerEmail: 'sarah@example.com',
        items: [
          OrderItem(
            id: 'ITEM3',
            name: 'Margherita Pizza',
            quantity: 1,
            price: 14.99,
          ),
          OrderItem(
            id: 'ITEM4',
            name: 'Tiramisu',
            quantity: 2,
            price: 7.99,
          ),
        ],
        status: OrderStatus.accepted,
        type: OrderType.delivery,
        orderTime: now.subtract(const Duration(minutes: 45)),
        pickupTime: now.add(const Duration(minutes: 30)),
        subtotal: 30.97,
        tax: 2.48,
        deliveryFee: 5.99,
        tip: 4.00,
      ),
      Order(
        id: 'ORD12347',
        customerName: 'Michael Johnson',
        customerPhone: '555-456-7890',
        customerEmail: 'michael@example.com',
        items: [
          OrderItem(
            id: 'ITEM5',
            name: 'Beef Burger',
            quantity: 3,
            price: 12.99,
            modifiers: ['Extra patty', 'No pickle'],
          ),
          OrderItem(
            id: 'ITEM6',
            name: 'French Fries',
            quantity: 2,
            price: 4.99,
          ),
          OrderItem(
            id: 'ITEM7',
            name: 'Chocolate Milkshake',
            quantity: 3,
            price: 5.99,
          ),
        ],
        status: OrderStatus.preparing,
        type: OrderType.pickup,
        orderTime: now.subtract(const Duration(minutes: 60)),
        pickupTime: now.add(const Duration(minutes: 15)),
        subtotal: 68.91,
        tax: 5.51,
        deliveryFee: 0.0,
        tip: 8.00,
      ),
      Order(
        id: 'ORD12348',
        customerName: 'Emily Davis',
        customerPhone: '555-234-5678',
        customerEmail: 'emily@example.com',
        items: [
          OrderItem(
            id: 'ITEM8',
            name: 'Vegetable Pasta',
            quantity: 1,
            price: 13.99,
          ),
        ],
        status: OrderStatus.ready,
        type: OrderType.pickup,
        orderTime: now.subtract(const Duration(minutes: 90)),
        pickupTime: now.subtract(const Duration(minutes: 5)),
        subtotal: 13.99,
        tax: 1.12,
        deliveryFee: 0.0,
        tip: 2.00,
      ),
      Order(
        id: 'ORD12349',
        customerName: 'Alex Thompson',
        customerPhone: '555-345-6789',
        customerEmail: 'alex@example.com',
        items: [
          OrderItem(
            id: 'ITEM9',
            name: 'Sushi Combo',
            quantity: 1,
            price: 24.99,
          ),
          OrderItem(
            id: 'ITEM10',
            name: 'Miso Soup',
            quantity: 2,
            price: 3.99,
          ),
        ],
        status: OrderStatus.ready,
        type: OrderType.delivery,
        orderTime: now.subtract(const Duration(minutes: 120)),
        pickupTime: now,
        specialInstructions: 'Leave at door, contactless delivery please',
        subtotal: 32.97,
        tax: 2.64,
        deliveryFee: 5.99,
        tip: 6.00,
      ),
    ];
  }
}