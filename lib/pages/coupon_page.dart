import 'package:flutter/material.dart';

class CouponPage extends StatefulWidget {
  const CouponPage({super.key});

  @override
  State<CouponPage> createState() => _CouponPageState();
}

class _CouponPageState extends State<CouponPage> {
  // 쿠폰 데이터
  final List<Map<String, dynamic>> coupons = [
    {
      'title': '신선과일 10% 할인',
      'description': '모든 과일 상품 10% 할인',
      'discount': '10%',
      'validUntil': '2025.10.31',
      'minAmount': 10000,
      'isUsed': false,
      'color': Colors.green,
    },
    {
      'title': '수산물 5,000원 할인',
      'description': '신선한 수산물 구매시 5,000원 할인',
      'discount': '5,000원',
      'validUntil': '2025.10.25',
      'minAmount': 20000,
      'isUsed': false,
      'color': Colors.blue,
    },
    {
      'title': '정육점 15% 할인',
      'description': '1등급 한우 및 돼지고기 15% 할인',
      'discount': '15%',
      'validUntil': '2025.10.20',
      'minAmount': 15000,
      'isUsed': true,
      'color': Colors.red,
    },
    {
      'title': '반찬가게 3,000원 할인',
      'description': '집밑반찬 구매시 3,000원 할인',
      'discount': '3,000원',
      'validUntil': '2025.11.05',
      'minAmount': 8000,
      'isUsed': false,
      'color': Colors.orange,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('쿠폰함'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // 쿠폰 개수 정보
          _buildCouponSummary(),
          const SizedBox(height: 20),
          
          // 쿠폰 목록
          ...coupons.map((coupon) => _buildCouponCard(coupon)).toList(),
        ],
      ),
    );
  }

  Widget _buildCouponSummary() {
    final usableCoupons = coupons.where((c) => !c['isUsed']).length;
    final usedCoupons = coupons.where((c) => c['isUsed']).length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text(
                '$usableCoupons',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade700,
                ),
              ),
              const Text('사용 가능', style: TextStyle(color: Colors.grey)),
            ],
          ),
          Container(
            height: 40,
            width: 1,
            color: Colors.grey.shade300,
          ),
          Column(
            children: [
              Text(
                '$usedCoupons',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const Text('사용 완료', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCouponCard(Map<String, dynamic> coupon) {
    final isUsed = coupon['isUsed'] as bool;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: isUsed 
              ? null 
              : LinearGradient(
                  colors: [
                    coupon['color'].withOpacity(0.1),
                    coupon['color'].withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // 할인 금액/비율
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: isUsed 
                      ? Colors.grey.shade300 
                      : coupon['color'].withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        coupon['discount'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isUsed ? Colors.grey : coupon['color'],
                        ),
                      ),
                      Text(
                        '할인',
                        style: TextStyle(
                          fontSize: 12,
                          color: isUsed ? Colors.grey : coupon['color'],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                
                // 쿠폰 정보
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        coupon['title'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isUsed ? Colors.grey : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        coupon['description'],
                        style: TextStyle(
                          fontSize: 14,
                          color: isUsed ? Colors.grey : Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.schedule,
                                size: 14,
                                color: isUsed ? Colors.grey : Colors.grey.shade600,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${coupon['validUntil']}까지',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isUsed ? Colors.grey : Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.shopping_cart,
                                size: 14,
                                color: isUsed ? Colors.grey : Colors.grey.shade600,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${_formatPrice(coupon['minAmount'])}원 이상',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isUsed ? Colors.grey : Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // 사용 상태
                if (isUsed)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      '사용완료',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: coupon['color'],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      '사용가능',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}