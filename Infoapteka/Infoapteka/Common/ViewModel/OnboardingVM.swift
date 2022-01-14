//
//  OnboardingVM.swift
//  Infoapteka
//
//

import Foundation

final class OnboardingVM {

    private var items: [BaseVC] = []

    func fetchPages(_ delegate: OnboardingItemDelegate, _ completion: @escaping (() -> Void)) {
        API.onboardingAPI.fetchPages { (pages) in
            self.items.removeAll()
            for (index, value) in pages.enumerated() {
                var page = value
                page.pgIndex = index
                self.items.append(OnboardingItemVC(page, delegate, pages.count))
            }
            completion()
        }
    }

    func getItem(_ at: Int) -> BaseVC? {
        return at < self.items.count ? self.items[at] : nil
    }

    func getLiquidSwipeContainerCount() -> Int {
        self.items.count
    }
}
