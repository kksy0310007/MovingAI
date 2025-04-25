//
//  BottomSheetView.swift
//  MovingAI
//
//  Created by soyoung on 1/17/25.
//

import UIKit
import SnapKit

protocol BottomSheetDelegate: AnyObject {
    func bottomSheetDidSelectItem(index: Int)
}

class BottomSheetView: UIView {
    
    let nxCamData = NxCamMethods.shared
    var camList: [NewNxCamDeviceInfo] = []
    
    // 델리게이트 선언
    weak var delegate: BottomSheetDelegate?
    
    var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(cgColor: CGColor(red: 207/255, green: 207/255, blue: 207/255, alpha: 1.0))
        return view
    }()
    
    let tableView : UITableView = {
        let tableView = UITableView()
        tableView.register(CamListCell.self, forCellReuseIdentifier: CamListCell.identifier)
        return tableView
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
            
        setupViewHierarchy()
        setupViewAttributes()
        setupLayout()
                
        // 리스트 중복 제거
        let originalList = nxCamData.getNewDeviceInfoList()
        var seenSerials = Set<String>()
        let uniqueList = originalList.filter { deviceInfo in
            let serial = deviceInfo.deviceData.deviceSerial
            if seenSerials.contains(serial) {
                return false
            } else {
                seenSerials.insert(serial)
                return true
            }
        }

        camList = uniqueList
        
        tableView.reloadData() // 데이터 소스 갱신
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func setupViewHierarchy(){
        self.addSubview(lineView)
        self.addSubview(tableView)
    }
        
    func setupViewAttributes(){
        self.backgroundColor = .white
        
        self.layer.cornerRadius = 28
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner] // 왼쪽 위, 오른쪽 위 모서리만 둥글게
        self.clipsToBounds = true
        
        tableView.dataSource = self
        tableView.delegate = self
    }
        
    func setupLayout(){
        lineView.layer.cornerRadius = 5
        lineView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(4)
            make.centerX.equalToSuperview()
            make.width.equalTo(30)
        }
        
        tableView.backgroundColor = .red
        tableView.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview().inset(10)
        }
        tableView.rowHeight = CamListCellHeight.simple.rawValue
    }
}
extension BottomSheetView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nxCamData.getNewDeviceInfoList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CamListCell.identifier, for: indexPath) as! CamListCell
        
        let height = CamListCellHeight.simple
        cell.updateCellHeight(to: height)
        
        cell.title.text = camList[indexPath.row].name
        cell.selectionStyle = .none
            
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected item at row \(indexPath.row)")
        
        let nxCamData = NxCamMethods.shared
        let selected = nxCamData.getNewDeviceInfoList()[indexPath.row]
        nxCamData.setNewSelectedDeviceInfo(selected)
        print("selected =  \(selected.deviceData.deviceName)")
        
        self.delegate?.bottomSheetDidSelectItem(index: indexPath.row)
    }
}
