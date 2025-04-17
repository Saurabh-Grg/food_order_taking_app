import 'package:flutter/material.dart';

enum OrderStatus {
  pending,
  accepted,
  preparing,
  ready,
  completed,
  cancelled
}

enum OrderType {
  pickup,
  delivery
}

class OrderItem {
  final String id;
  final String name;
  final int quantity;
  final double price;
  final List<String> modifiers;

  OrderItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    this.modifiers = const [],
  });

  double get subtotal => price * quantity;
}

class Order {
  final String id;
  final String customerName;
  final String customerPhone;
  final String customerEmail;
  final List<OrderItem> items;
  final OrderStatus status;
  final OrderType type;
  final DateTime orderTime;
  final DateTime? pickupTime;
  final String? specialInstructions;
  final double subtotal;
  final double tax;
  final double deliveryFee;
  final double tip;

  Order({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.customerEmail,
    required this.items,
    required this.status,
    required this.type,
    required this.orderTime,
    this.pickupTime,
    this.specialInstructions,
    required this.subtotal,
    required this.tax,
    required this.deliveryFee,
    required this.tip,
  });

  double get total => subtotal + tax + deliveryFee + tip;

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  // Helper method to get status text for display
  String get statusText {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.accepted:
        return 'Accepted';
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.ready:
        return 'Ready';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.cancelled:
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }

  // Helper method to get status color
  Color get statusColor {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.accepted:
        return Colors.blue;
      case OrderStatus.preparing:
        return Colors.purple;
      case OrderStatus.ready:
        return Colors.green;
      case OrderStatus.completed:
        return Colors.grey;
      case OrderStatus.cancelled:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Helper method to get first letter of customer name for avatar
  String get customerInitial {
    return customerName.isNotEmpty ? customerName[0].toUpperCase() : '?';
  }
}