import 'package:flutter/material.dart';

class MarketMapPage extends StatefulWidget {
  const MarketMapPage({super.key});

  @override
  State<MarketMapPage> createState() => _MarketMapPageState();
}

class _MarketMapPageState extends State<MarketMapPage> {
  // 시장 구역 데이터
  final List<Map<String, dynamic>> marketAreas = [
    {
      'name': '1구역 - 과일존',
      'shops': ['신선과일마트', '과일천국', '청과마트'],
      'color': Colors.green,
      'icon': Icons.apple,
    },
    {
      'name': '2구역 - 채소존',
      'shops': ['유기농채소', '농장직판장', '건강채소마켓'],
      'color': Colors.lightGreen,
      'icon': Icons.eco,
    },
    {
      'name': '3구역 - 수산물존',
      'shops': ['싱싱횟집', '바다마트', '수산시장'],
      'color': Colors.blue,
      'icon': Icons.set_meal,
    },
    {
      'name': '4구역 - 정육존',
      'shops': ['프리미엄정육점', '신선정육마트'],
      'color': Colors.red,
      'icon': Icons.lunch_dining,
    },
    {
      'name': '5구역 - 떡·한과존',
      'shops': ['전통떡집', '맛있는떡방'],
      'color': Colors.brown,
      'icon': Icons.cake,
    },
    {
      'name': '6구역 - 반찬존',
      'shops': ['엄마손반찬', '건강반찬가게'],
      'color': Colors.orange,
      'icon': Icons.restaurant,
    },
  ];

  int selectedAreaIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('시장 지도'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // 지도 안내
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.orange.shade50,
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.orange.shade600),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    '원주중앙시장 구역별 안내도입니다. 구역을 터치하면 상점 정보를 볼 수 있습니다.',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          
          // 시장 지도 (그리드 형태)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // 지도 제목
                  const Text(
                    '원주중앙시장 배치도',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // 지도 그리드
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.2,
                      ),
                      itemCount: marketAreas.length,
                      itemBuilder: (context, index) {
                        return _buildAreaCard(index);
                      },
                    ),
                  ),
                  
                  // 선택된 구역 정보
                  if (selectedAreaIndex >= 0) _buildSelectedAreaInfo(),
                ],
              ),
            ),
          ),
        ],
      ),
      // 전체보기/ 내 위치 버튼
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: "location",
            onPressed: () {
              _showLocationDialog();
            },
            backgroundColor: Colors.orange,
            child: const Icon(Icons.my_location, color: Colors.white),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "fullscreen",
            onPressed: () {
              setState(() {
                selectedAreaIndex = -1;
              });
            },
            backgroundColor: Colors.orange.shade300,
            child: const Icon(Icons.fullscreen, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildAreaCard(int index) {
    final area = marketAreas[index];
    final isSelected = selectedAreaIndex == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAreaIndex = selectedAreaIndex == index ? -1 : index;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected 
            ? area['color'].withOpacity(0.3) 
            : area['color'].withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected 
              ? area['color'] 
              : area['color'].withOpacity(0.3),
            width: isSelected ? 3 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              area['icon'],
              size: 40,
              color: area['color'],
            ),
            const SizedBox(height: 8),
            Text(
              area['name'],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: area['color'],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${area['shops'].length}개 상점',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedAreaInfo() {
    final area = marketAreas[selectedAreaIndex];
    
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(area['icon'], color: area['color']),
              const SizedBox(width: 8),
              Text(
                area['name'],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: area['color'],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            '이 구역의 상점들:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: (area['shops'] as List<String>).map((shop) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: area['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: area['color'].withOpacity(0.3),
                  ),
                ),
                child: Text(
                  shop,
                  style: TextStyle(
                    fontSize: 12,
                    color: area['color'],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _showLocationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.location_on, color: Colors.orange.shade600),
              const SizedBox(width: 8),
              const Text('내 위치'),
            ],
          ),
          content: const Text(
            '현재 위치: 원주중앙시장 정문\n\n가장 가까운 구역:\n• 1구역 - 과일존 (50m)\n• 6구역 - 반찬존 (80m)',
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
}