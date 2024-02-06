//
//  UserProfileViewController.swift
//  RecapShopping
//
//  Created by Jaehui Yu on 1/29/24.
//

import UIKit
import SnapKit

enum ValidationError: Error {
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
    var profileImage = Int.random(in: 1...4)
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigation()
        configureHierarchy()
        configureUI()
        configureConstraints()
        
        let profileImageViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageViewTapped))
        profileImageView.addGestureRecognizer(profileImageViewTapGesture)
        nicknameTextField.addTarget(self, action: #selector(nicknameTextFieldStarted), for: .editingDidBegin)
        nicknameTextField.addTarget(self, action: #selector(nicknameTextFieldChanged), for: .editingChanged)
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
    
    func configureUI() {
        setViewBackgroundColor()
        cameraImageView.image = UIImage(named: "camera")
        
        if UserDefaultsManager.shared.profileImage == 0 {
            UserDefaultsManager.shared.profileImage = profileImage
        }
            
        nicknameTextField.text = accessType == .setting ? "" : UserDefaultsManager.shared.nickname // set?
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
    
    @objc func nicknameTextFieldStarted() {
        guard let text = nicknameTextField.text else { return }
        if text.isEmpty {
            completeButton.isEnabled = false
        }
    }
    
    @objc func nicknameTextFieldChanged() {
        guard let text = nicknameTextField.text else { return }
        let forbiddenCharacters = ["@", "#", "$", "%"]
        let forbiddenNumbers = ["0","1","2","3","4","5","6","7","8","9"]
        
        do {
            let _ = try validateUserInputError(text: text)
            stateTextField("사용할 수 있는 닉네임이에요.", color: .point, isEnabled: true)
        } catch {
            switch error {
            case ValidationError.lessThanCount: stateTextField("닉네임은 2글자 이상으로 설정해주세요.", color: .systemRed, isEnabled: false)
            case ValidationError.countExceeded: stateTextField("닉네임은 10글자 이내로 설정해주세요.", color: .systemRed, isEnabled: false)
            case ValidationError.forbiddenCharacters: stateTextField("닉네임에 @, #, $, %를 입력할 수 없어요.", color: .systemRed, isEnabled: false)
            case ValidationError.forbiddenNumbers: stateTextField("닉네임에 숫자는 입력할 수 없어요.", color: .systemRed, isEnabled: false)
            case ValidationError.startBlank: stateTextField("닉네임은 공백으로 시작할 수 없어요.", color: .systemRed, isEnabled: false)
            case ValidationError.continuousBlank: stateTextField("닉네임에 공백을 연속으로 사용할 수 없어요.", color: .red, isEnabled: false)
            default: print(error)
            }
        }
        
        func validateUserInputError(text: String) throws -> Bool {
            guard !(text.count < 2) else { throw ValidationError.lessThanCount }
            guard !(text.count > 10) else { throw ValidationError.countExceeded }
            guard !(forbiddenCharacters.contains { text.contains($0) }) else { throw ValidationError.forbiddenCharacters }
            guard !(forbiddenNumbers.contains { text.contains($0) }) else { throw ValidationError.forbiddenNumbers }
            guard text.first != " " else { throw ValidationError.startBlank }
            guard !text.contains("  ") else { throw ValidationError.continuousBlank }
            return true
        }
        
        func stateTextField(_ text: String, color: UIColor, isEnabled: Bool) {
            nicknameStateLabel.text = text
            nicknameStateLabel.textColor = color
            completeButton.isEnabled = isEnabled
        }
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
