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
            BeforeYouGoApp.dateFormatter.dateFormat = "HH:mm"
            return BeforeYouGoApp.dateFormatter.string(from: self)
        case .dayShort:
            BeforeYouGoApp.dateFormatter.dateFormat = "M/d E"
            return BeforeYouGoApp.dateFormatter.string(from: self)
        case .dayFull:
            BeforeYouGoApp.dateFormatter.dateFormat = "M/d EEEE"
            return BeforeYouGoApp.dateFormatter.string(from: self)
        default:
            return BeforeYouGoApp.dateFormatter.string(from: self)
        }
    }
}
