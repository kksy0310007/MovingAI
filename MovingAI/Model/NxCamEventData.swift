//
//  NxCamEventData.swift
//  MovingAI
//
//  Created by soyoung on 2/7/25.
//

import Foundation

//enum EnxCamEvent {
//    case battery
//    case faint
//    case hook
//    case helmet
//    case invasion
//    case panic
//    case fire
//}

class NxCamEventData {
    func setEventNameAutomatic(event: String) -> String {
        switch event {
        case "battery":
            return "배터리 잔량"
        case "faint":
            return "쓰러짐"
        case "hook":
            return "안전고리"
        case "helmet":
            return "안전모 미착용"
        case "invasion":
            return "위험구역 침입"
        case "panic":
            return "패닉"
        case "fire":
            return "화재"
        default:
            return event // 기본값
        }
    }
}
