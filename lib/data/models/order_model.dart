// lib/models/order_model.dart
class OrderModel {
  final String id;
  final String customerName;
  final List<Map<String, dynamic>> items;
  final double total;
  String status;
  final DateTime createdAt;
  final String address;
  final String phoneNumber;

  OrderModel({
    required this.id,
    required this.customerName,
    required this.items,
    required this.total,
    required this.status,
    required this.createdAt,
    required this.address,
    required this.phoneNumber,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      customerName: json['customerName'],
      items: List<Map<String, dynamic>>.from(json['items']),
      total: json['total'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      address: json['address'],
      phoneNumber: json['phoneNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerName': customerName,
      'items': items,
      'total': total,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'address': address,
      'phoneNumber': phoneNumber,
    };
  }
}