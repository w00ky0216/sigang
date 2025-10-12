import 'package:flutter/material.dart';

/// 음성 인식 및 AI 응답을 처리하는 서비스
class VoiceService {
  static final VoiceService _instance = VoiceService._internal();
  factory VoiceService() => _instance;
  VoiceService._internal();

  // 음성 인식 상태
  bool _isListening = false;
  bool get isListening => _isListening;

  // 음성 인식 결과 콜백
  Function(String)? _onSpeechResult;
  Function(String)? _onError;

  /// 음성 인식 시작
  Future<void> startListening({
    Function(String)? onResult,
    Function(String)? onError,
  }) async {
    _onSpeechResult = onResult;
    _onError = onError;
    
    try {
      _isListening = true;
      
      // TODO: 실제 음성 인식 라이브러리 연동
      // 예: speech_to_text 패키지 사용
      // await _speechToText.listen(onResult: _handleSpeechResult);
      
      // 임시 시뮬레이션 (3초 후 결과 반환)
      await Future.delayed(const Duration(seconds: 3));
      _handleSpeechResult("사과를 찾고 있어요");
      
    } catch (e) {
      _isListening = false;
      _onError?.call("음성 인식 중 오류가 발생했습니다: $e");
    }
  }

  /// 음성 인식 중지
  Future<void> stopListening() async {
    _isListening = false;
    // TODO: 실제 음성 인식 중지
    // await _speechToText.stop();
  }

  /// 음성 인식 결과 처리
  void _handleSpeechResult(String recognizedWords) {
    _isListening = false;
    _onSpeechResult?.call(recognizedWords);
    
    // AI 응답 처리
    _processAIResponse(recognizedWords);
  }

  /// AI 응답 처리
  void _processAIResponse(String userInput) {
    // TODO: AI API 호출 (예: OpenAI, Google AI 등)
    // 현재는 간단한 키워드 매칭으로 시뮬레이션
    
    String response = _generateMockResponse(userInput);
    debugPrint("AI 응답: $response");
  }

  /// 목업 AI 응답 생성
  String _generateMockResponse(String userInput) {
    final input = userInput.toLowerCase();
    
    if (input.contains('사과') || input.contains('과일')) {
      return "김씨네 과일가게에서 신선한 사과를 판매하고 있어요! 1봉에 5,000원입니다.";
    } else if (input.contains('생선') || input.contains('회') || input.contains('고등어')) {
      return "바다횟집에서 싱싱한 생선을 만나보세요! 고등어 1손에 8,000원입니다.";
    } else if (input.contains('떡') || input.contains('백설기')) {
      return "할머니 떡집의 꿀 백설기는 어떠세요? 2,000원에 맛있는 전통 떡을 드실 수 있습니다.";
    } else if (input.contains('추천') || input.contains('뭐가') || input.contains('좋은')) {
      return "오늘의 추천 상품은 신선한 사과, 고등어, 유기농 채소입니다! 어떤 것이 궁금하시나요?";
    } else {
      return "죄송해요, 다시 한 번 말씀해 주시겠어요? 상품명이나 가게 이름을 말씀해 주시면 더 정확한 정보를 드릴 수 있습니다.";
    }
  }

  /// 음성 합성 (TTS)
  Future<void> speak(String text) async {
    // TODO: TTS 라이브러리 연동
    // 예: flutter_tts 패키지 사용
    debugPrint("TTS: $text");
  }

  /// 서비스 초기화
  Future<void> initialize() async {
    // TODO: 음성 인식 및 TTS 라이브러리 초기화
    // 권한 요청 등
    debugPrint("VoiceService 초기화 완료");
  }

  /// 서비스 정리
  void dispose() {
    _isListening = false;
    _onSpeechResult = null;
    _onError = null;
  }
}

/// 음성 인식 상태를 나타내는 열거형
enum VoiceState {
  idle,      // 대기 중
  listening, // 음성 인식 중
  processing, // AI 처리 중
  speaking,  // TTS 재생 중
}