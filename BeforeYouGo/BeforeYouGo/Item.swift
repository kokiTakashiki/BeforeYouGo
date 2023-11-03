//
//  Item.swift
//  BeforeYouGo
//
//  Created by takedatakashiki on 2023/11/03.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
