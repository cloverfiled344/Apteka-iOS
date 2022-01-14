//
//  SearchHintVM.swift
//  Infoapteka
//
//

import Foundation

final class SearchHintVM {

    private var hints    : [String] = []
    private var _category : Category?

    init(_ category: Category?) {
        self._category = category
    }

    func fetchHints(_ search: String?, _ completion: @escaping(() -> Void)) {
        API.hintsAPI.fetchHints(search) { hints in
            self.hints = hints
            completion()
        }
    }

    func numberOfRowsInSection() -> Int {
        self.hints.count
    }
    
    func getHint(_ by: Int) -> String? {
        hints.count > by ? hints[by] : nil
    }

    var category: Category? {
        get {
            return _category
        }
        set {
            guard let category = _category else { return }
            _category = category
        }
    }
}
