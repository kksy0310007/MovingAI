//
//  CamMonitorViewController.swift
//  MovingAI
//
//  Created by soyoung on 12/20/24.
//

import UIKit
import SnapKit
import SwiftyToaster
import Starscream
import Alamofire
import AVFoundation

class CamMonitorViewController: UIViewController, URLSessionDelegate {

    let ZOOM_IN_VALUE: CGFloat = 1.5
    let ZOOM_OUT_VALUE: CGFloat = 0.65
    let MAX_SCALE: CGFloat = 3.3
    let MIN_SCALE: CGFloat = 1
    
    var titleString: String? = ""
    let nxCamData = NxCamMethods.shared
    var selectedDeviceData: NxCamDeviceInfo? = nil
    
    // 버튼 보임/가림 처리
    var monitorButtnFlag = true
    var monitorFullScreenButtonFlag = true
    
    // fullView에서 화면 돌리기 flag
    var isInitSettting = true
    
    var camChannel = "1"
    
    // 모니터 뷰
    var monitorView = UIView()
    var monitorImageView = UIImageView()
    var monitorButtonsView = UIView()
    
    private var isFullScreen: Bool = false
    
    // WebSocket 인스턴스
    private var socket: WebSocket?
    private var Rtpsocket: WebSocket?
        
    var presetServerDataList: [PresetManageData] = []
    var devicePresetList: [PresetManageData] = []
    var presetDataList: [PresetData] = []
    
    private var isRecording = false
    var audioStreamingManager = AudioStreamingManager()
    
