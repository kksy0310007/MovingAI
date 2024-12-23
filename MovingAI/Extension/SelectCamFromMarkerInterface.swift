//
//  SelectCamFromMarkerInterface.swift
//  MovingAI
//
//  Created by soyoung on 12/20/24.
//

import UIKit
import WebKit

class SelectCamFromMarkerInterface: NSObject, WKScriptMessageHandler {
    
    private var context: UIViewController
    private var deviceList: [NxCamDeviceInfo] // 장비 정보 리스트
    
    init(context: UIViewController, deviceList: [NxCamDeviceInfo]) {
        self.context = context
        self.deviceList = deviceList
        
        print("SelectCamFromMarkerInterface => deviceList : \(deviceList)")
    }
    
    // JavaScript 메시지 처리
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("SelectCamFromMarkerInterface => message.name : \(message.name), message.body : \(message.body)" )
        if message.name == "MarkerInterface", let markerTitle = message.body as? String {
            handleMarkerSelection(markerTitle)
        }
    }
    
    private func handleMarkerSelection(_ markerTitle: String) {
        let markerDataSplit = markerTitle.split(separator: ",").map { String($0) }
        guard let sessionId = markerDataSplit.first else { return }
        
        if let selectedDevice = deviceList.first(where: { $0.sessionId == sessionId }) {
            NxCamMethods.shared.setSelectedDeviceInfo(selectedDevice)
            NxCamMethods.shared.changeScreen(context, to: CamMonitorViewController.self)
        }
    }
}
