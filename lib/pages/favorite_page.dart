import 'package:flutter/material.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildSectionTitle('단골 상점'),
        _buildFavoriteShopList(),
        const SizedBox(height: 24),
        
        _buildSectionTitle('찜한 상품'),
        _buildFavoriteProductList(),
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

  Widget _buildFavoriteShopList() {
    return Column(
      children: [
        _buildFavoriteShopItem('김씨네 과일가게', '4.5', '과일'),
        _buildFavoriteShopItem('바다횟집', '4.7', '수산물'),
        _buildFavoriteShopItem('할머니 떡집', '4.3', '떡집'),
      ],
    );
  }

  Widget _buildFavoriteShopItem(String name, String rating, String category) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.pink.shade100,
          child: Icon(
            Icons.storefront,
            color: Colors.pink.shade700,
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Row(
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 16),
            Text(' $rating'),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                category,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.favorite, color: Colors.red),
          onPressed: () {
            // 찜 해제
          },
        ),
      ),
    );
  }

  Widget _buildFavoriteProductList() {
    return Column(
      children: [
        _buildFavoriteProductItem('사과 1봉', '5,000원', '김씨네 과일가게'),
        _buildFavoriteProductItem('고등어 1손', '8,000원', '바다횟집'),
        _buildFavoriteProductItem('꿀 백설기', '2,000원', '할머니 떡집'),
      ],
    );
  }

  Widget _buildFavoriteProductItem(String name, String price, String shopName) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.image, color: Colors.grey),
        ),
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              price,
              style: const TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              shopName,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.favorite, color: Colors.red),
              onPressed: () {
                // 찜 해제
              },
            ),
            IconButton(
              icon: const Icon(Icons.add_shopping_cart),
              onPressed: () {
                // 장바구니에 추가
              },
            ),
          ],
        ),
      ),
    );
  }
}