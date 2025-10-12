import 'package:flutter/material.dart';

/// 간편결제 서비스 타입
enum PaymentService {
  tossPay('토스페이', 'assets/icons/toss_pay.png', Color(0xFF0064FF)),
  kakaoPay('카카오페이', 'assets/icons/kakao_pay.png', Color(0xFFFFE812)),
  naverPay('네이버페이', 'assets/icons/naver_pay.png', Color(0xFF03C75A)),
  payco('페이코', 'assets/icons/payco.png', Color(0xFFE60012)),
  samsungPay('삼성페이', 'assets/icons/samsung_pay.png', Color(0xFF1428A0)),
  applePay('애플페이', 'assets/icons/apple_pay.png', Color(0xFF000000)),
  googlePay('구글페이', 'assets/icons/google_pay.png', Color(0xFF4285F4)),
  creditCard('신용카드', 'assets/icons/credit_card.png', Color(0xFF6B7280));

  const PaymentService(this.displayName, this.iconPath, this.brandColor);

  final String displayName;
  final String iconPath;
  final Color brandColor;
}

/// 결제 요청 정보
class PaymentRequest {
  final String orderId;          // 주문 ID
  final String orderName;        // 주문명
  final int amount;              // 결제 금액
  final String customerEmail;    // 고객 이메일
  final String customerName;     // 고객 이름
  final PaymentService paymentService; // 결제 서비스
  final Map<String, dynamic>? metadata; // 추가 메타데이터

  PaymentRequest({
    required this.orderId,
    required this.orderName,
    required this.amount,
    required this.customerEmail,
    required this.customerName,
    required this.paymentService,
    this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'orderName': orderName,
      'amount': amount,
      'customerEmail': customerEmail,
      'customerName': customerName,
      'paymentService': paymentService.name,
      'metadata': metadata,
    };
  }
}

/// 결제 결과
class PaymentResult {
  final bool isSuccess;
  final String? paymentKey;      // 결제 키
  final String? transactionId;   // 거래 ID
  final String? errorMessage;    // 에러 메시지
  final Map<String, dynamic>? data; // 추가 결과 데이터

  PaymentResult({
    required this.isSuccess,
    this.paymentKey,
    this.transactionId,
    this.errorMessage,
    this.data,
  });

  factory PaymentResult.success({
    required String paymentKey,
    required String transactionId,
    Map<String, dynamic>? data,
  }) {
    return PaymentResult(
      isSuccess: true,
      paymentKey: paymentKey,
      transactionId: transactionId,
      data: data,
    );
  }

  factory PaymentResult.failure({
    required String errorMessage,
    Map<String, dynamic>? data,
  }) {
    return PaymentResult(
      isSuccess: false,
      errorMessage: errorMessage,
      data: data,
    );
  }
}

/// 간편결제 서비스 메인 클래스
class PaymentService_ {
  static final PaymentService_ _instance = PaymentService_._internal();
  factory PaymentService_() => _instance;
  PaymentService_._internal();

  // 개발용 API 키들 (실제 배포시에는 환경변수나 보안 저장소 사용)
  final Map<PaymentService, String> _apiKeys = {
    PaymentService.tossPay: 'test_ck_D5GePWvyOeEERO5l2deEgX9POLqK', // 토스페이 테스트 키
    PaymentService.kakaoPay: 'kakaopay_test_key',
    PaymentService.naverPay: 'naverpay_test_key',
    // 다른 결제 서비스들도 추가...
  };

  /// 결제 요청
  Future<PaymentResult> requestPayment(PaymentRequest request) async {
    try {
      debugPrint('결제 요청 시작: ${request.paymentService.displayName}');
      debugPrint('주문 정보: ${request.toJson()}');

      // 실제 API 호출 전 시뮬레이션
      await Future.delayed(const Duration(seconds: 2));

      // 각 결제 서비스별 처리
      switch (request.paymentService) {
        case PaymentService.tossPay:
          return await _processTossPayment(request);
        case PaymentService.kakaoPay:
          return await _processKakaoPayment(request);
        case PaymentService.naverPay:
          return await _processNaverPayment(request);
        case PaymentService.payco:
          return await _processPaycoPayment(request);
        case PaymentService.samsungPay:
          return await _processSamsungPayment(request);
        case PaymentService.applePay:
          return await _processApplePayment(request);
        case PaymentService.googlePay:
          return await _processGooglePayment(request);
        case PaymentService.creditCard:
          return await _processCreditCardPayment(request);
      }
    } catch (e) {
      return PaymentResult.failure(
        errorMessage: '결제 처리 중 오류가 발생했습니다: $e',
      );
    }
  }

