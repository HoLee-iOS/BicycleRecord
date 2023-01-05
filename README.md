
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
| 프레임워크 | `UIKit` `Foundation` `Network` `MessageUI` `SafariServices` `CoreLocation`|
| 라이브러리 | `Toast` `SwiftyJSON` `Lottie` `SnapKit` `NaverMapSDK` `DropDown` `Toast` `FirebaseCrashlytics` `FirebaseAnalytics` `FirebaseMessaging` |
| 데이터베이스 | `Realm` |
| 네트워크 | `Alamofire` |
| 의존성관리 | `Cocoapods` `Swift Package Manager` |
| Tools | `Git / Github` `Jandi` |
| ETC | `DiffableDataSource` |

</br>

## 3. 핵심 기능

이 서비스의 핵심 기능은 자전거 사용자에게 정말 필요하지만 찾기 힘들었던 자전거 편의시설에 대한 정보 제공입니다.
- 편의시설 정보 제공
- 검색 기능
- 즐겨찾기 기능
- 날씨 정보 제공

### 3.1 편의시설 정보 제공

  - 앱 시작화면에서 통신을 통해 편의시설 데이터를 받아와서 Realm에 저장
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
  
  - Realm에 저장되어 있는 데이터 배열을 통해 마커를 생성하여 네이버 지도에 구현
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
  
  </br>
  
### 3.2 검색 기능

  - Realm 데이터 배열에 사용자로부터 입력 받은 텍스트를 contains 고차함수를 통해 검색 기능 구현
  ``` swift
  let text = searchText.lowercased()
  filteredArr = MapRepository.shared.tasks.where { $0.title.contains(text, options: .caseInsensitive) || $0.address.contains(text, options: .caseInsensitive) }
  ```
  
  </br>
  
### 3.3 즐겨찾기 기능

  - Realm 객체 별 즐겨찾기를 판별해줄 Bool 타입의 프로퍼티를 통해 전체 데이터 배열에서 filter 고차함수로 즐겨찾기 기능 구현
  ``` swift
  let arr = MapRepository.shared.tasks.where { $0.id == popup.id! }
  MapRepository.shared.updateFavorite(item: arr[0])
  arr[0].favorite ? popup.popupFavoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal) : popup.popupFavoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
  ```
  
  </br>
  
### 3.4 날씨 정보 제공

  - Alamofire와 SwiftyJSON을 이용하여 날씨 데이터를 Realm 데이터베이스에 저장한 후에 정보 제공
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

</br>

## 4. 트러블슈팅
- 개발 일지 : https://www.notion.so/8cac79381a344f69977b169c6d091d82

### 4.1 자전거 편의시설 마커 표시 구현시 스레드 에러
- 문제점: 네트워크 통신 내부에서 오버레이 추가를 하려고 했는데 스레드 에러가 발생함
- 해결: 지도에 추가된 오버레이의 속성은 메인스레드에서만 접근해야해서 대량의 오버레이를 다룰 경우 객체를 생성하고 초기 옵션을 지정하는 작업은 백그라운드 스레드에서 수행하고 지도에 추가하는 작업만을 메인 스레드에서 수행하면 메인 스레드를 효율적으로 사용할 수 있음</br>
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
- 문제점</br>
  <img width="726" alt="스크린샷 2022-12-28 오후 2 34 18" src="https://user-images.githubusercontent.com/78537078/209763047-24f36702-be20-4ff2-987b-7d6102f6f306.png">

- 해결: 로그인 기능이 없는 앱에서 소개 페이지에 서비스 이용 약관에 대해 기재해놓은 것으로 리젝 받은 것으로 소개페이지에서 이용 약관에 대한 부분 삭제 후 출시

</br>

## 5. 회고
- 프로젝트 개발에 대한 회고 원문 : https://skylert.tistory.com/48

### Keep

- 본 프로젝트에서 개발해보기 전에 예비 프로젝트를 만들어서 미리 생각했던 기능에 대한 구현 해보기
  - 위의 작업을 통해 프로젝트 개발 시간을 많이 줄일 수 있었던 것 같다.
  - 미리 구현을 통해 내가 미리 생각했던 기능에서 어떤 점이 문제였는지도 알 수 있고 본 프로젝트가 아니다 보니 좀 더 다양한 시도도 해볼 수 있어서 다시금 git branch가 중요성을 깨달았다.
