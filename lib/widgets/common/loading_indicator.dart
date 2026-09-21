// // Loading Indicator Widget
// import 'package:flutter/material.dart';
//
// class LoadingIndicator extends StatelessWidget {
//   const LoadingIndicator({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return const Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CircularProgressIndicator(),
//           SizedBox(height: 16),
//           Text(
//             'Loading...',
//             style: TextStyle(
//               color: Colors.grey,
//               fontSize: 16,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//


import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final String? message;

  const LoadingIndicator({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          if (message != null) ...[
            SizedBox(height: 16),
            Text(
              message!,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 16,
              ),
            ),
          ],
        ],
      ),
    );
  }
}