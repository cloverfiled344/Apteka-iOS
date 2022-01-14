//
//  UIImageView + Extensions.swift
//  Infoapteka
//
//  
//

import UIKit
import SDWebImage

extension UIImageView {
    func load(_ url: String, _ placeholder: UIImage = UIImage()) {
        guard let url = URL(string: url) else {
            self.image = placeholder
            return
        }
        self.sdSetImage(url, placeholder)
    }
    
    private func sdSetImage(_ url: URL, _ placeholder: UIImage) {
        DispatchQueue.main.async {
            self.sd_setImage(with: url, placeholderImage: placeholder, options: .continueInBackground, context: nil)
        }
        
        var name: String {
            return self.image?.accessibilityIdentifier ?? "Неизвестно"
        }
    }
}

extension UIImage {
    var sizeInBytes: Int {
        guard let cgImage = self.cgImage else {
            // This won't work for CIImage-based UIImages
            assertionFailure()
            return 0
        }
        return cgImage.bytesPerRow * cgImage.height
    }
    
    var sizeInMB: Float {
        return Float(self.sizeInBytes) * 0.000001
    }
    
    var sizeFromJPGData: Int {
        self.jpegData(compressionQuality: 1.0)?.count ?? 0
        
    }
}
