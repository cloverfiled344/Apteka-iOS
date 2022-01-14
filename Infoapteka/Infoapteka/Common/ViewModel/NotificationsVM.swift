//
//  NotificationsVM.swift
//  Infoapteka
//
//

import Foundation

final class NotificationsVM {

    private var _notifResult : NotifResult?
    private var _isLoading   : Bool = false

    func fetchNotifications(_ completion: @escaping(() -> Void)) {
        _isLoading = true
        API.notificationsAPI.fetchNotifications(_notifResult?.next) { [weak self] notifResult in
            guard let self = self, let notifResult = notifResult else {
                self?._isLoading = false
                return
            }

            let totalResultsCount = (self._notifResult?.results.count ?? 0) + notifResult.results.count
            if let count = self._notifResult?.count, count >= totalResultsCount,
               self._notifResult?.next != nil {
                self._notifResult?.results.append(contentsOf: notifResult.results)
                self._notifResult?.next = notifResult.next
            } else { self._notifResult = notifResult }
            completion()
        }
    }

    var numberOfRowsInSection: Int {
        get { return _notifResult?.results.count ?? 0}
    }

    var isLoading: Bool {
        set { self._isLoading = newValue }
        get { return self._isLoading }
    }
    
    func isPaginationNeeded(_ indexPath: IndexPath) -> Bool {
        return (indexPath.row == numberOfRowsInSection - 1 && _notifResult?.next != nil) && !_isLoading && (_notifResult?.count ?? 0) > numberOfRowsInSection
    }

    func getNotif(_ by: Int) -> Notif? {
        let resultsCount: Int = self._notifResult?.results.count ?? 0
        return resultsCount > by ? self._notifResult?.results[by] : nil
    }
}