    // 하단 넥서스캠 리스트 bottomSheet
    let sheet = BottomSheetView()
    private var sheetHeightConstraint: Constraint?
    private let minSheetHeight: CGFloat = 45
    private let maxSheetHeight: CGFloat = 250
    
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
        button.addTarget(self, action: #selector(onButtonAction), for: .touchUpInside)
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
        button.addTarget(self, action: #selector(offButtonAction), for: .touchUpInside)
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
        button.addTarget(self, action: #selector(plusButtonAction), for: .touchUpInside)
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
        button.addTarget(self, action: #selector(minusButtonAction), for: .touchUpInside)
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
    
    // fullScreen
    var monitorFullScreenView = UIView()
    var monitorFullScreenImageView = UIImageView()
    var monitorFullScreenButtonsView = UIView()
    
    let fullScreenChannelSwitch: CustomSwitch = {
        let view = CustomSwitch()
        view.barColor = .lightGray
        view.circleColor = .white
        view.isUserInteractionEnabled = true
        view.addTarget(self, action: #selector(fullScreenChannelSwitchAction), for: .touchUpInside)
        return view
    }()
    
    private let fullScreenChannelLabel : UILabel = {
        let label = UILabel()
        label.text = "Ch 1"
        label.textColor = .white
        return label
    }()
    
    private let fullScreenBackButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(fullScreenBackButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // 음성송출 버튼
    var fullScreenMicButton: UIButton = {
        let button = UIButton()
        button.tintColor = .lightGray
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .light)
        let image = UIImage(systemName: "microphone.fill", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(didTapMicView), for: .touchUpInside)
        return button
    }()
    
    // 안내방송 버튼
    var fullScreenPlayButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .light)
        let image = UIImage(systemName: "play.square.stack.fill", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.tintColor = .lightGray
        button.addTarget(self, action: #selector(didTapPlayView), for: .touchUpInside)
        return button
    }()
    
    var fullScreenOnButton: UIButton! = {
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
        button.addTarget(self, action: #selector(onButtonAction), for: .touchUpInside)
        return button
    }()
    
    var fullScreenOffButton: UIButton! = {
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
        button.addTarget(self, action: #selector(offButtonAction), for: .touchUpInside)
        return button
    }()
    
    var fullScreenPlusButton: UIButton! = {
        let button = UIButton()
        button.tintColor = .white
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .light)
        let image = UIImage(systemName: "plus.circle", withConfiguration: imageConfig)
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 3, height: 3)
        button.contentMode = .scaleToFill
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(fullScreenPlusButtonAction), for: .touchUpInside)
        return button
    }()
    
    var fullScreenMinusButton: UIButton! = {
        let button = UIButton()
        button.tintColor = .white
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .light)
        let image = UIImage(systemName: "minus.circle", withConfiguration: imageConfig)
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 3, height: 3)
        button.contentMode = .scaleToFill
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(fullScreenMinusButtonAction), for: .touchUpInside)
        return button
    }()
    
    let fullScreenControllerBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear//UIColor(_colorLiteralRed: 226/255, green: 226/255, blue: 226/255, alpha: 1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true // 터치 이벤트 차단
        view.layer.cornerRadius = 75
        view.layer.borderWidth = 3
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 3, height: 3)
        view.layer.borderColor = UIColor.clear.cgColor//UIColor.white.cgColor
        return view
    }()
    
    var fullScreenNButton: UIButton! = {
        let button = UIButton()
        button.tintColor = .gray
        button.setTitle("N", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.gray, for: .highlighted)
        button.layer.cornerRadius = 25
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(NButtonAction), for: .touchUpInside)
        return button
    }()
    
    var fullScreenSButton: UIButton! = {
        let button = UIButton()
        button.tintColor = .gray
        button.setTitle("S", for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.backgroundColor = .white
        button.layer.cornerRadius = 25
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(SButtonAction), for: .touchUpInside)
        return button
    }()
    
    var fullScreenEButton: UIButton! = {
        let button = UIButton()
        button.tintColor = .gray
        button.setTitle("E", for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.backgroundColor = .white
        button.layer.cornerRadius = 25
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(EButtonAction), for: .touchUpInside)
        return button
    }()
    
    var fullScreenWButton: UIButton! = {
        let button = UIButton()
        button.tintColor = .gray
        button.setTitle("W", for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.backgroundColor = .white
        button.layer.cornerRadius = 25
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(WButtonAction), for: .touchUpInside)
        return button
    }()
    
    deinit {
      socket?.disconnect()
      socket?.delegate = nil
        
      Rtpsocket?.disconnect()
      Rtpsocket?.delegate = nil
    }
    
    func reloadViewController() {
        // 현재 ViewController의 root view를 다시 로드
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        // 데이터 갱신 작업
        self.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        socket?.delegate = self
//        socket?.connect()
//        
//        Rtpsocket?.delegate = self
//        Rtpsocket?.connect()
//
//        reloadViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 상단 타이틀 바
        if titleString == nil || titleString == "" {
            titleString = "실시간 영상"
        }
        addNavigationBar(titleString: titleString!,isBackButtonVisible: true)
        
        initMonitorView()
        initControllerView()
        initFullMonitorView()
        
        
        checkSelectedDeviceData()
        initPresetVoiceData()
        
        setupWebSocket()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        socket?.disconnect()
        socket?.delegate = nil
          
        Rtpsocket?.disconnect()
        Rtpsocket?.delegate = nil
        
        navigationController?.popViewController(animated: true)
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
        
        monitorView.addSubview(monitorImageView)
        monitorImageView.transform = CGAffineTransform(scaleX: MIN_SCALE, y: MIN_SCALE)
        monitorImageView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
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
        
        WButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview().multipliedBy(1)
            make.height.width.equalTo(64)
        }
        
        EButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview().multipliedBy(1)
            make.height.width.equalTo(64)
        }
        
        SButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-10)
            make.centerX.equalToSuperview().multipliedBy(1)
            make.height.width.equalTo(64)
        }
        
        
        // 하단 장비 리스트
        self.bottomView.addSubview(sheet)
        sheet.delegate = self
        sheet.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            sheetHeightConstraint = make.height.equalTo(minSheetHeight).constraint
        }
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action:
                #selector(handlePanGesture))
                
        gestureRecognizer.cancelsTouchesInView = false
        sheet.addGestureRecognizer(gestureRecognizer)
    }
    
    func initFullMonitorView() {
        // 5. 큰화면 모니터 image view    full screen
        // 6. 큰화면 버튼 컨트롤러.                                  -> 보이고 안보이고
        
        monitorFullScreenView.backgroundColor = .black
        monitorFullScreenButtonsView.backgroundColor = .clear
        
        view.addSubview(monitorFullScreenView)
        monitorFullScreenView.addSubview(monitorFullScreenButtonsView)
        monitorFullScreenView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.leading.trailing.equalToSuperview()
        }
        self.view.bringSubviewToFront(monitorFullScreenView)
        
        
        monitorFullScreenView.addSubview(monitorFullScreenImageView)
        monitorFullScreenImageView.contentMode = .scaleAspectFill
        monitorFullScreenImageView.transform = CGAffineTransform(scaleX: MIN_SCALE, y: MIN_SCALE)
        monitorFullScreenImageView.rotate(angle: 90)
        monitorFullScreenImageView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        monitorFullScreenView.addSubview(monitorFullScreenButtonsView)
        monitorFullScreenButtonsView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        let tapFullScreenViewGesture = UITapGestureRecognizer(target: self, action: #selector(didTapMonitorFullScreenView))
        let tapFullScreenButtonsViewGesture = UITapGestureRecognizer(target: self, action: #selector(didTapMonitorFullScreenButtonsView))
        monitorFullScreenView.addGestureRecognizer(tapFullScreenViewGesture)
        monitorFullScreenButtonsView.addGestureRecognizer(tapFullScreenButtonsViewGesture)
        
        self.monitorFullScreenButtonsView.addSubview(fullScreenChannelSwitch)
        self.monitorFullScreenButtonsView.addSubview(fullScreenChannelLabel)
        self.monitorFullScreenButtonsView.addSubview(fullScreenBackButton)
        
        fullScreenBackButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-30)
            make.top.equalToSuperview()
        }
        
        fullScreenChannelLabel.snp.makeConstraints { make in
            make.top.equalTo(fullScreenBackButton.snp.bottom).offset(25)
            make.centerX.equalTo(fullScreenBackButton.snp.centerX)
        }
        
        fullScreenChannelSwitch.snp.makeConstraints { make in
            make.centerX.equalTo(fullScreenBackButton.snp.centerX)
            make.bottom.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(80)
        }
     
        
        self.monitorFullScreenButtonsView.addSubview(fullScreenOnButton)
        
        fullScreenOnButton.snp.makeConstraints { make in
            make.centerY.equalTo(fullScreenChannelSwitch.snp.centerY)
            make.centerX.equalToSuperview().multipliedBy(0.6)
            make.width.equalTo(60)
            make.height.equalTo(30)
        }
        
        self.monitorFullScreenButtonsView.addSubview(fullScreenOffButton)
        fullScreenOffButton.snp.makeConstraints { make in
            make.centerY.equalTo(fullScreenChannelSwitch.snp.centerY)
            make.trailing.equalTo(fullScreenOnButton.snp.leading).offset(10)
            make.width.equalTo(60)
            make.height.equalTo(30)
        }
        
        self.monitorFullScreenButtonsView.addSubview(fullScreenPlayButton)
        fullScreenPlayButton.snp.makeConstraints { make in
            make.leading.equalTo(fullScreenOnButton.snp.trailing)
            make.centerY.equalTo(fullScreenChannelSwitch.snp.centerY)
            make.width.height.equalTo(60)
        }
        
        self.monitorFullScreenButtonsView.addSubview(fullScreenMicButton)
        fullScreenMicButton.snp.makeConstraints { make in
            make.centerY.equalTo(fullScreenChannelSwitch.snp.centerY)
            make.leading.equalTo(fullScreenPlayButton.snp.trailing)
            make.width.height.equalTo(60)
        }
        
        self.monitorFullScreenButtonsView.addSubview(fullScreenPlusButton)
        fullScreenPlusButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(40)
            make.bottom.equalTo(fullScreenMicButton.snp.top).offset(-20)
            make.width.height.equalTo(40)
        }
        
        self.monitorFullScreenButtonsView.addSubview(fullScreenMinusButton)
        fullScreenMinusButton.snp.makeConstraints { make in
            make.centerY.equalTo(fullScreenPlusButton)
            make.trailing.equalTo(fullScreenPlusButton.snp.leading).offset(-60)
            make.width.height.equalTo(40)
        }
        
        self.monitorFullScreenButtonsView.addSubview(fullScreenControllerBackView)
        fullScreenControllerBackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.equalToSuperview().offset(15)
            make.width.height.equalTo(130)
        }
        
        fullScreenControllerBackView.addSubview(fullScreenNButton)
        fullScreenControllerBackView.addSubview(fullScreenSButton)
        fullScreenControllerBackView.addSubview(fullScreenEButton)
        fullScreenControllerBackView.addSubview(fullScreenWButton)
        
        fullScreenWButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview().multipliedBy(1)
            make.height.width.equalTo(50)
        }
        
        fullScreenSButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(1)
            make.height.width.equalTo(50)
        }
        
        fullScreenNButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(1)
            make.height.width.equalTo(50)
        }
        
        fullScreenEButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview().multipliedBy(1)
            make.height.width.equalTo(50)
        }
        
        setMonitorFullScreenButtonsViewFlag()
        monitorFullScreenView.isHidden = true
        isFullScreen = false
        
        
        if isInitSettting {
            fullScreenBackButton.rotate(angle: 90)
            fullScreenChannelLabel.rotate(angle: 90)
            fullScreenChannelSwitch.rotate(angle: 90)
            fullScreenOnButton.rotate(angle: 90)
            fullScreenOffButton.rotate(angle: 90)
            fullScreenPlayButton.rotate(angle: 90)
            fullScreenMicButton.rotate(angle: 90)
            fullScreenPlusButton.rotate(angle: 90)
            fullScreenMinusButton.rotate(angle: 90)
            
            fullScreenNButton.rotate(angle: 90)
            fullScreenSButton.rotate(angle: 90)
            fullScreenEButton.rotate(angle: 90)
            fullScreenWButton.rotate(angle: 90)
            
            isInitSettting = false
        }
        
    }
    
    
    func setMonitorButtonsViewFlag() {
        if (monitorButtnFlag) {
            monitorButtonsView.isHidden = false
        } else {
            monitorButtonsView.isHidden = true
        }
    }
    
    func setMonitorFullScreenButtonsViewFlag() {
        if (monitorFullScreenButtonFlag) {
            monitorFullScreenButtonsView.isHidden = false
        } else {
            monitorFullScreenButtonsView.isHidden = true
        }
    }
    
    
    // MARK: - Actions
    @objc func channelSwitchAction(sender: CustomSwitch) {
//        sendClose()
        if sender.isOn {
            print("select channel2ButtonAction")
            self.channelLabel.text = "Ch 2"
            self.fullScreenChannelLabel.text = "Ch 2"
            self.camChannel  = "2"
        } else {
            print("select channel1ButtonAction")
            self.channelLabel.text = "Ch 1"
            self.fullScreenChannelLabel.text = "Ch 1"
            self.camChannel  = "1"
        }
        connectVideoSocket(channel: camChannel)
    }
    
    @objc func fullScreenChannelSwitchAction(sender: CustomSwitch) {
        if sender.isOn {
            print("select fullScreenChannelSwitchAction")
            self.fullScreenChannelLabel.text = "Ch 2"
            self.camChannel  = "2"
        } else {
            print("select fullScreenChannelSwitchAction")
            self.fullScreenChannelLabel.text = "Ch 1"
            self.camChannel  = "1"
        }
    }
    
    @objc func fullScreenButtonAction(sender: UIButton) {
        print("select fullScreenButtonAction")
        monitorFullScreenView.isHidden = false
        self.navigationController?.navigationBar.isHidden = true
        // Status Bar 숨기기
        
        // 탭바 숨김
        tabBarController?.tabBar.isHidden = true
                
        // 상태바 스타일 설정을 위한 메서드
        setNeedsStatusBarAppearanceUpdate()
        isFullScreen = true
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
                self.fullScreenChannelSwitch.isOn = false
            } else {
                self.channelSwitch.isOn = true
                self.fullScreenChannelSwitch.isOn = true
            }
            
        }
    }
    
    @objc func didTapMonitorView() {
        print("select didTapMonitorView")
        monitorButtnFlag = true
        
        setMonitorButtonsViewFlag()
    }
    
    @objc func didTapMonitorFullScreenButtonsView(sender: UITapGestureRecognizer) {
        // 터치 위치가 channelSwitch 내부인지 확인
        let touchLocation = sender.location(in: monitorFullScreenButtonsView)
        
        // 터치가 channelSwitch의 영역 안에 있지 않으면 버튼을 숨기기
        if !fullScreenChannelSwitch.frame.contains(touchLocation) {
            print("select didTapMonitorButtonsView")
            monitorFullScreenButtonFlag = false
            setMonitorFullScreenButtonsViewFlag()
        } else {
            if self.fullScreenChannelSwitch.isOn {
                self.channelSwitch.isOn = false
                self.fullScreenChannelSwitch.isOn = false
            } else {
                self.channelSwitch.isOn = true
                self.fullScreenChannelSwitch.isOn = true
            }
            
        }
    }
    
    @objc func didTapMonitorFullScreenView() {
        print("select didTapMonitorFullScreenView")
        monitorFullScreenButtonFlag = true
        setMonitorFullScreenButtonsViewFlag()
    }
    
    @objc func onButtonAction(sender: UIButton) {
        print("select onButtonAction")
        patrolOn()
    }
    
    @objc func offButtonAction(sender: UIButton) {
        print("select offButtonAction")
        patrolOff()
    }
    
    @objc func didTapMicView() {
        print("select didTapMicView")
        
        let micPopupVC = MicPopupViewController()
        micPopupVC.delegate = self
        micPopupVC.modalPresentationStyle = .overFullScreen
        micPopupVC.modalTransitionStyle = .crossDissolve
        present(micPopupVC, animated: true)
        
        
        
    }
    
    @objc func didTapPlayView() {
        print("select didTapPlayView")

        let popupVC = PopupViewController(items: self.presetDataList)
        popupVC.delegate = self
        popupVC.modalPresentationStyle = .overFullScreen
        popupVC.modalTransitionStyle = .crossDissolve
        present(popupVC, animated: true)
    }
    
    
    // 위
    @objc func NButtonAction(sender: UIButton) {
        print("select NButtonAction")
        camRotateControl(session: selectedDeviceData!.sessionId, direction: 1)
    }
    
    // 오른
    @objc func EButtonAction(sender: UIButton) {
        print("select EButtonAction")
        camRotateControl(session: selectedDeviceData!.sessionId, direction: 3)
    }
    
    // 아래
    @objc func SButtonAction(sender: UIButton) {
        print("select SButtonAction")
        camRotateControl(session: selectedDeviceData!.sessionId, direction: 2)
    }
    
    // 왼
    @objc func WButtonAction(sender: UIButton) {
        print("select WButtonAction")
        camRotateControl(session: selectedDeviceData!.sessionId, direction: 4)
    }
    
    @objc func fullScreenBackButtonTapped(sender: UIButton) {
        print("fullScreenBackButtonTapped")
        self.navigationController?.navigationBar.isHidden = false
        monitorFullScreenView.isHidden = true
        // Tab Bar 보이기
        tabBarController?.tabBar.isHidden = false
                
        setNeedsStatusBarAppearanceUpdate()
        isFullScreen = false
    }
    
    @objc func plusButtonAction(sender: UIButton) {
        print("select plusButtonAction")
        imageViewPlayerZoomIn()
    }
    
    @objc func minusButtonAction(sender: UIButton) {
        print("select minusButtonAction")
        imageViewPlayerZoomOut()
    }
    
    @objc func fullScreenPlusButtonAction(sender: UIButton) {
        print("select fullScreenPlusButtonAction")
        imageViewPlayerZoomIn()
    }
    
    @objc func fullScreenMinusButtonAction(sender: UIButton) {
        print("select fullScreenMinusButtonAction")
        imageViewPlayerZoomOut()
    }
    
    @objc func handlePanGesture(gesture:UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: sheet)
        
        if gesture.state == .began {
            print("Began")
        } else if gesture.state == .changed {
            print("Changed")
            
            // 기존 높이에서 translation 값 적용
            var newHeight = sheetHeightConstraint?.layoutConstraints.first?.constant ?? minSheetHeight
            newHeight -= translation.y

            // 높이 제한 설정
            newHeight = max(minSheetHeight, min(maxSheetHeight, newHeight))
            
            // 제약 조건 업데이트
            sheetHeightConstraint?.update(offset: newHeight)
            // 팬 제스처 이동 값 초기화
            gesture.setTranslation(.zero, in: sheet)
            
            
        } else if gesture.state == .ended {
            print("Ended")
                        
            // 애니메이션으로 가장 가까운 높이로 이동
            let currentHeight = sheetHeightConstraint?.layoutConstraints.first?.constant ?? minSheetHeight
            let targetHeight: CGFloat = (currentHeight - minSheetHeight) > (maxSheetHeight - currentHeight) / 2 ? maxSheetHeight : minSheetHeight

            UIView.animate(withDuration: 0.3) {
                self.sheetHeightConstraint?.update(offset: targetHeight)
                self.view.layoutIfNeeded()
            }
        }
         
    }
    
    
    func checkSelectedDeviceData() {
        if let selectedData = nxCamData.selectedDeviceInfo {
            print("selected Data sessionID = \(selectedData.sessionId)")
            selectedDeviceData = selectedData
            
            connectVideoSocket(channel: camChannel)
        } else {
            Toaster.shared.makeToast("장비가 선택되지 않았습니다.", .middle)
            navigationController?.popViewController(animated: true)
        }
    }
    
    func patrolOn() {
        LoadingIndicator.shared.show()
        
        let headers: HTTPHeaders = [
            "Authorization": "test",
            "Accept": "application/json"
        ]
        
        if let sessionId = selectedDeviceData?.sessionId {
            let url = "nxcamPatrol/\(sessionId)/true"
            
            AF.request(
                baseDataApiUrl + url,
                method: .put,
                headers: headers
            ).validate(statusCode: 200..<300)
                .response { response in
                    switch response.result {
                        case .success(let data):
                            print("patrolOn ==== > data : \(data)")
                            Toaster.shared.makeToast("패트롤 ON", .short)
                            
                        case .failure(let error):
                            print("patrolOn ==== > error : \(error)")
                    }
            }
            
        } else {
            print("sessionId가 nil입니다.")
        }
    }
    
    func patrolOff() {
        
        LoadingIndicator.shared.show()
        
        let headers: HTTPHeaders = [
            "Authorization": "test",
            "Accept": "application/json"
        ]
        
        if let sessionId = selectedDeviceData?.sessionId {
            let url = "nxcamPatrol/\(sessionId)/false"
            
            AF.request(
                baseDataApiUrl + url,
                method: .put,
                headers: headers
            ).validate(statusCode: 200..<300)
                .response { response in
                    
                    switch response.result {
                        case .success(let data):
                        print("patrolOn ==== > data : \(data)")
                            Toaster.shared.makeToast("패트롤 OFF", .middle)
                            
                        case .failure(let error):
                            print("patrolOn ==== > error : \(error)")
                    }
            }
        } else {
            print("sessionId가 nil입니다.")
        }
    }
    
    // PTZ 컨트롤 버튼 설정
    func camRotateControl(session: String, direction: Int) {
        
        // 회전 방향
        // ==== 렌즈 ====
        // 1: 위
        // 2: 아래
        // ==== 몸체 =====
        // 3: 오른쪽
        // 4: 왼쪽
        
        // 로딩 시작
//        LoadingIndicator.shared.show()
        
        let headers: HTTPHeaders = [
            "Authorization": "test",
            "Accept": "application/json"
        ]
        
        var url = "control/ptz/\(session)/\(direction)"
        
        AF.request(
            baseApiUrl + url,
            method: .get,
            headers: headers
        ).validate(statusCode: 200..<300)
            .response { response in
                print("camRotateControl ==== > session : \(session), direction : \(direction) , response : \(response)")
            }
    }
    
    func connectVideoSocket(channel: String) {
        var socketUrl = "wss://platform.moving-ai.com/mjpeg?serial="
        if let deviceSerial = selectedDeviceData?.deviceSerial {
            socketUrl += deviceSerial
        }
        socketUrl += "&channel="
        socketUrl += "\(camChannel)"
        print("!!!!!!!! socketUrl = \(socketUrl)")
        LoadingIndicator.shared.show()
        let url = URL(string: socketUrl)!
        var request = URLRequest(url: url)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket?.delegate = self
        socket?.connect()
        
    }
    
    private func sendClose() {
        do {
            // JSON 객체 생성
            var jsonObject: [String: Any] = [:]
            jsonObject["type"] = "close"
            
            // JSON 문자열로 변환
            let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                // WebSocket으로 메시지 전송
                socket?.write(string: jsonString)
            }
            
            // 메인 스레드에서 UI 업데이트
            DispatchQueue.main.async {
                LoadingIndicator.shared.hide()
            }
        } catch {
            print("Failed to create JSON object: \(error.localizedDescription)")
        }
    }
    
    /** 이미지 뷰 확대 */
        func imageViewPlayerZoomIn() {
            let targetView = isFullScreen ? monitorFullScreenImageView : monitorImageView
            
            if (isFullScreen) {
                let currentScaleX = targetView.transform.b
                
                if currentScaleX >= MIN_SCALE {
                    let newScaleX = min(currentScaleX * ZOOM_IN_VALUE, MAX_SCALE)
                    targetView.transform = CGAffineTransform(scaleX: newScaleX, y: newScaleX)
                    targetView.rotate(angle: 90)
                }

            } else {
                let currentScaleX = targetView.transform.a
                
                if currentScaleX >= MIN_SCALE {
                    let newScaleX = min(currentScaleX * ZOOM_IN_VALUE, MAX_SCALE)
                    targetView.transform = CGAffineTransform(scaleX: newScaleX, y: newScaleX)
                }
            }
        }

        /** 이미지 뷰 축소 */
        func imageViewPlayerZoomOut() {
            let targetView = isFullScreen ? monitorFullScreenImageView : monitorImageView
            
            if (isFullScreen) {
                let currentScaleX = targetView.transform.b

                if currentScaleX > MIN_SCALE {
                    let newScaleX = max(currentScaleX * ZOOM_OUT_VALUE, MIN_SCALE)
                    targetView.transform = CGAffineTransform(scaleX: newScaleX, y: newScaleX)
                    targetView.rotate(angle: 90)
                }
            } else {
                let currentScaleX = targetView.transform.a
                
                if currentScaleX > MIN_SCALE {
                    let newScaleX = max(currentScaleX * ZOOM_OUT_VALUE, MIN_SCALE)
                    targetView.transform = CGAffineTransform(scaleX: newScaleX, y: newScaleX)
                }
            }
        }
    
    
    // 안내방송 리스트 통신으로 가져옴
    private func initPresetVoiceData() {
        // 완성된 URL
        let url = "\(baseDataApiUrl)/preset"
                
        // HTTP 헤더
        let headers: HTTPHeaders = [
            "Authorization": "test",
            "Accept": "application/json"
        ]
        
        AF.request(
            url,
            method: .get,
            headers: headers
        ).validate(statusCode: 200..<300)
            .responseDecodable(of: [PresetManageData].self) { response in
                switch response.result {
                
                case .success(let value):
                    print("initPresetVoiceData 성공하였습니다 ")
                    self.presetServerDataList = value
                    
                    var targetData: [String]?
                    
                    // 웹 리스트 COMPARE 장비 아이디
                    for data in self.presetServerDataList ?? [] {
                            targetData = data.applyNxCam.split(separator: "|").map { String($0) }
                            
                            if let targetData = targetData {
                                for deviceId in targetData {
                                    if let deviceSession = Int(NxCamMethods.shared.selectedDeviceInfo?.sessionId ?? ""),
                                       let presetDeviceSession = Int(deviceId) {
                                        // 켜진 장비 세션값 vs 프리셋이 적용된 장비 세션값
                                        if deviceSession == presetDeviceSession {
                                            self.devicePresetList.append(data)
                                        }
                                    }
                                }
                            }
                        }
                    
                    print("initPresetVoiceData 성공하였습니다 devicePresetList :: \(self.devicePresetList)")
                    self.getPresetVoiceData()
                    
                case .failure(let error):
                    print("initPresetVoiceData - 실패하였습니다 :: \(error)" )
                    
                }
        }
        
    }
    
    // 장비에 있는 프리셋 폴더 파일 리스트
    private func getPresetVoiceData() {
        // 완성된 URL
        let url = "\(baseApiUrl)manage/fileList"
                
        // HTTP 헤더
        let headers: HTTPHeaders = [
            "Authorization": "test",
            "Accept": "application/json"
        ]
        
        let parameters: Parameters = [
               "filename": "",
               "path": "PRESET",
               "sessionId": selectedDeviceData?.sessionId ?? ""
        ]
        
        AF.request(
            url,
            method: .get,
            parameters: parameters,
            encoding: URLEncoding.queryString,
            headers: headers
        ).validate(statusCode: 200..<300)
            .responseDecodable(of: [PresetData].self) { response in
                switch response.result {
                case .success(let value):
                    print("getPresetVoiceData 성공하였습니다")
                    
                    if !value.isEmpty {
                        // 장비 파일 리스트와 매칭 완료된 프리셋 리스트 필터링
                        for presetFile in value {
                            for presetModel in self.devicePresetList {
                                if presetFile.fileName == presetModel.oriFilename {
                                    self.presetDataList.append(presetFile)
                                }
                            }
                        }
                        print("getPresetVoiceData presetDataList: \(self.presetDataList)")
                        
                    } else {
                        // 값 업음
                        Toaster.shared.makeToast("안내방송이 존재하지 않습니다.")
                    }
                    
                case .failure(let error):
                    print("getPresetVoiceData - 실패하였습니다 :: \(error)" )
                    
                }
        }
        
    }
}

