//
//  UIViewController + TopViewController.swift
//  BicycleRecord
//
//  Created by 이현호 on 2022/10/12.
//

import UIKit

extension UIViewController {
    
    var topViewController: UIViewController? {
        return self.topViewController(currentViewController: self)
    }
    
    //최상위 뷰컨트롤러를 판단해주는 메서드
    //현재 사용자가 있는 최상위 뷰컨트롤러가 뭔지 알 수 있음
    func topViewController(currentViewController: UIViewController) -> UIViewController {
        //탭바컨트롤러와 연결되어 있는 뷰컨일 경우
        if let tabBarController = currentViewController as? UITabBarController, let selectedViewController = tabBarController.selectedViewController {
            
            return self.topViewController(currentViewController: selectedViewController)
            
        //네비게이션이 임베드 되어 있는 뷰컨일 경우
        } else if let navigationController = currentViewController as? UINavigationController, let visibleViewController = navigationController.visibleViewController {
            
            return self.topViewController(currentViewController: visibleViewController)
            
        //일반 뷰컨일 경우
        } else if let presentedViewController = currentViewController.presentedViewController {
            
            return self.topViewController(currentViewController: presentedViewController)
            
        } else {
            return currentViewController
        }
    }
}
