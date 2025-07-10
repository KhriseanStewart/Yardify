import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  final Color color;

  const LoadingScreen({super.key, required this.color});
  

  @override
  Widget build(BuildContext context) {
    return Center(child: SpinKitFadingCircle(color: color, size: 50.0));
  }
}
