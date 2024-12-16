//
//  MainViewController.swift
//  MovingAI
//
//  Created by soyoung on 12/5/24.
//

import UIKit
import CoreLocation
import SnapKit
import WebKit
import Alamofire

class MainViewController: UIViewController, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler {
    
    var webView: WKWebView!
    
    // 현재 위치의 위도, 경도
    var locationManager = CLLocationManager()
    var longitude = CLLocationDegrees()
    var latitude = CLLocationDegrees()
        
    // 전체 장비
    private var allAssetDeviceList: [AssetData] = []
    // 온라인 장비 전체
    private var onlineDeviceList: [NxCamDeviceInfo] = []
    // 계정의 접근 가능한 모든 현장 리스트
    private var allAttachList: [AttachData] = []
    
    /// 계정의 접근 가능한 모든 현장 리스트
    private var userAccessibleAllSitesList: [AttachData] = []
    /// 접근 가능한 현장의 전체 장비
    private var allSiteAssetList: [AssetData] = []
    /// 접근 가능한 현장 전체의 온라인 장비
    private var onlineSiteAssetList: [NxCamDeviceInfo] = []
    
    // 데이터 저장
    let userAccount = UserAccountMethods.shared
    let nxCamData = NxCamMethods.shared
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.name)
        if (message.name == "MarkerInterface") {
            print("\(message.body)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        // 메인화면 타이틀 설정
        let title = userAccount.title
        addNavigationBar(titleString: title,isBackButtonVisible: false)
        
        
        // 현재 위치
        locationManager.delegate = self
        //위치추적권한요청 when in foreground
        self.locationManager.requestWhenInUseAuthorization()
        //베터리에 맞게 권장되는 최적의 정확도
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        
        // 권한 체크
//        checkAuthorizationStatus()
        
        // 웹 뷰 초기화 및 설정
        settingsWebView()
        
        mapSetCenterFromGPS()
        
        addMarkerLayer()
        
        self.webView.reload()
        
        // 전체 온라인 장비
        apiOnlineDevices()
        // 전체 장비
        apiAllAssets()
        // 전체 현장
        apiAllSites()
    }

    // vworld 지도 위치 값 표시 JavaScript
    private func mapSetCenterFromGPS() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
            DispatchQueue.main.async {
                
                let jsCode = "fnSetCenter(\(self.longitude), \(self.latitude));"
                // 회사
//                let jsCode = "fnSetCenter(127.190688, 37.549060);"
                self.webView.evaluateJavaScript(jsCode) { (result, error) in
                    print("mapSetCenterFromGPS : \(jsCode)")
                    if let error = error {
                        print("mapSetCenterFromGPS - JavaScript execution error: \(error.localizedDescription)")
                    } else {
                        print("mapSetCenterFromGPS - JavaScript executed successfully: \(result ?? "No result")")
                    }
                }
            }
        }
    }
    
    // vworld 지도 마커레이어 추가 JavaScript
    private func addMarkerLayer() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
            DispatchQueue.main.async {
                
                let jsCode = "addMarkerLayer();"
                self.webView.evaluateJavaScript(jsCode) { (result, error) in
                    print("addMarkerLayer : \(jsCode)")
                    if let error = error {
                        print("addMarkerLayer - JavaScript execution error: \(error.localizedDescription)")
                    } else {
                        print("addMarkerLayer - JavaScript executed successfully: \(result ?? "No result")")
                    }
                }
            }
        }
    }
    
    // vworld 지도 마커 추가 JavaScript
