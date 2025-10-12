# 원주중앙시장 앱 🏪

원주중앙시장의 공식 모바일/웹 애플리케이션입니다.

## 🌐 웹사이트 접속

**배포 URL**: https://w00ky0216.github.io/sigang

## 🌟 주요 기능

- 🏠 **메인 화면**: 추천 상품, 시장 새소식, 바로가기 메뉴 (주황색 아이콘)
- 🛒 **상점**: 카테고리별(과일, 채소, 수산물, 정육, 떡, 반찬) 상점 탐색
- 💳 **간편결제**: 토스페이, 카카오페이, 네이버페이 등 다양한 결제 수단
- 🎫 **쿠폰함**: 할인 쿠폰 관리 및 사용
- 🗺️ **시장 지도**: 구역별 상점 위치 안내
- ⭐ **단골 상점**: 자주 방문하는 상점 관리 (VIP 시스템)
- 🛍️ **장바구니**: 상품 담기 및 주문 관리
- 🎤 **음성 인식**: AI 음성 주문 기능 (준비 중)

## 🚀 실행 방법

### 모바일 앱
```bash
flutter run
```

### 웹 앱
```bash
flutter run -d chrome
```

### 빌드
```bash
# 웹 빌드
flutter build web --release

# Android APK
flutter build apk --release
```

## 📱 지원 플랫폼

- ✅ **Android**: 네이티브 앱
- ✅ **iOS**: 네이티브 앱  
- ✅ **웹**: Chrome, Firefox, Safari, Edge
- ✅ **데스크톱**: Windows, macOS, Linux
- ✅ **PWA**: 모바일 웹에서 앱으로 설치 가능

## 🛠️ 기술 스택

- **Framework**: Flutter 3.24.0
- **Language**: Dart
- **Design**: Material Design 3
- **Color Scheme**: Orange Theme (#FF9800)
- **Architecture**: MVC Pattern
- **State Management**: StatefulWidget

## 📦 주요 구성 요소

### 📁 프로젝트 구조
```
lib/
├── main.dart                    # 앱 진입점
├── pages/                       # 화면 페이지들
│   ├── home_page.dart          # 메인 화면 (바로가기 메뉴)
│   ├── shop_page.dart          # 상점 목록 (카테고리 필터)
│   ├── payment_page.dart       # 간편결제 (8개 결제 수단)
│   ├── coupon_page.dart        # 쿠폰함 (할인 쿠폰 관리)
│   ├── market_map_page.dart    # 시장 지도 (6개 구역)
│   ├── regular_shop_page.dart  # 단골 상점 (VIP 시스템)
│   ├── cart_page.dart          # 장바구니 (상품 관리)
│   └── my_page.dart            # 마이페이지
├── services/                    # 서비스 레이어
│   ├── payment_service.dart    # 결제 서비스
│   └── voice_service.dart      # 음성 서비스
└── widgets/                     # 재사용 위젯들
    ├── voice_dialog.dart       # 음성 다이얼로그
    └── payment_dialog.dart     # 결제 다이얼로그
```

### 🎨 UI/UX 특징
- **주요 색상**: 주황색 테마로 통일감 있는 디자인
- **반응형**: 모바일 우선 설계, 웹에서도 최적화
- **접근성**: 시각적 피드백과 직관적 네비게이션
- **사용자 경험**: 간편한 결제 플로우와 카테고리 필터링

## 🌐 배포 및 호스팅

### GitHub Pages 자동 배포
- **Repository**: https://github.com/w00ky0216/sigang
- **Website**: https://w00ky0216.github.io/sigang
- **자동 배포**: main 브랜치에 푸시하면 GitHub Actions로 자동 빌드 및 배포

### PWA (Progressive Web App)
- **오프라인 지원**: Service Worker로 캐싱
- **앱 설치**: 모바일에서 "홈 화면에 추가" 가능
- **push 알림**: 준비 중

## 🎯 주요 기능 상세

### 1. 홈 화면
- 검색창
- 4개 바로가기 메뉴 (쿠폰함, 시장 지도, 단골 상점, 장바구니)
- 오늘의 추천 상품 (가로 스크롤)
- 시장 새소식

### 2. 상점 페이지
- 카테고리 필터: 전체, 과일, 채소, 수산물, 정육점, 떡집, 반찬
- 각 카테고리별 전용 상점들
- 상점 평점 및 카테고리 태그

### 3. 간편결제
- 8개 결제 수단: 토스페이, 카카오페이, 네이버페이, 페이코, 삼성페이, 애플페이, 구글페이, 신용카드
- 동적 금액 설정
- 결제 시뮬레이션

### 4. 쿠폰함
- 사용 가능/사용 완료 쿠폰 분류
- 할인율/할인금액별 쿠폰
- 유효기간 및 최소 구매 금액 표시

### 5. 시장 지도
- 6개 구역별 배치도
- 구역별 상점 목록
- 내 위치 기능

### 6. 단골 상점
- VIP 고객 시스템
- 방문 횟수 및 구매 내역 통계
- 단골 할인 혜택

## 📈 개발 현황

- ✅ **1차 베타**: 모든 핵심 기능 구현 완료
- 🔄 **진행 중**: 실제 API 연동 준비
- 📋 **예정**: 실제 결제 시스템 연동, 음성 AI 기능 구현

## 👨‍💻 개발 정보

- **개발 기간**: 2025년 10월
- **개발 환경**: Flutter 3.24.0, VS Code
- **버전 관리**: Git, GitHub
- **배포**: GitHub Pages, GitHub Actions

---

**원주중앙시장에서 신선하고 다양한 상품을 만나보세요! 🛒✨**

*이 앱은 전통시장의 디지털 전환을 위한 시범 프로젝트입니다.*