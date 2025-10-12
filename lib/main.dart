import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/shop_page.dart';
import 'pages/favorite_page.dart';
import 'pages/my_page.dart';
import 'pages/payment_page.dart';
import 'widgets/voice_dialog.dart';

// 앱의 시작점
void main() {
  runApp(const MarketApp());
}

// 앱의 최상위 위젯
class MarketApp extends StatelessWidget {
  const MarketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '시장',
      // DEBUG 배너 제거
      debugShowCheckedModeBanner: false,
      // 앱의 기본 테마 색상 설정
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // 앱이 처음 시작될 때 보여줄 화면
      home: const MainScreen(),
    );
  }
}

// 하단바가 있는 메인 화면
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // 각 탭에 해당하는 페이지들
  final List<Widget> _pages = [
    const HomePage(),
    const ShopPage(),
    const PaymentPage(),
    const MyPage(),
  ];

  // 각 탭의 제목들
  final List<String> _titles = ['원주중앙시장', '상점', '간편결제', '마이페이지'];

  // 음성 버튼 클릭 처리
  void _onVoiceButtonPressed() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const VoiceDialog();
      },
    );
  }

  // 하단 네비게이션 아이템 빌더
  Widget _buildBottomNavItem(IconData icon, String label, int index) {
    final isSelected = _currentIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.orange : Colors.grey,
                size: 22,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.orange : Colors.grey,
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 상단 앱 바
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        actions:
            _currentIndex ==
                0 // 홈 화면일 때만 아이콘 표시
            ? [
                IconButton(
                  icon: const Icon(Icons.notifications_none),
                  onPressed: () {
                    // 알림 버튼 눌렀을 때의 동작
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.person_outline),
                  onPressed: () {
                    // 프로필 버튼 눌렀을 때의 동작
                    setState(() {
                      _currentIndex = 3; // 마이페이지로 이동
                    });
                  },
                ),
              ]
            : null,
      ),
      // 현재 선택된 페이지 표시
      body: _pages[_currentIndex],
      // 중앙 음성 버튼
      floatingActionButton: Container(
        width: 65,
        height: 65,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Colors.orange.shade400, Colors.orange.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: _onVoiceButtonPressed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.mic, color: Colors.white, size: 28),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // 하단 네비게이션 바
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: SizedBox(
          height: 55,
          child: Row(
            children: [
              _buildBottomNavItem(Icons.storefront, '홈', 0),
              _buildBottomNavItem(Icons.shopping_basket, '상점', 1),
              const SizedBox(width: 40), // 중앙 버튼 공간
              _buildBottomNavItem(Icons.payment, '결제', 2),
              _buildBottomNavItem(Icons.account_circle, '마이', 3),
            ],
          ),
        ),
      ),
    );
  }
}
