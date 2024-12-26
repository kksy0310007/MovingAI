//
//  CamListViewController.swift
//  MovingAI
//
//  Created by soyoung on 12/5/24.
//


import UIKit

class CamListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    private let tableView : UITableView = { // 테이블 뷰 생성
            let tableView = UITableView()
            tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.register(CamListCell.self, forCellReuseIdentifier: CamListCell.identifier)
            return tableView
    }()
    
    private let deviceCountLabel : UILabel = {
        let label = UILabel()
        label.text = "운용장비: 00대 / 전체: 00대"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    
    let nxCamData = NxCamMethods.shared
    
    var camList: [NxCamDeviceInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 상단 타이틀 바
        addNavigationBar(titleString: "실시간 목록",isBackButtonVisible: false)
        
        view.backgroundColor = UIColor(cgColor: CGColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1.0))
        
        // 운용 전체 장비 라벨
        view.addSubview(deviceCountLabel)
        
        // tableview 설정
        tableView.dataSource = self
        tableView.rowHeight = 97
        tableView.delegate = self
//        tableView.isScrollEnabled = false
//        tableView.bounces = false
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .lightGray
        tableView.separatorInset = .zero
        view.addSubview(tableView)
        
        // tableview 위치, 크기
        setConstraint()
        
        deviceCountShow()
        camList = nxCamData.getDeviceInfoList()
    }
    
    private func setConstraint() {
        deviceCountLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalTo(44)
            
        }
        
        
        tableView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.top.equalTo(deviceCountLabel.snp.bottom)
        }
    }
    
    /** 온라인 장비 / 전체 장비 표시 기능 정의 */
    private func deviceCountShow() {
        let deviceCount = nxCamData.getDeviceInfoList().count
        let totalCount = TopAssetsMethods.shared.getAllSitesAssetsList().count
        
        deviceCountLabel.text = String(format: "운용장비: %d대 / 전체: %d대", deviceCount, totalCount)
    }
    
    // 셀 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nxCamData.getDeviceInfoList().count
    }
    
    // 셀에 데이터 넣음
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CamListCell.identifier, for: indexPath) as! CamListCell
                
            cell.title.text = camList[indexPath.row].deviceName
            cell.dateLabel.text = camList[indexPath.row].eventTime
            cell.selectionStyle = .none
            return cell

    }

    // 각 셀 클릭 시 호출
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("select \(indexPath.row)")
        
    }

}
