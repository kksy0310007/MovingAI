//
//  AudioStreamingManager.swift
//  MovingAI
//
//  Created by soyoung on 1/15/25.
//

import AVFoundation
import Starscream

/// 음성송출 기능 (오디오 녹음 + 웹 소켓으로 전달)
///

class AudioStreamingManager: NSObject {
    private let audioEngine = AVAudioEngine()
    private let inputNode: AVAudioInputNode
    private var webSocket: WebSocket?
    
    // 오디오 설정
    private let bufferSize: AVAudioFrameCount = 2048
    private let sampleRate: Double = 48000.0//44100.0 // 서버와 일치해야 함
    private let audioFormat: AVAudioFormat
    
    override init() {
        // 오디오 입력 노드 및 포맷 설정
        self.inputNode = audioEngine.inputNode
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(.playAndRecord, mode: .voiceChat, options: [.allowBluetooth, .defaultToSpeaker])
        try? audioSession.setActive(true)
        self.audioFormat = AVAudioFormat(commonFormat: .pcmFormatFloat32,//.pcmFormatInt16,
                                                  sampleRate: sampleRate,//audioSession.sampleRate,
                                                  channels: 1,
                                                  interleaved: true)!
        super.init()
    }
    
    func getURL(webSocketURL: String) {
        // WebSocket 초기화
        var request = URLRequest(url: URL(string: webSocketURL)!)
        request.timeoutInterval = 5
        self.webSocket = WebSocket(request: request)
        self.webSocket?.delegate = self
    }
    
    
    func start() {
        setupAudioEngine()
        connectWebSocket()
    }
    
    func stop() {
        stopAudioEngine()
        webSocket?.disconnect()
    }
    
    private func setupAudioEngine() {
        inputNode.installTap(onBus: 0, bufferSize: bufferSize, format: audioFormat) { [weak self] (buffer, _) in
            guard let self = self else { return }
            
            // 오디오 데이터를 PCM으로 변환
            let audioData = self.convertAudioBufferToPCM(buffer: buffer)
            
            // WebSocket으로 데이터 전송
            self.sendAudioDataToSocket(data: audioData)
        }
        
        do {
            try audioEngine.start()
        } catch {
            print("Audio Engine failed to start: \(error.localizedDescription)")
        }
    }
    
    private func stopAudioEngine() {
        inputNode.removeTap(onBus: 0)
        audioEngine.stop()
    }
    
    private func connectWebSocket() {
        webSocket?.connect()
    }
    
    // 메세지 크기가 너무 커서 잘라서 전송.
    func sendAudioDataToSocket(data: Data) {
        let totalSize = data.count
        var offset = 0

        while offset < totalSize {
            let length = min(8192, totalSize - offset)
            let chunk = data.subdata(in: offset..<offset + length)
            webSocket?.write(data: chunk) // 각 청크를 전송
            offset += length
        }
    }
    
    private func convertAudioBufferToPCM(buffer: AVAudioPCMBuffer) -> Data {
        let audioBuffer = buffer.audioBufferList.pointee.mBuffers
        guard let mData = audioBuffer.mData else { return Data() }
        return Data(bytes: audioBuffer.mData!, count: Int(audioBuffer.mDataByteSize))
    }
}

extension AudioStreamingManager: WebSocketDelegate {
    func didReceive(event: WebSocketEvent, client: WebSocketClient) {
        switch event {
        case .connected(_):
            print("WebSocket connected")
        case .disconnected(let reason, let code):
            print("WebSocket disconnected: \(reason) (code: \(code))")
        case .error(let error):
            print("WebSocket error: \(error?.localizedDescription ?? "Unknown error")")
        case .cancelled:
            print("WebSocket connection cancelled")
        default:
            break
        }
    }
}
