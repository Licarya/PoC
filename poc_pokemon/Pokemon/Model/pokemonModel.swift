//
//  Model.swift
//  Pokemon
//
//  Created by Justine Lecomte on 06/01/2023.
//

import Foundation
import SwiftUI

struct pokemon: Codable, Identifiable {
    let id = UUID()
    let name: String
    let image: String
    let apiGeneration: Int
    let stats: allStats
    let sprite: String
    let pokedexId: Int
}
