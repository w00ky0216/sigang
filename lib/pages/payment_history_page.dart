import 'package:flutter/material.dart';
import '../services/payment_service.dart';

/// 결제 내역 페이지
class PaymentHistoryPage extends StatefulWidget {
  const PaymentHistoryPage({super.key});

  @override
  State<PaymentHistoryPage> createState() => _PaymentHistoryPageState();
}

class _PaymentHistoryPageState extends State<PaymentHistoryPage> {
  final PaymentService_ _paymentService = PaymentService_();
  List<Map<String, dynamic>> _paymentHistory = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPaymentHistory();
  }

  Future<void> _loadPaymentHistory() async {
    setState(() {
      _isLoading = true;
    });

    // 실제로는 서버에서 결제 내역을 가져오지만, 
    // 여기서는 시뮬레이션 데이터를 사용
    await Future.delayed(const Duration(seconds: 1));
    
    setState(() {
      _paymentHistory = [
        {
          'orderId': 'order_1234567890',
          'orderName': '사과 1봉',
          'amount': 5000,
          'paymentMethod': '토스페이',
          'status': 'DONE',
          'approvedAt': '2025-10-12 14:30:00',
          'paymentKey': 'toss_1234567890',
        },
        {
          'orderId': 'order_1234567889',
          'orderName': '고등어 1손',
          'amount': 8000,
          'paymentMethod': '카카오페이',
          'status': 'DONE',
          'approvedAt': '2025-10-11 16:15:00',
          'paymentKey': 'kakao_1234567889',
        },
        {
          'orderId': 'order_1234567888',
          'orderName': '유기농 채소',
          'amount': 3500,
          'paymentMethod': '네이버페이',
          'status': 'CANCELLED',
          'approvedAt': '2025-10-10 10:20:00',
          'paymentKey': 'naver_1234567888',
        },
        {
          'orderId': 'order_1234567887',
          'orderName': '꿀 백설기',
          'amount': 2000,
          'paymentMethod': '토스페이',
          'status': 'DONE',
          'approvedAt': '2025-10-09 13:45:00',
          'paymentKey': 'toss_1234567887',
        },
      ];
      _isLoading = false;
    });
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'DONE':
        return Colors.green;
      case 'CANCELLED':
        return Colors.red;
      case 'PENDING':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'DONE':
        return '결제완료';
      case 'CANCELLED':
        return '결제취소';
      case 'PENDING':
        return '결제대기';
      default:
        return '알 수 없음';
    }
  }

  IconData _getPaymentMethodIcon(String method) {
    switch (method) {
      case '토스페이':
        return Icons.account_balance_wallet;
      case '카카오페이':
        return Icons.chat_bubble;
      case '네이버페이':
        return Icons.shopping_bag;
      case '페이코':
        return Icons.payment;
      default:
        return Icons.credit_card;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('결제 내역'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.orange,
              ),
            )
          : _paymentHistory.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: _loadPaymentHistory,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _paymentHistory.length,
                    itemBuilder: (context, index) {
                      final payment = _paymentHistory[index];
                      return _buildPaymentItem(payment);
                    },
                  ),
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            '결제 내역이 없습니다',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '상품을 구매하면 여기에 표시됩니다',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentItem(Map<String, dynamic> payment) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단: 상품명과 상태
            Row(
              children: [
                Expanded(
                  child: Text(
                    payment['orderName'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(payment['status']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getStatusText(payment['status']),
                    style: TextStyle(
                      fontSize: 12,
                      color: _getStatusColor(payment['status']),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 중간: 결제 정보
            Row(
              children: [
                Icon(
                  _getPaymentMethodIcon(payment['paymentMethod']),
                  size: 20,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 8),
                Text(
                  payment['paymentMethod'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const Spacer(),
                Text(
                  '${_formatPrice(payment['amount'])}원',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // 하단: 결제 시간과 주문번호
            Row(
              children: [
                Text(
                  payment['approvedAt'],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
                const Spacer(),
                Text(
                  '주문번호: ${payment['orderId']}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),

            // 버튼들 (취소가 가능한 경우)
            if (payment['status'] == 'DONE') ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _showPaymentDetails(payment),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.orange,
                        side: const BorderSide(color: Colors.orange),
                      ),
                      child: const Text('상세보기'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _requestRefund(payment),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                      ),
                      child: const Text('환불요청'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showPaymentDetails(Map<String, dynamic> payment) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('결제 상세 정보'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('상품명', payment['orderName']),
              _buildDetailRow('결제금액', '${_formatPrice(payment['amount'])}원'),
              _buildDetailRow('결제수단', payment['paymentMethod']),
              _buildDetailRow('결제상태', _getStatusText(payment['status'])),
              _buildDetailRow('결제시간', payment['approvedAt']),
              _buildDetailRow('주문번호', payment['orderId']),
              _buildDetailRow('결제키', payment['paymentKey']),
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  void _requestRefund(Map<String, dynamic> payment) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('환불 요청'),
          content: Text('${payment['orderName']} 상품의 결제를 취소하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                
                // 환불 처리
                final success = await _paymentService.cancelPayment(
                  payment['paymentKey'],
                  '고객 요청',
                );

                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('환불 요청이 완료되었습니다.')),
                  );
                  _loadPaymentHistory(); // 목록 새로고침
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('환불 요청에 실패했습니다.')),
                  );
                }
              },
              child: const Text('환불 요청'),
            ),
          ],
        );
      },
    );
  }
}