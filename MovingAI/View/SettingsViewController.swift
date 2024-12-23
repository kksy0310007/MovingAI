//
//  SettingsViewController.swift
//  MovingAI
//
//  Created by soyoung on 12/5/24.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let titles = ["푸시 알림 설정", "로그아웃"]
    
    var customTabBar = CustomTabBar()
//    var customTabBarVC = CustomTabBarController()
    
    private let tableView : UITableView = { // 테이블 뷰 생성
            let tableView = UITableView()
            tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.register(SettingsCell.self, forCellReuseIdentifier: SettingsCell.identifier)
            return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 상단 타이틀 바
        addNavigationBar(titleString: "설정",isBackButtonVisible: true)
        navigationController?.navigationBar.tintColor = UIColor.white
        
//        customTabBar.didTapButton = { [unowned self] in
//            self.navigationController?.popViewController(animated: true)
//            self.customTabBarVC.selectedIndex = 1
//        }
        
        // tableview 설정
        tableView.dataSource = self
        tableView.rowHeight = 61
        tableView.delegate = self
        tableView.isScrollEnabled = false
        tableView.bounces = false
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .lightGray
        tableView.separatorInset = .zero
        view.addSubview(tableView)
        
        // tableview 위치, 크기
        setConstraint()
        
        
    }

    private func setConstraint() {
        tableView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // 셀 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    // 셀에 데이터 넣음
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.identifier, for: indexPath) as! SettingsCell
                
            cell.title.text = titles[indexPath.row]
            cell.selectionStyle = .none
            return cell

    }

    // 각 셀 클릭 시 호출
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("select \(indexPath.row)")
        
        switch indexPath.row {
            case 0:
                // 푸시 알림 설정 화면 이동 -> SettingsNotificationActivity
                break
            case 1:
                // 로그아웃 팝업
                break
            default:
                break
            
        }
        
        
    }

}
