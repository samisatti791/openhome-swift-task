//
//  PersonalityView.swift
//  Task
//
//  Created by Satti on 03/09/2024.
//

import SwiftUI
import Combine

struct PersonalityView: View {
    @StateObject private var viewModel = PersonalityViewModel()
    
    var body: some View {
        VStack {
            if let image = viewModel.personalityImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
            } else {
                ProgressView()
                    .frame(width: 100, height: 100)
            }
            
            Text(viewModel.personalityName)
                .font(.title)
                .padding()
        }
        .onAppear(perform: viewModel.fetchPersonality)
    }
}

#Preview {
    PersonalityView()
}
