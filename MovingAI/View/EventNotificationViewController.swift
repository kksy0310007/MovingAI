//
//  EventNotificationViewController.swift
//  MovingAI
//
//  Created by soyoung on 12/5/24.
//

import UIKit
import Alamofire
import SwiftyToaster

class EventNotificationViewController: UIViewController {
    
    let searchView = UIView()
    
    var eventList: [EventResult] = []
    var filterEventList: [EventResult] = []
    
    lazy var requestParams: [String: Any] = createRequestParameters()
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.text = "날짜 / 장비 / 이벤트"
        label.textColor = UIColor.gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let searchImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "magnifyingglass")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.tintColor = .gray
        return image
    }()
    
    private let tableView : UITableView = { // 테이블 뷰 생성
            let tableView = UITableView()
            tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(EventNotificationListCell.self, forCellReuseIdentifier: EventNotificationListCell.identifier)
            return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addNavigationBar(titleString: "이벤트 조회",isBackButtonVisible: false)
        requestParams = createRequestParameters()
        getEventLogsApi()
        initView()
    }

    private func initView() {
        searchView.backgroundColor = .white
        searchView.layer.cornerRadius = 20
        searchView.layer.borderWidth = 3
        searchView.layer.borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1.0).cgColor
        
        let tapSearchViewGesture = UITapGestureRecognizer(target: self, action: #selector(didTapSearchView))
        searchView.addGestureRecognizer(tapSearchViewGesture)
        
        view.addSubview(searchView)
        
        searchView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(30)
            make.height.equalTo(45)
            make.leading.equalToSuperview().offset(40)
            make.trailing.equalToSuperview().offset(-40)
        }
        
        searchView.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
        }
        
        searchView.addSubview(searchImage)
        searchImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
        }
        
        // tableview 설정
        tableView.dataSource = self
        tableView.rowHeight = 97
        tableView.delegate = self
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .lightGray
        tableView.separatorInset = .zero
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchView.snp.bottom).offset(30)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    // 감지 이벤트 목록 api 호출
    func getEventLogsApi() {
        let url = "\(baseDataApiUrl)event"
        // HTTP 헤더
        let headers: HTTPHeaders = [
            "Authorization": "test",
            "Content-Type": "application/json"
        ]
        
        // 요청 파라미터
//        print("감지 이벤트 목록 api 호출 requestParams ==== >  \(requestParams)")
        
        self.eventList.removeAll()
        
        AF.request(
            url,
            method: .post,
            parameters: requestParams,
            encoding: JSONEncoding.default,
            headers: headers
        ).validate(statusCode: 200..<600)
            .responseDecodable(of: [EventResult].self) { response in
                switch response.result {
                    case .success(let data):
//                        print("감지 이벤트 목록 api 호출 getEventLogsApi ==== > success data : \(data)")

                        let allSitesAssetsList: [AssetData] = TopAssetsMethods.shared.allSitesAssets
                    
                            for targetAssetData in allSitesAssetsList {
                                for targetEventResult in data {
                                    if targetEventResult.assetId == targetAssetData.id {
//                                        print("호출 확인 3==== > targetEventResult.assetId : \(targetEventResult.assetId), targetAssetData.id : \(targetAssetData.id)")
                                        self.eventList.append(targetEventResult)
                                    }
                                }
                            }
                        
                        if self.eventList != nil {
                            self.tableView.reloadData()
                        } else {
                            Toaster.shared.makeToast("이벤트가 존재하지 않습니다.", .short)
                        }
                    case .failure(let error):
                        print("getEventLogsApi ==== > error : \(error)")
                }
            }
    }
    
    // 필터 값을 받아서 JSON 파라미터를 만드는 함수
    func createRequestParameters(
        page: Int? = nil,
        id: Int? = nil,
        searchDate: String? = nil
    ) -> [String: Any] {
        // 기본값
        var date = ""
        if searchDate != nil {
            date = searchDate!
        } else {
            date = getCurrentDate()
        }
        print("createRequestParameters ==== > searchDate : \(date)")
        
        return [
               "page": page ?? 1,
               "size": 10,
               "sort": ["regDate,desc"],
               "id": -1,
               "searchDate": date //?? getCurrentDate() // 기본값: 오늘 날짜
        ]
        
    }
    
    func updateRequestParameters(
        page: Int? = nil,
        id: Int? = nil,
        searchDate: String? = nil
    ) {
        requestParams = createRequestParameters(page: page, searchDate: searchDate)
    }

    // 현재 날짜를 "yyyy-MM-dd" 형식으로 반환하는 함수
    func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
    
    @objc func didTapSearchView() {
        print("select didTapSearchView")

        let popupVC = EventFilterPopupViewController()
        popupVC.delegate = self
        popupVC.modalPresentationStyle = .overFullScreen
        popupVC.modalTransitionStyle = .crossDissolve
        present(popupVC, animated: true)
    }
    
}
extension EventNotificationViewController: UITableViewDataSource, UITableViewDelegate, EventFilterPopupDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EventNotificationListCell.identifier, for: indexPath) as! EventNotificationListCell
        
        let item = eventList[indexPath.row]
        
        cell.title.text = item.assetName
        cell.dateLabel.text = item.regDate
        
        cell.eventLabel.text = item.eventName

        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row) 번 째 리스트 클릭 => id : \(self.eventList[indexPath.row].id)")
        
        getEventVideoFileDownload(id: self.eventList[indexPath.row].id!, index: indexPath.row)
    }
    

    func popupDidSelectButton(date: String, id: Int, event: String) {
        LoadingIndicator.shared.show()
//        print("필터 적용 완료!!!!! : date = \(date), id = \(id), event = \(event)")
        updateRequestParameters(searchDate: date)
        getEventLogsApi()
        
        // filter
        Task {
            try await Task.sleep(nanoseconds: 3_000_000_000) // 3초 (나노초 단위)
            filterListData(id: id, event: event)
        }
        
    }
    
    func filterListData(id: Int?, event: String?) {
        // 필터 리스트 초기화
        self.filterEventList.removeAll()
        
        if id == 0 || id == nil {
            if event == nil || event == "선택" || event == "" {
                // 필터 없음
                LoadingIndicator.shared.hide()
//                Toaster.shared.makeToast("검색 결과가 없습니다.", .short)
                return
            } else {
                // event만
                for data in eventList {
                    print("Comparing: \(data.eventName), event: \(event)")
                    if data.eventName == event {
                        self.filterEventList.append(data)
                    }
                }
            }
        } else {
            if event == nil || event == "선택" || event == ""{
                // id 만
                for data in eventList {
                    print("Comparing: \(data.assetId), id: \(id)")
                    if data.assetId == id {
                        self.filterEventList.append(data)
                    }
                }
            } else {
                // id 와 event 둘다
                for data in eventList {
                    print("Comparing: \(data.assetId), id: \(id)// \(data.eventName), event: \(event)")
                    if data.assetId == id && data.eventName == event{
                        self.filterEventList.append(data)
                    }
                }
            }
        }
        
        self.eventList = self.filterEventList
        if self.eventList.count == 0{
            Toaster.shared.makeToast("검색 결과가 없습니다.", .short)
        }
        
        self.tableView.reloadData()
        LoadingIndicator.shared.hide()
    }


    // event Video 파일 다운로드 api
    func getEventVideoFileDownload(id: Int, index: Int) {
        let url = "\(baseDataApiUrl)event/download?eventId=\(id)"
        // HTTP 헤더
        let headers: HTTPHeaders = [
            "Authorization": "test"
        ] //"Content-Type": "application/json"
        
        Toaster.shared.makeToast("다운로드 시작...", .middle)
        LoadingIndicator.shared.show()
        AF.request(
            url,
            method: .get,
            encoding: JSONEncoding.default,
            headers: headers
        ).validate(statusCode: 200..<600)
            .response { response in
                switch response.result {
                    case .success(let data):
                        print("getEventVideoFileDownload ==> data : \(data)")
//                        self.detectVideoFileDownload(data!, eventResult: self.eventList[index])
                        self.saveToDownloads(data: data!, eventResult: self.eventList[index], viewController: self)
                    case .failure(let error):
                        print("getEventVideoFileDownload ==== > error : \(error)")
                        // 메인 스레드에서 UI 업데이트
                        DispatchQueue.main.async {
                            LoadingIndicator.shared.hide()
                        }
                        Toaster.shared.makeToast("다운로드 실패.", .short)
                }
                
            }
    }
    
    // 파일 저장하기
