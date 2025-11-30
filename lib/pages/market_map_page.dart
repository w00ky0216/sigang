import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MarketMapPage extends StatefulWidget {
  const MarketMapPage({super.key});

  @override
  State<MarketMapPage> createState() => _MarketMapPageState();
}

class _MarketMapPageState extends State<MarketMapPage> {
  void _showShopInfo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            '새벽집',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow(Icons.store, '호수', '다1'),
              const SizedBox(height: 12),
              _buildInfoRow(Icons.business, '업종', '음식점'),
              const SizedBox(height: 12),
              _buildInfoRow(Icons.restaurant_menu, '취급품목', '한우숯불구이'),
              const SizedBox(height: 12),
              _buildInfoRow(Icons.phone, '연락처', '033-745-8687'),
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

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.orange.shade700),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('시장 지도'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: InteractiveViewer(
          boundaryMargin: const EdgeInsets.all(20),
          minScale: 0.5,
          maxScale: 4.0,
          child: GestureDetector(
            onTap: _showShopInfo,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SvgPicture.asset(
                'assets/images/sigang_inf.svg',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
