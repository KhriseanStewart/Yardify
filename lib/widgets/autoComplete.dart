import 'package:flutter/material.dart';
import 'package:yardify/mobile/database/item_list.dart';

class CategoryAutocomplete extends StatefulWidget {
  final Function(String?) onCategorySelected;

  const CategoryAutocomplete({Key? key, required this.onCategorySelected})
    : super(key: key);

  @override
  _CategoryAutocompleteState createState() => _CategoryAutocompleteState();
}

class _CategoryAutocompleteState extends State<CategoryAutocomplete> {
  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        }
        return categories.where((String category) {
          return category.toLowerCase().contains(
            textEditingValue.text.toLowerCase(),
          );
        });
      },
      onSelected: (String selection) {
        widget.onCategorySelected(selection);
      },
      fieldViewBuilder:
          (
            BuildContext context,
            TextEditingController controller,
            FocusNode focusNode,
            VoidCallback onFieldSubmitted,
          ) {
            return TextField(
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                labelText: 'Select a category',
                border: InputBorder.none,
              ),
            );
          },
    );
  }
}
