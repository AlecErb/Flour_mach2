//
//  ContentView.swift
//  Flour
//
//  Created on 2026-02-06.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Flour")
                .font(.largeTitle)
                .fontWeight(.bold)
            Text("Hyperlocal Marketplace")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
