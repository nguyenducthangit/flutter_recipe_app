import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Row(
          children: [
            Icon(
              Iconsax.setting5,
              size: 20,
            ),
            Text('Nguyen Duc Thang'),
          ],
        ),
      ),
    );
  }
}
