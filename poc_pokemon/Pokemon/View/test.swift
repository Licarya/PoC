//
//  test.swift
//  Pokemon
//
//  Created by Justine Lecomte on 11/01/2023.
//

import SwiftUI

struct test: View {
    @State private var count =  UserDefaults.standard.integer(forKey: "Tap")
    @AppStorage("TapCount") var tapCount = 0
    @State private var show = false
    
    var body: some View {
        
        Button("Show"){
            show = true
        }
        .popover(isPresented: $show) {
            Text("hello")
                .font(.headline)
        }
        
        Button("Tap count: \(count)") {
            count += 1
            UserDefaults.standard.set(count, forKey: "Tap")
        }
        
        Button("Second Tap count: \(tapCount)") {
            tapCount -= 1
        }
        
        Button("Reset") {
            count = 0
            tapCount = 0
            UserDefaults.standard.set(count, forKey: "Tap")
        }
    }
    func add() {
        print("Hello")
    }
}

struct test_Previews: PreviewProvider {
    static var previews: some View {
        test()
    }
}
