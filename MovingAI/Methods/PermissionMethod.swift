//
//  PermissionMethod.swift
//  MovingAI
//
//  Created by soyoung on 12/16/24.
//

import Foundation
import AVFoundation
import Photos
import PhotosUI
import CoreLocation

class PermissionMethod: ObservableObject {
    
    // 앱 처음 시작만 사용
    @Published var permissionNotCompleted: Bool {
        didSet {
            UserDefaults.standard.set(permissionNotCompleted, forKey: "PermissionNotCompleted")
        }
    }
    
    init() {
        // UserDefaults에서 값을 가져오고, 값이 없으면 true로 설정.
        self.permissionNotCompleted = UserDefaults.standard.object(forKey: "PermissionNotCompleted") as? Bool ?? true
    }
    
    // 권한 요청 시작
    func requestPermission() {
        requestAccessCamera()
    }
    
    // 카메라 권한 요청
    func requestAccessCamera() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            self.requestAccessAlbum()
        }
    }
    
    // 엘범 권한 요청
    func requestAccessAlbum() {
        PHPhotoLibrary.requestAuthorization(){ granted in
        
            switch granted {
                case .authorized:
                    // 허용.
                    print("Album 권한 허용.")
                case .denied:
                    // 허용 거부.
                    print("Album 권한 거부.")
                case .restricted, .notDetermined:
                    print("Album 선택하지 않음.")
                default:
                    break
            }
            self.requestAccessAudio()
        }
    }
    
    // 오디오 권한 요청
    func requestAccessAudio() {
        AVCaptureDevice.requestAccess(for: .audio) { accessGranted in
            self.requestMicrophonePermission { granted in
                self.requestAccessLocation()
            }
        }
    }
    
    // 마이크 퀀한 요청
    func requestMicrophonePermission(completion: @escaping (Bool) -> Void) {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            DispatchQueue.main.async {
                if granted {
                    // 허용.
                    completion(granted)
                    
                } else {
                    // 거부.
                    
                }
            }
        }
    }
    
    // 위치 권한 요청
    func requestAccessLocation() {
        var locationManager = CLLocationManager()
        
        if #available(iOS 14.0, *) {

            if locationManager.authorizationStatus == .authorizedAlways
                || locationManager.authorizationStatus == .authorizedWhenInUse {
                print("==> 위치 서비스 On 상태")
                locationManager.startUpdatingLocation() //위치 정보 받아오기 시작 - 사용자의 현재 위치를 보고하는 업데이트 생성을 시작
            } else if locationManager.authorizationStatus == .notDetermined {
                print("==> 위치 서비스 Off 상태")
                locationManager.requestWhenInUseAuthorization()
            } else if locationManager.authorizationStatus == .denied {
                print("==> 위치 서비스 Deny 상태")
            }

        } else {

            // Fallback on earlier versions
            if CLLocationManager.locationServicesEnabled() {
                print("위치 서비스 On 상태")
                locationManager.startUpdatingLocation() //위치 정보 받아오기 시작 - 사용자의 현재 위치를 보고하는 업데이트 생성을 시작
                print("LocationViewController >> checkPermission() - \(String(describing: locationManager.location?.coordinate))")
            } else {
                print("위치 서비스 Off 상태")
                locationManager.requestWhenInUseAuthorization()
            }

        }
        
        requestNotification()
    }
    
    // 푸시 권한 요청
    func requestNotification() {
        UNUserNotificationCenter.current().getNotificationSettings { permission in
            switch permission.authorizationStatus {
            case .authorized:
                // 허용.
                print(" 푸시 수신 동의")
            case .denied:
                // 거부.
                print(" 푸시 수신 거부")
            case .notDetermined:
                // 한번 허용.
                print(" 푸시 한번 허용")
            case .provisional:
                // 임시 중단.
                print(" 푸시 임시 중단")
            case .ephemeral:
                // 부분적 동의
                print("푸시 설정이 App Clip에 대해서만 부분적으로 동의.")
            @unknown default:
                print("Unknow Status")
            }
        }
        self.complete()
    }
    
    // 완료되면 FullScreen을 내리기 위해 false로 처리
    func complete() {
        print("모든 권한 묻기 완료")
        self.permissionNotCompleted = false
    }
    
    
}
