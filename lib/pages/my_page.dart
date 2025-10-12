import 'package:flutter/material.dart';
import 'payment_history_page.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // 프로필 섹션
        _buildProfileSection(),
        const SizedBox(height: 24),
        
        // 메뉴 섹션
        _buildMenuSection(),
      ],
    );
  }

  Widget _buildProfileSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.orange.shade100,
              child: Icon(
                Icons.person,
                size: 35,
                color: Colors.orange.shade700,
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '홍길동',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'hong@example.com',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // 프로필 편집
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection() {
    return Column(
      children: [
        _buildMenuGroup('내 활동', [
          _buildMenuItem(Icons.receipt_long, '주문 내역', () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const PaymentHistoryPage(),
              ),
            );
          }),
          _buildMenuItem(Icons.bookmark, '찜한 상품', () {}),
          _buildMenuItem(Icons.rate_review, '내 리뷰', () {}),
          _buildMenuItem(Icons.card_giftcard, '쿠폰함', () {}),
        ]),
        const SizedBox(height: 16),
        
        _buildMenuGroup('설정', [
          _buildMenuItem(Icons.notifications, '알림 설정', () {}),
          _buildMenuItem(Icons.location_on, '위치 설정', () {}),
          _buildMenuItem(Icons.language, '언어 설정', () {}),
        ]),
        const SizedBox(height: 16),
        
        _buildMenuGroup('고객 지원', [
          _buildMenuItem(Icons.help_outline, '도움말', () {}),
          _buildMenuItem(Icons.headset_mic, '문의하기', () {}),
          _buildMenuItem(Icons.info_outline, '앱 정보', () {}),
        ]),
        const SizedBox(height: 24),
        
        // 로그아웃 버튼
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              // 로그아웃
              _showLogoutDialog(null);
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text('로그아웃'),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuGroup(String title, List<Widget> items) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(height: 1),
          ...items,
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey.shade600),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
      onTap: onTap,
    );
  }

  void _showLogoutDialog(BuildContext? context) {
    if (context == null) return;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('로그아웃'),
          content: const Text('정말 로그아웃 하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // 로그아웃 처리
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }
}