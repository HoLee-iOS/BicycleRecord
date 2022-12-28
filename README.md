
<img src="https://user-images.githubusercontent.com/78537078/209314831-d69d4fcf-cd44-420a-86f1-96c0e6d13d74.png" width="20%">

# Ricle - 자전거 편의시설 지도 (출시)

>[Ricle - 자전거 편의시설 지도 앱스토어 링크](https://apps.apple.com/kr/app/ricle-%EC%9E%90%EC%A0%84%EA%B1%B0-%ED%8E%B8%EC%9D%98%EC%8B%9C%EC%84%A4-%EC%A7%80%EB%8F%84/id6443554916)</br>
>서울시 자전거 편의시설의 정보와 자전거 라이딩에 적합한 날씨인지에 대한 정보를 제공해주는 앱입니다.</br>
>주요 기획 의도는 자전거 편의시설에 대한 정보와 날씨를 함께 제공함으로 자전거 라이딩에 있어서 필요한 정보들을 한 앱에서 제공해주는 자전거 라이딩 앱입니다.

<p>
<img src="https://user-images.githubusercontent.com/78537078/209093977-4c452162-3fc3-4743-bc4c-32d5d13af5cd.png" width="19%">
<img src="https://user-images.githubusercontent.com/78537078/209094066-9647e175-e1b5-4c17-87f2-f754ba42e7f5.png" width="19%">
<img src="https://user-images.githubusercontent.com/78537078/209094069-ee3fe27a-3064-4079-8d6c-3a00dedbc214.png" width="19%">
<img src="https://user-images.githubusercontent.com/78537078/209094071-e3d8cf16-1324-4a9a-8d0f-5d1c621c627c.png" width="19%">
<img src="https://user-images.githubusercontent.com/78537078/209094074-d3ce88c2-804d-45c5-9db6-612c16055846.png" width="19%">
</p>

</br>

## 1. 제작 기간 & 참여 인원
- [개발 공수](https://elite-pet-b14.notion.site/a3763ffa4aef4f258b7bc5a9cd19feb1?v=ba2e1ce25e90468289919989c552cc3c)
- 2022년 9월 12일 ~ 10월 13일
- 개인 프로젝트

</br>

## 2. 사용 기술
#### `언어`
  - Swift
#### `데이터베이스`
  - Realm
#### `디자인`
  - AutoLayout
#### `네트워크`
  - Alamofire
#### `의존성관리`
  - Cocoapods 
  - Swift Package Manager
#### `프레임워크`
  - Foundation
  - UIKit
  - CoreLocation
  - Network
  - SafariServices
  - MessageUI
#### `라이브러리`
  - SwiftyJSON
  - Lottie
  - SnapKit
  - NaverMapSDK
  - DropDown
  - Toast
  - FirebaseCrashlytics
  - FirebaseAnalytics
  - FirebaseMessaging
#### `디자인패턴`
  - MVC
  - Singleton
#### `Tools`
  - Git / Github
  - Jandi
#### `ETC`
  - DiffableDataSource

</br>

## 3. 핵심 기능

<details>
<summary><b>핵심 기능 설명 펼치기</b></summary>

- Alamofire와 SwiftyJSON을 이용하여 편의시설의 데이터를 Realm 데이터베이스에 저장한 후에 마커 배열을 생성하여 네이버 지도 SDK에 마커 표시
- Realm 객체 별 종류를 판별해줄 Int 타입의 프로퍼티를 통해 전체 데이터 배열에서 filter 고차함수로 종류 별 필터 기능 구현
- Realm 편의시설 데이터 배열에서 사용자가 입력한 텍스트를 통해 contains 고차함수로 검색 기능 구현
- Realm 객체 별 즐겨찾기를 판별해줄 Bool 타입의 프로퍼티를 통해 전체 데이터 배열에서 filter 고차함수로 즐겨찾기 기능 구현
- Alamofire와 SwiftyJSON을 이용하여 날씨 데이터를 Realm 데이터베이스에 저장한 후 정보 제공
- 마커는 NMFOverlayImage를 통해 Custom Marker 생성
- DropDown을 통해 종류 선택 버튼 구현
- MessageUI framework와 MFMailComposeViewController 객체를 통해 문의하기 기능 구현****
- CoreLocation의 CLLocationManager를 이용하여 사용자 위치 권한 요청 및 예외 처리 및 위치 정보 수립
- Network framework를 통한 네트워크 연결 상태에 따른 예외 처리
- SafariServices framework를 통한 리뷰 남기기 기능 구현
- Firebase Crashlytics와 Firebase Analytics를 활용한 실시간 모니터링 기능 구현
- Firebase Messaging을 활용한 원격 알림 기능 구현

</details>

</br>

## 4. 트러블슈팅
[개발일지](https://www.notion.so/8cac79381a344f69977b169c6d091d82)

## 회고 / 느낀점

## 업데이트 내역
