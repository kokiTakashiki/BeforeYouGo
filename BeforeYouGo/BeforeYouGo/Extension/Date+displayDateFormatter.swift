//
//  Date+displayDateFormatter.swift
//  BeforeYouGo
//
//  Created by takedatakashiki on 2023/11/18.
//

import Foundation

extension Date {
    func displayDateFormatter(style: FormatMode) -> String? {
        switch style {
        case .time:
            BeforeYouGoApp.displayDateFormatter.dateFormat = "HH:mm"
            return BeforeYouGoApp.displayDateFormatter.string(from: self)
        case .dayShort:
            BeforeYouGoApp.displayDateFormatter.dateFormat = "M/d E"
            return BeforeYouGoApp.displayDateFormatter.string(from: self)
        case .dayFull:
            BeforeYouGoApp.displayDateFormatter.dateFormat = "M/d EEEE"
            return BeforeYouGoApp.displayDateFormatter.string(from: self)
        default:
            return BeforeYouGoApp.displayDateFormatter.string(from: self)
        }
    }
}