extension CamMonitorViewController: WebSocketDelegate {
    func didReceive(event: Starscream.WebSocketEvent, client: any Starscream.WebSocketClient) {
        switch event {
        case .connected(let headers):
            if client === socket {
                print("WebSocket connected.")
            } else if client === Rtpsocket {
                print("Rtpsocket connected.")
            }
          print("websocket is connected: \(headers)")
        case .disconnected(let reason, let code):
            if client === socket {
                print("websocket is disconnected: \(reason) with code: \(code)")
            } else if client === Rtpsocket {
                print("Rtpsocket is disconnected: \(reason) with code: \(code)")
            }
          
        case .text(let text):
            if client === socket {
                print("websocket received text: \(text)")
            } else if client === Rtpsocket {
                print("Rtpsocket received text: \(text)")
            }
          
        case .binary(let data):
            if client === socket {
                print("Received data: \(data.count)")
                  
                  DispatchQueue.main.async {
                      // 이미지 데이터 처리
                      if let image = UIImage(data: data) {
                          self.monitorImageView.image = image
                          self.monitorFullScreenImageView.image = image
                          
                      } else {
                          print("Failed to decode image data")
                      }
                      LoadingIndicator.shared.hide()
                  }
            } else if client === Rtpsocket {
                print("Rtpsocket Received data: \(data.count)")
            }
            
        case .ping(_):
          break
        case .pong(_):
          break
        case .viabilityChanged(_):
          break
        case .reconnectSuggested(_):
          break
        case .cancelled:
          print("websocket is canclled")
        case .error(let error):
          print("websocket is error = \(error!)")
        case .peerClosed:
            print("websocket is peerClosed")
        }
        
        
    }
}
extension CamMonitorViewController: PopupDelegate, MicPopupDelegate, BottomSheetDelegate, URLSessionWebSocketDelegate {

