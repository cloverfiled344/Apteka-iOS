//
//  DrugStoreMapListCVCell.swift
//  Infoapteka
//
//  
//

import UIKit

// MARK: DrugStoreMapListCVCellDelegate
protocol DrugStoreMapListCVCellDelegate {
    func pushToStoreDetail(_ id: Int?)
    func updateView()
}

// MARK: Appearance
extension DrugStoreMapListCVCell {
    struct Appearance {
        let tableViewBackColor: UIColor = Asset.mainWhite.color
    }
}

class DrugStoreMapListCVCell: UICollectionViewCell {
    
    // MARK: UI Components
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = appearance.tableViewBackColor
        view.registerdequeueReusableCell(DrugStoreMapListTVCell.self)
        view.registerdequeueReusableCell(IndicatorTVCell.self)
        view.dataSource = self
        view.delegate = self
        view.separatorStyle = .none
        view.alwaysBounceVertical = true
        view.showsVerticalScrollIndicator = false
        view.contentInset = .init(top: 20.0, left: 0, bottom: 0, right: 0)
        view.separatorColor = .white
        return view
    }()
    
    // MARK: Properties
    public var delegate: DrugStoreMapListCVCellDelegate?
    private let appearance = Appearance()
    private var viewModel: DrugStoreVM? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(tableView)
        let refreshControl = UIRefreshControl(frame: .init(origin: .zero, size: .init(width: 12, height: 12)))
        refreshControl.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        tableView.refreshControl = refreshControl
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    @objc private func fetchData() {
        viewModel?.fetchData { [weak self] in
            guard let self = self else { return }
            self.tableView.refreshControl?.endRefreshing()
            self.delegate?.updateView()
        }
    }

    func setData(_ viewModel: DrugStoreVM?) {
        self.viewModel = viewModel
    }
}

// MARK: UITableViewDataSource
extension DrugStoreMapListCVCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.drugStoresCount ?? .zero
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel?.isPaginationNeeded(indexPath) ?? false {
            let cell = tableView.dequeueReusableCell(IndicatorTVCell.self, indexPath: indexPath)
            cell.setup()
            paginateDrugStores()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(DrugStoreMapListTVCell.self, indexPath: indexPath)
            cell.setupCell(viewModel?.getDrugStore(by: indexPath.row))
            return cell
        }
    }

    fileprivate func paginateDrugStores() {
        viewModel?.paginateDrugStores { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.viewModel?.isLoading = false
            }
            self.delegate?.updateView()
        }
    }
}

// MARK: UITableViewDelegate
extension DrugStoreMapListCVCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.pushToStoreDetail(viewModel?.getDrugStoreId(by: indexPath.row))
    }
    
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        guard !(viewModel?.isLoading ?? true) else { return  }
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -500, 200, 0)
        cell.layer.transform = rotationTransform
        cell.alpha = 0
        UIView.animate(withDuration: 0.75) {
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1.0
        }
    }
}
