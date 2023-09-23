//
//  DisplayView.swift
//  MyApp
//
//  Created by Rawand Rzgar on 2023-09-22.
//

import SwiftUI


struct DisplayDish: View {
    @ObservedObject private var dish:Dish
    @State private var dishImage: UIImage?
    
    init(_ dish: Dish) {
        self.dish = dish
        
        if let imageData = dish.imageData {
            self._dishImage = State(initialValue: UIImage(data: imageData))
        } else {
            self._dishImage = State(initialValue: nil)
        }
    }
    
    func formatPrice(_ price: Double) -> String {
        let spacing = price < 10 ? " " : ""
        return "$ " + spacing + String(format: "%.2f", price)
    }
    
    var body: some View {
        HStack{
            VStack(alignment: .leading) {
                Text(dish.title ?? "")
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Text(dish.desc ?? "")
                    .padding([.top, .bottom], 7)
                    .foregroundColor(mainColor)
                
                if let price = dish.price {
                    Text(formatPrice(Double(price)!))
                        .monospaced()
                        .font(.callout)
                        .foregroundColor(mainColor)
                        .fontWeight(.medium)
                } else {
                    Text("N/A")
                        .monospaced()
                        .font(.callout)
                        .foregroundColor(mainColor)
                        .fontWeight(.medium)
                }
            }
            
            Spacer()
            
            if let uiImage = dishImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .cornerRadius(10)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
            } else {
                // Display a placeholder image
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)
            }
        }.padding(.horizontal, 15).onAppear {
            if let imageUrlString = dish.image, let imageUrl = URL(string: imageUrlString) {
                let request = URLRequest(url: imageUrl)
                let cache = URLCache.shared
                if let data = cache.cachedResponse(for: request)?.data, let uiImage = UIImage(data: data) {
                    self.dishImage = uiImage
                } else {
                    URLSession.shared.dataTask(with: request) { data, response, error in
                        if let imageData = data, let uiImage = UIImage(data: imageData) {
                            cache.storeCachedResponse(CachedURLResponse(response: response!, data: imageData), for: request)
                            DispatchQueue.main.async {
                                // Check if the dish object is still the same before updating the image
                                if self.dish == dish {
                                    self.dishImage = uiImage
                                    self.dish.saveImage(uiImage)
                                }
                            }
                        } else {
                            // Display another image in case of an error
                            DispatchQueue.main.async {
                                self.dishImage = UIImage(named: "error_image")
                            }
                        }
                    }.resume()
                }
            }
        }
        Divider()
    }
}
