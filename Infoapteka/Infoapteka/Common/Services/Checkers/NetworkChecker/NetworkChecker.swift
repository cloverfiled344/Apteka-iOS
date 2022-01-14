//
//  NetworkChecker.swift
//  Infoapteka
//
//

import Foundation
import Network

class NetworkChecker {

    static let instance = NetworkChecker()
    private var reachability: Reachability?

    //    MARK:    Internet check function.
    //    MARK:    Функция для проверки интернета.
    func isConnection() -> Bool {
        do {
            try reachability = Reachability.init()

            if (self.reachability?.connection) == .wifi || (self.reachability?.connection) == .cellular {
                return true
            } else if self.reachability?.connection == .unavailable {
                return false
            } else { return false }
        } catch { return false }
    }
}
