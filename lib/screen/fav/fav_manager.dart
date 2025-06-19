class FavoritesManager {
  // Singleton setup
  static final FavoritesManager _instance = FavoritesManager._internal();

  factory FavoritesManager() {
    return _instance;
  }

  FavoritesManager._internal();

  // Keep your list as a private member
  final List<Map<String, dynamic>> _favorites = [];

  List<Map<String, dynamic>> get favorites => _favorites;

  bool isFavorite(Map<String, dynamic> item) {
    return _favorites.any((fav) => fav['itemName'] == item['itemName']);
  }

  void addFavorite(Map<String, dynamic> item) {
    if (!isFavorite(item)) {
      _favorites.add(item);
    }
  }

  void removeFavorite(Map<String, dynamic> item) {
    _favorites.removeWhere((fav) => fav['itemName'] == item['itemName']);
  }
}
