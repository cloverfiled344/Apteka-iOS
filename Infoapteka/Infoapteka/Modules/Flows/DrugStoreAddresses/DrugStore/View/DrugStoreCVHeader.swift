//
//  DrugStoreCVHeader.swift
//  Infoapteka
//
//  
//

import UIKit

// MARK: DrugStoreCVHeaderDelegate
protocol DrugStoreCVHeaderDelegate: AnyObject {
    func switchSelectionIndex(_ index: Int)
}

// MARK: Appearance
extension DrugStoreCVHeader {
    struct Appearance {
        let segmentControlCornerRadius: CGFloat = 12.0
    }
}

class DrugStoreCVHeader: UIView {
    
    // MARK: UI Components
    private lazy var segmentControl: UISegmentedControl = {
        let view = UISegmentedControl(items: [L10n.drugStoreList, L10n.map])
        view.autoresizingMask = .flexibleWidth
        view.selectedSegmentIndex = .zero
        view.layer.cornerRadius = appearance.segmentControlCornerRadius
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Asset.segmentControllBack.color
        view.selectedSegmentTintColor = Asset.mainGreen.color
        view.addTarget(self, action: #selector(switchSegmentControl(_:)), for: .valueChanged)
        return view
    }()
    
    // MARK: Properties
    weak var delegate: DrugStoreCVHeaderDelegate?
    private let appearance = Appearance()
    
    var isEnableToSegment: Bool {
        get { return segmentControl.isEnabled }
        set { self.segmentControl.isEnabled = newValue }
    }
    
    // MARK: Initilaize
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setAttrToSegment()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func switchSegmentControl(_ sender: UISegmentedControl) {
        delegate?.switchSelectionIndex(sender.selectedSegmentIndex)
    }
    
    private func setupUI() {
        backgroundColor = .white
        addSubview(segmentControl)
        segmentControl.snp.makeConstraints { (maker) in
            maker.top.bottom.equalToSuperview()
            maker.leading.trailing.equalTo(self).inset(20)
        }
    }
    
    private func setAttrToSegment() {
        let selectedAttribute = [NSAttributedString.Key.foregroundColor: Asset.mainWhite.color]
        let unselectedAttribute = [NSAttributedString.Key.foregroundColor: Asset.darkBlue.color]
        segmentControl.setTitleTextAttributes(selectedAttribute, for: .selected)
        segmentControl.setTitleTextAttributes(unselectedAttribute, for: .normal)
    }
    
    func setSegmentValue(_ indexPath: IndexPath) {
        segmentControl.selectedSegmentIndex = indexPath.row
    }
}
