//
//  OnboardingViewController.swift
//  RecapShopping
//
//  Created by Jaehui Yu on 1/19/24.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    @IBOutlet var sesacShoppingImageView: UIImageView!
    @IBOutlet var onboardingImageView: UIImageView!
    @IBOutlet var startButton: UIButton!
    
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        startButton.addTarget(self, action: #selector(startButtonClicked), for: .touchUpInside)
    }
    
    @objc func startButtonClicked() {
        let sb = UIStoryboard(name: "Profile", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: ProfileViewController.identifier) as! ProfileViewController
        vc.accessType = .setting
        navigationController?.pushViewController(vc, animated: true)
        
        let content = UNMutableNotificationContent()
        content.title = "지금 쇼핑 어때요?"
        content.body = "당신이 원하는 그 상품이 할인 중일지도 몰라요🤫"
        let timeTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 10800, repeats: true)
//        var component = DateComponents()
//        component.hour = 3
//        let calenderTrigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: false)
        let request = UNNotificationRequest(identifier: "\(Date())", content: content, trigger: timeTrigger)
        UNUserNotificationCenter.current().add(request)
    }
}

// MARK: configureUI
extension OnboardingViewController {
    func configureUI() {
        setViewBackgroundColor()
        sesacShoppingImageView.image = UIImage(named: "sesacShopping")
        onboardingImageView.image = UIImage(named: "onboarding")
        startButton.greenButton("시작하기")
    }
}
