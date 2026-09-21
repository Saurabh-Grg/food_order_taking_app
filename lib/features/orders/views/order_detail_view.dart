import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/order_model.dart';
import '../../../routes/app_routes.dart';
import '../../tutorials/services/tutorial_service.dart';
import '../controllers/order_detail_controller.dart';

class OrderDetailView extends GetView<OrderDetailController> {
  const OrderDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final tutorialService = Get.find<TutorialService>();

    return WillPopScope(
      onWillPop: () async {
        if (tutorialService.isTutorialActive.value) {
          // Show completion dialog during tutorial
          _showCompletionDialog();
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Order Details'),
          leading: tutorialService.isTutorialActive.value
              ? SizedBox() // Hide back button during tutorial
              : BackButton(),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              // if (controller.hasError.value) {
              //   return Center(
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Text(controller.errorMessage.value),
              //         const SizedBox(height: 16),
              //         ElevatedButton(
              //           onPressed: () => controller.refreshOrder(),
              //           child: const Text('Retry'),
              //         ),
              //       ],
              //     ),
              //   );
              // }

              final order = controller.order;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOrderInfo(order),
                  SizedBox(height: 24),
                  _buildItemsList(order),
                  Spacer(),
                  _buildActionButtons(context, order),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderInfo(OrderModel order) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order #${order.id.substring(0, 8)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),
            Divider(),
            SizedBox(height: 8),
            _buildInfoRow('Customer', order.customerName),
            _buildInfoRow('Phone', order.phoneNumber),
            _buildInfoRow('Address', order.address),
            _buildInfoRow('Status', _getStatusText(order.status)),
            _buildInfoRow('Created', _formatDateTime(order.createdAt)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsList(OrderModel order) {
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Items',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: order.items.length,
                  itemBuilder: (context, index) {
                    final item = order.items[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        item['name'] as String,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        'Quantity: ${item['quantity']}',
                      ),
                      trailing: Text(
                        '\$${(item['price'] as double).toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Total:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '\$${order.total.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Theme.of(Get.context!).primaryColor,
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

  Widget _buildActionButtons(BuildContext context, OrderModel order) {
    final tutorialService = Get.find<TutorialService>();
    final isTutorial = tutorialService.isTutorialActive.value;

    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              if (isTutorial) {
                // Show tutorial completion dialog
                _showCompletionDialog();
              } else {
                controller.acceptOrder();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Accept Order',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: OutlinedButton(
            onPressed: isTutorial ? null : controller.rejectOrder,
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(
                color: Colors.red,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Reject Order',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showCompletionDialog() {
    final tutorialService = Get.find<TutorialService>();

    Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: Text('Tutorial Complete'),
          content: Text(
            'Congratulations! You have completed the tutorial.\n\n'
                'Now you know how to receive and accept orders in the app.',
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                tutorialService.completeTutorial();
                Get.back(); // Close dialog
                Get.until((route) => route.settings.name == Routes.HOME);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(Get.context!).primaryColor,
              ),
              child: Text('Start Using the App'),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'new':
        return 'New';
      case 'in_progress':
        return 'In Progress';
      case 'ready':
        return 'Ready';
      default:
        return status.capitalizeFirst ?? status;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final date = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    final time = '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    return '$date at $time';
  }
}