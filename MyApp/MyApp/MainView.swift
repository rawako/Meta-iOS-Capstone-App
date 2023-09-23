//
//  MainView.swift
//  MyApp
//
//  Created by Rawand Rzgar on 2023-09-22.
//

import Foundation
import SwiftUI
import CoreData


struct MainView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject var model = Model()
    @AppStorage("firstName") var firstName = ""
    @AppStorage("lastName") var lastName = ""
    @AppStorage("email") var email = ""
    @State var tabSelection = 0
    @State var previousTabSelection = -1 // any invalid value
    @ObservedObject var dishesModel = DishesModel()
    @State var categories: [String] = []
   
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor.white
    }
    
    var body: some View {
        TabView (selection: $model.tabViewSelectedIndex) {
            if firstName.isEmpty || lastName.isEmpty || email.isEmpty {
                OnboardingView()
            } else {
                HomeView(categories: categories)
                    .tag(0)
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                    .onAppear() {
                        tabSelection = 0
                    }
                
                UserProfile()
                    .tag(1)
                    .tabItem {
                        Image(systemName: "person.crop.circle")
                        Text("Profile")
                    }.onAppear() {
                        tabSelection = 1
                    }
            }
         
        }
        .accentColor(mainColor)
        .id(tabSelection)
        .task {
            await dishesModel.reload(viewContext)
            let latestCategories = dishesModel.menuItems.map { $0.category }
            let result = Array(Set(latestCategories))
            categories=result
         }
        .environmentObject(model)
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
