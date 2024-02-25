//
//  UserProfileViewController.swift
//  RecapShopping
//
//  Created by Jaehui Yu on 1/29/24.
//

import UIKit
import SnapKit

enum ValidationError: Error {
    case isEmpty
    case sameAsBefore
    case lessThanCount
    case countExceeded
    case forbiddenCharacters
    case forbiddenNumbers
    case startBlank
    case continuousBlank
}

class UserProfileViewController: UIViewController {
    
    let profileImageView = ProfileImageView(frame: .zero)
    let cameraImageView = UIImageView()
    let nicknameTextField = NicknameTextField()
    let nicknameStateLabel = UILabel()
    let completeButton = PointColorButton()
    
    var accessType: AccessType = .setting
    var userNickname = ""
    
    let viewModel = ProfileViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.outputText.bind { value in
            self.nicknameStateLabel.text = value
        }
        
        viewModel.outputColor.bind { value in
            self.nicknameStateLabel.textColor = value ? .point : .systemRed
            self.completeButton.backgroundColor = value ? .point : .systemGray
        }
        
        viewModel.outputIsEnabled.bind { value in
            self.completeButton.isEnabled = value
        }
        
        setNavigation()
        configureHierarchy()
        configureView()
        configureConstraints()
        
        let profileImageViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageViewTapped))
        profileImageView.addGestureRecognizer(profileImageViewTapGesture)
        nicknameTextField.addTarget(self, action: #selector(nicknameTextFieldChanged), for: .allEditingEvents)
        completeButton.addTarget(self, action: #selector(completeButtonClicked), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let profileImage = UserDefaultsManager.shared.profileImage
        profileImageView.image = UIImage(named: "profile\(profileImage)")
    }
    
    func setNavigation() {
        navigationItem.title = accessType == .setting ? "프로필 설정" : "프로필 수정"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.text]
        navigationController?.navigationBar.tintColor = .text
        navigationItem.backButtonTitle = ""
        navigationItem.backBarButtonItem?.action = #selector(backButtonClicked)
    }
    
    @objc func backButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    func configureHierarchy() {
        view.addSubview(profileImageView)
        view.addSubview(cameraImageView)
        view.addSubview(nicknameTextField)
        view.addSubview(nicknameStateLabel)
        view.addSubview(completeButton)
    }
    
    func configureView() {
        setViewBackgroundColor()
        cameraImageView.image = UIImage(named: "camera")
        
        if UserDefaultsManager.shared.profileImage == 0 {
            UserDefaultsManager.shared.profileImage = Int.random(in: 1...4)
        }
            
        nicknameTextField.text = userNickname // set?
        nicknameTextField.attributedPlaceholder = NSAttributedString(string: "닉네임을 입력해주세요 :)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        nicknameTextField.underLine(viewSize: view.bounds.width, color: .text)
        
        nicknameStateLabel.text = ""
        nicknameStateLabel.font = FontStyle.tertiary
        
        completeButton.setTitle("완료", for: .normal)
    }
    
    func configureConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.width.height.equalTo(120)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        cameraImageView.snp.makeConstraints { make in
            make.trailing.equalTo(profileImageView.snp.trailing)
            make.bottom.equalTo(profileImageView.snp.bottom)
            make.width.height.equalTo(40)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(32)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(34)
        }
        
        nicknameStateLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(32)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        completeButton.snp.makeConstraints { make in
            make.top.equalTo(nicknameStateLabel.snp.bottom).offset(32)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(40)
        }
        
    }
    
    @objc func profileImageViewTapped() {
        let vc = UserProfileImageViewController()
        vc.type = accessType
        vc.userSelect = UserDefaultsManager.shared.profileImage
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func nicknameTextFieldChanged() {
        viewModel.inputText.value = nicknameTextField.text ?? ""
    }
    
    @objc func completeButtonClicked() {
        guard let text = nicknameTextField.text else { return }
        userNickname = text
        UserDefaultsManager.shared.nickname = userNickname // get?
        
        if accessType == .setting { // 기존의 온보딩 화면과 프로필 '설정' 화면을 메모리에서 지움
            UserDefaults.standard.setValue(true, forKey: "UserState")
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            let sceneDelegate = windowScene?.delegate as? SceneDelegate
            let sb = UIStoryboard(name: "Search", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "mainTabBarController") as! UITabBarController
            vc.tabBar.backgroundColor = .background
            vc.tabBar.tintColor = .point
            vc.tabBar.barTintColor = .secondaryLabel
            sceneDelegate?.window?.rootViewController = vc
            sceneDelegate?.window?.makeKeyAndVisible()
        } else { // setting이 아니고 edit인 경우에는 화면을 새로 그릴 필요는 없음
            navigationController?.popViewController(animated: true)
        }
    }
}
