import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../data/models/order_model.dart';
import '../../../widgets/buttons/custom_button.dart';
import '../../../widgets/common/loading_indicator.dart';
import '../controllers/order_detail_controller.dart';

class OrderDetailView extends GetView<OrderDetailController> {
  const OrderDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() =>
            Text('Order #${controller.order.value?.id.substring(0, 6) ?? ''}')),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.refreshOrder(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingIndicator();
        }

        if (controller.hasError.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(controller.errorMessage.value),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.refreshOrder(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final order = controller.order.value;
        if (order == null) {
          return const Center(child: Text('Order not found'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Status Card
              _buildStatusCard(order, context),

              const SizedBox(height: 24),

              // Customer Information
              _buildSectionHeader('Customer Information'),
              _buildInfoCard([
                _buildInfoRow('Name', order.customerName),
                _buildInfoRow('Phone', order.customerPhone),
                _buildInfoRow('Email', order.customerEmail),
              ]),

              const SizedBox(height: 24),

              // Order Details
              _buildSectionHeader('Order Details'),
              _buildInfoCard([
                _buildInfoRow('Order ID', '#${order.id}'),
                _buildInfoRow('Order Type',
                    order.type == OrderType.pickup ? 'Pickup' : 'Delivery'),
                _buildInfoRow('Order Time',
                    DateFormat('MMM d, yyyy h:mm a').format(order.orderTime)),
                if (order.pickupTime != null)
                  _buildInfoRow(
                      'Pickup Time',
                      DateFormat('MMM d, yyyy h:mm a')
                          .format(order.pickupTime!)),
                if (order.specialInstructions != null &&
                    order.specialInstructions!.isNotEmpty)
                  _buildInfoRow(
                      'Special Instructions', order.specialInstructions!),
              ]),

              const SizedBox(height: 24),

              // Order Items
              _buildSectionHeader('Order Items'),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: order.items.length,
                itemBuilder: (context, index) {
                  final item = order.items[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Quantity circle
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                item.quantity.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Item details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                if (item.modifiers.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      item.modifiers.join(', '),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          // Item price
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '\$${item.price.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (item.quantity > 1)
                                Text(
                                  '\$${item.subtotal.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              // Order Summary
              _buildSectionHeader('Order Summary'),
              _buildInfoCard([
                _buildInfoRow(
                    'Subtotal', '\$${order.subtotal.toStringAsFixed(2)}'),
                _buildInfoRow('Tax', '\$${order.tax.toStringAsFixed(2)}'),
                if (order.deliveryFee > 0)
                  _buildInfoRow('Delivery Fee',
                      '\$${order.deliveryFee.toStringAsFixed(2)}'),
                if (order.tip > 0)
                  _buildInfoRow('Tip', '\$${order.tip.toStringAsFixed(2)}'),
                _buildInfoRow(
                  'Total',
                  '\$${order.total.toStringAsFixed(2)}',
                  boldValue: true,
                  boldKey: true,
                ),
              ]),

              const SizedBox(height: 32),

              // Action buttons
              _buildActionButtons(order, context),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatusCard(Order order, BuildContext context) {
    return Card(
      color: order.statusColor.withOpacity(0.1),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: order.statusColor.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              _getStatusIcon(order.status),
              color: order.statusColor,
              size: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order Status',
                    style: TextStyle(
                      fontSize: 14,
                      color: order.statusColor.withOpacity(0.8),
                    ),
                  ),
                  Text(
                    order.statusText,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: order.statusColor,
                    ),
                  ),
                ],
              ),
            ),
            if (order.status == OrderStatus.pending)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'Action Required',
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    String key,
    String value, {
    bool boldKey = false,
    bool boldValue = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              key,
              style: TextStyle(
                color: Colors.grey[700],
                fontWeight: boldKey ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontWeight: boldValue ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(Order order, BuildContext context) {
    // Only show action buttons for pending orders
    if (order.status == OrderStatus.pending) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomButton(
            text: 'Accept Order',
            textColor: Theme.of(context).primaryColor,
            onPressed: () => _showPickupTimeDialog(context),
          ),
          const SizedBox(height: 12),
          CustomButton(
            text: 'Reject Order',
            textColor: Colors.grey[400]!,
            onPressed: () => _showRejectConfirmation(context),
          ),
        ],
      );
    }
    // For accepted orders that are not yet ready
    else if (order.status == OrderStatus.accepted ||
        order.status == OrderStatus.preparing) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomButton(
            text: order.status == OrderStatus.accepted
                ? 'Start Preparing'
                : 'Mark as Ready',
            textColor: Theme.of(context).primaryColor,
            onPressed: () {
              if (order.status == OrderStatus.accepted) {
                controller.updateOrderStatus(OrderStatus.preparing);
              } else {
                controller.updateOrderStatus(OrderStatus.ready);
              }
            },
          ),
          const SizedBox(height: 12),
          CustomButton(
            text: 'Update Pickup Time',
            textColor: Colors.grey[400]!,
            onPressed: () => _showPickupTimeDialog(context),
          ),
        ],
      );
    }
    // For ready orders
    else if (order.status == OrderStatus.ready) {
      return CustomButton(
        text: 'Mark as Completed',
        textColor: Theme.of(context).primaryColor,
        onPressed: () => controller.updateOrderStatus(OrderStatus.completed),
      );
    }

    // No actions for completed or cancelled orders
    return const SizedBox.shrink();
  }

  void _showPickupTimeDialog(BuildContext context) {
    final now = DateTime.now();
    DateTime selectedTime = now.add(const Duration(minutes: 30));

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Set Pickup Time'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Please select a pickup time for this order:'),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.dateAndTime,
                  initialDateTime: selectedTime,
                  minimumDate: now,
                  maximumDate: now.add(const Duration(days: 1)),
                  onDateTimeChanged: (dateTime) {
                    selectedTime = dateTime;
                  },
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Get.back();
                controller.acceptOrderWithPickupTime(selectedTime);
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _showRejectConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reject Order'),
          content: const Text('Are you sure you want to reject this order?'),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Get.back();
                controller.updateOrderStatus(OrderStatus.cancelled);
              },
              child: const Text('Reject'),
            ),
          ],
        );
      },
    );
  }

  IconData _getStatusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Icons.hourglass_empty;
      case OrderStatus.accepted:
        return Icons.check_circle_outline;
      case OrderStatus.preparing:
        return Icons.restaurant;
      case OrderStatus.ready:
        return Icons.done_all;
      case OrderStatus.completed:
        return Icons.check_circle;
      case OrderStatus.cancelled:
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }
}
