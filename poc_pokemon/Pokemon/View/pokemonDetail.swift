//
//  pokemonDetail.swift
//  Pokemon
//
//  Created by Justine Lecomte on 06/01/2023.
//

import Foundation
import SwiftUI

//extension UserDefaults {
//    var pokedex: [Int] {
//        get {
//            array(forKey: "poke") as? [Int] ?? []
//        }
//        set {
//            set(newValue, forKey: "poke")
//        }
//    }
//}

struct pokemonDetail: View {
    
    @State var detailPoke: pokemon
    @State var name: String
    
    @State var pokedex: [Int] = UserDefaults.standard.array(forKey: "pokedex") as? [Int] ?? [Int]()
        
    var body: some View {
            NavigationStack{
                    ZStack{
                            VStack(spacing: 0){
                                    Color.red
                                    Color.black
                                            .frame(maxHeight: 50)
                                    Color.white
                            }
                            .ignoresSafeArea()
                            VStack {
                                    VStack{
                                            Text("\(detailPoke.pokedexId). \(detailPoke.name)")
                                                    .font(.headline.weight(.bold))
                                            HStack{
                                                    AsyncImage(url: URL(string: detailPoke.image), scale: 3)
                                                    Spacer()
                                                    VStack{
                                                            Text("HP : \(detailPoke.stats.HP)")
                                                            Text("Attack : \(detailPoke.stats.attack)")
                                                            Text("Défense : \(detailPoke.stats.defense)")
                                                            Text("Speed : \(detailPoke.stats.speed)")
                                                            Text("Att Spé : \(detailPoke.stats.special_attack)")
                                                            Text("Def Spé : \(detailPoke.stats.special_defense)")
                                                    }
                                                    Spacer()
                                            }
                                            if pokedex.contains(detailPoke.pokedexId) {
                                                    Button("Release", role: .destructive){
                                                            print("Go back in nature \(detailPoke.name)")
                                                            pokedex.remove(at: pokedex.firstIndex(of: detailPoke.pokedexId) ?? 100)
                                                            UserDefaults.standard.set(pokedex, forKey: "pokedex")
                                                            print(pokedex)
                                                    }
                                                    .buttonStyle(.bordered)
                                                    .tint(.red)
                                                    
                                            } else {
                                                    Button("Catch") {
                                                            print("I catch \(detailPoke.name)")
                                                            pokedex.append(detailPoke.pokedexId)
                                                            UserDefaults.standard.set(pokedex, forKey: "pokedex")
                                                            print(pokedex)
                                                    }
                                                    .buttonStyle(.bordered)
                                                    .tint(.teal)
                                                    .foregroundColor(.black)
                                            }
                                    }
                                    .padding()
                                    .background(.thinMaterial)
                                    .cornerRadius(20)
                                    .shadow(radius: 10)
                            }
                            .padding()
                    }
            }
    .onAppear {
        callPokemon().getPokemon(id: detailPoke.pokedexId) { (pokemons) in
            self.detailPoke = pokemons
        }
    }
}
}

//struct PokeView_Previews: PreviewProvider {
//    static var previews: some View {
//        pokemonDetail()
//    }
//}
