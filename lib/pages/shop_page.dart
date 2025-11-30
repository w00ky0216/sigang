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
    '축산물': [
      {
        'name': '형제정육점',
        'location': '다59',
        'category': '축산물',
        'items': '육류',
        'phone': '033-742-3228',
      },
      {
        'name': '소망정육점',
        'location': '라68',
        'category': '축산물',
        'items': '정육',
        'phone': '',
      },
    ],
    '수산/건어물': [
      {
        'name': '금천김',
        'location': '다62',
        'category': '수산/건어물',
        'items': '김/부각/튀각/누룽지',
        'phone': '033-735-6455',
      },
      {
        'name': '부부식품 건어물',
        'location': '라74',
        'category': '수산/건어물',
        'items': '건어물',
        'phone': '033-742-8056',
      },
      {
        'name': '서울수산',
        'location': '라77-1',
        'category': '수산/건어물',
        'items': '수산물',
        'phone': '033-743-2540',
      },
    ],
    '떡/베이커리': [
      {
        'name': '유성떡집',
        'location': '가10',
        'category': '떡/베이커리',
        'items': '떡',
        'phone': '033-745-9950',
      },
      {
        'name': '철수네 꽈배기',
        'location': '다51',
        'category': '떡/베이커리',
        'items': '꽈배기',
        'phone': '',
      },
      {
        'name': '이동규 제과점',
        'location': '라51',
        'category': '떡/베이커리',
        'items': '식빵/꽈배기 등 빵류',
        'phone': '033-765-4702',
      },
      {
        'name': '원주떡집',
        'location': '라66',
        'category': '떡/베이커리',
        'items': '떡류',
        'phone': '033-745-7706',
      },
      {
        'name': '대월떡집',
        'location': '라72',
        'category': '떡/베이커리',
        'items': '떡류',
        'phone': '033-744-9292',
      },
    ],
    '반찬/부식': [
      {
        'name': '부부분식',
        'location': '다52',
        'category': '반찬/부식',
        'items': '분식',
        'phone': '033-732-7579',
      },
      {
        'name': '장수반찬',
        'location': '다52-1',
        'category': '반찬/부식',
        'items': '반찬류',
        'phone': '033-748-2353',
      },
      {
        'name': '반찬곳간',
        'location': '다57',
        'category': '반찬/부식',
        'items': '반찬',
        'phone': '033-742-6614',
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
          shop['location']!,
          shop['category']!,
          shop['items']!,
          shop['phone']!,
        );
      }).toList(),
    );
  }

  Widget _buildShopItem(
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
            Text('호수: $location'),
            Text('취급품목: $items'),
            if (phone.isNotEmpty) Text('연락처: $phone'),
            const SizedBox(height: 4),
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
        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
        onTap: () {
          // 상점 상세 페이지로 이동
        },
      ),
    );
  }
}
