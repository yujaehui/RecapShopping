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
