//
//  AppDelegate.swift
//  BicycleRecord
//
//  Created by 이현호 on 2022/09/27.
//

import UIKit
import FirebaseCore
import FirebaseMessaging
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        aboutRealmMigration()
        
        //앱 실행시 네트워크 상태 확인
        NetworkMonitor.shared.startMonitoring()
        
        FirebaseApp.configure()
        
        //원격 알림 시스템에 앱을 등록
        // For iOS 10 display notification (sent via APNS)
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
        
        application.registerForRemoteNotifications()
        
        //메시지 대리자 설정
        Messaging.messaging().delegate = self
        
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM registration token: \(token)")
            }
        }
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
}

extension AppDelegate {
    
    //마이그레이션 적용
    func aboutRealmMigration() {
        
        let config = Realm.Configuration(schemaVersion: 1) { migration, oldSchemaVersion in
            
            //이전 버전에 rain 타입이 Int -> Double로 변경되었던것에 대한 마이그레이션
            if oldSchemaVersion < 1 {
                migration.enumerateObjects(ofType: UserWeather.className()) { oldObject, newObject in
                    guard let new = newObject else { return }
                    guard let old = oldObject else { return }
                    
                    new["rain"] = old["rain"]
                }
            }
        }
        
        Realm.Configuration.defaultConfiguration = config
        
    }
    
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    //포그라운드 알림 수신: 로컬/푸시 동일
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //.banner, .list: iOS14+
        completionHandler([.badge, .sound, .banner, .list])
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        //키 값에 따라서 이벤트 분기처리 가능
        
        guard let viewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController?.topViewController else { return }
        
        let userInfo = response.notification.request.content.userInfo
        
        //키값에 따른 화면 전환
        if userInfo[AnyHashable("Map")] as? String == "0" {
            viewController.tabBarController?.selectedIndex = 0
        } else if userInfo[AnyHashable("Weather")] as? String == "2" {
            viewController.tabBarController?.selectedIndex = 2
        }
        
    }
    
}

extension AppDelegate: MessagingDelegate {
    //토큰 갱신 모니터링: 토큰 정보가 언제 바뀔까?
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
}

