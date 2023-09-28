//
//  MyPokemon.swift
//  Pokemon
//
//  Created by Justine Lecomte on 11/01/2023.
//

import SwiftUI

struct MyPokemon: View {
    @State var myPokemon: [pokemon] = []
    
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
                VStack{
                    VStack {
                        ScrollView{
                            ForEach(myPokemon) { pokemon in
                                if pokedex.contains(pokemon.pokedexId) {
                                    VStack{
                                        Text("\(pokemon.pokedexId). \(pokemon.name)")
                                            .font(.headline.weight(.bold))
                                        HStack{
                                            AsyncImage(url: URL(string: pokemon.image), scale: 3)
                                            Spacer()
                                            VStack{
                                                Text("HP : \(pokemon.stats.HP)")
                                                Text("Attack : \(pokemon.stats.attack)")
                                                Text("Défense : \(pokemon.stats.defense)")
                                                Text("Speed : \(pokemon.stats.speed)")
                                                Text("Att Spé : \(pokemon.stats.special_attack)")
                                                Text("Def Spé : \(pokemon.stats.special_defense)")
                                                
                                                Button("Release", role: .destructive){
                                                    print("Go back in nature \(pokemon.name)")
                                                    pokedex.remove(at: pokedex.firstIndex(of: pokemon.pokedexId) ?? 100)
                                                    UserDefaults.standard.set(pokedex, forKey: "pokedex")
                                                    print(pokedex)
                                                }
                                                .buttonStyle(.bordered)
                                                .tint(.red)
                                                .padding()
                                            }
                                            Spacer()
                                        }
                                    }
                                    .foregroundColor(.black)
                                    .background(.thinMaterial)
                                    .cornerRadius(30)
                                    .padding()
                                    .shadow(radius: 10)
                                }
                            }
                        }
                    }
                }
            }
        }
                .onAppear {
                    apiCall().getPokemon(){ (pokemons) in
                        self.myPokemon = pokemons
                    }
                }
                
        
            }
        }
    

