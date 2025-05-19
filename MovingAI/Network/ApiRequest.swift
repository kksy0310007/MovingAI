//
//  ApiRequest.swift
//  MovingAI
//
//  Created by soyoung on 2/24/25.
//
import Foundation
import Alamofire

class ApiRequest {
    
    private let commonHeaders: HTTPHeaders = ["Authorization": "test",
                                              "Accept": "application/json"]
    
    private let broadcaseHeaders: HTTPHeaders = [
        "Authorization": "test",
        "Content-Type": "application/json",
        "Accept": "application/json"
    ]
    
    static let shared: ApiRequest = ApiRequest()
    
    
    
    
    //   Login   //
    
    func loginAttempt(encUserName: String, encPassword: String, completion: @escaping (MovingAiUserAccount?, Error?) -> Void){
        
        AF.request(ApiUrl.loginApiUrl + "\(encUserName)/\(encPassword)", method: .get, headers: commonHeaders)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: MovingAiUserAccount.self) { response in
                switch response.result {
                case .success(let value):
//                    print("@ loginAttempt @ - 성공하였습니다 :: \(value)")
                    completion(value, nil)
                    
                case .failure(let error):
                    print("@ loginAttempt @ - 실패하였습니다 :: \(error)" )
                    completion(nil, error)
                }
            }
    }
    
    
    
    //   Main   //
    
    func getOnlineDevice(completion: @escaping ([NxCamDeviceInfo]?, Error?) -> Void){
//        baseGetRequest(apiUrl: ApiUrl.onlineDevice, completion: completion)
        
        AF.request(
            ApiUrl.onlineDevice,
            method: .get,
            headers: commonHeaders
        ).validate(statusCode: 200..<300) // 상태 코드 유효성 검증
        .responseDecodable(of: [NxCamDeviceInfo].self) { response in
            switch response.result {
        
            case .success(let value):
//                print("@ getOnlineDevice @ - 성공하였습니다 :: \(value)")
                completion(value, nil)
        
            case .failure(let error):
                print("@ getOnlineDevice @ - 실패하였습니다 :: \(error)" )
                completion(nil, error)
                break
            }
        }
    }
    
    func getAllAssets(completion: @escaping ([AssetData]?, Error?) -> Void){
        AF.request(
            ApiUrl.allAssets,
            method: .get,
            headers: commonHeaders
        ).validate(statusCode: 200..<300) // 상태 코드 유효성 검증
            .responseDecodable(of: [AssetData].self) { response in
                switch response.result {
                    
                case .success(let value):
//                    print("@ getAllAssets @ - 성공하였습니다 :: \(value)")
                    completion(value, nil)
                case .failure(let error):
                    print("@ getAllAssets @ - 실패하였습니다 :: \(error)" )
                    completion(nil, error)
                    break
                }
            }
    }
    
    func getAllSites(completion: @escaping ([AttachData]?, Error?) -> Void){
        AF.request(
            ApiUrl.allSites,
            method: .get,
            headers: commonHeaders
        ).validate(statusCode: 200..<300) // 상태 코드 유효성 검증
            .responseDecodable(of: [AttachData].self) { response in
                switch response.result {
                
                case .success(let value):
//                    print("@ getAllSites @ - 성공하였습니다 :: \(value)")
                    completion(value, nil)
                case .failure(let error):
                    print("@ getAllSites @ - 실패하였습니다 :: \(error)" )
                    completion(nil, error)
                    break
                    
                }
            }
    }
    
    func getOneAssetsData(id: Int,completion: @escaping ([AssetData]?, Error?) -> Void){
        AF.request(
            ApiUrl.oneAssetsData + "\(id)",
            method: .get,
            headers: commonHeaders
        ).validate(statusCode: 200..<300) // 상태 코드 유효성 검증
            .responseDecodable(of: [AssetData].self) { response in
                switch response.result {
                
                case .success(let value):
//                    print("@ getOneAssetsData @ - 성공하였습니다 :: \(value)")
                    completion(value, nil)
                    
                case .failure(let error):
                    print("@ getOneAssetsData @ - 실패하였습니다 :: \(error)" )
                    completion(nil, error)
                }
            }
    }
    
    
    //   CamMonitor   //
    
    func getPresetVoiceData(completion: @escaping ([PresetManageData]?, Error?) -> Void){
        
        AF.request(
            ApiUrl.presetVoiceData,
            method: .get,
            headers: commonHeaders
        ).validate(statusCode: 200..<300)
            .responseDecodable(of: [PresetManageData].self) { response in
                switch response.result {
                
                case .success(let value):
//                    print("@ getPresetVoiceData @ - 성공하였습니다 :: \(value)")
                    completion(value, nil)
                    
                case .failure(let error):
                    print("@ getPresetVoiceData @ - 실패하였습니다 :: \(error)" )
                    completion(nil, error)
                }
        }
    }
    
    
    func getPresetVoiceDeviceData(sessionId: String, completion: @escaping ([PresetData]?, Error?) -> Void){
        
        let parameters: Parameters = [
               "filename": "",
               "path": "PRESET",
               "sessionId": sessionId
        ]
        
        AF.request(
            ApiUrl.presetVoiceDeviceData,
            method: .get,
            parameters: parameters,
            encoding: URLEncoding.queryString,
            headers: commonHeaders
        ).validate(statusCode: 200..<300)
            .responseDecodable(of: [PresetData].self) { response in
                switch response.result {
                case .success(let value):
//                    print("@ getPresetVoiceDeviceData @ - 성공하였습니다 :: \(value)")
                    completion(value, nil)
                
                case .failure(let error):
                    print("@ getPresetVoiceDeviceData @ - 실패하였습니다 :: \(error)" )
                    completion(nil, error)
                }
        }
    }
    
    
    func setPatrolOn(sessionId: String, completion: @escaping (Bool, Error?) -> Void){
                   
            AF.request(
                ApiUrl.patrolOn + "\(sessionId)/true",
                method: .put,
                headers: commonHeaders
            ).validate(statusCode: 200..<300)
                .responseData { response in
                    switch response.result {
                        case .success:
//                            print("@ setPatrolOn @ - 성공하였습니다 :: ")
                            completion(true, nil)
                            
                        case .failure(let error):
                            print("@ setPatrolOn @ - 실패하였습니다 :: \(error)" )
                            completion(false, error)
                    }
            }
    }
    
    
    func setPatrolOff(sessionId: String, completion: @escaping (Bool, Error?) -> Void){
                   
            AF.request(
                ApiUrl.patrolOff + "\(sessionId)/false",
                method: .put,
                headers: commonHeaders
            ).validate(statusCode: 200..<300)
                .responseData { response in
                    switch response.result {
                        case .success:
//                            print("@ setPatrolOff @ - 성공하였습니다 :: ")
                            completion(true, nil)
                            
                        case .failure(let error):
                            print("@ setPatrolOff @ - 실패하였습니다 :: \(error)" )
                            completion(false, error)
                    }
            }
    }
    
    func setCamRotateControl(session: String, direction: Int, completion: @escaping (Bool, Error?) -> Void){
        
        AF.request(
            ApiUrl.camRotateControl + "\(session)/\(direction)",
            method: .get,
            headers: commonHeaders
        ).validate(statusCode: 200..<300)
            .response { response in
                    switch response.result {
                        case .success:
//                            print("@ setCamRotateControl @ - 성공하였습니다 :: ")
                            completion(true, nil)
                            
                        case .failure(let error):
                            print("@ setCamRotateControl @ - 실패하였습니다 :: \(error)" )
                            completion(false, error)
                    }
            }
    }
    
    func getPlayPresetVoice(targetURL: String, completion: @escaping (Bool, Error?) -> Void){
        
        AF.request(
            ApiUrl.playPresetVoice + targetURL,
            method: .get,
            headers: commonHeaders
        ).validate(statusCode: 200..<300)
            .response { response in
                switch response.result {
                    case .success(let data):
//                        print("@ getPlayPresetVoice @ - 성공하였습니다 :: ")
                        completion(true, nil)
                    case .failure(let error):
                        print("@ getPlayPresetVoice @ - 실패하였습니다 :: \(error)" )
                        completion(false, error)
                }
                
            }
    }
    
    func setBroadcastHistoryCreate(sessionId: String, apiType: String, eventKind: String, completion: @escaping (Bool, Error?) -> Void){
        
        guard let sessionIdInt = Int(sessionId) else {
            print("Error: sessionId를 Int로 변환할 수 없음")
            completion(false, NSError(domain: "Invalid sessionId", code: -1, userInfo: nil))
                return
        }
        
        // 요청 파라미터
        let parameters: [String: Any] = [
            "id": sessionIdInt,
            "apiType": apiType,
            "eventKind": eventKind,
            "userId": UserAccountMethods.shared.movingAIUserAccount?.userId ?? ""
        ]
        print("!!!@ setBroadcastHistoryCreate @ - parameters :: \(parameters)" )
        
        AF.request(
            ApiUrl.broadcastHistoryCreate,
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: broadcaseHeaders
        ).validate(statusCode: 200..<300)
            .response { response in
                switch response.result {
                    case .success(let data):
//                        print("@ setBroadcastHistoryCreate @ - 성공하였습니다 :: ")
                        completion(true, nil)

                    case .failure(let error):
                        print("@ setBroadcastHistoryCreate @ - 실패하였습니다 :: \(error)" )
                        completion(false, error)
                }
                
            }
    }
    
    
    func getEventLogs(params: [String: Any], completion: @escaping ([EventResult]?, Error?) -> Void){
        
        AF.request(
            ApiUrl.eventLogs,
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: commonHeaders
        ).validate(statusCode: 200..<600)
            .responseDecodable(of: [EventResult].self) { response in
                switch response.result {
                    case .success(let data):
                        print("@ getEventLogs @ - 성공하였습니다 :: \(data)")
                        completion(data, nil)

                        
                    case .failure(let error):
                        print("@ getEventLogs @ - 실패하였습니다 :: \(error)" )
                        completion(nil, error)
                }
            }
    }
    
    func getEventVideoFileDownload(id: Int, completion: @escaping (Data?, Error?) -> Void) {
        
        AF.request(
            ApiUrl.eventVideoFileDownload + "eventId=\(id)",
            method: .get,
            encoding: JSONEncoding.default,
            headers: commonHeaders
        ).validate(statusCode: 200..<600)
            .response { response in
                switch response.result {
                    case .success(let data):
//                        print("@ getEventVideoFileDownload @ - 성공하였습니다 :: data = \(data)")
                        completion(data, nil)

                    case .failure(let error):
                        print("@ getEventVideoFileDownload @ - 실패하였습니다 :: \(error)" )
                        completion(nil, error)
                        
                }
                
            }
    }
    
    func getAssetAiModel(assetId: Int?, assetName: String?, siteId: Int?, siteName: String?, completion: @escaping ([AssetAiModelData]?, Error?) -> Void){
        
        // 요청 파라미터: nil이 아닌 값만 포함
            var parameters: [String: Any] = [:]
            
            if let assetId = assetId {
                parameters["assetId"] = assetId
            }
            if let assetName = assetName {
                parameters["assetName"] = assetName
            }
            if let siteId = siteId {
                parameters["siteId"] = siteId
            }
            if let siteName = siteName {
                parameters["siteName"] = siteName
            }
        
        print("!!!@ getAssetAiModel @ - parameters :: \(parameters)" )
        
        AF.request(
            ApiUrl.postAssetAiModel,
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: commonHeaders
        ).validate(statusCode: 200..<300)
            .responseDecodable(of: [AssetAiModelData].self) { response in
                switch response.result {
                    case .success(let data):
                        print("@ getAssetAiModel @ - 성공하였습니다 :: ")
                        completion(data, nil)

                        
                    case .failure(let error):
                        print("@ getAssetAiModel @ - 실패하였습니다 :: \(error)" )
                        completion(nil, error)
                }
            }
    }
}
