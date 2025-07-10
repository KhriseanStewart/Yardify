import 'package:flutter/material.dart';
import 'package:yardify/mobile/database/item_list.dart';

// ignore: must_be_immutable
class PfpProduct extends StatefulWidget {
  String uid;
  PfpProduct({required this.uid});

  @override
  _PfpProductState createState() => _PfpProductState();
}

class _PfpProductState extends State<PfpProduct> {
  Widget _imageWidget = CircularProgressIndicator();

  @override
  void initState() {
    super.initState();
    loadAndDisplayImage();
  }

  void loadAndDisplayImage() async {
    Widget image = await UserService().loadProfileImage(widget.uid);
    setState(() {
      _imageWidget = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle),
      width: 100,
      height: 100,
      child: _imageWidget,
    );
  }
}
