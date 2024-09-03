//
//  AudioRecorder.swift
//  Task
//
//  Created by Satti on 03/09/2024.
//


import AVFoundation

class AudioRecorder: NSObject, ObservableObject {
    private var audioEngine: AVAudioEngine!
    private let sampleRate: Double = 16000.0
    
    func startRecording() {
        audioEngine = AVAudioEngine()
        let inputNode = audioEngine.inputNode
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        let downsampledFormat = AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: sampleRate, channels: 1, interleaved: true)!
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.processAudio(buffer: buffer, downsampledFormat: downsampledFormat)
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            print("Audio Engine start error: \(error)")
        }
    }
    
    func stopRecording() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
    }
    
    private func processAudio(buffer: AVAudioPCMBuffer, downsampledFormat: AVAudioFormat) {
        let downsampledData = Data() 
        let base64EncodedString = downsampledData.base64EncodedString()
        let jsonData = "{\"type\":\"audio\",\"data\":\"\(base64EncodedString)\"}"
        
        WebSocketManager().sendMessage(jsonData)
    }
}
