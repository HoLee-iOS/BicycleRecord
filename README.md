
<img src="https://user-images.githubusercontent.com/78537078/209314831-d69d4fcf-cd44-420a-86f1-96c0e6d13d74.png" width="20%">

# Ricle - 자전거 편의시설 지도 (출시)

>[Ricle - 자전거 편의시설 지도 앱스토어 링크](https://apps.apple.com/kr/app/ricle-%EC%9E%90%EC%A0%84%EA%B1%B0-%ED%8E%B8%EC%9D%98%EC%8B%9C%EC%84%A4-%EC%A7%80%EB%8F%84/id6443554916)</br>
>서울시 자전거 편의시설의 정보와 자전거 라이딩에 적합한 날씨인지에 대한 정보를 제공해주는 앱입니다.</br>
>주요 기획 의도는 자전거 편의시설에 대한 정보와 날씨를 함께 제공함으로 자전거 라이딩에 필요한 정보들을 한 앱에서 제공해주는 앱입니다.

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
|카테고리|내용|
|---|---|
|언어|Swift|
|데이터베이스|Realm|
|디자인|AutoLayout|
|네트워크|Alamofire|
|의존성관리|Cocoapods, Swift Package Manager|
|프레임워크|Foundation, UIKit, CoreLocation, Network, SafariServices, MessageUI|
|라이브러리|SwiftyJSON, Lottie, SnapKit, NaverMapSDK, DropDown, Toast, FirebaseCrashlytics, FirebaseAnalytics, FirebaseMessaging|
|디자인패턴|MVC, Singleton|
|Tools|Git / Github, Jandi|
|ETC|DiffableDataSource|

</br>

## 3. 핵심 기능
이 서비스의 핵심 기능은 자전거 사용자에게 정말 필요하지만 찾을 수 없었던 자전거 편의시설에 대한 정보 제공입니다.
- 사용자의 위치 기반으로 주변에 있는 자전거 편의시설에 대한 정보를 제공합니다.
- 원하는 지역이나 시설이 있다면 검색도 해볼 수 있습니다.
- 자주 찾는 시설에 대해 즐겨찾기를 설정하여 쉽게 찾아볼 수 있습니다.
- 그날의 라이딩에 알맞은 날씨인지 확인해 볼 수 있습니다.

<details>
<summary><b>핵심 기능 설명 펼치기</b></summary>

### 3.1 편의시설 정보 제공
  ``` swift
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
  
  ``` swift    
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
  ``` swift
  let text = searchText.lowercased()
  filteredArr = MapRepository.shared.tasks.where { $0.title.contains(text, options: .caseInsensitive) || $0.address.contains(text, options: .caseInsensitive) }
  ```
  - Realm 데이터 배열에 사용자로부터 입력 받은 텍스트를 contains 고차함수를 통해 검색 기능 구현
  
  </br>
  
### 3.3 즐겨찾기 기능

  ``` swift
  let arr = MapRepository.shared.tasks.where { $0.id == popup.id! }
  MapRepository.shared.updateFavorite(item: arr[0])
  arr[0].favorite ? popup.popupFavoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal) : popup.popupFavoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
  ```
  - Realm 객체 별 즐겨찾기를 판별해줄 Bool 타입의 프로퍼티를 통해 전체 데이터 배열에서 filter 고차함수로 즐겨찾기 기능 구현
  
  </br>
  
### 3.4 날씨 정보 제공

  ``` swift
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
[개발일지](https://www.notion.so/8cac79381a344f69977b169c6d091d82)

</br>

## 5. 회고 / 느낀점

</br>

## 6. 업데이트 내역
