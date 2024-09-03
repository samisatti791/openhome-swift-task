//
//  ContentView.swift
//  Task
//
//  Created by Satti on 03/09/2024.
//

import SwiftUI

import SwiftUI

struct ContentView: View {
    @StateObject var webSocketManager = WebSocketManager()
    @StateObject var audioRecorder = AudioRecorder()
    @State private var interruptSensitivity: Double = 0.5
    @State private var isGuest = false
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.black, .gray]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 40) {
                    Image(systemName: "mic.circle.fill")
                        .font(.system(size: 100))
                        .foregroundColor(.white)
                        .background(
                            Circle()
                                .fill(Color.orange)
                                .frame(width: 120, height: 120)
                                .shadow(color: .orange, radius: 10, x: 0, y: 0)
                        )
                        .padding(.top, 60)
                    
                    Spacer()
                    
                    VStack(spacing: 20) {
                        Text("Demo")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        HStack(spacing: 20) {
                            NavigationLink(destination: PersonalityView()) {
                                Text("Click Personality Test")
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.red)
                                    .cornerRadius(10)
                            }
                            
                        }
                    }
                    .padding()
                    .background(Color.black.opacity(0.8))
                    .cornerRadius(15)
                    
                    Spacer()
                    
                    HStack(spacing: 20) {
                        Button(action: {
                            webSocketManager.connect()
                            audioRecorder.startRecording()
                        }) {
                            HStack {
                                Image(systemName: "play.fill")
                                Text("Start Conversation")
                            }
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.orange)
                            .cornerRadius(10)
                        }
                        
                        Button(action: {
                            audioRecorder.stopRecording()
                            webSocketManager.disconnect()
                        }) {
                            HStack {
                                Image(systemName: "mic.slash.fill")
                                Text("End Conversation")
                            }
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                        }
                        
                        
                    }
                    
                    
                    VStack {
                        Text("Interrupt Sensitivity")
                            .foregroundColor(.white)
                        
                        Slider(value: $interruptSensitivity, in: 0...1)
                            .accentColor(.white)
                            .padding(.horizontal)
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .navigationBarHidden(true)
        }
    }
}



#Preview {
    ContentView()
}
