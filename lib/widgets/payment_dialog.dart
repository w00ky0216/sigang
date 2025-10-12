import 'package:flutter/material.dart';
import '../services/payment_service.dart';

/// 간편결제 선택 다이얼로그
class PaymentDialog extends StatefulWidget {
  final String orderName;
  final int amount;
  final Function(PaymentResult) onPaymentComplete;

  const PaymentDialog({
    required this.orderName,
    required this.amount,
    required this.onPaymentComplete,
    super.key,
  });

  @override
  State<PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  final PaymentService_ _paymentService = PaymentService_();
  PaymentService? _selectedPaymentMethod;
  bool _isProcessing = false;

  // 주요 결제 서비스들
  final List<PaymentService> _popularPayments = [
    PaymentService.tossPay,
    PaymentService.kakaoPay,
    PaymentService.naverPay,
    PaymentService.payco,
  ];

  // 기타 결제 서비스들
  final List<PaymentService> _otherPayments = [
    PaymentService.samsungPay,
    PaymentService.applePay,
    PaymentService.googlePay,
    PaymentService.creditCard,
  ];

  String get _formattedAmount {
    return '${widget.amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    )}원';
  }

  void _processPayment() async {
    if (_selectedPaymentMethod == null) {
      _showSnackBar('결제 수단을 선택해주세요.');
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final request = PaymentRequest(
        orderId: 'order_${DateTime.now().millisecondsSinceEpoch}',
        orderName: widget.orderName,
        amount: widget.amount,
        customerEmail: 'customer@example.com', // 실제로는 로그인 정보에서 가져옴
        customerName: '홍길동', // 실제로는 로그인 정보에서 가져옴
        paymentService: _selectedPaymentMethod!,
        metadata: {
          'source': 'sigang_app',
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      final result = await _paymentService.requestPayment(request);
      
      setState(() {
        _isProcessing = false;
      });

      Navigator.of(context).pop();
      widget.onPaymentComplete(result);

    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      _showSnackBar('결제 처리 중 오류가 발생했습니다.');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 헤더
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.payment,
                        color: Colors.orange,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        '결제 수단 선택',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                        iconSize: 20,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        widget.orderName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _formattedAmount,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 결제 수단 목록
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 인기 결제 수단
                    const Text(
                      '인기 결제 수단',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...(_popularPayments.map((payment) => 
                      _buildPaymentOption(payment))),
                    
                    const SizedBox(height: 20),
                    
                    // 기타 결제 수단
                    const Text(
                      '기타 결제 수단',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...(_otherPayments.map((payment) => 
                      _buildPaymentOption(payment))),
                  ],
                ),
              ),
            ),

            // 하단 버튼
            Container(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isProcessing ? null : _processPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isProcessing
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text('결제 처리 중...'),
                          ],
                        )
                      : Text(
                          '${_formattedAmount} 결제하기',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(PaymentService payment) {
    final isSelected = _selectedPaymentMethod == payment;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedPaymentMethod = payment;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Colors.orange : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
            color: isSelected ? Colors.orange.shade50 : Colors.white,
          ),
          child: Row(
            children: [
              // 결제 서비스 아이콘 (실제로는 이미지 사용)
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: payment.brandColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getPaymentIcon(payment),
                  color: payment.brandColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              
              // 결제 서비스 이름
              Expanded(
                child: Text(
                  payment.displayName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.orange.shade700 : Colors.black87,
                  ),
                ),
              ),
              
              // 선택 표시
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: Colors.orange.shade600,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getPaymentIcon(PaymentService payment) {
    switch (payment) {
      case PaymentService.tossPay:
        return Icons.account_balance_wallet;
      case PaymentService.kakaoPay:
        return Icons.chat_bubble;
      case PaymentService.naverPay:
        return Icons.shopping_bag;
      case PaymentService.payco:
        return Icons.payment;
      case PaymentService.samsungPay:
        return Icons.phone_android;
      case PaymentService.applePay:
        return Icons.phone_iphone;
      case PaymentService.googlePay:
        return Icons.account_balance_wallet_outlined;
      case PaymentService.creditCard:
        return Icons.credit_card;
    }
  }
}

/// 결제 결과 다이얼로그
class PaymentResultDialog extends StatelessWidget {
  final PaymentResult result;

  const PaymentResultDialog({
    required this.result,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 결과 아이콘
          Icon(
            result.isSuccess ? Icons.check_circle : Icons.error,
            color: result.isSuccess ? Colors.green : Colors.red,
            size: 64,
          ),
          const SizedBox(height: 16),
          
          // 결과 제목
          Text(
            result.isSuccess ? '결제 완료' : '결제 실패',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: result.isSuccess ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(height: 12),
          
          // 결과 메시지
          Text(
            result.isSuccess 
                ? '결제가 성공적으로 완료되었습니다!'
                : result.errorMessage ?? '결제 중 오류가 발생했습니다.',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14),
          ),
          
          // 거래 정보 (성공시)
          if (result.isSuccess && result.transactionId != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '거래 ID: ${result.transactionId}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  if (result.data?['approvedAt'] != null)
                    Text(
                      '승인 시간: ${result.data!['approvedAt']}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('확인'),
        ),
      ],
    );
  }
}