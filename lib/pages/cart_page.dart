import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // 장바구니 아이템 데이터
  final List<Map<String, dynamic>> cartItems = [
    {
      'id': 1,
      'name': '한우 등심',
      'shopName': '형제정육점',
      'price': 45000,
      'quantity': 1,
      'unit': 'kg',
      'category': '축산물',
      'color': Colors.red,
      'icon': Icons.lunch_dining,
      'isSelected': true,
    },
    {
      'id': 2,
      'name': '김 선물세트',
      'shopName': '금천김',
      'price': 15000,
      'quantity': 2,
      'unit': '세트',
      'category': '수산/건어물',
      'color': Colors.blue,
      'icon': Icons.set_meal,
      'isSelected': true,
    },
    {
      'id': 3,
      'name': '백설기',
      'shopName': '유성떡집',
      'price': 12000,
      'quantity': 1,
      'unit': '판',
      'category': '떡/베이커리',
      'color': Colors.brown,
      'icon': Icons.cake,
      'isSelected': false,
    },
    {
      'id': 4,
      'name': '떡볶이 세트',
      'shopName': '부부분식',
      'price': 8000,
      'quantity': 2,
      'unit': '인분',
      'category': '반찬/부식',
      'color': Colors.orange,
      'icon': Icons.restaurant,
      'isSelected': true,
    },
  ];

  bool get isAllSelected {
    return cartItems.every((item) => item['isSelected']);
  }

  int get selectedItemsCount {
    return cartItems.where((item) => item['isSelected']).length;
  }

  int get totalPrice {
    return cartItems
        .where((item) => item['isSelected'])
        .fold(
          0,
          (sum, item) => sum + (item['price'] * item['quantity']) as int,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('장바구니'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: _clearCart,
            child: const Text('전체삭제', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: cartItems.isEmpty
          ? _buildEmptyCart()
          : Column(
              children: [
                // 전체 선택 체크박스
                _buildSelectAllHeader(),

                // 장바구니 아이템 목록
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      return _buildCartItem(cartItems[index], index);
                    },
                  ),
                ),

                // 하단 주문 정보 및 결제 버튼
                _buildBottomOrderInfo(),
              ],
            ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            '장바구니가 비어있습니다',
            style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Text(
            '상점에서 상품을 담아보세요!',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // 상점 탭으로 이동
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.store),
            label: const Text('상점 둘러보기'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectAllHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Checkbox(
            value: isAllSelected,
            onChanged: (value) {
              setState(() {
                for (var item in cartItems) {
                  item['isSelected'] = value ?? false;
                }
              });
            },
            activeColor: Colors.orange,
          ),
          const Text(
            '전체선택',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const Spacer(),
          Text(
            '선택 $selectedItemsCount/${cartItems.length}개',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(Map<String, dynamic> item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // 선택 체크박스
              Checkbox(
                value: item['isSelected'],
                onChanged: (value) {
                  setState(() {
                    item['isSelected'] = value ?? false;
                  });
                },
                activeColor: Colors.orange,
              ),

              // 상품 아이콘
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: item['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(item['icon'], color: item['color'], size: 24),
              ),
              const SizedBox(width: 12),

              // 상품 정보
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['name'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(
                          Icons.store,
                          size: 14,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          item['shopName'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_formatPrice(item['price'])}원/${item['unit']}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.orange.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // 수량 조절 및 삭제
              Column(
                children: [
                  // 수량 조절
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (item['quantity'] > 1) {
                              item['quantity']--;
                            }
                          });
                        },
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Icon(Icons.remove, size: 16),
                        ),
                      ),
                      Container(
                        width: 40,
                        alignment: Alignment.center,
                        child: Text(
                          '${item['quantity']}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            item['quantity']++;
                          });
                        },
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Icon(Icons.add, size: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // 삭제 버튼
                  InkWell(
                    onTap: () {
                      _removeItem(index);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        Icons.delete_outline,
                        size: 20,
                        color: Colors.grey.shade600,
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

  Widget _buildBottomOrderInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          // 주문 요약 정보
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('선택 상품', style: TextStyle(fontSize: 16)),
              Text(
                '$selectedItemsCount개',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '총 결제 금액',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '${_formatPrice(totalPrice)}원',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 주문하기 버튼
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: selectedItemsCount > 0 ? _proceedToPayment : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                selectedItemsCount > 0
                    ? '${_formatPrice(totalPrice)}원 주문하기'
                    : '상품을 선택해주세요',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _removeItem(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('상품 삭제'),
          content: Text('${cartItems[index]['name']}을(를) 장바구니에서 삭제하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  cartItems.removeAt(index);
                });
                Navigator.of(context).pop();
              },
              child: const Text('삭제', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _clearCart() {
    if (cartItems.isEmpty) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('장바구니 비우기'),
          content: const Text('장바구니의 모든 상품을 삭제하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  cartItems.clear();
                });
                Navigator.of(context).pop();
              },
              child: const Text('전체삭제', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _proceedToPayment() {
    final selectedItems = cartItems
        .where((item) => item['isSelected'])
        .toList();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.payment, color: Colors.orange.shade600),
              const SizedBox(width: 8),
              const Text('결제하기'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('선택 상품: ${selectedItems.length}개'),
              Text('총 금액: ${_formatPrice(totalPrice)}원'),
              const SizedBox(height: 12),
              const Text(
                '간편결제 페이지로 이동하여 결제를 진행하시겠습니까?',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('취소'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // 결제 페이지로 이동하는 로직
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('간편결제 페이지로 이동합니다!'),
                    backgroundColor: Colors.orange,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              child: const Text('결제하기'),
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
