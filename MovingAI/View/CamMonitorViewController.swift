//
//  CamMonitorViewController.swift
//  MovingAI
//
//  Created by soyoung on 12/20/24.
//

import UIKit

class CamMonitorViewController: UIViewController {

    // 버튼 보임/가림 처리
    var monitorButtnFlag = true
    
    // 모니터 뷰
    var monitorView = UIView()
    var monitorButtonsView = UIView()
    
    // 모니터 뷰 버튼
    let channelSwitch: CustomSwitch = {
        let view = CustomSwitch()
        view.barColor = .lightGray
        view.circleColor = .white
        view.isUserInteractionEnabled = true
        view.addTarget(self, action: #selector(channelSwitchAction), for: .touchUpInside)
        return view
    }()
    
    private let channelLabel : UILabel = {
        let label = UILabel()
        label.text = "Ch 1"
        label.textColor = .white
        return label
    }()
    
    var fullScreenButton: UIButton! = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.tintColor = .white
        let image = UIImage(systemName: "viewfinder")!
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(fullScreenButtonAction), for: .touchUpInside)
        return button
    }()
    
    // 컨트롤러 뷰
    var controllerView = UIView()
    
    // 컨트롤러 뷰 버튼
    // 음성송출 버튼
    var micImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "microphone.fill")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.tintColor = .gray
        image.backgroundColor = .clear
        image.contentMode = .scaleAspectFit
        return image
    }()
    var micLabel : UILabel = {
        let label = UILabel()
        label.text = "음성송출"
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()
    
    var micView = UIView()
    
    // 안내방송 버튼
    var playImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "play.square.stack.fill")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.tintColor = .gray
        image.backgroundColor = .clear
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    var playLabel : UILabel = {
        let label = UILabel()
        label.text = "안내방송"
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()
    
    var playView = UIView()

    
    var onButton: UIButton! = {
        let button = UIButton()
        button.setTitle("ON", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .lightGray
        button.tintColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        button.layer.cornerRadius = 5
        let image = UIImage(systemName: "repeat.circle.fill")!
        button.setImage(image, for: .normal)
        button.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 5)
        button.addTarget(self, action: #selector(onButtonButtonAction), for: .touchUpInside)
        return button
    }()
    
    var offButton: UIButton! = {
        let button = UIButton()
        button.setTitle("OFF", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(.black, for: .normal)
        let image = UIImage(systemName: "repeat.circle.fill")!
        button.setImage(image, for: .normal)
        button.layer.cornerRadius = 5
        button.backgroundColor = .lightGray
        button.tintColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        button.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 5)
        button.addTarget(self, action: #selector(offButtonButtonAction), for: .touchUpInside)
        return button
    }()
    
    let bottomView = UIView()
    
    var plusButton: UIButton! = {
        let button = UIButton()
        button.tintColor = .white
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .light)
        let image = UIImage(systemName: "plus.circle", withConfiguration: imageConfig)
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 3, height: 3)
        button.contentMode = .scaleToFill
        button.setImage(image, for: .normal)
        return button
    }()
    
    var minusButton: UIButton! = {
        let button = UIButton()
        button.tintColor = .white
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .light)
        let image = UIImage(systemName: "minus.circle", withConfiguration: imageConfig)
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 3, height: 3)
        button.contentMode = .scaleToFill
        button.setImage(image, for: .normal)
        return button
    }()

    let controllerBackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(_colorLiteralRed: 226/255, green: 226/255, blue: 226/255, alpha: 1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true // 터치 이벤트 차단
        view.layer.cornerRadius = 100
        view.layer.borderWidth = 3
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 3, height: 3)
        view.layer.borderColor = UIColor.white.cgColor
        return view
    }()
    
    var NButton: UIButton! = {
        let button = UIButton()
        button.tintColor = .gray
        button.setTitle("N", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.gray, for: .highlighted)
        button.layer.cornerRadius = 32
        button.setTitleColor(UIColor(_colorLiteralRed: 226/255, green: 226/255, blue: 226/255, alpha: 1.0), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.addTarget(self, action: #selector(NButtonAction), for: .touchUpInside)
        return button
    }()
    
    var SButton: UIButton! = {
        let button = UIButton()
        button.tintColor = .gray
        button.setTitle("S", for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.backgroundColor = .white
        button.layer.cornerRadius = 32
        button.setTitleColor(UIColor(_colorLiteralRed: 226/255, green: 226/255, blue: 226/255, alpha: 1.0), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.addTarget(self, action: #selector(SButtonAction), for: .touchUpInside)
        return button
    }()
    
    var EButton: UIButton! = {
        let button = UIButton()
        button.tintColor = .gray
        button.setTitle("E", for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.backgroundColor = .white
        button.layer.cornerRadius = 32
        button.setTitleColor(UIColor(_colorLiteralRed: 226/255, green: 226/255, blue: 226/255, alpha: 1.0), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.addTarget(self, action: #selector(EButtonAction), for: .touchUpInside)
        return button
    }()
    
    var WButton: UIButton! = {
        let button = UIButton()
        button.tintColor = .gray
        button.setTitle("W", for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.backgroundColor = .white
        button.layer.cornerRadius = 32
        button.setTitleColor(UIColor(_colorLiteralRed: 226/255, green: 226/255, blue: 226/255, alpha: 1.0), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.addTarget(self, action: #selector(WButtonAction), for: .touchUpInside)
        return button
    }()
    
    var monitorFullScreenView = UIView()
    var monitorFullScreenButtonsView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 상단 타이틀 바
        addNavigationBar(titleString: "실시간 영상",isBackButtonVisible: true)
        
        initMonitorView()
        initControllerView()
    }

    private func initMonitorView() {
        
        // 1. 작은화면 모니터 image view
        self.view.addSubview(monitorView)
        monitorView.backgroundColor = .black
        monitorView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        
        
        // 2. 작은화면 버튼
        self.view.addSubview(monitorButtonsView)
        monitorButtonsView.isUserInteractionEnabled = true
        monitorButtonsView.backgroundColor = .clear
        monitorButtonsView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(monitorView.snp.height)
        }
        
        // 배경 터치 제스처 추가
        let tapViewGesture = UITapGestureRecognizer(target: self, action: #selector(didTapMonitorView))
        let tapButtonsViewGesture = UITapGestureRecognizer(target: self, action: #selector(didTapMonitorButtonsView))
        
        monitorView.addGestureRecognizer(tapViewGesture)
        monitorButtonsView.addGestureRecognizer(tapButtonsViewGesture)
        
        // 버튼 추가
        self.monitorButtonsView.addSubview(channelSwitch)
        self.monitorButtonsView.addSubview(channelLabel)
        
        channelSwitch.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(15)
            make.height.equalTo(40)
            make.width.equalTo(80)
        }
        
        channelLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(20)
        }
        
        // 라벨 추가
        self.monitorButtonsView.addSubview(fullScreenButton)
        
        fullScreenButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.width.equalTo(54)
        }
        
        
        setMonitorButtonsViewFlag()
        
        
        
        // 5. 큰화면 모니터 image view    full screen
        // 6. 큰화면 버튼 컨트롤러.                                  -> 보이고 안보이고
        // 7. 장비 리스트
        // 8. 음성 송출 팝업 view
        // 9. 안내방송 팝업 view
        
        
    }
    
    private func initControllerView() {
        // 3. 작은화면 버튼 컨트롤러 - 1 (음성송출, 안내방송, 카메라 회전).  -> 보이고 안보이고
        // 4. 작은화면 버튼 컨트롤러 - 2 (상하좌우, 확대/축소)
        self.view.addSubview(controllerView)
        controllerView.backgroundColor = .white
        controllerView.snp.makeConstraints { make in
            make.top.equalTo(monitorView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(100)
        }
        
        controllerView.addSubview(micImageView)
        controllerView.addSubview(playImageView)
        controllerView.addSubview(micLabel)
        controllerView.addSubview(playLabel)
        controllerView.addSubview(micView)
        controllerView.addSubview(playView)
        
        micImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.width.height.equalTo(40)
        }
        
        micLabel.snp.makeConstraints { make in
            make.centerX.equalTo(micImageView)
            make.top.equalTo(micImageView.snp.bottom).offset(5)
        }
        
        micView.backgroundColor = .clear
        micView.snp.makeConstraints { make in
            make.top.equalTo(micImageView.snp.top).offset(-7)
            make.bottom.equalTo(micLabel.snp.bottom).offset(5)
            make.trailing.equalTo(micLabel.snp.trailing)
            make.leading.equalTo(micLabel.snp.leading)
        }
        
        let tapMicViewGesture = UITapGestureRecognizer(target: self, action: #selector(didTapMicView))
        
        micView.addGestureRecognizer(tapMicViewGesture)
        
        playImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.equalTo(micImageView.snp.trailing).offset(25)
            make.top.equalToSuperview().offset(20)
            make.width.height.equalTo(40)
        }
        
        playLabel.snp.makeConstraints { make in
            make.centerX.equalTo(playImageView)
            make.top.equalTo(playImageView.snp.bottom).offset(5)
        }
        
        playView.backgroundColor = .clear
        playView.snp.makeConstraints { make in
            make.top.equalTo(playImageView.snp.top).offset(-7)
            make.bottom.equalTo(playLabel.snp.bottom).offset(5)
            make.trailing.equalTo(playLabel.snp.trailing)
            make.leading.equalTo(playLabel.snp.leading)
        }
        
        let tapPlayViewGesture = UITapGestureRecognizer(target: self, action: #selector(didTapPlayView))
        
        playView.addGestureRecognizer(tapPlayViewGesture)
        
        controllerView.addSubview(onButton)
        controllerView.addSubview(offButton)
        
        onButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalTo(playImageView.snp.trailing).offset(30)
            make.width.equalTo(80)
            make.height.equalTo(35)
        }
        
        offButton.snp.makeConstraints { make in
            make.centerX.equalTo(onButton)
            make.top.equalTo(onButton.snp.bottom).offset(10)
            make.width.equalTo(80)
            make.height.equalTo(35)
        }
        
        bottomView.backgroundColor = UIColor(cgColor: CGColor(red: 207/255, green: 207/255, blue: 207/255, alpha: 1.0))
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(controllerView.snp.bottom)
        }
        
        bottomView.addSubview(plusButton)
        bottomView.addSubview(minusButton)
        
        plusButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.leading.equalToSuperview().offset(48)
            make.height.width.equalTo(84)
        }
        
        minusButton.snp.makeConstraints { make in
            make.top.equalTo(plusButton.snp.bottom).offset(10)
            make.centerX.equalTo(plusButton.snp.centerX)
            make.height.width.equalTo(84)
        }
        
        bottomView.addSubview(controllerBackView)
        controllerBackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-20)
            make.trailing.equalToSuperview().offset(-40)
            make.height.width.equalTo(200)
        }
        
        controllerBackView.addSubview(NButton)
        controllerBackView.addSubview(SButton)
        controllerBackView.addSubview(EButton)
        controllerBackView.addSubview(WButton)
        
        NButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview().multipliedBy(1)
            make.height.width.equalTo(64)
        }
        
        SButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview().multipliedBy(1)
            make.height.width.equalTo(64)
        }
        
        EButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview().multipliedBy(1)
            make.height.width.equalTo(64)
        }
        
        WButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-10)
            make.centerX.equalToSuperview().multipliedBy(1)
            make.height.width.equalTo(64)
        }
    }
    
    
    
    func setMonitorButtonsViewFlag() {
        if (monitorButtnFlag) {
            monitorButtonsView.isHidden = false
        } else {
            monitorButtonsView.isHidden = true
        }
    }
    
    
    // MARK: - Actions
    @objc func channelSwitchAction(sender: CustomSwitch) {
        if sender.isOn {
            print("select channel2ButtonAction")
            self.channelLabel.text = "Ch 2"
        } else {
            print("select channel1ButtonAction")
            self.channelLabel.text = "Ch 1"
        }
    }
    
    
    @objc func fullScreenButtonAction(sender: UIButton) {
        print("select fullScreenButtonAction")
        
    }
    
    @objc func didTapMonitorButtonsView(sender: UITapGestureRecognizer) {
        // 터치 위치가 channelSwitch 내부인지 확인
        let touchLocation = sender.location(in: monitorButtonsView)
        
        // 터치가 channelSwitch의 영역 안에 있지 않으면 버튼을 숨기기
        if !channelSwitch.frame.contains(touchLocation) {
            print("select didTapMonitorButtonsView")
            monitorButtnFlag = false
            setMonitorButtonsViewFlag()
        } else {
            if self.channelSwitch.isOn {
                self.channelSwitch.isOn = false
            } else {
                self.channelSwitch.isOn = true
            }
            
        }
    }
    
    @objc func didTapMonitorView() {
        print("select didTapMonitorView")
        monitorButtnFlag = true
        
        setMonitorButtonsViewFlag()
    }
    
    @objc func onButtonButtonAction(sender: UIButton) {
        print("select onButtonButtonAction")
        
    }
    
    @objc func offButtonButtonAction(sender: UIButton) {
        print("select offButtonButtonAction")
        
    }
    
    @objc func didTapMicView() {
        print("select didTapMicView")
        
    }
    
    @objc func didTapPlayView() {
        print("select didTapPlayView")
        
    }
    
    @objc func NButtonAction(sender: UIButton) {
        print("select NButtonAction")
        
    }
    
    @objc func EButtonAction(sender: UIButton) {
        print("select EButtonAction")
        
    }
    
    @objc func SButtonAction(sender: UIButton) {
        print("select SButtonAction")
        
    }
    
    @objc func WButtonAction(sender: UIButton) {
        print("select WButtonAction")
        
    }
}
