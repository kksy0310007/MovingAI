//
//  AudioStreamingManager.swift
//  MovingAI
//
//  Created by soyoung on 1/15/25.
//

import AVFoundation
import Starscream

/// 음성송출 기능 (오디오 녹음 + 웹 소켓으로 전달)
/// ios 녹음 sampleRate 는 48000 Hz, 넥서스캠의 장비 오디오 sampleRate 는 22050 Hz => 소켓 전송 시 변환 필요

class AudioStreamingManager: NSObject {
    private let audioEngine = AVAudioEngine()
    private let inputNode: AVAudioInputNode
    private var webSocket: WebSocket?
    
    // 오디오 설정
    private let bufferSize: AVAudioFrameCount = 2048
    
    //private let sampleRate: Double = 44100.0//48000.0// // 서버와 일치해야 함
    private let audioFormat: AVAudioFormat
    
    private var converter: AVAudioConverter?
    private let targetSampleRate: Double = 22050.0
    
    override init() {
        // 오디오 입력 노드 및 포맷 설정
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setActive(true)
        try? audioSession.setCategory(.playAndRecord, mode: .voiceChat, options: [.allowBluetooth, .defaultToSpeaker])
        
        self.inputNode = audioEngine.inputNode
       
        self.audioFormat = AVAudioFormat(commonFormat: .pcmFormatInt16,//.pcmFormatFloat32,//,
                                         sampleRate: audioSession.sampleRate,
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
    
    private func setupAudioEngine() {
        // 변환할 포맷 지정 (22050Hz, Int16)
        guard let outputFormat = AVAudioFormat(commonFormat: .pcmFormatInt16,
                                               sampleRate: targetSampleRate,
                                               channels: 1,
                                               interleaved: true) else {
            print("Failed to create output format")
            return
        }

        converter = AVAudioConverter(from: audioFormat, to: outputFormat)

        inputNode.installTap(onBus: 0, bufferSize: bufferSize, format: audioFormat) { [weak self] (buffer, _) in
            guard let self = self else { return }
            guard let converter = self.converter else { return }

            let outputBuffer = AVAudioPCMBuffer(pcmFormat: outputFormat, frameCapacity: buffer.frameCapacity)!

            var error: NSError?
            let status = converter.convert(to: outputBuffer, error: &error) { inNumPackets, outStatus in
                outStatus.pointee = .haveData
                return buffer
            }

            if status == .error {
                print("Conversion error: \(String(describing: error))")
                return
            }
            // 오디오 데이터를 PCM으로 변환
            let audioData = self.convertAudioBufferToPCM(buffer: outputBuffer)
            // WebSocket으로 데이터 전송
            self.sendAudioDataToSocket(data: audioData)
        }

        do {
            audioEngine.prepare()
            try audioEngine.start()
        } catch {
            print("Audio Engine failed to start: \(error.localizedDescription)")
        }
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
