import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CustomLoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.staggeredDotsWave(
        color: Colors.white,
        size: 40,
      ),
    );
  }
}
class CustomLoadingWidget1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.staggeredDotsWave(
        color: Colors.brown,
        size: 40,
      ),
    );
  }
}
