//
//  ContentView.swift
//  Pokemon
//
//  Created by Justine Lecomte on 06/01/2023.
//

import SwiftUI

struct ContentView: View {
    @State var pokemons: [pokemon] = []
    @State var generation: Int = 1
    
    
    let generations: [Int] = [1, 2, 3, 4, 5, 6, 7, 8]
    
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
                    Spacer()
                    VStack{
                        Section{
                            Picker("Choose a generation", selection: $generation){
                                ForEach(generations, id: \.self){
                                    Text("\($0)")
                                }
                            }
                            .pickerStyle(.segmented)
                        } header: {
                            Text("Choose a generation")
                        }
                    }
                    .padding()
                    .background(.thinMaterial)
                    .background(.white)
                    .cornerRadius(30)
                    .padding()
                    
                    ScrollView{
                    ForEach(pokemons) { pokemon in
                            if generation == pokemon.apiGeneration {
                                NavigationLink{
                                    pokemonDetail(detailPoke: pokemon, name: pokemon.name)
                                } label: {
                                    HStack{
                                        Spacer()
                                        Text("\(pokemon.pokedexId). ")
                                        Spacer()
                                        AsyncImage(url: URL(string: pokemon.sprite), scale: 1.5)
                                        Spacer()
                                        Text("\(pokemon.name)")
                                        Spacer()
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
            .navigationTitle("Tous les Pokemons")
            
            .onAppear {
                apiCall().getPokemon { (pokemons) in
                    self.pokemons = pokemons
                }
            }
            
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
