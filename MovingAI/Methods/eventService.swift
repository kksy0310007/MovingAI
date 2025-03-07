//
//  eventService.swift
//  MovingAI
//
//  Created by soyoung on 2/28/25.
//
import UIKit
import UserNotifications
import BackgroundTasks


class eventService {
    
    static let shared = eventService()
    private var timer: Timer?
    private var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    
    var responseEventList: [EventResult] = []
    var processedEventList: [EventResult] = []
    
    private init() {}
    
    // 서비스 시작
    func start() {
        requestNotificationPermission()
        startBackgroundTask()
    }
    
    // 1. 푸시 알림 권한 요청
    private func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print(" 푸시 알림 권한 허용 ")
            } else {
                print(" 푸시 알림 권한 거부 됨 : \(error?.localizedDescription ?? "")")
            }
        }
    }
    
    // 2. 백그라운드 작업 실행
    private func startBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask(withName: "eventBackgroundTask", expirationHandler: {
            UIApplication.shared.endBackgroundTask(self.backgroundTask)
            self.backgroundTask = .invalid
        })
        
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(fetchEvents), userInfo: nil, repeats: true)
    }
    
    // 3. 서버에서 이벤트 가져오기
    @objc private func fetchEvents() {
        self.responseEventList.removeAll()
        
        let allSitesAssetsList: [AssetData] = TopAssetsMethods.shared.allSitesAssets
        
        let params: [String: Any] = [
            "page": 1,
            "size": 10,
            "sort": ["id,desc"],
            "id": -1,
            "searchDate": ""
        ]
        
        ApiRequest.shared.getEventLogs(params: params) { response, error in
            if let data = response {
                    for targetAssetData in allSitesAssetsList {
                        for targetEventResult in data {
                            if targetEventResult.assetId == targetAssetData.id {
                                self.responseEventList.append(targetEventResult)

                                self.handleEvents(self.responseEventList)
                                print("이벤트 푸시 Data !!!!!!!!! ==== > handleEvents : \(self.responseEventList)")
                            }
                        }
                    }
                if self.processedEventList.count == 0 {
                    self.processedEventList = self.responseEventList
                }
                
            } else {
                print("getEventLogsApi 2 ==== > error : \(error)")
            }
        }
        
    }
    
    // 4. 이벤트 처리 및 푸시 알림 전송
    private func handleEvents(_ events: [EventResult]) {
        guard let latestEvent = events.first else { return }
        print("이벤트 푸시!!!!!!!!! ==== > name : \(latestEvent.assetName), \(latestEvent.eventName)")
        self.sendNotification(title: "이벤트 감지 - \(latestEvent.eventName!)", message: "[ \(latestEvent.assetName!) ]  \(latestEvent.regDate!)")
//        DispatchQueue.main.async {
//            
//        }
    }

    // 5. 로컬 푸시 알림 전송
    private func sendNotification(title: String, message: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = message
        content.sound = UNNotificationSound.default

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("푸시 알림 오류: \(error.localizedDescription)")
            } else {
                print("푸시 알림 전송됨: \(title) - \(message)")
            }
        }
    }
}

