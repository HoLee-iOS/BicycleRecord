//
//  NetworkMonitor.swift
//  BicycleRecord
//
//  Created by 이현호 on 2022/09/28.
//

import Foundation
import Network
import UIKit

final class NetworkMonitor{
    
    static let shared = NetworkMonitor()

    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    public private(set) var isConnected: Bool = false
    public private(set) var connectionType:ConnectionType = .unknown

    //MARK: 연결타입
    enum ConnectionType {
        case wifi
        case cellular
        case ethernet
        case unknown
    }

    private init(){
        print("init 호출")
        monitor = NWPathMonitor()
    }

    public func startMonitoring(){
        print("startMonitoring 호출")
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            print("path :\(path)")

            self?.isConnected = path.status == .satisfied
            self?.getConenctionType(path)

            if self?.isConnected == true {
                print("연결이된 상태임!")
            }else{
                print("연결 안된 상태임!")

            }
        }
    }

    public func stopMonitoring(){
        print("stopMonitoring 호출")
        monitor.cancel()
    }


    private func getConenctionType(_ path:NWPath) {
        print("getConenctionType 호출")
        if path.usesInterfaceType(.wifi){
            connectionType = .wifi
            print("wifi에 연결")

        }else if path.usesInterfaceType(.cellular) {
            connectionType = .cellular
            print("cellular에 연결")

        }else if path.usesInterfaceType(.wiredEthernet) {
            connectionType = .ethernet
            print("wiredEthernet에 연결")

        }else {
            connectionType = .unknown
            print("unknown ..")
        }
    }

    func showAlert() -> UIAlertController {
        let requestNetworkServiceAlert = UIAlertController(title: "네트워크 이용", message: "네트워크 연결 상태를 확인해주세요.", preferredStyle: .alert)
        let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in

            //설정까지 이동하거나 설정 세부화면까지 이동하거나
            //한 번도 설정 앱에 들어가지 않았거나, 막 다운받은 앱이거나 - 설정
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }

        }
        let cancel = UIAlertAction(title: "종료", style: .default) { _ in
            UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                exit(0)
            }
        }
        requestNetworkServiceAlert.addAction(cancel)
        requestNetworkServiceAlert.addAction(goSetting)

        return requestNetworkServiceAlert
    }
}


