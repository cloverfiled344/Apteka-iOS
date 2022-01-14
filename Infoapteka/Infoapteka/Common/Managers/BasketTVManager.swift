//
//  BasketTVManager.swift
//  Infoapteka
//
//

import UIKit

protocol BasketTVManagerDelegate {
    func deleteCart(_ cart: Cart)
    func changeQuantity(_ cart: Cart, _ quantity: Int)
    func changeFavourite(_ cart: Cart,
                         _ isFavorite: Bool)
    func pushToBasketDetail(_ drug: Drug?)
}

class BasketTVManager: NSObject {

    // MARK: UI Components
    private lazy var backView : InfoAptekaBackgroundView = {
        let view = InfoAptekaBackgroundView()
        view.setupView(Asset.icEmptyBasket.image, L10n.emptyBasket)
        return view
    }()

    private var viewModel: BasketVM
    var delegate: BasketTVManagerDelegate?
    
    init(_ viewModel: BasketVM) {
        self.viewModel = viewModel
    }

    func setup(complation: @escaping () -> ()) {
        viewModel.getBasket(complation)
    }
}

extension BasketTVManager: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        switch viewModel.numberOfRowsInSection {
        case .zero:
            tableView.setNoDataPlaceholder()
            backView.frame = tableView.bounds
            tableView.backgroundView = backView
            return .zero
        default:
            tableView.removeNoDataPlaceholder()
            return viewModel.numberOfRowsInSection
        }
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(BasketTVCell.self, indexPath: indexPath)
        cell.delegate = self
        cell.setup(viewModel.getCart(indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.pushToBasketDetail(viewModel.getCart(indexPath.row)?.drug)
    }

    func makeTableViewFooter(_ tableView: UITableView) -> UIView? {
        guard let basket = viewModel.basket, !basket.carts.isEmpty else {
            return .none
        }
        let footer = tableView.dequeueReusableHeaderFooter(BasketTVFooter.self)
        footer.frame = .init(x: 0, y: 0, width: tableView.frame.size.width, height: 129.0)
        footer.setup(viewModel.basket)
        return footer
    }
}

extension BasketTVManager: BasketTVCellDelegate {
    func changeFavorite(_ cart: Cart, _ isFavorite: Bool) {
        delegate?.changeFavourite(cart, isFavorite)
    }

    func deleteCart(_ cart: Cart) {
        delegate?.deleteCart(cart)
    }

    func changeQuantity(_ cart: Cart, _ count: Int) {
        delegate?.changeQuantity(cart, count)
    }
}