- 개발 일지 작성
  - 개발을 하면서 개인적으로 가장 중요한 부분이 어떤 기능을 구현해내는 것도 중요하지만 구현하기까지의 나의 삽질들이나 생각 Flow와 같은 것들을 기록하는 것이 진짜 중요하다고 생각하는데 일지 작성을 하면 매일매일의 나의 삽질들을 모아볼 수 있어서 나의 성장에도 정말 큰 도움이 되고 정말 좋은 것 같다.
- 개발 공수 작성
  - 공수 작성은 해당 프로젝트를 해보면서 처음 해봤는데 계획 지키기가 이렇게 어려운 건가 느낄 수 있었다.
  - 공수 작성을 해보면서 어려웠던 점은 기능을 얼마만큼의 단위로 쪼개서 어느 정도의 시간을 할당할 것인가였다. 사실 그냥 모든 부분이 애매하고 어려웠다. PM과 공수의 중요성에 대해서 정말 크게 느낄 수 있었다.
  - 개발해보면서 시간도 재보고 했는데 아무래도 익숙한 기술 스택을 사용해보는 것은 좀 빠르게 해 볼 수 있지만 처음 사용해보는 스택이면 진짜 오래 걸릴 수도 있고 의외로 빨리 끝내는 경우도 많아서 나의 개발 시간을 예측하는 것도 정말 어려운 부분이구나 느낄 수 있었다.
- Mapkit이 아닌 네이버지도를 사용했던 점
  - Mapkit은 공부해보면서 사용해봤지만 네이버지도는 사용해본 적이 없어서 처음에는 막연하게 사용해보지 않은 걸로 공부하면서 사용해보자 하는 생각으로 사용을 했다.
  - 가독성이 너무 좋다.
    - AppleMap이나 GoogleMap, KakaoMap 다양한 지도들이 있지만 그중에서도 가독성이 정말 제일 좋다고 생각한다. 제가 평소에 네이버지도를 자주 사용해서 그런지는 몰라도 가독성이 너무 좋아서 마음에 들었다.
  - API 문서 업데이트가 잘되어있다.
    - 다른 지도들 특히나 KakaoMap은 지도 자체는 잘되어있지만 API 문서가 아주 오래전에 머물러있기 때문에 문서를 보며 공부하면서 개발해야 되는 사람들에게는 적합하지 않다고 생각한다.
    - 네이버지도는 API 문서의 업데이트도 잘되어있고 API 레퍼런스에 들어가 보면 각 클래스, 메서드 별로 설명이 한글로 자세히 나와있기 때문에 공부하면서 개발하기가 너무 좋다.
  - 커스텀이 너무 편하다.
    - 기존에 사용했던 MapKit은 마커를 커스텀하기 위해서는 코드를 줄이고 줄이더라도 필수적으로 사용해야 하는 Delegate나 메서드 같은 것들이 있었는데 네이버지도는 마커의 NMFOverlayImage 만 설정해준다면 간단하게 커스텀할 수 있어서 정말 너무 편했다.
      
### Problem

- 코드의 복잡성
    - 사실 이 문제는 앞으로도 계속 고민해봐야 할 문제이긴 하지만 역시 이번 프로젝트 때도 코드를 좀 더 줄일 수 있었는데 줄이지 못한 점이 너무 아쉬웠다.
    - CLLocationManager에 대한 부분도 싱글턴 패턴으로 만들어서 코드의 중복을 좀 줄여볼 수 있었는데 싱글턴으로 만들었을 때 화면 별 분기처리에 대한 문제를 해결하지 못해서 결국 실패했던 점이 너무 아쉬웠다.
    - 각 파일에서 Raw 한 값들이 좀 많아서 추후에 전부 enum으로 처리해볼 예정이다. Raw 한 값이 많으면 유지보수에도 좋지 않은 구조이기 때문에 반드시 리팩토링 해야 하는 부분이라고 생각한다.
