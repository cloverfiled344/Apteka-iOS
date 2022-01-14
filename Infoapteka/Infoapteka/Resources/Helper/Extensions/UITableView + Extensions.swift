//
//  UITableView + Extensions.swift
//  Infoapteka
//
//  
//

import UIKit

extension UITableView {

    func registerdequeueReusableCell<T: UITableViewCell>(_ cellType: T.Type) {
        let className = String(describing: cellType)
        let identifier = className + "ID"
        register(cellType, forCellReuseIdentifier: identifier)
    }

    func dequeueReusableCell<T: UITableViewCell>(_ cellType: T.Type,
                                                 indexPath: IndexPath) -> T {
        let className = String(describing: cellType)
        let identifier = className + "ID"
        return dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! T

    }

    func registerdequeueReusableHeaderFooter<T: UITableViewHeaderFooterView>(_ cellType: T.Type) {
        let className = String(describing: cellType)
        let identifier = className + "ID"
        register(cellType, forHeaderFooterViewReuseIdentifier: identifier)
    }

    func dequeueReusableHeaderFooter<T: UITableViewHeaderFooterView>(_ cellType: T.Type) -> T {
        let className = String(describing: cellType)
        let identifier = className + "ID"
        return dequeueReusableHeaderFooterView(withIdentifier: identifier) as! T
    }
    
    func setNoDataPlaceholder() {
           self.separatorStyle = .none
    }
    
    func removeNoDataPlaceholder() {
        self.isScrollEnabled = true
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}

extension UITableView {

    private func indicatorView() -> UIActivityIndicatorView{
        getIV()
    }

    private func getIV() -> UIActivityIndicatorView {
        return self.tableFooterView == nil ?
            createIV() :
            (self.tableFooterView as? UIActivityIndicatorView ?? self.createIV())
    }

    private func createIV() -> UIActivityIndicatorView {
        var activityIndicatorView = UIActivityIndicatorView()
        let indicatorFrame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 80)
        activityIndicatorView = UIActivityIndicatorView(frame: indicatorFrame)
        activityIndicatorView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
        activityIndicatorView.style = .large
        activityIndicatorView.hidesWhenStopped = true
        self.tableFooterView = activityIndicatorView
        return activityIndicatorView
    }

    func addLoading(_ indexPath: IndexPath){
        indicatorView().startAnimating()
    }

    func stopLoading() {
        if self.tableFooterView != nil {
            self.indicatorView().stopAnimating()
            self.tableFooterView = nil
        } else { self.tableFooterView = nil }
    }
}
