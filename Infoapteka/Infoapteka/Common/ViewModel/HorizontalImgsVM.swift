//
//  HorizontalImgsVM.swift
//  Infoapteka
//
//

import UIKit

final class HorizontalImgsVM {

    private var images: [Image] = []

    func removeImg(_ image: Image, complation: @escaping () -> ()) {
        self.images.removeAll { $0.id == image.id}
        complation()
    }

    func setImages(_ images: [Image]) {
        images.forEach { self.images.append($0) }
    }

    func getImages() -> [Image] {
        self.images
    }

    func getImage(_ by: Int) -> Image? {
        self.images.count > by ? self.images[by] : nil
    }

    func getNumberOfItemsInSection() -> Int {
        self.images.count
    }
}
