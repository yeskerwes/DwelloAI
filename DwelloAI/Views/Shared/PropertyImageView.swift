//
//  PropertyImageView.swift
//  DwelloAI
//
//  Created by Bakdaulet Yeskermes on 11.05.2026.
//

import SwiftUI

struct PropertyImageView: View {
    let imageName: String
    var contentMode: ContentMode = .fill

    var body: some View {
        if let uiImage = loadFromDisk(imageName) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: contentMode)
        } else {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: contentMode)
        }
    }

    private func loadFromDisk(_ name: String) -> UIImage? {
        guard !name.isEmpty, name != "placeholder" else { return nil }
        let url = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(name)
        guard let data = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: data)
    }
}

enum PhotoStorage {
    static func save(_ image: UIImage) -> String {
        let filename = UUID().uuidString + ".jpg"
        let url = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(filename)
        if let data = image.jpegData(compressionQuality: 0.82) {
            try? data.write(to: url)
        }
        return filename
    }
}
