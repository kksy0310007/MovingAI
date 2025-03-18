//
//  LoginViewController.swift
//  MovingAI
//
//  Created by soyoung on 12/13/24.
//

import UIKit
import SnapKit
import Alamofire
import SwiftUICore
import SwiftyToaster

class LoginViewController: UIViewController {
    
    @StateObject var permissionViewModel = PermissionMethod()
    
    private let bottomSheetLayout = UIView()
    private let errorLabel = UILabel()
    let nameField = UITextField()
    let passwordField = UITextField()
    
    var bottomSheetFlag = false
    var isAutoLogin = false
    var id: String = ""
    var pw: String = ""
    
    let userAccount = UserAccountMethods.shared
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 권한 묻기
        permissionViewModel.requestPermission()
        
        // 키보드 이벤트 감지 등록
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.isAutoLogin = UserDefaults.standard.bool(forKey: "isAutoLogin")
        
        if (self.isAutoLogin) {
            let userDefaultsId = UserDefaults.standard.string(forKey: "id") ?? ""
            let userDefaultsPWD = UserDefaults.standard.string(forKey: "pwd") ?? ""
            
            loginAttempt(userName: userDefaultsId, password: userDefaultsPWD, isEncode: true) { result in
                if (result) {
                    // 자동 로그인
                    self.updateUI()
                } else {
                    // 자동 로그인 실패
                    Toaster.shared.makeToast("다시 로그인 해주세요.", .short)
                    self.setUI()
                }
            }
            
        } else {
            setUI()
        }
        
    }
    
    func setUI() {
        
        let backgroundView = UIImageView(frame: view.bounds)
        backgroundView.image = UIImage(named: "background")
        backgroundView.isUserInteractionEnabled = true // 터치 이벤트 차단
        view.addSubview(backgroundView)
        view.sendSubviewToBack(backgroundView)
        
        // 로고 레이아웃
        let logoLayout = UIStackView()
        logoLayout.axis = .vertical
        logoLayout.alignment = .center
        logoLayout.spacing = 8
        view.addSubview(logoLayout)
        logoLayout.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(259)
            make.centerX.equalToSuperview()
        }
                
        let logoImageView = UIImageView(image: UIImage(named: "logo_movingaiwhite"))
        logoImageView.contentMode = .scaleAspectFit
        logoLayout.addArrangedSubview(logoImageView)
        logoImageView.snp.makeConstraints { make in
            make.width.equalTo(150)
            make.height.equalTo(80)
        }
        
        // 버튼 레이아웃
        let buttonLayout = UIStackView()
        buttonLayout.axis = .vertical
        buttonLayout.alignment = .fill
        buttonLayout.spacing = 16
        view.addSubview(buttonLayout)
        buttonLayout.snp.makeConstraints { make in
            make.top.equalTo(logoLayout.snp.bottom).offset(39)
            make.bottom.equalToSuperview().offset(-152)
            make.leading.trailing.equalToSuperview().inset(50)
        }
        
        let signInButton = UIButton(type: .system)
        signInButton.setTitle(("로그인 하기"), for: .normal)
        signInButton.setTitleColor(.white, for: .normal)
        signInButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        signInButton.layer.cornerRadius = 20
        signInButton.clipsToBounds = true
        signInButton.backgroundColor = UIColor(cgColor: CGColor(red: 50/255, green: 83/255, blue: 213/255, alpha: 1.0))
        buttonLayout.addArrangedSubview(signInButton)
        signInButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        // 투명 뷰 추가
        let transparentView = UIView()
        transparentView.backgroundColor = UIColor.clear // 투명 배경색 설정
        view.addSubview(transparentView)
        transparentView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(signInButton.snp.top)
        }
        
        // Bottom Sheet Layout
        bottomSheetLayout.backgroundColor = .white
        bottomSheetLayout.layer.cornerRadius = 20
        bottomSheetLayout.layer.maskedCorners = [
            .layerMinXMinYCorner,  // 왼쪽 위 모서리 둥글게
            .layerMaxXMinYCorner   // 오른쪽 위 모서리 둥글게
        ]
        bottomSheetLayout.clipsToBounds = true
        bottomSheetFlag = false
        bottomSheetLayout.isHidden = true // 초기에는 숨김 상태
        view.addSubview(bottomSheetLayout)
        bottomSheetLayout.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.4)
        }
           
        nameField.placeholder = NSLocalizedString("아이디를 입력하세요.", comment: "")
        nameField.borderStyle = .none
        nameField.font = UIFont.systemFont(ofSize: 16)
        bottomSheetLayout.addSubview(nameField)
        nameField.snp.makeConstraints { make in
            make.top.equalTo(bottomSheetLayout.snp.top).offset(50)
            make.leading.trailing.equalToSuperview().inset(50)
            make.height.equalTo(50)
        }
         
        let lineView = UIView()
        lineView.backgroundColor = UIColor(cgColor: CGColor(red: 123/255, green: 123/255, blue: 123/255, alpha: 1.0))
        bottomSheetLayout.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.top.equalTo(nameField.snp.bottom).offset(3)
            make.leading.trailing.equalTo(nameField)
            make.height.equalTo(1) // 선의 두께 설정
        }
        
        passwordField.placeholder = NSLocalizedString("비밀번호를 입력하세요.", comment: "")
        passwordField.borderStyle = .none
        passwordField.isSecureTextEntry = true
        passwordField.font = UIFont.systemFont(ofSize: 16)
        bottomSheetLayout.addSubview(passwordField)
        passwordField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(lineView.snp.bottom).offset(10)
            make.leading.trailing.equalTo(nameField)
        }

        let lineView2 = UIView()
        lineView2.backgroundColor = UIColor(cgColor: CGColor(red: 123/255, green: 123/255, blue: 123/255, alpha: 1.0))
        bottomSheetLayout.addSubview(lineView2)
        lineView2.snp.makeConstraints { make in
            make.top.equalTo(passwordField.snp.bottom).offset(3)
            make.leading.trailing.equalTo(passwordField)
            make.height.equalTo(1) // 선의 두께 설정
        }
        
        let autoLoginCheckBox = UIButton(type: .system)
        autoLoginCheckBox.tintColor = .clear
        autoLoginCheckBox.backgroundColor = .clear
        autoLoginCheckBox.setTitleColor(.black, for: .normal)
        autoLoginCheckBox.setImage(UIImage(named: "circle_radio_unselected")?.withRenderingMode(.alwaysOriginal), for: .normal)
        autoLoginCheckBox.setImage(UIImage(named: "circle_radio_selected")?.withRenderingMode(.alwaysOriginal), for: .selected)
        autoLoginCheckBox.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        autoLoginCheckBox.imageView?.contentMode = .scaleAspectFit
        autoLoginCheckBox.contentHorizontalAlignment = .left
        
        bottomSheetLayout.addSubview(autoLoginCheckBox)
        autoLoginCheckBox.snp.makeConstraints { make in
            make.height.width.equalTo(20)
            make.top.equalTo(lineView2.snp.bottom).offset(10)
            make.leading.equalTo(nameField)
        }
        
        // 저장된 자동 로그인 값이 있는지 확인
        let userId = UserDefaults.standard.string(forKey: "id")
        if(userId == nil || userId == "") {
            isAutoLogin = false
            autoLoginCheckBox.isSelected = false
        }
        
        let autoLoginLabel = UILabel()
        autoLoginLabel.text = "자동 로그인"
        autoLoginLabel.textColor = .black
        autoLoginLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        bottomSheetLayout.addSubview(autoLoginLabel)
        autoLoginLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.centerY.equalTo(autoLoginCheckBox) // 체크박스와 수평 정렬
            make.leading.equalTo(autoLoginCheckBox.snp.trailing).offset(8) // 간격 설정
        }

        let loginButton = UIButton(type: .system)
        loginButton.setTitle("로그인", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.backgroundColor = UIColor(cgColor: CGColor(red: 50/255, green: 83/255, blue: 213/255, alpha: 1.0))
        loginButton.layer.cornerRadius = 20
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        loginButton.clipsToBounds = true
        bottomSheetLayout.addSubview(loginButton)
        loginButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(autoLoginCheckBox.snp.bottom).offset(40)
            make.leading.trailing.equalTo(nameField)
        }
        
        errorLabel.text = "아이디 혹은 비밀번호가 일치하지 않습니다."
        errorLabel.textColor = UIColor(cgColor: CGColor(red: 241/255, green: 20/255, blue: 43/255, alpha: 1.0))
        errorLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        errorLabel.isHidden = true
        bottomSheetLayout.addSubview(errorLabel)
        errorLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.top.equalTo(autoLoginLabel.snp.bottom).offset(8) // 간격 설정
            make.leading.trailing.equalTo(nameField)
        }
        
        // 로그인 Button Action
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        
        // Sign In Button Action
        signInButton.addTarget(self, action: #selector(didTapSignInButton), for: .touchUpInside)
        
        // 배경 터치 제스처 추가
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapBackgroundView))
        transparentView.addGestureRecognizer(tapGesture)
    
        // 체크박스 선택 상태를 토글하는 액션 추가
        autoLoginCheckBox.addTarget(self, action: #selector(didTapAutoLoginCheckBox), for: .touchUpInside)
    }
    
    @objc private func didTapLoginButton() {
        id = nameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        pw = passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        if (id.isEmpty || pw.isEmpty) {
            errorLabel.isHidden = false
        } else {
            errorLabel.isHidden = true
            print("로그인 버튼 눌림")

            loginAttempt(userName: id, password: pw, isEncode: false) { result in
                if (result) {
                    // 화면 이동
                     DispatchQueue.main.async {
                         self.updateUI()
                     }
                }
            }
        }
    }
    
    @objc private func didTapSignInButton() {
        UIView.animate(withDuration: 0.3) {
            self.bottomSheetLayout.isHidden = false
        }
    }
    
    @objc private func didTapBackgroundView() {
        self.bottomSheetLayout.isHidden = true
        // 키보드 내리기
        view.endEditing(true)
    }
    
    @objc private func didTapAutoLoginCheckBox(_ sender: UIButton) {
        sender.isSelected.toggle() // 선택 상태를 토글
        self.isAutoLogin = sender.isSelected
        print("Auto-login checkbox is now: \(sender.isSelected ? "Selected" : "Unselected")")
    }
    
    deinit {
        // 키보드 이벤트 감지 해제
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }

        let keyboardHeight = keyboardFrame.height

        // BottomSheetLayout를 키보드 높이만큼 위로 이동
        bottomSheetLayout.snp.updateConstraints { make in
            make.bottom.equalToSuperview().inset(keyboardHeight)
        }

        // 애니메이션으로 부드럽게 이동
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        // BottomSheetLayout를 원래 위치로 복원
        bottomSheetLayout.snp.updateConstraints { make in
            make.bottom.equalToSuperview()
        }

        // 애니메이션으로 복원
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func loginAttempt(userName: String, password: String, isEncode: Bool, completion: @escaping (Bool) -> Void) {
        var encodeUserName = ""
        var encodePW = ""
        
        if(!isEncode) {
            let userNameEnc = userName.data(using: .utf8)
            encodeUserName = userNameEnc!.base64EncodedString()
            
            let pwEnc = password.data(using: .utf8)
            encodePW = pwEnc!.base64EncodedString()
        } else {
            encodeUserName = userName
            encodePW = password
        }

                        
        ApiRequest.shared.loginAttempt(encUserName: encodeUserName, encPassword: encodePW) { response, error in
            
            if let userAccount = response {
                if (self.isAutoLogin) {
                    UserDefaults.standard.set(encodeUserName, forKey: "id")
                    UserDefaults.standard.set(encodePW,forKey: "pwd")
                }
                UserDefaults.standard.set(self.isAutoLogin, forKey: "isAutoLogin")
                
               // 싱클톤으로 값 저장
                self.userAccount.name = encodeUserName
                self.userAccount.isAutoLogin = self.isAutoLogin
                self.userAccount.movingAIUserAccount = userAccount
                self.userAccount.id = userAccount.id
                self.userAccount.attachId = userAccount.attach.id
                self.userAccount.attachType = userAccount.attach.attachType ?? "Company"
                self.userAccount.title = userAccount.attach.name
               
                completion(true)
               
            } else {
                print("실패하였습니다 :: \(error)" )
                self.errorLabel.text = "일치하는 회원정보가 없습니다."
                self.errorLabel.isHidden = false
                
                completion(false)
            }
        }
    }
    
    func updateUI() {
        print("이동시켜라" )
        guard let customTabBarVC = self.storyboard?.instantiateViewController(withIdentifier: "CustomTabBarController") as? CustomTabBarController else { return }
        self.navigationController?.pushViewController(customTabBarVC, animated: true)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false // 제스처 막기
    }
}

