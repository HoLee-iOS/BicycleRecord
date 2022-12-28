
<img src="https://user-images.githubusercontent.com/78537078/209314831-d69d4fcf-cd44-420a-86f1-96c0e6d13d74.png" width="20%">

# Ricle - 자전거 편의시설 지도 (출시)

- [Ricle - 자전거 편의시설 지도 앱스토어 링크](https://apps.apple.com/kr/app/ricle-%EC%9E%90%EC%A0%84%EA%B1%B0-%ED%8E%B8%EC%9D%98%EC%8B%9C%EC%84%A4-%EC%A7%80%EB%8F%84/id6443554916)</br>
- [Ricle 소개 페이지](https://elite-pet-b14.notion.site/Ricle-1-1-1-440a2fada68b4fa2aeb40bd933016f18)</br>
- [Ricle 개인정보처리방침 및 오픈소스 라이선스 페이지](https://elite-pet-b14.notion.site/Ricle-90a18363c595446fa9ae9ae3a5ae9738)</br>
- 서울시 자전거 편의시설의 정보와 자전거 라이딩에 적합한 날씨인지에 대한 정보를 제공해주는 앱입니다.</br>
- 주요 기획 의도는 자전거 편의시설에 대한 정보와 날씨를 함께 제공함으로 자전거 라이딩에 필요한 정보들을 한 앱에서 제공해주는 앱입니다.

<p>
<img src="https://user-images.githubusercontent.com/78537078/209093977-4c452162-3fc3-4743-bc4c-32d5d13af5cd.png" width="19%">
<img src="https://user-images.githubusercontent.com/78537078/209094066-9647e175-e1b5-4c17-87f2-f754ba42e7f5.png" width="19%">
<img src="https://user-images.githubusercontent.com/78537078/209094069-ee3fe27a-3064-4079-8d6c-3a00dedbc214.png" width="19%">
<img src="https://user-images.githubusercontent.com/78537078/209094071-e3d8cf16-1324-4a9a-8d0f-5d1c621c627c.png" width="19%">
<img src="https://user-images.githubusercontent.com/78537078/209094074-d3ce88c2-804d-45c5-9db6-612c16055846.png" width="19%">
</p>

</br>

## 1. 제작 기간 & 참여 인원
- 개발 공수 : https://elite-pet-b14.notion.site/a3763ffa4aef4f258b7bc5a9cd19feb1?v=ba2e1ce25e90468289919989c552cc3c
- 2022년 9월 12일 ~ 10월 13일
- 개인 프로젝트

</br>

## 2. 사용 기술
| kind | stack |
| ------ | ------ |
| 아키텍처 | `MVC` |
| 프레임워크 | `UIKit` `Foundation` `MapKit` `Network` `MessageUI` `SafariServices` `CoreLocation`|
| UI | `Snapkit` `Codebase` |
| 라이브러리 | `Toast` `SwiftyJSON` `Lottie` `SnapKit` `NaverMapSDK` `DropDown` `Toast` `FirebaseCrashlytics` `FirebaseAnalytics` `FirebaseMessaging` |
| 데이터베이스 | `Realm` |
| 네트워크 | `Alamofire` |
| 의존성관리 | `Cocoapods`, `Swift Package Manager` |
| Tools | `Git / Github` `Jandi` |
| ETC | `DiffableDataSource` |

</br>

## 3. 핵심 기능
이 서비스의 핵심 기능은 자전거 사용자에게 정말 필요하지만 찾을 수 없었던 자전거 편의시설에 대한 정보 제공입니다.
- 편의시설 정보 제공
- 검색 기능
- 즐겨찾기 기능
- 날씨 정보 제공

<details>
<summary><b>핵심 기능 설명 펼치기</b></summary>

### 3.1 편의시설 정보 제공
  ``` Swift
  BicycleAPIManager.shared.callRequest(startIndex: 1, endIndex: 1000) { loc, count  in
                    loc.forEach {
                        if $0.2.contains("공기") || $0.2.contains("주입기") {
                            let task = UserMap(lat: $0.0, lng: $0.1, title: $0.2, info: $0.3, id: $0.4, address: $0.5, type: 0)
                            MapRepository.shared.saveRealm(item: task)
                        } else if $0.2.contains("주차") || $0.2.contains("거치") || $0.2.contains("보관") {
                            let task = UserMap(lat: $0.0, lng: $0.1, title: $0.2, info: $0.3, id: $0.4, address: $0.5, type: 1)
                            MapRepository.shared.saveRealm(item: task)
                        } else {
                            let task = UserMap(lat: $0.0, lng: $0.1, title: $0.2, info: $0.3, id: $0.4, address: $0.5, type: 2)
                            MapRepository.shared.saveRealm(item: task)
                        }
                    }
                }
  ```
  - 앱 시작화면에서 통신을 통해 편의시설 데이터를 받아와서 Realm에 저장
  
  ``` Swift    
  for i in MapRepository.shared.tasks {
            marker.position = NMGLatLng(lat: i.lat, lng: i.lng)
            
            marker.userInfo = ["type":i.type]
            
            marker.touchHandler = { [weak self] (overlay: NMFOverlay) -> Bool in
                guard let self = self else { return false }
                
                if let marker = self.mark {
                    if marker.userInfo["type"] as! Int == 0 {
                        marker.iconImage = NMFOverlayImage(name: "loc1")
                    } else if marker.userInfo["type"] as! Int == 1 {
                        marker.iconImage = NMFOverlayImage(name: "loc2")
                    } else {
                        marker.iconImage = NMFOverlayImage(name: "loc3")
                    }
                }
  }
  ```
  - Realm에 저장되어 있는 데이터 배열을 통해 마커를 생성하여 네이버 지도에 구현
  
  </br>
  
### 3.2 검색 기능
  ``` Swift
  let text = searchText.lowercased()
  filteredArr = MapRepository.shared.tasks.where { $0.title.contains(text, options: .caseInsensitive) || $0.address.contains(text, options: .caseInsensitive) }
  ```
  - Realm 데이터 배열에 사용자로부터 입력 받은 텍스트를 contains 고차함수를 통해 검색 기능 구현
  
  </br>
  
### 3.3 즐겨찾기 기능

  ``` Swift
  let arr = MapRepository.shared.tasks.where { $0.id == popup.id! }
  MapRepository.shared.updateFavorite(item: arr[0])
  arr[0].favorite ? popup.popupFavoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal) : popup.popupFavoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
  ```
  - Realm 객체 별 즐겨찾기를 판별해줄 Bool 타입의 프로퍼티를 통해 전체 데이터 배열에서 filter 고차함수로 즐겨찾기 기능 구현
  
  </br>
  
### 3.4 날씨 정보 제공

  ``` Swift
  WeatherAPIManager.shared.callWeather(lat: lat, lon: lng) { main, temp, windPower in
                
                Weather.wea1 = (main, temp, windPower)
                
                //날씨 아이콘
                self.main.weatherImage.image = UIImage(named: self.iconType(main))
                //날씨 종류
                self.typeSwitch(main)
                //현재 기온
                self.main.currentTemp.text = "\(temp)º"
                //풍속
                self.main.windy.statusLabel.text = "\(windPower)m/s"
            }
            WeatherRepository.shared.saveRealm(item: item)
  ```
  - Alamofire와 SwiftyJSON을 이용하여 날씨 데이터를 Realm 데이터베이스에 저장한 후에 정보 제공
</details>

</br>

## 4. 트러블슈팅
- 개발 일지 : https://www.notion.so/8cac79381a344f69977b169c6d091d82

### 4.1 자전거 편의시설 마커 표시 구현시 스레드 에러
- 문제점: 네트워크 통신 내부에서 오버레이 추가를 하려고 했는데 스레드 에러가 발생함
- 해결: 지도에 추가된 오버레이의 속성은 메인스레드에서만 접근해야해서 대량의 오버레이를 다룰 경우 객체를 생성하고 초기 옵션을 지정하는 작업은 백그라운드 스레드에서 수행하고 지도에 추가하는 작업만을 메인 스레드에서 수행하면 메인 스레드를 효율적으로 사용할 수 있음
<img width="584" alt="슈팅1" src="https://user-images.githubusercontent.com/78537078/209756995-3586bc2e-48b7-4d28-802c-d162bcdbf39e.png">

### 4.2 날씨 데이터 통신 콜 수 제한
- 문제점: 화면 들어올때마다 날씨 데이터 통신을 하게 만들었더니 콜 수 제한 때문에 API 계정에 Lock이 걸림
- 해결: 앱 최초실행, 통신 후 3시간 경과, 현 위치의 구 단위 변경 시에만 데이터 통신이 되도록 조건을 설정함
<img width="1107" alt="스크린샷 2022-12-28 오후 1 33 25" src="https://user-images.githubusercontent.com/78537078/209757794-83e56c50-9132-4986-9ce2-517eeca8acb9.png">

### 4.3 즐겨찾기 탭에서 홈 탭으로 값 전달
- 문제점: 즐겨찾기 탭에서 셀 선택 시 홈 탭으로 값 전달하여 동작을 해야하는데 UITabBarController에서 탭 간 값전달을 할 수 있는 방법이 떠오르지 않음
- 해결: NotificationCenter를 이용하면 내가 선택하는 시점에 탭 전환만 해주면 홈 탭에서 원하는 값을 전달 받아서 원하는 동작을 실행할 수 있음!
<img width="881" alt="스크린샷 2022-12-28 오후 1 46 26" src="https://user-images.githubusercontent.com/78537078/209759920-f6a9ffbe-46f7-4936-9f99-5cb215207850.png">
<img width="1207" alt="스크린샷 2022-12-28 오후 1 46 47" src="https://user-images.githubusercontent.com/78537078/209759930-6f001dfc-118d-447f-9b6f-1c19ff373e70.png">
<img width="976" alt="스크린샷 2022-12-28 오후 1 57 50" src="https://user-images.githubusercontent.com/78537078/209759939-058aa8a6-b56a-4d8a-90b0-273a6c8c3b16.png">

### 4.4 네트워크 상태에 따른 예외 처리
- 문제점: 네트워크 상태에 따른 예외 처리 시에 설정으로 이동 후 네트워크 설정 없이 화면으로 돌아오는 경우 경고창이 뜨지 않음
- 해결: SceneDelegate의 sceneDidBecomeActive 시점에 네트워크가 연결되어있는지를 확인해서 연결되어 있다면 그냥 넘어가고 되어있지않다면 네트워크 연결에 대한 경고창을 띄워서 예외처리함
<img width="830" alt="슈팅2" src="https://user-images.githubusercontent.com/78537078/209761144-e410a4d9-2ba5-4061-9dfb-3138a098e2fd.png">

### 4.5 날씨 데이터 통신 후 Realm 데이터 저장
- 문제점: 날씨 데이터 통신이 다 끝나고 Realm 데이터 저장이 되어야하는데 통신이 끝나기 전에 데이터 저장이 되어서 값이 몇개가 빈 상태로 저장됨
- 해결: API 통신을 끝낸 후에 Realm 데이터에 담아줘야하기 때문에 Dispatch Group을 이용해서 통신이 완전히 끝나면 Realm에 담아주게 처리해줌
<img width="243" alt="1" src="https://user-images.githubusercontent.com/78537078/209761732-1f40673f-c3a0-4300-8e9b-e33dfb3e7b0d.png">
<img width="971" alt="2" src="https://user-images.githubusercontent.com/78537078/209761751-087d2dcd-a275-471d-a7da-27e99343f9c9.png">
<img width="929" alt="3" src="https://user-images.githubusercontent.com/78537078/209761757-36e13dc8-8c46-4df3-a049-7f4522f380f6.png">

### 4.6 앱 리젝
- 문제점
<img width="726" alt="스크린샷 2022-12-28 오후 2 34 18" src="https://user-images.githubusercontent.com/78537078/209763047-24f36702-be20-4ff2-987b-7d6102f6f306.png">

- 해결: 로그인 기능이 없는 앱에서 소개 페이지에 서비스 이용 약관에 대해 기재해놓은 것으로 리젝 받은 것으로 소개페이지에서 이용 약관에 대한 부분 삭제 후 출시

</br>

## 5. 회고
- 프로젝트 개발에 대한 회고 : https://skylert.tistory.com/48

</br>

## 6. 업데이트 내역
|ver|content|
|---|---|
|1.1.2| 설정 탭 Diffable Datasource로 수정 |
|1.1.1|Realm 테이블 구조 변화에 대한 마이그레이션 구현|
|1.1.0|강수확률 데이터가 계속 0으로 나오는 버그 수정 </br> 리뷰 남기기 기능 추가 </br> 앱 실시간 모니터링을 위한 FirebaseCrashlytics, FirebaseAnalytics 추가 </br> 원격 알림 전송을 위한 FirebaseMessaging 추가|
|1.0|앱 출시|
