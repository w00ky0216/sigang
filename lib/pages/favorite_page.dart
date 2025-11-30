import 'package:flutter/material.dart';

class FavoritePage extends StatelessWidget {
  final Set<String> favoriteShopNames;
  final List<Map<String, String>> allShops;
  final Function(String) onToggleFavorite;
  final Function(Map<String, String>) onShopTap;

  const FavoritePage({
    super.key,
    required this.favoriteShopNames,
    required this.allShops,
    required this.onToggleFavorite,
    required this.onShopTap,
  });

  @override
  Widget build(BuildContext context) {
    // Filter shops that are in favorites
    final favoriteShops = allShops
        .where((shop) => favoriteShopNames.contains(shop['name']))
        .toList();

    if (favoriteShops.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 80, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              '찜한 상점이 없습니다',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '마음에 드는 상점을 찜해보세요!',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildSectionTitle('찜한 상점 (${favoriteShops.length})'),
        ...favoriteShops.map(
          (shop) => _buildFavoriteShopItem(
            shop['name']!,
            shop['location']!,
            shop['category']!,
            shop['items']!,
            shop['phone']!,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildFavoriteShopItem(
    String name,
    String location,
    String category,
    String items,
    String phone,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.pink.shade100,
          child: Icon(Icons.storefront, color: Colors.pink.shade700),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('호수: $location'),
            Text('취급품목: $items'),
            if (phone.isNotEmpty) Text('연락처: $phone'),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(category, style: const TextStyle(fontSize: 12)),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.favorite, color: Colors.red),
          onPressed: () {
            onToggleFavorite(name);
          },
        ),
        onTap: () {
          onShopTap({
            'name': name,
            'location': location,
            'category': category,
            'items': items,
            'phone': phone,
          });
        },
      ),
    );
  }
}