- 네트워크 통신 코드의 중복
    - 네트워크 통신 코드도 통신 종류 별로 싱글턴을 이용하여 APIManager를 생성하여 최대한 줄여서 개발하였지만 다른 통신이여도 중복되는 부분이 많기 때문에 이 부분 또한 좀 더 줄여보지 못한 게 좀 아쉬운 부분이였다.
- SwiftyJSON의 사용
    - Alamofire 통신 시에 SwiftyJSON을 사용하여 받아오는 JSON 데이터에서 원하는 값만 조금씩 뽑아오고 있는데 이 부분도 처음 개발할 때는 몰랐지만 개발을 하면 할수록 좋지 않다는 것을 느낄 수 있었다.
    - Codable을 사용했다면 좀 더 코드를 줄여볼 수 있었을 것 같은데 SwiftyJSON을 사용함으로써 받아오는 정보가 적다면 더 효율적일 수도 있겠지만 정보가 많다면 코드가 정말 길어지고 나중에는 내가 이 정보를 받아오게 처리해놨나 하고 헷갈리기까지 한다. 그래서 추후에 이 부분은 반드시 Codable로 리팩터링 하여 SwiftyJSON을 덜어내는 것이 좋을 것이라고 생각한다.
- Error Handling의 부족
    - 네트워크 통신 시 값을 받아오거나 받아오지 못하거나에 대한 두 가지의 케이스 밖에 없기 때문에 실패 케이스에서 좀 더 사용자에게 맞는 Error Handling을 하지 못했다.
    - 실패 시에 좀 더 사용자의 입장에서 생각하여 Error Handling을 세세하게 하지 못한 아쉬움이 있다.
- MVVM을 시도해보지 못했던 것
    - MVVM 패턴에 대해서 막 배웠을 때라 공수 기간을 맞추지 못할까 봐 MVC 패턴으로 개발을 했지만 좀 아쉬운 부분이 있는 것 같다.
    - 무조건적으로 MVVM이 좋다고 할 수는 없지만 새로운 아키텍처 패턴을 공부하는데 직접 프로젝트에 적용해보면서 공부해봤다면 해당 아키텍처에 대한 이해가 좀 더 수월하지 않았을까 싶은 아쉬움이 있다.
- NaverMap에서의 아쉬웠던 부분
    - 클러스터링을 지원하지 않는다.
        - MapKit은 클러스터링 기능이 기본적으로 있다.
        - 네이버 지도에서는 해당 기능을 지원하지 않기 때문에 겹치는 마커에 대해서는 종류 별 우선순위를 통해 더 적은 개수의 시설 종류를 우선적으로 보여주게 했다.
        - 이렇게 처리한 부분은 사실 클러스터링을 구현해보려고 했지만 결국 실패하여 대체된 부분이기 때문에 너무 큰 아쉬움이 있다.

### Try

- git을 좀 더 활용해보기
    - 사실 아직은 git을 거의 코드 저장의 용도로만 사용하고 있지만 이번 프로젝트에서 branch의 중요성에 대해 확실히 알 수 있었기 때문에 다음 프로젝트에서는 예비 프로젝트를 따로 생성하여 사용하지 않고 branch를 통해 개발을 해봐야겠다.
- 개발 일지 작성법의 보완
    - 개발 일지를 처음 작성해보면서 일단은 어떤 형식으로든 기록을 해야겠다는 생각이 너무 컸다.
    - 형식 없이 그냥 캡처하고 카피하는 식으로 기록을 해두었는데 그렇게 기록해두니 가독성이 떨어지는 점도 아쉽고 읽기가 어렵다보니 자연스럽게 보지 않게 되었다.
    - 나만의 양식으로 작성하면 한번 더 그 날의 기록을 회고해 볼 수 있고 정리를 하면서 그 날의 개발에 대해 좀 더 깊이 있게 공부해보면서 아쉬운 점과 좋았던 점을 확실하게 짚고 넘어갈 수 있을 것이다.
- 정확한 개발 공수 작성을 위한 공수 작성의 생활화
    - 공수는 앞으로 개발하는 데 있어서 정말 필수적인 부분이라고 생각한다.
    - 아직 공수 작성을 많이 해본 적이 없고 개발을 할때 일정 시간을 정하고 해본 적이 없었기 때문에 이번 공수는 사실 끝없는 수정의 연속이였다.
    - 앞으로 개발하면서 계속 공수를 생활화하여 공수의 정확성을 높여야겠다.