//    private func makeAddMarkerLayer() {
//        var latDeg: Double
//        var lonDeg: Double
//
//        // 접근 가능한 현장의 장비 리스트만 마커 업로드하기
//        for targetDevice in onlineSiteAssetList {
//            for targetAsset in allSiteAssetList {
//                if let sessionId = Int(targetDevice.sessionId), sessionId == targetAsset.id {
//
//                    if let lat = targetAsset.lat, let lon = targetAsset.lon {
//                        latDeg = lat
//                        lonDeg = lon
//                    } else if let attachLat = targetAsset.attach?.lat, let attachLon = targetAsset.attach?.lng {
//                        latDeg = attachLat
//                        lonDeg = attachLon
//                    } else {
//                        continue // lat/lon 정보가 없으면 스킵
//                    }
//
//                    let sb = [
//                        targetAsset.serial,
//                        "\(targetAsset.id)",
//                        targetAsset.name,
//                        "\(lonDeg)",
//                        "\(latDeg)"
//                    ].joined(separator: "@")
//
//                    webView.evaluateJavaScript("javascript:addMarker('\(sb)')", completionHandler: nil)
//                }
//            }
//        }
//
//
//        DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
//            DispatchQueue.main.async {
//                print("makeAddMarkerLayer : 3 seconds have passed")
//                let jsCode = "addMarker('\(sb)');"
//
//                self.webView.evaluateJavaScript(jsCode) { (result, error) in
//                    if let error = error {
//                        print("makeAddMarkerLayer - JavaScript execution error: \(error.localizedDescription)")
//                    } else {
//                        print("makeAddMarkerLayer - JavaScript executed successfully: \(result ?? "No result")")
//                    }
//                }
//            }
//        }
//    }
  
    
    private func initView() {
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
    
    private func settingsWebView() {
    
            // 웹 뷰 설정 - javaScript 사용 설정, 자동으로 javaScript를 통해 새 창 열기 설정
            let preferences = WKPreferences() // 웹 뷰 기본 속성
            preferences.javaScriptCanOpenWindowsAutomatically = true
            let contentController = WKUserContentController() // 웹 뷰와 javaScript간의 상호작용 관리
            // 사용 할 메시지 등록
            contentController.add(self, name: "MarkerInterface")
    
            // preference, contentController 설정
            let configuration = WKWebViewConfiguration()
//            configuration.suppressesIncrementalRendering = false
            configuration.userContentController = contentController
            configuration.preferences = preferences
            
            // 버전에 따른 자바스크립트 허용 여부
            if #available(iOS 14.0, *) {
                configuration.defaultWebpagePreferences.allowsContentJavaScript = true
            } else {
                configuration.preferences.javaScriptEnabled = true
            }

            webView = WKWebView(frame: .zero, configuration: configuration)
            webView.uiDelegate = self
            webView.navigationDelegate = self
            webView.allowsBackForwardNavigationGestures = true // 뒤로가기 제스처 허용
            
            if #available(iOS 16.4, *) {
                #if DEBUG
                webView.isInspectable = true  // webview inspector 가능하도록 설정
                #endif
            }
            
            // snapkit 으로 화면 구성
            initView()
            
            // HTML 파일 로드
            loadWebView()
        }
    
    private func loadWebView() {
        
        guard let url = Bundle.main.url(forResource: "vworldmap",withExtension: "html") else {
            print("HTML 파일을 찾을 수 없습니다.")
            return
        }
        
        webView.loadFileURL(url, allowingReadAccessTo: url)
        
    }
    
    // api 통신
    func apiOnlineDevices() -> Void{
        print("apiOnlineDevices 호출 시작!")
        
        let headers: HTTPHeaders = [
            "Authorization": "test",
            "Accept": "application/json"
        ]
        
        // 통신
        
        AF.request(
            baseApiUrl + "manage/deviceList",
            method: .get,
            headers: headers
        ).validate(statusCode: 200..<300) // 상태 코드 유효성 검증
            .responseDecodable(of: [NxCamDeviceInfo].self) { response in
                switch response.result {
                
                case .success(let value):
                    print("성공하였습니다 :: \(value)")
                    
                    self.onlineDeviceList = value
                    self.nxCamData.onlineDeviceList = value
                    
                case .failure(let error):
                    print("apiOnlineDevices - 실패하였습니다 :: \(error)" )
                }
            }
    }
    
    func apiAllAssets() -> Void{
        print("apiAllAssets 호출 시작!")
        
        let headers: HTTPHeaders = [
            "Authorization": "test",
            "Accept": "application/json"
        ]
        
        // 통신
        
        AF.request(
            baseDataApiUrl + "asset/-1",
            method: .get,
            headers: headers
        ).validate(statusCode: 200..<300) // 상태 코드 유효성 검증
            .responseDecodable(of: [AssetData].self) { response in
                switch response.result {
                    
                case .success(let value):
                    print("성공하였습니다 :: \(value)")
                    self.allAssetDeviceList = value
                    self.nxCamData.allAssetDeviceList = value
                    
                case .failure(let error):
                    print("apiAllAssets - 실패하였습니다 :: \(error)" )
                }
            }
    }
    
    func apiAllSites() -> Void{
        print("apiAllSites 호출 시작!")
        
        let headers: HTTPHeaders = [
            "Authorization": "test",
            "Accept": "application/json"
        ]
        
        // 통신
        
        AF.request(
            baseDataApiUrl + "attach/-1",
            method: .get,
            headers: headers
        ).validate(statusCode: 200..<300) // 상태 코드 유효성 검증
            .responseDecodable(of: [AttachData].self) { response in
                switch response.result {
                
                case .success(let value):
                    print("성공하였습니다 :: \(value)")
                    self.allAttachList = value
                    self.nxCamData.allAttachList = value
                    
                case .failure(let error):
                    print("apiAllSites - 실패하였습니다 :: \(error)" )
                }
            }
    }
    
    func settingData() {
        
    }
}


extension MainViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("locationManager >> didUpdateLocations ")
        
        if let location = locations.first {
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
            print("위도: \(latitude), 경도: \(longitude)")
        }
        locationManager.stopUpdatingLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("locationManager >> didChangeAuthorization ")
        locationManager.startUpdatingLocation()  //위치 정보 받아오기 start
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("locationManager >> didFailWithError ")
    }
    
    /**
     * checkAuthorizationStatus()
     * - 권한 상태 확인하기
     **/
//    func checkAuthorizationStatus() {
//
//        if #available(iOS 14.0, *) {
//
//            if locationManager.authorizationStatus == .authorizedAlways
//                || locationManager.authorizationStatus == .authorizedWhenInUse {
//                print("==> 위치 서비스 On 상태")
//                locationManager.startUpdatingLocation() //위치 정보 받아오기 시작 - 사용자의 현재 위치를 보고하는 업데이트 생성을 시작
//            } else if locationManager.authorizationStatus == .notDetermined {
//                print("==> 위치 서비스 Off 상태")
//                locationManager.requestWhenInUseAuthorization()
//            } else if locationManager.authorizationStatus == .denied {
//                print("==> 위치 서비스 Deny 상태")
//            }
//
//        } else {
//
//            // Fallback on earlier versions
//            if CLLocationManager.locationServicesEnabled() {
//                print("위치 서비스 On 상태")
//                locationManager.startUpdatingLocation() //위치 정보 받아오기 시작 - 사용자의 현재 위치를 보고하는 업데이트 생성을 시작
//                print("LocationViewController >> checkPermission() - \(String(describing: locationManager.location?.coordinate))")
//            } else {
//                print("위치 서비스 Off 상태")
//                locationManager.requestWhenInUseAuthorization()
//            }
//
//        }
//    }
    
}
