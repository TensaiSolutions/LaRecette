//
//  MainView.swift
//  LaRecette
//
//  Created by philip sidell on 3/10/25.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.modelContext) var modelContext
    @Injected(\.recipeService) var recipeService
    @Query(sort: \Recipe.name) var recipes: [Recipe]
    @State private var showingDebug = false
    @State private var apiInUse: APIs.Recipes = APIs.Recipes.allRecipes
    @State private var toast: Toast? = nil
    @State private var isLoading: Bool = false
    
    var body: some View {
        NavigationView {
            List(recipes) { recipe in
                RecipeCardView(recipe: recipe)
            }
            .scrollContentBackground(.hidden)
            .listRowSeparator(.hidden)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {showingDebug.toggle()} ) {
                        Label("Debug", systemImage: "gear")
                    }
                }
            }
            .overlay {
                if isLoading {
                    ProgressView()
                }
                if recipes.isEmpty && !isLoading {
                    ContentUnavailableView {
                        Label("No Recipes Available", systemImage: "fork.knife.circle")
                    } description: {
                        Text("Pull to refresh")
                    }
                }
            }
            .task {
                if recipes.isEmpty {
                    fetchRecipes()
                }
            }
            .refreshable {
                fetchRecipes()
            }
            .onChange(of: apiInUse) {
                showingDebug.toggle()
                fetchRecipes()
            }
            .navigationBarTitle("Recettes")
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
    
    private func fetchRecipes() {
        isLoading.toggle()
        Task{
            @MainActor in
            do{
                try await recipeService.fetchRecipes(url: apiInUse.url.absoluteString)
                isLoading.toggle()
            } catch {
                switch error {
                case NetworkError.failedToDecodeResponse:
                    print("Couldn't decode response")
                    toast = .error("Oops Something went wrong!")
                    isLoading.toggle()
                default:
                    print("unhandled error: \(error)")
                    break
                    
                }
            }
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Recipe.self, configurations: config)
        let sampleRecipe = Recipe(
            name: "Phils Mac & Cheese",
            cuisine: "American",
            photoURLSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg"
        )
        container.mainContext.insert(sampleRecipe)
        
        return MainView().modelContainer(container)
    } catch {
        fatalError("Unable to create preview environment: \(error)")
    }
}
