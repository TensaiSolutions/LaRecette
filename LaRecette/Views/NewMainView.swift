//
//  NewMainView.swift
//  LaRecette
//
//  Created by philip sidell on 3/24/25.
//

import SwiftUI

struct NewMainView: View {
    @State private var showingDebug = false
    @State private var apiInUse: APIs.Recipes = APIs.Recipes.allRecipes
    @State private var toast: Toast? = nil
    @State private var isLoading: Bool = false
    
    var body: some View {
        NavigationView {
        }
        .sheet(isPresented: $showingDebug) {
            VStack {
                Text("Current API: \(apiInUse.rawValue)")
                Picker("API", selection: $apiInUse) {
                    ForEach(APIs.Recipes.allCases, id: \.self) {api in
                        Text(api.rawValue)
                    }
                }
            }
            .presentationDetents([.medium, .large])
        }
        .toastView(toast: $toast)
    }
}

#Preview {
    NewMainView()
}
