import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
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
  Map<String, String>? selectedShop; // Track selected shop for details view
  Set<String> favoriteShops = {}; // Track favorite shops by name
  bool isLoadingFavorites = true;

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
    _loadFavorites();
  }

  // Load favorites from shared preferences
  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getString('favorite_shops');
    if (favoritesJson != null) {
      final List<dynamic> favoritesList = jsonDecode(favoritesJson);
      setState(() {
        favoriteShops = favoritesList.map((e) => e.toString()).toSet();
        isLoadingFavorites = false;
      });
    } else {
      setState(() {
        isLoadingFavorites = false;
      });
    }
  }

  // Save favorites to shared preferences
  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = jsonEncode(favoriteShops.toList());
    await prefs.setString('favorite_shops', favoritesJson);
  }

  // Toggle favorite status
  Future<void> _toggleFavorite(String shopName) async {
    setState(() {
      if (favoriteShops.contains(shopName)) {
        favoriteShops.remove(shopName);
      } else {
        favoriteShops.add(shopName);
      }
    });
    await _saveFavorites();
  }

  // Check if shop is favorite
  bool _isFavorite(String shopName) {
    return favoriteShops.contains(shopName);
  }

  // Get all shops from all categories
  List<Map<String, String>> _getAllShops() {
    List<Map<String, String>> allShops = [];
    categoryShops.values.forEach((shops) {
      allShops.addAll(shops);
    });
    return allShops;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If a shop is selected, show details view
    if (selectedShop != null) {
      return _buildShopDetailsView();
    }

    // Otherwise show the shop list
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
              FavoritePage(
                favoriteShopNames: favoriteShops,
                allShops: _getAllShops(),
                onToggleFavorite: (shopName) async {
                  await _toggleFavorite(shopName);
                  final isFav = _isFavorite(shopName);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isFav
                              ? '$shopName 찜 목록에 추가되었습니다'
                              : '$shopName 찜 목록에서 제거되었습니다',
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
                onShopTap: (shop) {
                  setState(() {
                    selectedShop = shop;
                  });
                },
              ),
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
    final isFav = _isFavorite(name);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        leading: Stack(
          children: [
            CircleAvatar(
              backgroundColor: Colors.orange.shade100,
              child: Icon(
                Icons.storefront,
                color: Colors.orange.shade700,
                size: 24,
              ),
            ),
            if (isFav)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.favorite,
                    size: 12,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            if (isFav)
              Icon(Icons.favorite, size: 16, color: Colors.red.shade400),
          ],
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
              child: Text(category, style: const TextStyle(fontSize: 12)),
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
        onTap: () {
          // Show shop details in the same page
          setState(() {
            selectedShop = {
              'name': name,
              'location': location,
              'category': category,
              'items': items,
              'phone': phone,
            };
          });
        },
      ),
    );
  }

  Widget _buildShopDetailsView() {
    final shop = selectedShop!;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back button
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    setState(() {
                      selectedShop = null;
                    });
                  },
                ),
                const Text(
                  '상점 상세정보',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Shop details content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Shop icon and name
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.storefront,
                          size: 50,
                          color: Colors.orange.shade700,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        shop['name']!,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          shop['category']!,
                          style: TextStyle(
                            color: Colors.orange.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Shop information
                _buildDetailRow(Icons.location_on, '호수', shop['location']!),
                const SizedBox(height: 16),
                _buildDetailRow(Icons.shopping_basket, '취급품목', shop['items']!),
                if (shop['phone']!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildDetailRow(Icons.phone, '연락처', shop['phone']!),
                ],

                const SizedBox(height: 32),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          await _toggleFavorite(shop['name']!);
                          final isFav = _isFavorite(shop['name']!);
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isFav
                                      ? '${shop['name']} 찜 목록에 추가되었습니다'
                                      : '${shop['name']} 찜 목록에서 제거되었습니다',
                                ),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        icon: Icon(
                          _isFavorite(shop['name']!)
                              ? Icons.favorite
                              : Icons.favorite_border,
                        ),
                        label: Text(
                          _isFavorite(shop['name']!) ? '찜 해제' : '찜하기',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isFavorite(shop['name']!)
                              ? Colors.red
                              : Colors.orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          if (shop['phone']!.isNotEmpty) {
                            // Call phone logic (would need url_launcher package)
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('전화 걸기: ${shop['phone']}'),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.call),
                        label: const Text('전화하기'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.orange,
                          side: const BorderSide(color: Colors.orange),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.orange, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