    func popupDidSelectItem(index: Int) {
        print("선택된 아이템 인덱스: \(index)")
        
        playPresetVoice(position: index)
    }
    
    // preset 재생
    private func playPresetVoice(position: Int) {
        if (presetDataList[position].fileSize == nil) {
            print("Preset 파일 에러 ")
            return
        }
        
        if let fileName = presetDataList[position].fileName {
            let fileNameParts = fileName.split(separator: ".")
            if let firstPart = fileNameParts.first {
                let targetURL = "control/preset/\(NxCamMethods.shared.selectedDeviceInfo?.sessionId ?? "")/\(firstPart)"
                print("Target URL: \(targetURL)")
                
                // HTTP 헤더
                let headers: HTTPHeaders = [
                    "Authorization": "test",
                    "Accept": "application/json"
                ]
                
                
                AF.request(
                    baseApiUrl + targetURL,
                    method: .get,
                    headers: headers
                ).validate(statusCode: 200..<300)
                    .response { response in
                        switch response.result {
                            case .success(let data):
                                print("playPresetVoice ==== > success data : \(data)")
                                self.broadcastHistoryCreate(apiType: "VOICEMSG", eventKind: "")
                            case .failure(let error):
                                print("playPresetVoice ==== > error : \(error)")
                        }
                        
                    }

            }
        }
    }
    
