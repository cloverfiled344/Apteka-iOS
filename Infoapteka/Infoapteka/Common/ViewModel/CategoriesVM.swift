//
//  CategoriesVM.swift
//  Infoapteka
//
//

import Foundation

final class CategoriesVM {

    private var categories          : [Category] = []
    private var children            : [Category] = []
    private var parentCategory      : Category?
    private var superParentCategory : Category?
    private var _selectType: CategorySelectType

    init(_ selectType: CategorySelectType) {
        self._selectType = selectType
    }

    init(_ parentCategory: Category, _ superParentCategory: Category, _ selectType: CategorySelectType) {
        self.children               = parentCategory.children
        self._selectType = selectType

        addSeeAllCategory(parentCategory, children) { newChildren in
            self.children = newChildren

            var newParentCategory  = parentCategory
            newParentCategory.type = .parent
            self.parentCategory    = newParentCategory
            !self.children.isEmpty ? self.children.insert(newParentCategory, at: self.children.startIndex) : nil

            var newSuperParentCategory  = superParentCategory
            newSuperParentCategory.type = .superParent
            self.superParentCategory    = newSuperParentCategory
            !self.children.isEmpty ? self.children.insert(newSuperParentCategory, at: self.children.startIndex) : nil

            self.superParentCategory = superParentCategory
        }
    }

    func fetchCategories(_ completion: @escaping(() -> Void)) {
        if children.isEmpty {
            API.categoriesAPI.fetchCategories { categories in
                self.categories = categories
                self.addSeeAllCategory(nil, self.categories) { [weak self] newCategories in
                    guard let self = self else { return }
                    self.categories = newCategories
                    completion()
                }
            }
        } else {
            completion()
        }
    }

    fileprivate func addSeeAllCategory(_ parentCategory: Category? = nil,
                                       _ categories: [Category],
                                       _ completion: @escaping(([Category]) -> Void)) {
        guard selectType == .search else {
            completion(categories)
            return
        }
        var seeAllCategory: Category = parentCategory ?? Category(map: .init(mappingType: .fromJSON,
                                                                             JSON: [:]))
        seeAllCategory.type = .seeAll

        var newCategories = categories
        !newCategories.isEmpty ? newCategories.insert(seeAllCategory, at: newCategories.startIndex) : nil
        completion(newCategories)
    }

    func numberOfRowsInSection() -> Int {
        children.isEmpty ? self.categories.count : children.count
    }

    func getCategory(_ by: Int) -> Category? {
        children.isEmpty ? (categories.count > by ? categories[by] : nil) : (children.count > by ? children[by] : nil)
    }

    func isHeaderNeeded() -> Bool { superParentCategory != nil }

    func getSuperParentCategory() -> Category {
        guard let superParentCategory = superParentCategory else {
            return Category(map: .init(mappingType: .fromJSON, JSON: ["name": "Категории"]))
        }
        return superParentCategory
    }

    func getParentCategory() -> Category {
        guard let parentCategory = parentCategory else {
            return Category(map: .init(mappingType: .fromJSON, JSON: ["name": "Категории"]))
        }
        return parentCategory
    }

    var selectType: CategorySelectType {
        get { return _selectType }
    }

    var isNeedRefresh: Bool {
        get { return !categories.isEmpty }
    }
}
