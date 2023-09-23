//
//  Model.swift
//  MyApp
//
//  Created by Rawand Rzgar on 2023-09-22.
//

import Foundation

class Model:ObservableObject {
  @Published var displayingReservationForm = false
  @Published var followNavitationLink = false
  
  @Published var displayTabBar = true
  @Published var tabBarChanged = false
  @Published var tabViewSelectedIndex = Int.max {
    didSet {
      tabBarChanged = true
    }
  }
}
