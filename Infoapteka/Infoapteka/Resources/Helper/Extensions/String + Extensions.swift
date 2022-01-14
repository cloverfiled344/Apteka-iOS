//
//  String + Extensions.swift
//  Infoapteka
//
//  
//

import UIKit

extension RangeReplaceableCollection where Self: StringProtocol {
    var digits: Self { filter(\.isWholeNumber) }
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)

        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)

        return ceil(boundingBox.width)
    }
}

extension String {
    var encodeUrl : String {
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
    var decodeUrl : String {
        return self.removingPercentEncoding!
    }

    var toLatin: String {
        return self.applyingTransform(StringTransform.toLatin, reverse: false) ?? ""
    }

    var toLatinNoDiacritic: String {
        return self.toLatin.applyingTransform(StringTransform.stripDiacritics, reverse: false) ?? ""
    }
}

extension String {
    func getISODateAsStr(_ dateFormat: String, _ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        return dateFormatter.string(from: date)
    }
}

extension Date {
    init(dateString: String) {
        self = Date.iso8601Formatter.date(from: dateString) ?? Date()
    }

    static let iso8601Formatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate,
                                   .withTime,
                                   .withDashSeparatorInDate,
                                   .withColonSeparatorInTime]
        return formatter
    }()
}
