//
//  pokemonViewModel.swift
//  Pokemon
//
//  Created by Justine Lecomte on 06/01/2023.
//

import Foundation

class apiCall {
    func getPokemon(completion:@escaping ([pokemon]) -> ()) {
        guard let url = URL(string: "https://pokebuildapi.fr/api/v1/pokemon")
        else { return }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            let pokemons = try! JSONDecoder().decode([pokemon].self, from: data!)
            print(pokemons)
            
            DispatchQueue.main.async {
                completion(pokemons)
            }
        }
        .resume()
    }
}

class callPokemon {
    func getPokemon( id: Int, completion:@escaping (pokemon) -> ()) {
        guard let url = URL(string: "https://pokebuildapi.fr/api/v1/pokemon/\(id)")
        else { return }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            
            let pokemons = try! JSONDecoder().decode(pokemon.self, from: data!)
            print(pokemons)
            
            DispatchQueue.main.async {
                completion(pokemons)
            }
        }
        .resume()
    }
}

