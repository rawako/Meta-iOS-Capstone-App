//
//  Header.swift
//  MyApp
//
//  Created by Rawand Rzgar on 2023-09-22.
//

import Foundation
import SwiftUI
import CoreData

struct HeaderView: View {
    
    @AppStorage("profileImage") private var profileImage: Data = Data()
    
    private var imageURL: URL? {
        
        guard !profileImage.isEmpty else { return nil }
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let imageURL = documentsDirectory.appendingPathComponent("profileImage.jpg")
        
        do {
            try profileImage.write(to: imageURL)
            return imageURL
        } catch {
            print("Error writing image data to disk: \(error.localizedDescription)")
            return nil
        }
    }
    
    
    var body: some View {
        HStack {
            Spacer()
            
            Image("littleLemon")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 40)
            
            Spacer()
            
            
            Button(action: {
                // Perform action when button is tapped
            }) {
                if let imageURL = imageURL,
                   let imageData = try? Data(contentsOf: imageURL),
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                }
            }
        }
        .padding()
        .background(Color.white)
        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 4)
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
    }
}
