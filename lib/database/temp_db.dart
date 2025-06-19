import 'package:zellyshop/screen/home/home.dart';

final List<String> categories = [
  "All Products",
  "Flash Sales",
  "Gadgets",
  "Appliances",

  "More",
];
final List<Map<String, dynamic>> productDetails = [
  {
    'brandName': 'Palmers Tech',
    'image': 'xr-5c.jpg',
    'itemName': 'Iphone XR',
    'price': '12,500',
    'rating': '4.1/5',
    'sort': 'new',
    'categories': 'Gadgets',
    'item': 'phone',
  },
  {
    'brandName': 'Palmers Tech',
    'image': 'kv-laptop.png',
    'itemName': 'MSI Laptop',
    'price': '82,500',
    'rating': '4.9/5',
    'sort': 'newly used',
    'categories': 'Gadgets',
    'item': 'laptop',
  },
  {
    'brandName': 'Palmers Tech',
    'image': '71Mt4JAZQtL._AC_SL1500_.jpg',
    'itemName': 'Tablet',
    'price': '32,500',
    'rating': '4.5/5',
    'sort': 'used',
    'categories': 'Gadgets',
    'item': 'tablet',
  },
  {
    'brandName': 'Stewarts Auto',
    'image': '61FNFOpoRJL.jpg',
    'itemName': 'Car Jack',
    'price': '12,500',
    'rating': '4.1/5',
    'sort': 'newly used',
    'categories': 'vehicle Parts',
    'item': 'jack',
  },
  {
    'brandName': 'Stewarts Auto',
    'image': '002_2.jpg',
    'itemName': 'Vitz',
    'price': '1,922,500',
    'rating': '2.9/5',
    'sort': 'newly used',
    'categories': 'Vehicle',
    'item': 'vitz',
  },
];

List<Map<String, dynamic>> get filteredProducts {
  if (selectedCategory == 'All Products') {
    return productDetails;
  }
  return productDetails.where((product) {
    final category = product['categories']?.toString().toLowerCase() ?? '';
    final selected = selectedCategory.toLowerCase();
    return category.contains(selected);
  }).toList();
}