- NaverMap 클러스터링 기능의 라이브러리 개발해보기
    - 네이버 지도에서는 클러스터링을 지원하지 않기 때문에 직접 클러스터링을 구현해보려고 했으나 실패했다.
    - 해당 부분은 추후에 다시 도전해서 라이브러리로 만들어 네이버지도를 사용하는 많은 개발자 분들에게 도움을 드리고 싶다.
- Error Handling을 좀 더 상세하게 해보기
    - 만약 사용자의 입장에서 Error를 만났을 경우 이거 뭐 어쩌라고 라는 반응이 절대 나오면 안된다고 생각한다.
    - 시중에 나와있는 앱 중에서도 생각보다 그런 앱이 되게 많은데 개발을 하다보니 그런 부분을 세세하게 처리하는게 쉽지 않은 부분이라는 것을 깨달았다.
    - 앞으로 Error Handling을 좀 더 상세하고 친절하게 처리하여 사용자가 Error를 만났을 경우 당황하지 않게 만들어야겠다.
- MVVM 패턴의 시도
    - 이번 프로젝트에서는 익숙하지 않은 패턴 사용으로 공수를 맞추지 못할까하는 두려움에 사용하지 못하였지만 다음 프로젝트에서는 좀 더 공부하고 익숙해져서 MVVM 패턴의 개발로 코드를 좀 더 분리해보고 싶다.

### 느낀 점

- 앱의 처음부터 끝까지를 모두 경험해보면서 정말 하나하나 쉬운 게 없다는 것을 느꼈다.
- 가장 먼저 기획 부분인데 기획이 정말 중요하다! 화면을 구성할 때 해당 화면에 들어갈 기능, 해당 화면과 연결될 화면들도 생각을 하면서 기획을 하는 것이 중요한 것 같다. 그렇지 않으면 추후에 기획을 다시 하게 되는 경우가 빈번하게 발생한다. 이래서 플로우차트 같은 것을 작성하는 것 같다.
- 함께하는 분들이 정말 중요하다는 것을 느꼈다. SeSAC 동기분들께 앱에 대해 피드백 요청도 해보고 피드백을 드려보기도 하면서 서로 많은 인사이트를 공유했는데 그렇게 하면서 정말 많은 성장을 했던 것 같다. 평소에 그냥 넘어가는 부분도 더 많은 인사이트를 공유하고 싶어서 좀 더 디테일하게 파보기도 하고 다른 분들 앱을 피드백해주면서 알고 있는 것에 대해 말로 풀어서 표현하는 것도 쉬운 일이 아니구나를 느꼈다. 이래서 커뮤니케이션 능력이 정말 중요한 것 같다.
- 나중에라는 건 없다! 개발을 하다 보면 공수에 쫓겨 일단 이렇게 하고 넘어간 다음에 나중에 리팩토링 해야지 하는 부분들이 있는데 이미 지나간 코드를 다시 보는 건 정말 힘든 일이다. 그때 최대한 잘해두고 넘어가는 것이 좋은 것 같다.
- 앱 출시는 했지만 아직 추가해야 하는 기능도 있고 많은 부분이 부족한 앱이다.. 앞으로 주먹구구식으로 구현하고 넘어간 코드들이나 Raw 하게 작성한 부분들을 리팩토링 하고 코드들을 전반적으로 점검하는 시간이 필요할 것 같다.

</br>

## 6. 업데이트 내역
|ver|content|
|---|---|
|1.1.2| 설정 탭 Diffable Datasource로 수정 |
|1.1.1|Realm 테이블 구조 변화에 대한 마이그레이션 구현|
|1.1.0|강수확률 데이터가 계속 0으로 나오는 버그 수정 </br> 리뷰 남기기 기능 추가 </br> 앱 실시간 모니터링을 위한 FirebaseCrashlytics, FirebaseAnalytics 추가 </br> 원격 알림 전송을 위한 FirebaseMessaging 추가|
|1.0|앱 출시|
