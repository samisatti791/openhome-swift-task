//
//  WebSocketManager.swift
//  Task
//
//  Created by Satti on 03/09/2024.
//


import Foundation

class WebSocketManager: NSObject, URLSessionWebSocketDelegate, ObservableObject {
    private var webSocketTask: URLSessionWebSocketTask?
        private var audioPlayer = AudioPlayer()

    func connect() {
        guard let url = URL(string: "wss://app.openhome.xyz/websocket/voice-stream/4a0f0ac44df1a9bed4c630baa785e49e4f297a47005804f3665f40027beecbc6/3106?demo=true") else {
            print("Invalid WebSocket URL")
            return
        }
        
        print("WebSocket URL is valid")

        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        webSocketTask = session.webSocketTask(with: url)
        
        if let webSocketTask = webSocketTask {
            print("WebSocket task created successfully")
            webSocketTask.resume()
            receiveMessage()
        } else {
            print("WebSocket task is nil")
        }
    }

    func sendMessage(_ message: String) {
        let message = URLSessionWebSocketTask.Message.string(message)
        webSocketTask?.send(message) { error in
            if let error = error {
                print("WebSocket sending error: \(error)")
            }
        }
    }
    
    func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .failure(let error):
                print("WebSocket receiving error: \(error)")
            case .success(.string(let message)):
                print("Received string: \(message)")
            case .success(.data(let data)):
                print("Received data: \(data)")
            default:
                break
            }
            self?.receiveMessage()
        }
    }

    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
    }
      
    private func handleMessage(_ text: String) {
          if let data = text.data(using: .utf8) {
              do {
                  if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                     let messageType = json["type"] as? String {
                      
                      switch messageType {
                      case "audio-init":
                          print("Audio Init Received")
                         
                      case "audio":
                          if let base64String = json["data"] as? String {
                              audioPlayer.playAudio(base64String: base64String)
                          }
                      case "audio-end":
                          print("Audio End Received")
                       
                          audioPlayer.stopAudio()
                      default:
                          break
                      }
                  }
              } catch {
                  print("Failed to decode JSON: \(error)")
              }
          }
      }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("WebSocket closed")
    }
}