  /// 토스페이 결제 처리
  Future<PaymentResult> _processTossPayment(PaymentRequest request) async {
    // TODO: 실제 토스페이 API 연동
    // 토스페이 SDK나 API 호출
    
    // 시뮬레이션
    final random = DateTime.now().millisecondsSinceEpoch % 10;
    if (random < 8) { // 80% 성공률
      return PaymentResult.success(
        paymentKey: 'toss_${DateTime.now().millisecondsSinceEpoch}',
        transactionId: 'tx_toss_${request.orderId}',
        data: {
          'method': 'toss_pay',
          'approvedAt': DateTime.now().toIso8601String(),
        },
      );
    } else {
      return PaymentResult.failure(
        errorMessage: '토스페이 결제가 취소되었습니다.',
      );
    }
  }

  /// 카카오페이 결제 처리
  Future<PaymentResult> _processKakaoPayment(PaymentRequest request) async {
    // TODO: 실제 카카오페이 API 연동
    
    final random = DateTime.now().millisecondsSinceEpoch % 10;
    if (random < 8) {
      return PaymentResult.success(
        paymentKey: 'kakao_${DateTime.now().millisecondsSinceEpoch}',
        transactionId: 'tx_kakao_${request.orderId}',
        data: {
          'method': 'kakao_pay',
          'approvedAt': DateTime.now().toIso8601String(),
        },
      );
    } else {
      return PaymentResult.failure(
        errorMessage: '카카오페이 결제가 실패했습니다.',
      );
    }
  }

  /// 네이버페이 결제 처리
  Future<PaymentResult> _processNaverPayment(PaymentRequest request) async {
    // TODO: 실제 네이버페이 API 연동
    
    final random = DateTime.now().millisecondsSinceEpoch % 10;
    if (random < 8) {
      return PaymentResult.success(
        paymentKey: 'naver_${DateTime.now().millisecondsSinceEpoch}',
        transactionId: 'tx_naver_${request.orderId}',
      );
    } else {
      return PaymentResult.failure(
        errorMessage: '네이버페이 결제가 실패했습니다.',
      );
    }
  }

  /// 페이코 결제 처리
  Future<PaymentResult> _processPaycoPayment(PaymentRequest request) async {
    // TODO: 실제 페이코 API 연동
    return PaymentResult.success(
      paymentKey: 'payco_${DateTime.now().millisecondsSinceEpoch}',
      transactionId: 'tx_payco_${request.orderId}',
    );
  }

  /// 삼성페이 결제 처리
  Future<PaymentResult> _processSamsungPayment(PaymentRequest request) async {
    // TODO: 실제 삼성페이 API 연동
    return PaymentResult.success(
      paymentKey: 'samsung_${DateTime.now().millisecondsSinceEpoch}',
      transactionId: 'tx_samsung_${request.orderId}',
    );
  }

  /// 애플페이 결제 처리
  Future<PaymentResult> _processApplePayment(PaymentRequest request) async {
    // TODO: 실제 애플페이 API 연동
    return PaymentResult.success(
      paymentKey: 'apple_${DateTime.now().millisecondsSinceEpoch}',
      transactionId: 'tx_apple_${request.orderId}',
    );
  }

  /// 구글페이 결제 처리
  Future<PaymentResult> _processGooglePayment(PaymentRequest request) async {
    // TODO: 실제 구글페이 API 연동
    return PaymentResult.success(
      paymentKey: 'google_${DateTime.now().millisecondsSinceEpoch}',
      transactionId: 'tx_google_${request.orderId}',
    );
  }

  /// 신용카드 결제 처리
  Future<PaymentResult> _processCreditCardPayment(PaymentRequest request) async {
    // TODO: 실제 신용카드 결제 API 연동
    return PaymentResult.success(
      paymentKey: 'card_${DateTime.now().millisecondsSinceEpoch}',
      transactionId: 'tx_card_${request.orderId}',
    );
  }

  /// 결제 취소
  Future<bool> cancelPayment(String paymentKey, String reason) async {
    try {
      debugPrint('결제 취소 요청: $paymentKey, 사유: $reason');
      
      // TODO: 실제 결제 취소 API 호출
      await Future.delayed(const Duration(seconds: 1));
      
      return true;
    } catch (e) {
      debugPrint('결제 취소 실패: $e');
      return false;
    }
  }

  /// 결제 내역 조회
  Future<Map<String, dynamic>?> getPaymentDetails(String paymentKey) async {
    try {
      // TODO: 실제 결제 내역 조회 API 호출
      await Future.delayed(const Duration(milliseconds: 500));
      
      return {
        'paymentKey': paymentKey,
        'status': 'DONE',
        'amount': 15000,
        'approvedAt': DateTime.now().subtract(const Duration(hours: 1)).toIso8601String(),
      };
    } catch (e) {
      debugPrint('결제 내역 조회 실패: $e');
      return null;
    }
  }
}