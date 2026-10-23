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
    @State private var loadingFailed = false
    @State private var searchText = ""

    private var visibleRecipes: [Recipe] {
        RecipeSearch(query: searchText).filter(recipes)
    }
    
    var body: some View {
        NavigationView {
            List(visibleRecipes) { recipe in
                RecipeCardView(recipe: recipe)
            }
            .accessibilityIdentifier("recipeList")
            .searchable(text: $searchText, prompt: "Name or cuisine")
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
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
                    ProgressView("Loading recipes")
                        .accessibilityIdentifier("recipeLoading")
                }
                if recipes.isEmpty && !isLoading {
                    ContentUnavailableView {
                        Label(loadingFailed ? "Couldn't Load Recipes" : "No Recipes Available",
                              systemImage: loadingFailed ? "exclamationmark.triangle" : "fork.knife.circle")
                    } description: {
                        Text(loadingFailed ? "Pull to refresh and try again" : "Pull to refresh")
                    }
                } else if visibleRecipes.isEmpty && !isLoading {
                    ContentUnavailableView {
                        Label("No Matching Recipes", systemImage: "magnifyingglass")
                    } description: {
                        Text("Try a different name or cuisine")
                    }
                    .accessibilityIdentifier("recipeSearchEmpty")
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
        isLoading = true
        loadingFailed = false
        Task { @MainActor in
            defer { isLoading = false }
            do {
                try await recipeService.fetchRecipes(url: apiInUse.url.absoluteString)
            } catch {
                loadingFailed = true
                toast = .error("Oops Something went wrong!")
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
