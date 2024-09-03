//
//  AudioPlayer.swift
//  Task
//
//  Created by Satti on 03/09/2024.
//

import AVFoundation
import Foundation

class AudioPlayer: NSObject {
    private var audioEngine: AVAudioEngine?
    private var audioPlayerNode: AVAudioPlayerNode?
    private var format: AVAudioFormat?
    
    func playAudio(base64String: String) {
        
        guard let audioData = Data(base64Encoded: base64String) else {
            print("Failed to decode base64 string.")
            return
        }
        
        do {
            
            audioEngine = AVAudioEngine()
            audioPlayerNode = AVAudioPlayerNode()
            
            
            format = AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: 16000, channels: 1, interleaved: true)
            
            guard let format = format else {
                print("Failed to create audio format.")
                return
            }
            
            let bytesPerFrame = format.streamDescription.pointee.mBytesPerFrame
            let frameCapacity = UInt32(audioData.count) / bytesPerFrame
            let audioBuffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCapacity)
            audioBuffer?.frameLength = audioBuffer?.frameCapacity ?? 0
            
            guard let audioBufferPointer = audioBuffer?.floatChannelData?[0] else {
                print("Failed to get audio buffer pointer.")
                return
            }
            
            audioData.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) in
                let int16Pointer = bytes.baseAddress!.assumingMemoryBound(to: Int16.self)
                
                
                for i in 0..<Int(audioData.count / MemoryLayout<Int16>.size) {
                    let int16Value = int16Pointer[i]
                    audioBufferPointer[i] = Float(int16Value) / 32767.0
                }
            }
            
            guard let audioPlayerNode = audioPlayerNode else {
                print("Audio player node is nil.")
                return
            }
            
            guard let audioEngine = audioEngine else {
                print("Audio engine is nil.")
                return
            }
            
            audioEngine.attach(audioPlayerNode)
            audioEngine.connect(audioPlayerNode, to: audioEngine.mainMixerNode, format: format)
            
            
            audioPlayerNode.scheduleBuffer(audioBuffer!, at: nil, options: .loops, completionHandler: nil)
            
            
            try audioEngine.start()
            audioPlayerNode.play()
            
        } catch {
            print("Audio playback error: \(error)")
        }
    }
    
    
    func stopAudio() {
        audioPlayerNode?.stop()
        audioEngine?.stop()
        audioEngine = nil
        audioPlayerNode = nil
    }
}

