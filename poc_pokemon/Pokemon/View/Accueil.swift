//
//  Accueil.swift
//  Pokemon
//
//  Created by Justine Lecomte on 06/01/2023.
//

import Foundation
import SwiftUI

struct Accueil: View {
    @State private var showMenu = false
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
                
                Button("Enter in pokedex") {
                    showMenu = true
                    
                }
                .padding(25)
               .background(.thinMaterial)
               .cornerRadius(20)
               .shadow(radius: 20)
               .foregroundColor(.black)
                .popover(isPresented: $showMenu) {
                    NavigationStack{
                        Menu()
                            //                    NavigationLink{
                            //                        Menu()
                            //                    } label: {
                            //                        Text("Enter in the Pokedex")
                            //                            .foregroundColor(.white)
                            //                    }
                            //                    .padding(25)
                            //                    .background(.thinMaterial)
                            //                    .cornerRadius(20)
                            //                    .shadow(radius: 20)
                        }
                    }
                }
        }
    }
}
