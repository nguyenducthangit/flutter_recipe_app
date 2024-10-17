import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CelendarScreen extends StatefulWidget {
  const CelendarScreen({super.key});

  @override
  State<CelendarScreen> createState() => _CelendarScreenState();
}

class _CelendarScreenState extends State<CelendarScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Row(
          children: [
            Icon(
              Iconsax.calendar5,
              size: 20,
            ),
            Text('Nguyen Duc Thang'),
          ],
        ),
      ),
    );
  }
}
