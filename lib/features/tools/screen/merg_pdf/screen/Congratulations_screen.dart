import 'package:flutter/material.dart';
import 'package:pdf_scanner/features/tools/widget/custom_top_back_button.dart';

class CongratulationsScreen extends StatelessWidget {
  static final routeName = '/congratulationsScreen';
  const CongratulationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomTopBarBackButton(title: '', icon: Icons.home_outlined),
          ],
        ),
      ),
    );
  }
}
