import 'package:flutter/material.dart';

class RegularShopPage extends StatefulWidget {
  const RegularShopPage({super.key});

  @override
  State<RegularShopPage> createState() => _RegularShopPageState();
}

class _RegularShopPageState extends State<RegularShopPage> {
  // 단골 상점 데이터
  final List<Map<String, dynamic>> regularShops = [
    {
      'name': '형제정육점',
      'location': '다59',
      'category': '축산물',
      'items': '육류',
      'phone': '033-742-3228',
      'rating': 4.8,
      'visitCount': 23,
      'lastVisit': '2025.10.10',
      'discount': '단골 할인 5%',
      'color': Colors.red,
      'icon': Icons.lunch_dining,
      'totalSpent': 145000,
    },
    {
      'name': '금천김',
      'location': '다62',
      'category': '수산/건어물',
      'items': '김/부각/튀각/누룽지',
      'phone': '033-735-6455',
      'rating': 4.9,
      'visitCount': 18,
      'lastVisit': '2025.10.08',
      'discount': '단골 할인 10%',
      'color': Colors.blue,
      'icon': Icons.set_meal,
      'totalSpent': 89000,
    },
    {
      'name': '유성떡집',
      'location': '가10',
      'category': '떡/베이커리',
      'items': '떡',
      'phone': '033-745-9950',
      'rating': 4.7,
      'visitCount': 12,
      'lastVisit': '2025.10.05',
      'discount': '단골 할인 8%',
      'color': Colors.brown,
      'icon': Icons.cake,
      'totalSpent': 234000,
    },
    {
      'name': '부부분식',
      'location': '다52',
      'category': '반찬/부식',
      'items': '분식',
      'phone': '033-732-7579',
      'rating': 4.6,
      'visitCount': 15,
      'lastVisit': '2025.10.12',
      'discount': '단골 할인 7%',
      'color': Colors.orange,
      'icon': Icons.restaurant,
      'totalSpent': 67000,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('단골 상점'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // 단골 상점 통계
          _buildRegularShopStats(),
          const SizedBox(height: 20),

          // 단골 등급 안내
          _buildLoyaltyLevelInfo(),
          const SizedBox(height: 20),

          // 단골 상점 목록
          const Text(
            '나의 단골 상점',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          ...regularShops.map((shop) => _buildRegularShopCard(shop)).toList(),
        ],
      ),
    );
  }

  Widget _buildRegularShopStats() {
    final totalVisits = regularShops.fold<int>(
      0,
      (sum, shop) => sum + (shop['visitCount'] as int),
    );
    final totalSpent = regularShops.fold<int>(
      0,
      (sum, shop) => sum + (shop['totalSpent'] as int),
    );
    final avgRating =
        regularShops.fold<double>(
          0.0,
          (sum, shop) => sum + (shop['rating'] as double),
        ) /
        regularShops.length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange.shade100, Colors.orange.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.store, color: Colors.orange.shade700, size: 24),
              const SizedBox(width: 8),
              Text(
                '나의 단골 활동',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('단골 상점', '${regularShops.length}개'),
              _buildStatItem('총 방문', '$totalVisits회'),
              _buildStatItem('총 구매', '${_formatPrice(totalSpent)}원'),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 20),
              const SizedBox(width: 4),
              Text(
                '평균 만족도: ${avgRating.toStringAsFixed(1)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.orange.shade700,
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildLoyaltyLevelInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.workspace_premium, color: Colors.amber.shade600, size: 24),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'VIP 단골 고객',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '단골 상점에서 추가 혜택을 받으실 수 있습니다',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegularShopCard(Map<String, dynamic> shop) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  // 상점 아이콘
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: shop['color'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(shop['icon'], color: shop['color'], size: 30),
                  ),
                  const SizedBox(width: 16),

                  // 상점 정보
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              shop['name'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: shop['color'].withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                shop['category'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: shop['color'],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 16,
                            ),
                            Text(
                              ' ${shop['rating']}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              '방문 ${shop['visitCount']}회',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // 단골 할인 뱃지
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.shade500,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      '단골할인',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 상세 정보
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '마지막 방문: ${shop['lastVisit']}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Text(
                          '총 구매: ${_formatPrice(shop['totalSpent'])}원',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.local_offer,
                          color: Colors.orange.shade600,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          shop['discount'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.orange.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // 액션 버튼들
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _showShopDetails(shop);
                      },
                      icon: const Icon(Icons.info_outline, size: 16),
                      label: const Text('상점 정보'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.orange,
                        side: BorderSide(color: Colors.orange.shade300),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _visitShop(shop);
                      },
                      icon: const Icon(Icons.store, size: 16),
                      label: const Text('방문하기'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showShopDetails(Map<String, dynamic> shop) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(shop['icon'], color: shop['color']),
              const SizedBox(width: 8),
              Text(shop['name']),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('호수: ${shop['location']}'),
              Text('카테고리: ${shop['category']}'),
              Text('취급품목: ${shop['items']}'),
              if (shop['phone'].isNotEmpty) Text('연락처: ${shop['phone']}'),
              const SizedBox(height: 8),
              Text('평점: ${shop['rating']} ⭐'),
              Text('방문 횟수: ${shop['visitCount']}회'),
              Text('마지막 방문: ${shop['lastVisit']}'),
              Text('총 구매 금액: ${_formatPrice(shop['totalSpent'])}원'),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '🎁 ${shop['discount']} 혜택 적용 중',
                  style: TextStyle(
                    color: Colors.orange.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  void _visitShop(Map<String, dynamic> shop) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('상점 방문'),
          content: Text('${shop['name']}으로 이동하시겠습니까?\n\n단골 할인 혜택이 자동으로 적용됩니다.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('취소'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // 여기에 상점 페이지로 이동하는 로직 추가
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${shop['name']}으로 이동합니다!'),
                    backgroundColor: Colors.orange,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              child: const Text('방문하기'),
            ),
          ],
        );
      },
    );
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}
