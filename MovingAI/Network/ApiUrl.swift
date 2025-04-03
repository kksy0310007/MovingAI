//
//  ApiUrl.swift
//  MovingAI
//
//  Created by soyoung on 2/24/25.
//
// 통신 주소값

struct ApiUrl {
    
    
    // BaseUrl //
    
    // 장비에서 바로 가져오는 데이터 (카메라 회전, 실시간 영상, 음성파일, 현재 켜져있는 모든 장비 리스트 등)
    static let baseApiUrl: String = "https://platform.moving-ai.com/api/v1/"
    
    // 그 외 서버에서 가져오는 데이터 (현장 별 장비 리스트 등)
    static let baseDataApiUrl: String = "https://moving-ai.com/api/v1/"
    
    
    
    
    
    
    
    // login
    static let loginApiUrl: String = "https://moving-ai.com/outside/"
    
    // onlineDevices
    static let onlineDevice: String = baseApiUrl + "manage/deviceList"
    
    // allAssets
    static let allAssets: String = baseDataApiUrl + "asset/-1"
    
    // allSites
    static let allSites: String = baseDataApiUrl + "attach/-1"
    
    // oneAssetsData
    static let oneAssetsData: String = baseDataApiUrl + "/asset/"
    
    // presetVoiceData  // 안내방송 리스트 통신으로 가져옴
    static let presetVoiceData: String = baseDataApiUrl + "/preset"
    
    // presetVoiceDeviceData  // 장비에 있는 프리셋 폴더 파일 리스트
    static let presetVoiceDeviceData: String = baseApiUrl + "manage/fileList"
    
    // patrolOn
    static let patrolOn: String = baseDataApiUrl + "nxcamPatrol/"
    
    // patrolOff
    static let patrolOff: String = baseDataApiUrl + "nxcamPatrol/"
    
    // camRotateControl
    static let camRotateControl: String = baseApiUrl + "control/ptz/"
    
    // playPresetVoice
    static let playPresetVoice: String = baseApiUrl + "control/preset/"
    
    // broadcastHistoryCreate
    static let broadcastHistoryCreate: String = baseDataApiUrl + "broadcastHistory/create"
    
    // eventLogs
    static let eventLogs: String = baseDataApiUrl + "event"
    
    // eventVideoFileDownload
    static let eventVideoFileDownload: String = baseDataApiUrl + "event/download?"
    
    // aiModelData
    static let postAssetAiModel: String = baseDataApiUrl + "asset"
}
