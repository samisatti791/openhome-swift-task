//
//  PersonalityViewModel.swift
//  Task
//
//  Created by Satti on 03/09/2024.
//

import Foundation
import SwiftUI
import Combine

class PersonalityViewModel: ObservableObject {
    @Published var personalityImage: UIImage?
    @Published var personalityName: String = ""

    private var cancellable: AnyCancellable?
    private let baseImageUrl = "https://app.openhome.xyz"

    func fetchPersonality() {
        guard let url = URL(string: "https://app.openhome.xyz/api/personalities/access-link/eyJ1c2VyX2lkIjoxLCJwZXJzb25hbGl0eV9pZCI6MzEwNiwiZXhwaXJlc190aW1lIjpudWxsfQ.ZtHBSA.VEcbpJo71qLE7rTYvwWk2mxV3Jc/") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.addValue("Bearer guest", forHTTPHeaderField: "Authorization")

        cancellable = URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Failed to fetch personality: \(error)")
                }
            }, receiveValue: { [weak self] data in
              
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Raw JSON response: \(jsonString)")
                }

          
                let decoder = JSONDecoder()
                do {
                    let response = try decoder.decode(PersonalityResponse.self, from: data)
                    DispatchQueue.main.async {
                        self?.personalityName = response.personality.name
                        let imageUrlString = (self?.baseImageUrl ?? "") + response.personality.imageFile
                        print("Image URL: \(imageUrlString)")
                        if let imageUrl = URL(string: imageUrlString) {
                            self?.loadImage(from: imageUrl)
                        }
                    }
                } catch {
                    print("Failed to decode JSON: \(error)")
                }
            })
    }

    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.personalityImage = image
                }
            } else if let error = error {
                print("Failed to load image: \(error)")
            }
        }.resume()
    }
}

