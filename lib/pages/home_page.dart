import 'package:flutter/material.dart';
import 'coupon_page.dart';
import 'market_map_page.dart';
import 'regular_shop_page.dart';
import 'cart_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 네비게이션 함수들
  void _navigateToCouponPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CouponPage()),
    );
  }

  void _navigateToMarketMapPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MarketMapPage()),
    );
  }

  void _navigateToRegularShopPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegularShopPage()),
    );
  }

  void _navigateToCartPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CartPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ListView를 사용하면 내용이 길어져도 자동으로 스크롤이 가능해짐
    return ListView(
      padding: const EdgeInsets.all(16.0), // 전체적으로 여백 주기
      children: [
        // --- 검색창 ---
        _buildSearchBar(),
        const SizedBox(height: 24.0), // 위젯 사이의 간격
        // --- 바로가기 메뉴 ---
        _buildQuickMenu(),
        const SizedBox(height: 24.0),

        // --- 오늘의 추천 상품 ---
        _buildSectionTitle('오늘의 추천 상품'),
        _buildHotDeals(),
        const SizedBox(height: 24.0),

        // --- 시장 새소식 ---
        _buildSectionTitle('시장 새소식'),
        _buildNewsList(),
      ],
    );
  }

  // 검색창 위젯을 만드는 함수
  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: '가게나 상품을 검색해보세요',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }

  // 바로가기 메뉴 위젯을 만드는 함수
  Widget _buildQuickMenu() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround, // 아이콘들을 균등하게 배치
      children: [
        _buildMenuItem(
          Icons.card_giftcard,
          '쿠폰함',
          () => _navigateToCouponPage(),
        ),
        _buildMenuItem(
          Icons.location_on,
          '시장 지도',
          () => _navigateToMarketMapPage(),
        ),
        _buildMenuItem(
          Icons.store,
          '단골 상점',
          () => _navigateToRegularShopPage(),
        ),
        _buildMenuItem(Icons.shopping_bag, '장바구니', () => _navigateToCartPage()),
      ],
    );
  }

  // 메뉴 아이템 하나를 만드는 함수
  Widget _buildMenuItem(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.orange.shade100,
            child: Icon(icon, color: Colors.orange.shade600, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  // 각 섹션의 제목 위젯을 만드는 함수
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  // 추천 상품 목록(가로 스크롤) 위젯을 만드는 함수
  Widget _buildHotDeals() {
    return SizedBox(
      height: 200, // 가로 스크롤 목록의 높이 지정
      child: ListView(
        scrollDirection: Axis.horizontal, // 가로로 스크롤되도록 설정
        children: [
          _buildDealItem('assets/beef.jpg', '한우 등심', '45000'),
          _buildDealItem('assets/seaweed.jpg', '김 선물세트', '15000'),
          _buildDealItem('assets/ricecake.jpg', '백설기', '12000'),
          _buildDealItem('assets/tteokbokki.jpg', '떡볶이 세트', '8000'),
          // 간편결제 안내 카드
          _buildPaymentGuideCard(),
        ],
      ),
    );
  }

  // 추천 상품 아이템 하나를 만드는 함수
  Widget _buildDealItem(String imagePath, String name, String price) {
    return SizedBox(
      width: 150,
      child: Card(
        clipBehavior: Clip.antiAlias, // 카드의 경계를 넘어가는 이미지를 잘라줌
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 이미지는 현재 없으므로 회색 박스로 대체
            Container(
              height: 120,
              color: Colors.grey[300],
              alignment: Alignment.center,
              child: const Icon(Icons.image, size: 50, color: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('${_formatPrice(price)}원'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 가격 포맷팅 (1000 -> 1,000)
  String _formatPrice(String priceString) {
    final price = int.tryParse(priceString) ?? 0;
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  // 간편결제 안내 카드
  Widget _buildPaymentGuideCard() {
    return SizedBox(
      width: 150,
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: Colors.orange.shade50,
        child: InkWell(
          onTap: () {
            // 간편결제 탭으로 이동하는 안내
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Row(
                    children: [
                      Icon(Icons.payment, color: Colors.orange.shade600),
                      const SizedBox(width: 8),
                      const Text('간편결제'),
                    ],
                  ),
                  content: const Text(
                    '하단의 "결제" 탭에서\n여러 상품을 선택해서\n한번에 결제할 수 있어요!',
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
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 120,
                color: Colors.orange.shade100,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.payment,
                      size: 40,
                      color: Colors.orange.shade600,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '간편결제',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '한번에 여러 상품',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '빠른 결제 →',
                      style: TextStyle(
                        color: Colors.orange.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 시장 새소식 목록 위젯을 만드는 함수
  Widget _buildNewsList() {
    return Column(
      children: [
        _buildNewsItem('시장 어플 출시', '2025.10.13'),
        _buildNewsItem('온누리상품권 사용처 확대 안내', '2025.10.10'),
        _buildNewsItem('추석 맞이 감사 대잔치', '2025.10.03'),
      ],
    );
  }

  // 새소식 아이템 하나를 만드는 함수
  Widget _buildNewsItem(String title, String date) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        leading: const Icon(Icons.campaign, color: Colors.orange),
        title: Text(title),
        subtitle: Text(date),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
      ),
    );
  }
}
