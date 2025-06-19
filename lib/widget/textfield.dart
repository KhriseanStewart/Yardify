import 'package:flutter/material.dart';

class Textfield extends StatefulWidget {
  final String textlabel;
  final Icon? texticon;
  final bool? obscuretext;
  final IconButton? iconbutton;
  final TextInputType keyboardType;
  final TextEditingController? textcontroller;
  final ValueChanged? onchange;
  final String? Function(String?)? val;
  Textfield({
    super.key,
    required this.textlabel,
    required this.keyboardType,
    this.texticon,
    this.iconbutton,
    this.textcontroller,
    this.obscuretext,
    this.onchange,
    this.val,
  });

  @override
  State<Textfield> createState() => _TextfieldState();
}

class _TextfieldState extends State<Textfield> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: widget.keyboardType,
      controller: widget.textcontroller,
      obscureText: widget.obscuretext ?? false,
      decoration: InputDecoration(
        hintText: widget.textlabel,
        // label: Center(child: Text(textlabel)),
        prefixIcon: widget.texticon,
        hintStyle: TextStyle(color: Colors.black),
        prefixIconColor: Colors.black,
        suffixIcon: widget.iconbutton,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onChanged: widget.onchange,
      validator: widget.val,
    );
  }
}
