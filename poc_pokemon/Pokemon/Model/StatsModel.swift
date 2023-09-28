//
//  StatsModel.swift
//  Pokemon
//
//  Created by Justine Lecomte on 06/01/2023.
//

import Foundation
import SwiftUI

struct allStats: Codable, Identifiable {
    let id = UUID()
    let HP: Int
    let attack: Int
    let defense: Int
    let special_attack: Int
    let special_defense: Int
    let speed: Int
}

