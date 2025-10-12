import 'package:flutter/material.dart';
import '../services/voice_service.dart';

/// 음성 인식 다이얼로그
class VoiceDialog extends StatefulWidget {
  const VoiceDialog({super.key});

  @override
  State<VoiceDialog> createState() => _VoiceDialogState();
}

class _VoiceDialogState extends State<VoiceDialog>
    with TickerProviderStateMixin {
  final VoiceService _voiceService = VoiceService();
  late AnimationController _pulseController;
  late AnimationController _waveController;
  
  bool _isListening = false;
  String _recognizedText = "";
  String _aiResponse = "";

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat();
    
    _startListening();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _waveController.dispose();
    _voiceService.stopListening();
    super.dispose();
  }

  void _startListening() async {
    setState(() {
      _isListening = true;
      _recognizedText = "";
      _aiResponse = "";
    });

    await _voiceService.startListening(
      onResult: (result) {
        setState(() {
          _recognizedText = result;
          _isListening = false;
        });
        _showAIResponse();
      },
      onError: (error) {
        setState(() {
          _isListening = false;
          _aiResponse = "오류: $error";
        });
      },
    );
  }

  void _showAIResponse() {
    // 간단한 AI 응답 시뮬레이션
    setState(() {
      _aiResponse = _generateResponse(_recognizedText);
    });
  }

  String _generateResponse(String input) {
    final lowerInput = input.toLowerCase();
    
    if (lowerInput.contains('사과') || lowerInput.contains('과일')) {
      return "🍎 김씨네 과일가게에서 신선한 사과를 판매하고 있어요!\n가격: 1봉 5,000원\n⭐ 평점 4.5";
    } else if (lowerInput.contains('생선') || lowerInput.contains('회')) {
      return "🐟 바다횟집에서 싱싱한 생선을 만나보세요!\n고등어 1손: 8,000원\n⭐ 평점 4.7";
    } else if (lowerInput.contains('떡')) {
      return "🍰 할머니 떡집의 꿀 백설기 추천드려요!\n가격: 2,000원\n⭐ 평점 4.3";
    } else if (lowerInput.contains('추천')) {
      return "✨ 오늘의 추천 상품\n• 신선한 사과 (김씨네 과일가게)\n• 고등어 (바다횟집)\n• 유기농 채소 (채소마을)";
    } else {
      return "🤔 죄송해요, 다시 한 번 말씀해 주시겠어요?\n상품명이나 가게 이름을 말씀해 주세요!";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 제목
            const Text(
              '🎤 음성 쇼핑 도우미',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 24),

            // 음성 인식 애니메이션
            if (_isListening) ...[
              SizedBox(
                width: 120,
                height: 120,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // 파동 애니메이션
                    AnimatedBuilder(
                      animation: _waveController,
                      builder: (context, child) {
                        return Container(
                          width: 120 * (0.5 + 0.5 * _waveController.value),
                          height: 120 * (0.5 + 0.5 * _waveController.value),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.orange.withOpacity(
                              0.3 * (1 - _waveController.value),
                            ),
                          ),
                        );
                      },
                    ),
                    // 중앙 버튼
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        return Container(
                          width: 80 + (10 * _pulseController.value),
                          height: 80 + (10 * _pulseController.value),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Colors.orange.shade400,
                                Colors.orange.shade600
                              ],
                            ),
                          ),
                          child: const Icon(
                            Icons.mic,
                            color: Colors.white,
                            size: 32,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '듣고 있습니다...',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ] else if (_recognizedText.isNotEmpty) ...[
              // 인식된 텍스트
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '말씀하신 내용:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _recognizedText,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              
              if (_aiResponse.isNotEmpty) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.smart_toy,
                            color: Colors.orange.shade600,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'AI 추천:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _aiResponse,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ],

            const SizedBox(height: 24),

            // 버튼들
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (!_isListening && _recognizedText.isNotEmpty)
                  TextButton.icon(
                    onPressed: _startListening,
                    icon: const Icon(Icons.refresh),
                    label: const Text('다시 듣기'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.orange,
                    ),
                  ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('닫기'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}