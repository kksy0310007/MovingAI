//
//  AppDelegate.swift
//  MovingAI
//
//  Created by soyoung on 12/5/24.
//

import UIKit
import BackgroundTasks
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    let taskId = "com.youngshine.MovingAI.background.task.identifier"


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UNUserNotificationCenter.current().delegate = self
        
//        BGTaskScheduler.shared.register(forTaskWithIdentifier: taskId, using: nil) { task in
//            self.handleBackgroundTask(task: task as! BGProcessingTask)
//        }
        
        eventService.shared.start()
        
        return true
    }

    // 백그라운드 작업 실행 함수
//    private func handleBackgroundTask(task: BGProcessingTask) {
//        eventService.shared.start()
//        task.setTaskCompleted(success: true)
//      }

      // 앱이 백그라운드에 있을 때 주기적으로 실행 요청
//    func scheduleBackgroundTask() {
//        print("이벤트 푸시!!!!!!!!! scheduleBackgroundTask")
//        let request = BGProcessingTaskRequest(identifier: taskId)
//        request.earliestBeginDate = Date(timeIntervalSinceNow: 60 * 5) // 5분 후 실행
//        try? BGTaskScheduler.shared.submit(request)
//    }
//
//    func applicationDidEnterBackground(_ application: UIApplication) {
//        scheduleBackgroundTask()
//    }
    
    // 디바이스 토큰 등록
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token : \(token)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: any Error) {
        print("Failed to register for remote notifications: \(error)")
    }
    
    // 포그라운드 푸시 수신
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // 포그라운드에서 알림을 어떻게 표시할지 결정한다.
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // 사용자가 알림을 탭했을 때의 동작을 처리한다.
        let userInfo = response.notification.request.content.userInfo
        print("알림을 탭했을 때의 동작 userInfo: \(userInfo)")
        completionHandler()
    }
    
    // 백그라운드 모드 설정
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String) async {
//        completHandler()
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // 세로모드 고정
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }


}

