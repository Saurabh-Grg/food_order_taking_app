


import 'package:flutter/material.dart';

class SettingView extends StatelessWidget {

  const SettingView({super.key});



  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Settings'),
        elevation: 4,
        
      ),
      body: Column(
        children: [
          Text('')
        ],
      ),
    );
  }


}