    // 방송 전파이력 생성
    private func broadcastHistoryCreate(apiType: String, eventKind: String) {
        let url = baseDataApiUrl + "broadcastHistory/create"
        
        // HTTP 헤더
        let headers: HTTPHeaders = [
            "Authorization": "test",
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        // 요청 파라미터
        let parameters: [String: Any] = [
            "id": Int(selectedDeviceData?.sessionId ?? "0"),
            "apiType": apiType,
            "eventKind": eventKind,
            "userId": UserAccountMethods.shared.movingAIUserAccount?.userId ?? ""
        ]

        AF.request(
            url,
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers
        ).validate(statusCode: 200..<300)
            .response { response in
                switch response.result {
                    case .success(let data):
                        print("broadcastHistoryCreate ==== > success data : \(data)")

                    case .failure(let error):
                        print("broadcastHistoryCreate ==== > error : \(error)")
                }
                
            }
    }
    
    func micButtonTouchDown() {
        print("마이크 버튼 누름!!!!!!!!!")
        isRecording = true
        
        // 녹음 장치 권한 체크
        let permission = PermissionViewModel()
        permission.requestMicrophonePermission { [weak self] granted in
            print("micButtonTouchDown granted : \(granted)")
            print("micButtonTouchDown isRecording : \(self?.isRecording)")
            guard let self = self else { return }
            
            if granted {
                do {
                    if isRecording {
                        // 스트리밍 시작
                        audioStreamingManager.start()
                    }
                    
                } catch {
                    print("Failed to configure audio session: \(error)")
                }
            } else {
                print("Microphone permission not granted")
            }
        }
    }
    
    func micButtonTouchUpInside() {
        print("마이크 버튼 뗌!!!!!!!!!")
        isRecording = false
        
        // 스트리밍 중단
        audioStreamingManager.stop()
        
        broadcastHistoryCreate(apiType: "REALTIME_VOICE", eventKind: "")
    }

    
    private func setupWebSocket() {
        var socketUrl = "wss://platform.moving-ai.com/mic/"
        if let session = selectedDeviceData?.sessionId {
            socketUrl += session
        }
        audioStreamingManager.getURL(webSocketURL: socketUrl)
    }
    
    func bottomSheetDidSelectItem(index: Int) {
        print("선택된 아이템 인덱스: \(index)")
        
        reloadViewController()
    }
    
    
}
