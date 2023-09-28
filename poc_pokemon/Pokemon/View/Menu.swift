//
//  Menu.swift
//  Pokemon
//
//  Created by Justine Lecomte on 12/01/2023.
//

import SwiftUI

struct Menu: View {
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
                ScrollView{
                    VStack{
                        Spacer()
                        NavigationLink{
                            ContentView()
                        } label: {
                            VStack {
                                AsyncImage(url: URL(string: "https://media.licdn.com/dms/image/C5612AQElxByNYtEX_A/article-cover_image-shrink_600_2000/0/1551814454243?e=2147483647&v=beta&t=fLBqc9WzydtUoZhx2Ua63wxx9FkIkMwmVSKxYSrYeU8"), scale: 6)
                                Text("See all Pokemon")
                                    .foregroundColor(.black)
                            }
                            .padding()
                            .background(.thinMaterial)
                            .cornerRadius(20)
                        }
                        
                        Spacer()
                        
                        NavigationLink{
                            MyPokemon()
                        } label: {
                            VStack{
                                AsyncImage(url: URL(string: "https://ih1.redbubble.net/image.733115337.2227/flat,1000x1000,075,f.jpg"), scale: 4)
                                Text("Enter in your Pokedex")
                                    .foregroundColor(.black)
                            }
                            .padding(25)
                            .background(.white)
                            .cornerRadius(20)
                            .shadow(radius: 10)
                        }
                        
                        Spacer()
                    }
                    .offset(y: 200)
                    
                }
            }
        }
    }
}

struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        Menu()
    }
}
