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
import iOSDropDown
import SwiftyToaster

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
    let topAssets = TopAssetsMethods.shared
    
    let backgroundView = UIView()
    let dropDown = DropDown()
    // DropDown 데이터를 담을 배열
    var dropDownDataSource: [String] = []
    
    @available(iOS 8.0, *)
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!\(message.name)")
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
        
        
        
        // 전체 온라인 장비
        apiOnlineDevices()
        // 전체 장비
        apiAllAssets()
        // 전체 현장
        apiAllSites()
        
        // 접근 가능한 현장의 온라인/전체 장비 데이터를 불러오고 처리하는 thread 작업
        siteAssetsCheck()
        
        // 권한 체크
//        checkAuthorizationStatus()
        
        // 웹 뷰 초기화 및 설정
        settingsWebView()
        self.webView.reload()
        
        initDropDown()
        
    }
    
    private func mapWithWebView() {
        let selectedSite = userAccount.movingAIUserAccount?.attach
        
        print("???????? selectedSite?.lng : \(selectedSite?.lng), selectedSite?.lat : \(selectedSite?.lat)")
        if (selectedSite?.lng != nil && selectedSite?.lat != nil) {
            if (selectedSite?.lat != 0.0 || selectedSite?.lng != 0.0 ) {
                mapSetCenterFromGPS(lon: (selectedSite?.lng)!, lat: (selectedSite?.lat)!)
            } else {
                print("위치정보가 존재하지 않습니다.")
                Toaster.shared.makeToast("위치정보가 존재하지 않습니다.", .middle)
                mapSetCenterFromGPS(lon: self.longitude, lat: self.latitude)
            }
            
        } else {
            print("계정에 위치값이 없습니다. 현재 위치로 맵 포커스 이동.")
           
            Toaster.shared.makeToast("위치정보가 존재하지 않습니다.", .middle)
            mapSetCenterFromGPS(lon: self.longitude, lat: self.latitude)
        }
    }

    // vworld 지도 위치 값 표시 JavaScript
    private func mapSetCenterFromGPS(lon: Double, lat: Double) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
            DispatchQueue.main.async {
                
                let jsCode = "fnSetCenter(\(lon), \(lat));"
                // 회사
//                let jsCode = "fnSetCenter(127.190688, 37.549060);"
                self.webView.evaluateJavaScript(jsCode) { (result, error) in
                    print("mapSetCenterFromGPS : \(jsCode)")
                    if let error = error {
                        print("mapSetCenterFromGPS - JavaScript execution error: \(error.localizedDescription)")
                    } else {
                        print("mapSetCenterFromGPS - JavaScript executed successfully: \(result ?? "No result")")
                    }
                    
                    LoadingIndicator.shared.hide()
                    self.addMarkerLayer()
                    self.makeAddMarkerLayer()
                    
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
    private func makeAddMarkerLayer() {
    
        DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
            DispatchQueue.main.async {
                print("makeAddMarkerLayer : 3 seconds have passed")
                             
                
                // 접근 가능한 현장의 장비 리스트만 마커 업로드하기
                for targetDevice in self.onlineSiteAssetList {
                    for targetAsset in self.allSiteAssetList {
                        if let sessionId = Int(targetDevice.sessionId), sessionId == targetAsset.id {

                            var latDeg: Double
                            var lonDeg: Double
                            
                            if let lat = targetAsset.lat, let lon = targetAsset.lon, lat != 0.0, lon != 0.0 {
                                latDeg = lat
                                lonDeg = lon
                            } else if let attachLat = targetAsset.attach?.lat, let attachLon = targetAsset.attach?.lng, attachLat != 0.0, attachLon != 0.0 {
                                latDeg = attachLat
                                lonDeg = attachLon
                            } else {
                                continue // lat/lon 정보가 없거나 0.0인 경우 스킵
                            }

                            let sb = [
                                targetAsset.serial,
                                "\(targetAsset.id)",
                                targetAsset.name ?? ".",
                                "\(lonDeg)",
                                "\(latDeg)"
                            ].joined(separator: "@")
                            
                            let jsCode = "addMarker('\(sb)');"
                            print("마커.  ==========> : \(jsCode)")
                            self.webView.evaluateJavaScript(jsCode) { (result, error) in
                                if let error = error {
                                    print("makeAddMarkerLayer - JavaScript execution error: \(error.localizedDescription)")
                                } else {
                                    print("makeAddMarkerLayer - JavaScript executed successfully: \(result ?? "No result")")
                                }
                            }
                        }
                    }
                }

            }
        }
    }
  
    
    private func initView() {
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        // 리스트 back UIView
        backgroundView.backgroundColor = .white
        backgroundView.layer.cornerRadius = 20
        backgroundView.layer.borderWidth = 3
        backgroundView.layer.borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1.0).cgColor
        
        
        view.addSubview(backgroundView)
        view.bringSubviewToFront(backgroundView)
        
        backgroundView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(30)
            make.height.equalTo(45)
            make.leading.equalToSuperview().offset(80)
            make.trailing.equalToSuperview().offset(-80)
        }

    }
    
    private func settingsWebView() {
    
            // 웹 뷰 설정 - javaScript 사용 설정, 자동으로 javaScript를 통해 새 창 열기 설정
            let preferences = WKPreferences() // 웹 뷰 기본 속성
            preferences.javaScriptCanOpenWindowsAutomatically = true
            let contentController = WKUserContentController() // 웹 뷰와 javaScript간의 상호작용 관리
            // 사용 할 메시지 등록
            let markerInterface = SelectCamFromMarkerInterface(context: self, deviceList: onlineSiteAssetList)
//            contentController.add(markerInterface, name: "MarkerInterface")
            contentController.add(self, name: "MarkerInterface")
        
        
            // preference, contentController 설정
            let configuration = WKWebViewConfiguration()
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
        
            mapWithWebView()
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
        
        // 로딩 시작
        LoadingIndicator.shared.show()
        
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
//                    print("성공하였습니다 :: \(value)")
                    
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
//                    print("성공하였습니다 :: \(value)")
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
//                    print("성공하였습니다 :: \(value)")
                    self.allAttachList = value
                    self.nxCamData.allAttachList = value
//                    print("allAttachList :: \(self.allAttachList)")
                    
                case .failure(let error):
                    print("apiAllSites - 실패하였습니다 :: \(error)" )
                    
                    
                }
            }
    }
    
    func apiGetAssetsData(id: Int){
        print("apiGetAssetsData 호출 시작!")
        
        let headers: HTTPHeaders = [
            "Authorization": "test",
            "Accept": "application/json"
        ]
        
        let url = "\(baseDataApiUrl)/asset/\(id)"
        
        // 통신
        
        AF.request(
            url,
            method: .get,
            headers: headers
        ).validate(statusCode: 200..<300) // 상태 코드 유효성 검증
            .responseDecodable(of: [AttachData].self) { response in
                switch response.result {
                
                case .success(let value):
                    print("성공하였습니다 :: \(value)")
                    // 첫 번째 AttachData만 사용
                    if let firstData = value.first,
                        let latitude = firstData.lat,
                        let longitude = firstData.lng {
                        
                        self.mapSetCenterFromGPS(lon: longitude, lat: latitude)
                        
                    } else {
                            print("장비의 위치정보가 없습니다.")
                    }
                    
                case .failure(let error):
                    print("apiAllSites - 실패하였습니다 :: \(error)" )
                    
                    
                }
            }
    }
    
    func siteAssetsCheck() {
        // 계정 현장 타입별 조회가 필요한 현장 리스트
        let attachType = userAccount.attachType
//        let id = userAccount.id
        let id = userAccount.attachId
        
        print("MainVC settingData attachType : \(attachType)")
        print("MainVC settingData id : \(id)")
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
            DispatchQueue.main.async {
                switch (attachType) {
                    // 회사 계정
                    case "Company":
        //            print("settingData ===> 1, allAttachList : \(allAttachList) ")

                    for targetContractor in self.allAttachList {
                        print("settingData ===> 2, targetContractor.parentId : \(targetContractor.parentId) ")
                            // 계정 company 아래에 있는 contractor 조회
                            if let parentId = targetContractor.parentId, parentId == id {
                                print("settingData 같은 아이디 있다!!")
                                for targetSite in self.allAttachList {
                                    // 특정 contractor 아래에 있는 site 조회
                                    if let siteParentId = targetSite.parentId, siteParentId == targetContractor.id {
                                        self.userAccessibleAllSitesList.append(targetSite)
                                        print("settingData ===> 3, Company, siteParentId : \(siteParentId) ")
                                    }
                                }
                            }
                        }
                    
                        // 현장 전체 장비 리스트
                    for targerAsset in self.allAssetDeviceList {
                        for accessibleSites in self.userAccessibleAllSitesList {
                                if let attachId = targerAsset.attach?.id, attachId == accessibleSites.id {
                                    self.allSiteAssetList.append(targerAsset)
                                    print("settingData ===> Company, attachId : \(attachId) ")
                                }
                            }
                        }
                        
                        // 온라인 장비 중 계정 현장에 해당하는 장비 리스트
                    self.checkOnlineDeviceList()
                        
                    
                    case "Contractor":
                    for targetSite in self.allAttachList {
                            if let parentId = targetSite.parentId, parentId == id {
                                self.userAccessibleAllSitesList.append(targetSite)
                                print("settingData ===> Contractor, parentId : \(parentId) ")
                            }
                        }
                    
                        // 현장 전체 장비 리스트
                    for targerAsset in self.allAssetDeviceList {
                        for accessibleSites in self.userAccessibleAllSitesList {
                                if let attachId = targerAsset.attach?.id, attachId == accessibleSites.id {
                                    self.allSiteAssetList.append(targerAsset)
                                    print("settingData ===> Contractor, attachId : \(attachId) ")
                                }
                            }
                        }
                    
                        // 온라인 장비 중 계정 현장에 해당하는 장비 리스트
                    self.checkOnlineDeviceList()
                        
                    
                    case "Site":
        //                    userAccessibleAllSitesList.append(userAccount)
                    
                    for targetAsset in self.allAssetDeviceList {
                            if let attachId = targetAsset.attach?.id, attachId == id {
                                self.allSiteAssetList.append(targetAsset)
                                print("settingData ===> Site, attachId : \(attachId) ")
                            }
                        }
                        
                        // 온라인 장비 중 계정 현장에 해당하는 장비 리스트
                    self.checkOnlineDeviceList()
                        
                    
                    default:
                        break
                }
                
                // 계정에 허용된 현장 리스트 저장
                //
                // 현장들 전체 장비 리스트 저장
                //
                
                // 현장 온라인장비 저장
                self.nxCamData.deviceInfoList.append(contentsOf: self.onlineSiteAssetList)
                
                // 전체 장비 리스트
                self.topAssets.setAllSitesAssetsList(self.allSiteAssetList)
                
                // Simple Foreground Service(push notification)에서 앱 종료 후에도 계정이 받아야 할 푸쉬알림 분류를 위한 현장 ID 저장
                var siteAssetsStringList: [String] = []

                // allSiteAssetList는 AssetData 배열이라고 가정합니다.
                for asset in self.allSiteAssetList {
                    let assetId = asset.id
                    siteAssetsStringList.append(String(assetId))
                }

                // "siteAssets" 키로 UserDefaults에 저장
                let assetsString = siteAssetsStringList.joined(separator: "|")
                UserDefaults.standard.set(assetsString, forKey: "siteAssets")

                print("Saved Site Assets: \(assetsString)")
                
                // 로딩 종료
                LoadingIndicator.shared.hide()
            }
        }

    }
    
    func checkOnlineDeviceList() {
        // 전체 온라인 장비 리스트
        for targetOnlineDevice in onlineDeviceList {
            // 계정이 접근 가능한 현장의 전체 장비 리스트
            for targetSiteAsset in allSiteAssetList {
                if let sessionId = Int(targetOnlineDevice.sessionId), sessionId == targetSiteAsset.id {
                    // 온라인 장비 api의 "장비 이름" 말고 장비 정보 api의 "장비 이름" 입력
//                    targetOnlineDevice.set
                    print("checkOnlineDeviceList ==> targetSiteAsset.name : \(String(describing: targetSiteAsset.name)) ")
                    onlineSiteAssetList.append(targetOnlineDevice)
                    // 드롭다운 리스트
                    setDropDown()
                }
            }
        }
    }
    
    
    // DropDown 메뉴 구성
    func initDropDown() {
        backgroundView.addSubview(dropDown)
        dropDown.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(45)
        }
        dropDown.isSearchEnable = false
        dropDown.selectedRowColor = .white
        dropDown.checkMarkEnabled = false
        dropDown.text = "장비 선택"
        
    }
    
    func setDropDown() {
        dropDownDataSource.append(contentsOf: onlineSiteAssetList.compactMap { $0.deviceName })
        dropDown.optionArray = dropDownDataSource
        
        print("@@#@#@#@#@#@ => setDropDown : \(dropDownDataSource)")
        
        if (dropDownDataSource.count == 0) {
            Toaster.shared.makeToast("연결된 장비가 없습니다.", .middle)
        }
        
        dropDown.didSelect { selectedText, index, id in
            print("Selected : \(index)")
            
            // 로딩 시작
            LoadingIndicator.shared.show()
            
            // 해당 데이터의 위치에 맵 포커스 맞춤
            // 선택된 이름과 매칭되는 데이터 검색
            if let selectedDevice = self.onlineSiteAssetList.first(where: { $0.deviceName == selectedText }) {
                    let sessioid = selectedDevice.sessionId
                    
                    print("Selected Device sessionId: \(sessioid)")
                
                    self.apiGetAssetsData(id: Int(sessioid)!)

                } else {
                    print("No matching device found for \(selectedText)")
                }
        }
    }
}



extension MainViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("locationManager >> didUpdateLocations ")
        
        if let location = locations.first {
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
            print("위도: \(latitude), 경도: \(longitude)")
            mapWithWebView()
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
 
}
