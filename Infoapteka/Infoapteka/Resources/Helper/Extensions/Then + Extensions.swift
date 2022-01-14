//
//  Then + Extensions.swift
//  Infoapteka
//
//  
//

import UIKit

public protocol Then { }

extension Then where Self: AnyObject {
    public func then(_ block: (Self) throws -> Void) rethrows -> Self {
        try block(self)
        return self
    }
}

extension Then where Self: Any {
  public func with(_ block: (inout Self) throws -> Void) rethrows -> Self {
    var copy = self
    try block(&copy)
    return copy
  }

  public func `do`(_ block: (Self) throws -> Void) rethrows {
    try block(self)
  }
}

extension NSObject: Then {}
extension CGPoint: Then {}
extension CGRect: Then {}
extension CGSize: Then {}
extension CGVector: Then {}
#if os(iOS) || os(tvOS)
  extension UIEdgeInsets: Then {}
  extension UIOffset: Then {}
  extension UIRectEdge: Then {}
#endif
