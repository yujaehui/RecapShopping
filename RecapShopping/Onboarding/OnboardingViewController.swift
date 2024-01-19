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
        
        view.backgroundColor = .background
        
        sesacShoppingImageView.image = UIImage(named: "sesacShopping")
        onboardingImageView.image = UIImage(named: "onboarding")
        startButton.primaryButton("시작하기")
        
    }
}

extension UIButton {
    func primaryButton(_ title: String) {
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = .boldSystemFont(ofSize: 18)
        self.backgroundColor = .point
        self.tintColor = .text
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
}
