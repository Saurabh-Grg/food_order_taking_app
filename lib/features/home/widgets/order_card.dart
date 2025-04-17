import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/models/order_model.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback onTap;

  const OrderCard({
    Key? key,
    required this.order,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('MMM d, h:mm a');

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Customer initial circle avatar
                  CircleAvatar(
                    child: Icon(
                      _getStatusIcon(order.statusText.toLowerCase()),
                      color: order.statusColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Order info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${order.customerName} - #${order.id.substring(0, 6)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '${order.totalItems} items - ${formatter.format(order.orderTime)}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Status indicator
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: order.statusColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      order.statusText,
                      style: TextStyle(
                        color: order.statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              // Order type and total price
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        order.type == OrderType.pickup
                            ? Icons.store
                            : Icons.delivery_dining,
                        color: Colors.grey[600],
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        order.type == OrderType.pickup ? 'Pickup' : 'Delivery',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'NRS ${order.total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              // Pickup time if available
              if (order.pickupTime != null)
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: Colors.grey[600],
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Pickup at ${formatter.format(order.pickupTime!)}',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'pending':
        return Icons.hourglass_empty;
      case 'ready':
        return Icons.done_all;
      case 'accepted':
        return Icons.check_circle_outline;
      case 'preparing':
        return Icons.restaurant;
      case 'completed':
        return Icons.check_circle;
      default:
        return Icons.help_outline;
    }
  }
}