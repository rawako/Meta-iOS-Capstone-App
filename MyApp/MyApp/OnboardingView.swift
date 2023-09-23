//
//  SwiftUIView.swift
//  MyApp
//
//  Created by Rawand Rzgar on 2023-09-22.
//

import Foundation
import SwiftUI
import CoreData

let mainColor = Color(red: 73/255,green: 94/255, blue: 87/255, opacity: 1)
let secondaryColor = Color(red: 244/255,green: 206/255, blue: 20/255, opacity: 1)
let mainBg = Color(red: 245/255,green: 245/255, blue: 245/255, opacity: 1)

struct OnboardingView: View {
    let defaults = UserDefaults.standard
//    @EnvironmentObject var appState: AppState
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showValidationAlert = false
 

    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    
    private func isValidEmail(_ email: String) -> Bool {
          // Validate email using regular expression
          let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
          let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
          return emailPred.evaluate(with: email)
      }
    
    private func handleRegistration() {
         guard !firstName.isEmpty else {
             showValidationAlert = true
             return
         }
         guard !lastName.isEmpty else {
             showValidationAlert = true
             return
         }
         guard isValidEmail(email) else {
             showValidationAlert = true
             return
         }
         do {
             try viewContext.save()
             defaults.set(firstName, forKey: "firstName")
             defaults.set(lastName, forKey: "lastName")
             defaults.set(email, forKey: "email")
         } catch {
             print("Failed to save user: \(error.localizedDescription)")
         }
     }

    var body: some View {
        VStack {
            VStack {
                Image("littleLemon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 40)
                    .padding(.bottom,20)
            }
            .frame(maxWidth: .infinity)
            .background(.white)
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Little Lemon")
                            .foregroundColor(secondaryColor) .font(.system(size: 36))
                            .fontWeight(.medium)
                        Text("Chicago")
                            .foregroundColor(.white)
                            .font(.system(size: 24))
                            .fontWeight(.regular)
                    }
                    Spacer()
                }
                
                HStack(alignment: .bottom) {
                    Text("We are a family owned Mediterranean restaurant, focused on traditional recipes served with a modern twist.")
                        .frame(maxHeight: 165)
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                        .fontWeight(.regular)
                        .frame(maxWidth: 242)
                        .padding(.bottom, 5)
                    Image("Hero image")
                        .resizable()
                        .aspectRatio(1, contentMode: .fill)
                        .frame(maxWidth: 147, maxHeight: 152)
                        .cornerRadius(10)
                        .padding(.trailing, 15)
                }
                Spacer()
                TextField("First Name", text: $firstName)
                    .onChange(of: firstName) { value in
                        self.firstName = value
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Last Name", text: $lastName)
                    .textFieldStyle(RoundedBorderTextFieldStyle()).padding(.top, 6)
                    .onChange(of: lastName) { value in
                        self.lastName = value
                    }
                
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.top, 6)
                    .padding(.bottom, 12)
                    .onChange(of: email) { value in
                        self.email = value
                    }
                Button(action: {
                   handleRegistration()
                }) {
                   Text("Register")
                       .font(.headline)
                       .foregroundColor(mainColor)
                       .padding()
                }
                .frame(width: 200)
                .background(secondaryColor)
                .cornerRadius(10)
                .alert(isPresented: $showValidationAlert) {
                    Alert(title: Text("Error"), message: Text("Please enter a valid first name, last name, and email."), dismissButton: .default(Text("OK")))
                }
                Spacer()
            }
            .padding(.horizontal, 30)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(mainColor)
        .navigationBarHidden(true)
      
    }
 
}


struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
