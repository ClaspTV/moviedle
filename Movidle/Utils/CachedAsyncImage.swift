//
//  CachedAsyncImage.swift
//  Movidle
//
//  Created by Sidharth Datta on 08/11/24.
//

import Foundation
import SwiftUI
import Combine

struct CachedAsyncImage: View {
    @StateObject private var loader: ImageLoader
    let placeholder: Image
    
    init(url: String?, placeholder: Image = Image("user")) {
        self.placeholder = placeholder
        _loader = StateObject(wrappedValue: ImageLoader(url: url))
    }
    
    var body: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                placeholder
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
    }
}

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private let url: String?
    private var cancellable: AnyCancellable?
    
    init(url: String?) {
        self.url = url
        loadImage()
    }
    
    private func loadImage() {
        guard let urlString = url,
              let url = URL(string: urlString) else {
            return
        }
        print("loading image from: ", urlString)
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                print("image:", image?.description ?? "")
                self?.image = image
            }
    }
    
    deinit {
        cancellable?.cancel()
    }
}
