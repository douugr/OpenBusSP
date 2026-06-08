//
//  Item.swift
//  OpenBusSP
//
//  Created by Douglas Neto on 08/06/26.
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
