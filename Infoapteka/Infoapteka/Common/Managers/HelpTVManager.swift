//
//  HelpTVManager.swift
//  Infoapteka
//
//  
//

import UIKit

class HelpTVManager: NSObject {
    
    private var viewModel: HelpResultVM
    
    init(_ viewModel: HelpResultVM) {
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(_ completion: @escaping(() -> Void)) {
        self.viewModel.getHelpPage {
            completion()
        }
    }
}

// MARK: UITableViewDelegate and UITableViewDataSource
extension HelpTVManager: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.helpPageCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(HelpTVCell.self, indexPath: indexPath)
        cell.setupCell(self.viewModel.getHelpResult(), self.viewModel.getHelpByIndexPath(indexPath)) { (callback) in
            tableView.performBatchUpdates { callback() }
        }
        return cell
    }
}