//    func detectVideoFileDownload(_ data: Data, eventResult: EventResult) {
//        do {
//            // 저장할 폴더 경로
//            let fileManager = FileManager.default
//            let folderName = "ai_event_detect"
//            let folderURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(folderName)
//            
//            // 폴더가 없으면 생성
//            if !fileManager.fileExists(atPath: folderURL.path) {
//                try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
//            }
//            
//            // 파일명 설정
//            let regDate = eventResult.regDate?.split(separator: " ")[0]
//            let regTime = eventResult.regDate?.split(separator: " ")[1].replacingOccurrences(of: ":", with: "_")
//            
//           
//            if let date = regDate, let time = regTime, let name = eventResult.eventName {
//                let fileName = "\(date) \(time) \(name).mp4"
//                let fileURL = folderURL.appendingPathComponent(fileName)
//                
//                // 데이터 쓰기
//                try data.write(to: fileURL)
//                
//                // 다운로드 완료 알림
//                DispatchQueue.main.async {
//                    print("다운로드 완료: \(fileURL.path)")
//                }
//            }
//            
//        } catch {
//            print("파일 저장 실패: \(error.localizedDescription)")
//        }
//    }
    
    // 파일 저장하기
    func saveToDownloads(data: Data, eventResult: EventResult, viewController: UIViewController) {
        let fileManager = FileManager.default
        let folderName = "Downloads" // 다운로드 폴더
        
        LoadingIndicator.shared.hide()
        
        do {
            // 파일명 설정
            let regDate = eventResult.regDate?.split(separator: " ")[0]
            let regTime = eventResult.regDate?.split(separator: " ")[1].replacingOccurrences(of: ":", with: "_")
            
            if let date = regDate, let time = regTime, let name = eventResult.eventName {
                let fileName = "\(date) \(time) \(name).mp4"
                
                // 임시 저장 (iOS는 바로 Downloads 폴더에 저장 불가하므로 임시 경로 사용)
                let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
                try data.write(to: tempURL)
                
                // UIDocumentPicker로 사용자가 다운로드 위치 선택
                let picker = UIDocumentPickerViewController(forExporting: [tempURL])
                picker.delegate = viewController as? UIDocumentPickerDelegate
                picker.modalPresentationStyle = .formSheet
                viewController.present(picker, animated: true)
            }
            
            Toaster.shared.makeToast("다운로드 완료", .short)
            
        } catch {
            print("파일 저장 실패: \(error.localizedDescription)")
        }
    }
    
}
