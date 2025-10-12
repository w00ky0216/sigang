import 'package:flutter/material.dart';
import 'favorite_page.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedCategory = '전체';

  // 카테고리별 상점 데이터
  final Map<String, List<Map<String, String>>> categoryShops = {
    '과일': [
      {
        'name': '신선과일마트',
        'description': '국내산 신선한 과일을 저렴하게!',
        'rating': '4.5',
        'category': '과일',
      },
      {
        'name': '과일천국',
        'description': '달콤한 제철 과일 전문점',
        'rating': '4.7',
        'category': '과일',
      },
      {
        'name': '청과마트',
        'description': '과일·견과류 전문 매장',
        'rating': '4.3',
        'category': '과일',
      },
    ],
    '채소': [
      {
        'name': '유기농채소',
        'description': '무농약 유기농 채소 전문점',
        'rating': '4.6',
        'category': '채소',
      },
      {
        'name': '농장직판장',
        'description': '농장에서 바로 온 신선한 채소',
        'rating': '4.4',
        'category': '채소',
      },
      {
        'name': '건강채소마켓',
        'description': '건강한 채소와 쌈채소 전문',
        'rating': '4.5',
        'category': '채소',
      },
    ],
    '수산물': [
      {
        'name': '싱싱횟집',
        'description': '활어회와 해산물 전문점',
        'rating': '4.8',
        'category': '수산물',
      },
      {
        'name': '바다마트',
        'description': '신선한 생선과 해산물',
        'rating': '4.6',
        'category': '수산물',
      },
      {
        'name': '수산시장',
        'description': '다양한 수산물을 한 곳에서',
        'rating': '4.4',
        'category': '수산물',
      },
    ],
    '정육점': [
      {
        'name': '프리미엄정육점',
        'description': '1등급 한우 전문점',
        'rating': '4.7',
        'category': '정육점',
      },
      {
        'name': '신선정육마트',
        'description': '신선한 돼지고기·닭고기',
        'rating': '4.5',
        'category': '정육점',
      },
    ],
    '떡집': [
      {
        'name': '전통떡집',
        'description': '전통 방식으로 만든 수제떡',
        'rating': '4.6',
        'category': '떡집',
      },
      {
        'name': '맛있는떡집',
        'description': '다양한 떡과 한과 전문',
        'rating': '4.4',
        'category': '떡집',
      },
    ],
    '반찬': [
      {
        'name': '엄마손반찬',
        'description': '집밑반찬과 김치 전문',
        'rating': '4.8',
        'category': '반찬',
      },
      {
        'name': '건강반찬가게',
        'description': '건강한 밑반찬 전문점',
        'rating': '4.5',
        'category': '반찬',
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 탭바
        Container(
          color: Colors.white,
          child: TabBar(
            controller: _tabController,
            labelColor: Colors.orange,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.orange,
            tabs: const [
              Tab(icon: Icon(Icons.storefront), text: '전체 상점'),
              Tab(icon: Icon(Icons.bookmark), text: '찜 · 단골'),
            ],
          ),
        ),

        // 탭 내용
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildAllShopsTab(),
              const FavoritePage(), // 기존 찜 페이지 재사용
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAllShopsTab() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // 카테고리 선택
        _buildCategoryFilter(),
        const SizedBox(height: 20),

        // 상점 목록
        _buildSectionTitle(
          selectedCategory == '전체' ? '전체 상점' : '$selectedCategory 상점',
        ),
        _buildShopList(),
      ],
    );
  }

  Widget _buildCategoryFilter() {
    final categories = ['전체', ...categoryShops.keys];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          return _buildCategoryChip(category, selectedCategory == category);
        }).toList(),
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (value) {
          setState(() {
            selectedCategory = label;
          });
        },
        selectedColor: Colors.orange.shade100,
        checkmarkColor: Colors.orange,
      ),
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

  Widget _buildShopList() {
    List<Map<String, String>> shopsToShow = [];

    if (selectedCategory == '전체') {
      // 전체가 선택되면 모든 카테고리의 상점을 보여줌
      categoryShops.values.forEach((shops) {
        shopsToShow.addAll(shops);
      });
    } else {
      // 특정 카테고리가 선택되면 해당 카테고리의 상점만 보여줌
      shopsToShow = categoryShops[selectedCategory] ?? [];
    }

    if (shopsToShow.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text(
            '해당 카테고리에 상점이 없습니다.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    return Column(
      children: shopsToShow.map((shop) {
        return _buildShopItem(
          shop['name']!,
          shop['description']!,
          shop['rating']!,
          shop['category']!,
        );
      }).toList(),
    );
  }

  Widget _buildShopItem(
    String name,
    String description,
    String rating,
    String category,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.orange.shade100,
          child: Icon(
            Icons.storefront,
            color: Colors.orange.shade700,
            size: 24,
          ),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(description),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 16),
                Text(' $rating'),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(category, style: const TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
        onTap: () {
          // 상점 상세 페이지로 이동
        },
      ),
    );
  }
}
