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
        
        print("감지 이벤트 목록 api 호출 requestParams ==== >  \(requestParams)")
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
                        print("감지 이벤트 목록 api 호출 getEventLogsApi ==== > success data : \(data)")

                        let allSitesAssetsList: [AssetData] = TopAssetsMethods.shared.allSitesAssets
                    
                            for targetAssetData in allSitesAssetsList {
                                for targetEventResult in data {
                                    if targetEventResult.assetId == targetAssetData.id {
                                        print("호출 확인 3==== > targetEventResult.assetId : \(targetEventResult.assetId), targetAssetData.id : \(targetAssetData.id)")
                                        self.eventList.append(targetEventResult)
                                    }
                                }
                            }
                        
                        if self.eventList != nil {
                            print("감지 이벤트 목록 api 호출 !!!! ==== > eventList : \(self.eventList)")
                            self.tableView.reloadData()
                        } else {
                            Toaster.shared.makeToast("이벤트가 존재하지 않습니다.", .short)
                        }
                    case .failure(let error):
                        print("감지 이벤트 목록 api 호출 getEventLogsApi ==== > error : \(error)")
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
        return [
               "page": page ?? 1,
               "size": 10,
               "sort": ["regDate,desc"],
               "id": id ?? -1,
               "searchDate": searchDate //?? getCurrentDate() // 기본값: 오늘 날짜
           ]
    }
    
    func updateRequestParameters(
        page: Int? = nil,
        id: Int? = nil,
        searchDate: String? = nil
    ) {
        requestParams = createRequestParameters(page: page, id: id, searchDate: searchDate)
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
    

    func popupDidSelectButton(date: String, id: Int, event: String) {
        print("필터 적용 완료!!!!! : date = \(date), id = \(id), event = \(event)")
//        updateRequestParameters(id: id, searchDate: date)
//        getEventLogsApi()
    }
    
}
