import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:prueba/widgets/sub_title_text.dart';

class LoadingWidget extends StatelessWidget {
  final String title;
  const LoadingWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset('assets/loading.json'),
        SubTitleText(text: title)
      ],
    );
  }
}