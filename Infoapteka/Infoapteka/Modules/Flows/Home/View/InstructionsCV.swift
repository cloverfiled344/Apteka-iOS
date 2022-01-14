//
//  HomeCardItemCV.swift
//  Infoapteka
//
//  
//

import UIKit

protocol InstructionCVDelegate {
    func pushToMapPage()
    func pushToDeliveryPage(_ programPolicy: PrivacyPolicy?)
    func pushToInstructionPage(_ programPolicy: PrivacyPolicy?)
}

extension InstructionsCV {
    struct Appearance {
        let backgroundColor: UIColor = Asset.backgroundGray.color
    }
}

class InstructionsCV: UICollectionView {
    
    // MARK: Intialize
    public var _delegate: InstructionCVDelegate?
    private let appearance = Appearance()
    private var viewModel: InstructionsCVM? {
        didSet {
            DispatchQueue.main.async {
                self.reloadData()
            }
        }
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        super.init(frame: frame, collectionViewLayout: flowLayout)
        setupCV()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCV() {
        backgroundColor = appearance.backgroundColor
        contentInset = .init(top: 0, left: 20, bottom: 0, right: 20)
        showsHorizontalScrollIndicator = false
        delegate = self
        dataSource = self
        registerdequeueReusableCell(HomeCardItemCVCell.self)
    }
    
    func setInstructions(_ viewModel: InstructionsCVM) {
        self.viewModel = viewModel
    }
}

// MARK: UICollectionViewDataSource and UICollectionViewDelegate
extension InstructionsCV: UICollectionViewDataSource,
                          UICollectionViewDelegate,
                          UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel?.intructionsCount ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(HomeCardItemCVCell.self, indexPath)
        cell.setCardItem(viewModel?.getInstructions()[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        switch self.viewModel?.getInstructionType(by: indexPath.row) {
        case .some(let type):
            switch type {
            case .map:
                _delegate?.pushToMapPage()
            case .delivery:
                viewModel?.getProgramRules { (result) in
                    self._delegate?.pushToDeliveryPage(result)
                }
            case .instructDelivery:
                viewModel?.getProgramRules { (result) in
                    self._delegate?.pushToInstructionPage(result)
                }
            }
        case .none:
            break
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        4.0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.size.width - 48) / 3
        return .init(width: width, height: collectionView.bounds.size.height)
    }
}
