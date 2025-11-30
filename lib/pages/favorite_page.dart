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
        _buildFavoriteShopItem('형제정육점', '다59', '축산물', '육류', '033-742-3228'),
        _buildFavoriteShopItem('금천김', '다62', '수산/건어물', '김/부각/튀각/누룽지', '033-735-6455'),
        _buildFavoriteShopItem('유성떡집', '가10', '떡/베이커리', '떡', '033-745-9950'),
        _buildFavoriteShopItem('부부분식', '다52', '반찬/부식', '분식', '033-732-7579'),
      ],
    );
  }

  Widget _buildFavoriteShopItem(String name, String location, String category, String items, String phone) {
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
        _buildFavoriteProductItem('한우 1kg', '45,000원', '형제정육점'),
        _buildFavoriteProductItem('김 선물세트', '15,000원', '금천김'),
        _buildFavoriteProductItem('백설기', '12,000원', '유성떡집'),
        _buildFavoriteProductItem('떡볶이 세트', '8,000원', '부부분식'),
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