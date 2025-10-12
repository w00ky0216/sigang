import 'package:flutter/material.dart';
import '../widgets/payment_dialog.dart';
import '../services/payment_service.dart';

/// 간편결제 메인 페이지
class PaymentPage extends StatefulWidget {
  final int? totalAmount; // 장바구니 총 금액 또는 상점 요청 금액
  final String? orderName; // 주문명
  final Map<String, dynamic>? orderDetails; // 주문 상세 정보
  
  const PaymentPage({
    super.key,
    this.totalAmount,
    this.orderName,
    this.orderDetails,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  // 빠른 결제 버튼들 생성
  Widget _buildQuickPaymentButtons() {
    // 결제 수단 목록
    final paymentMethods = [
      {
        'name': '토스페이',
        'service': PaymentService.tossPay,
        'icon': Icons.account_balance_wallet,
        'color': const Color(0xFF0064FF),
        'description': '가장 많이 사용하는 간편결제',
      },
      {
        'name': '카카오페이',
        'service': PaymentService.kakaoPay,
        'icon': Icons.chat_bubble,
        'color': const Color(0xFFFFE812),
        'description': '카카오톡으로 간편하게',
      },
      {
        'name': '네이버페이',
        'service': PaymentService.naverPay,
        'icon': Icons.shopping_bag,
        'color': const Color(0xFF03C75A),
        'description': '네이버 포인트 적립',
      },
      {
        'name': '페이코',
        'service': PaymentService.payco,
        'icon': Icons.payment,
        'color': const Color(0xFFE60012),
        'description': 'NHN 페이코 간편결제',
      },
      {
        'name': '삼성페이',
        'service': PaymentService.samsungPay,
        'icon': Icons.phone_android,
        'color': const Color(0xFF1428A0),
        'description': '삼성 디바이스 전용',
      },
      {
        'name': '신용카드',
        'service': PaymentService.creditCard,
        'icon': Icons.credit_card,
        'color': Colors.grey.shade700,
        'description': '모든 카드사 지원',
      },
    ];

    return Column(
      children: paymentMethods.map((method) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: _buildPaymentMethodCard(
            method['name'] as String,
            method['service'] as PaymentService,
            method['icon'] as IconData,
            method['color'] as Color,
            method['description'] as String,
          ),
        );
      }).toList(),
    );
  }

  // 결제 수단 카드 생성
  Widget _buildPaymentMethodCard(
    String name,
    PaymentService paymentService,
    IconData icon,
    Color color,
    String description,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _processDirectPayment(name, paymentService),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // 결제 서비스 아이콘
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),

              // 결제 수단 정보
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              // 화살표 아이콘
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey.shade400,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 가격 포맷팅
  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  // 에러 다이얼로그 표시
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('알림'),
          content: Text(message),
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

  // 직접 결제 처리 (선택한 결제 수단으로 바로 결제)
  void _processDirectPayment(String paymentMethodName, PaymentService paymentService) async {
    // 결제 금액이 없으면 결제 불가
    if (widget.totalAmount == null || widget.totalAmount! <= 0) {
      _showErrorDialog('결제할 금액이 없습니다.\n상점에서 상품을 선택하거나 결제 요청을 받으세요.');
      return;
    }
    
    final int amount = widget.totalAmount!;
    final PaymentService_ paymentServiceInstance = PaymentService_();
    
    // 로딩 다이얼로그 표시
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: Colors.orange),
                  SizedBox(height: 16),
                  Text('결제 처리 중...'),
                ],
              ),
            ),
          ),
        );
      },
    );

    try {
      // 결제 요청 생성
      final request = PaymentRequest(
        orderId: 'order_${DateTime.now().millisecondsSinceEpoch}',
        orderName: widget.orderName ?? '시장 상품 결제',
        amount: amount,
        customerEmail: 'customer@example.com',
        customerName: '홍길동',
        paymentService: paymentService,
        metadata: {
          'source': 'sigang_app_direct',
          'paymentMethod': paymentMethodName,
          if (widget.orderDetails != null) ...widget.orderDetails!,
        },
      );

      // 결제 처리
      final result = await paymentServiceInstance.requestPayment(request);

      // 로딩 다이얼로그 닫기
      Navigator.of(context).pop();

      // 결과 다이얼로그 표시
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return PaymentResultDialog(result: result);
        },
      );

    } catch (e) {
      // 로딩 다이얼로그 닫기
      Navigator.of(context).pop();
      
      // 에러 다이얼로그 표시
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('결제 오류'),
            content: Text('결제 처리 중 오류가 발생했습니다.\n$e'),
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
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          
          // 간편결제 아이콘 및 제목
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Colors.orange.shade300, Colors.orange.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.payment,
              color: Colors.white,
              size: 50,
            ),
          ),
          const SizedBox(height: 24),

          // 제목
          const Text(
            '간편결제',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          const SizedBox(height: 8),

          // 설명
          Text(
            widget.totalAmount != null 
              ? '원하시는 결제 수단을 선택하여\n빠르고 안전하게 결제하세요'
              : '상점에서 상품을 담거나\n결제 요청을 받으면 결제할 수 있습니다',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: widget.totalAmount != null ? Colors.grey : Colors.orange.shade600,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),

          // 총 결제 금액 표시 (금액이 있을 때만)
          if (widget.totalAmount != null) ...[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Column(
                children: [
                  const Text(
                    '총 결제 금액',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_formatPrice(widget.totalAmount!)}원',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade700,
                    ),
                  ),
                  if (widget.orderName != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      widget.orderName!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],

          // 빠른 결제 버튼들
          _buildQuickPaymentButtons(),
          
          const SizedBox(height: 24),

          // 테스트 결제 안내
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.blue.shade600,
                  size: 20,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    '테스트 결제입니다. 실제 금액이 결제되지 않습니다.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

}