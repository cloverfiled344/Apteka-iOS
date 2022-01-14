//
//  DrugSearchVM.swift
//  Infoapteka
//
//

import UIKit

struct SearchFilter: Codable {
    var id         : Int?
    var isSelected : Bool = false
    var filterType : SearchFilterType?

    enum CodingKeys: String, CodingKey {
        case id, isSelected, filterType
    }

    init(_ id: Int, _ isSelected: Bool, _ filterType: SearchFilterType) {
        self.id = id
        self.isSelected = isSelected
        self.filterType = filterType
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        id = try values.decode(Int.self, forKey: .id)
        isSelected = try values.decode(Bool.self, forKey: .isSelected)
        filterType = try values.decode(SearchFilterType.self, forKey: .filterType)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(isSelected, forKey: .isSelected)
        try container.encode(filterType, forKey: .filterType)
    }
}

final class DrugSearchVM {
    
    private var _haederTitle: String
    private var _owner   : Profile?
    private var _ownerID : Int?
    private var _showType: DrugSearchVCShowType?
    private var _drugResult: DrugResult?
    private var _category  : Category?
    private var _searchStr : String?
    private var _isLoading : Bool = false
    private var _searchFilter: SearchFilter? {
        set {
            guard let searchFilter = newValue else { return }
            AppSession.searchFilter = searchFilter
        }
        get { return AppSession.searchFilter }
    }

    private var _collectionType: CollectionType {
        set {
            AppSession.collectionType = newValue
        }
        get { return AppSession.collectionType ?? .grid }
    }

    init(_ ownerID: Int?) {
        self._ownerID = ownerID
        self._haederTitle = "Товары продавца"
        self._showType = .ownerProfile
    }

    init(_ category: Category?) {
        self._category = category
        self._haederTitle = category?.title ?? "Категории"
        self._showType = .search
    }

    func getOwner(_ completion: @escaping () -> ()) {
        guard let ownerID = _ownerID else {
            completion()
            return
        }
        API.drugSearchAPI.getOwner(ownerID) { profile in
            self._owner = profile
            self.search(true, completion)
        }
    }
    
    func search(_ withAnimation: Bool,
                _ completion: @escaping () -> ()) {
        API.drugSearchAPI.search(_drugResult?.next,
                                 _ownerID,
                                 _category?.id,
                                 _searchStr,
                                 _searchFilter,
                                 withAnimation) { [weak self] result in
            guard let self = self, let drugResult = result else {
                self?._isLoading = false
                completion()
                return
            }
            let totalResultsCounnt = self._drugResult?.results.count ?? 0 + drugResult.results.count
            if let count = self._drugResult?.count, count >= totalResultsCounnt,
               self._drugResult?.next != nil {
                self._drugResult?.results.append(contentsOf: drugResult.results)
                self._drugResult?.next = drugResult.next
            } else {
                self._drugResult = result
            }
            completion()
        }
    }

    func makeHaederView(_ delegate: DrugSearchCVHeaderDelegate,
                        _ collectionView: UICollectionView,
                        _ indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableHeader(DrugSearchCVHeader.self, indexPath)
        header.delegate = delegate
        header.setup(haederTitle, _searchFilter, _collectionType, _owner)
        return header
    }

    var drugResult: DrugResult {
        set { self._drugResult = newValue }
        get { return self._drugResult ?? .init(map: .init(mappingType: .fromJSON, JSON: [:])) }
    }

    var haederTitle: String {
        set { self._haederTitle = newValue }
        get { return self._haederTitle }
    }

    var category: Category? {
        set { self._category = newValue }
        get { return self._category }
    }

    var owner: Profile? {
        set { self._owner = newValue }
        get { return self._owner }
    }

    var searchFilter: SearchFilter? {
        set {
            guard let searchFilter = newValue else { return }
            self._searchFilter = searchFilter
        }
        get { return self._searchFilter }
    }

    var collectionType : CollectionType {
        set {
            self._collectionType = newValue
        }
        get { return self._collectionType }
    }

    var searchStr : String? {
        set {
            guard let searchStr = newValue else { return }
            self._searchStr = searchStr
        }
        get { return self._searchStr }
    }

    var drugsCount: Int {
        get { _drugResult?.results.count ?? 0 }
    }

    var isLoading: Bool {
        set { self._isLoading = newValue }
        get { return self._isLoading }
    }

    var showType: DrugSearchVCShowType {
        set { self._showType = newValue }
        get { return self._showType ?? .search }
    }

    func isPaginationNeeded(_ indexPath: IndexPath) -> Bool {
        return (indexPath.row == drugsCount - 1 && self._drugResult?.next != nil) && !_isLoading && (drugResult.count ?? 0) > drugsCount
    }
    
    func getDrug(_ by: Int) -> Drug? {
        let resultsCount: Int = _drugResult?.results.count ?? 0
        return resultsCount > by ? _drugResult?.results[by] : nil
    }
    
    // MARK: Action in Card
    func replaceDrugById(_ drug: Drug) {
        let drugIndex = drugResult.results.firstIndex { $0.id == drug.id }
        guard let index = drugIndex, drugsCount > index else { return }
        drugResult.results[index] = drug
    }
}
