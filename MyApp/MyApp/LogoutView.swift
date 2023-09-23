//
//  LogoutView.swift
//  MyApp
//
//  Created by Rawand Rzgar on 2023-09-22.
//

import SwiftUI

struct LogoutView: View {
    let onLogout: () -> Void 
    var body: some View {
        Spacer()
        Button(action: {
            self.onLogout()

        }) {
            Text("Logout")
                .padding(8)
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(8)
                .fontWeight(.medium)
        }.padding(.bottom, 30)
    }
}

struct LogoutView_Previews: PreviewProvider {
    static var previews: some View {
        LogoutView {
            
        }
    }
}
