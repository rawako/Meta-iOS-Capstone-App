//
//  Dish+Extension.swift
//  MyApp
//
//  Created by Rawand Rzgar on 2023-09-22.
//

import Foundation
import CoreData
import SwiftUI

extension Dish {
    
    static func createDishesFrom(menuItems:[MenuItem],
                                 _ context:NSManagedObjectContext) {
        for menuItem in menuItems {
            guard exists(title: menuItem.title, context) == false else {
                continue
            }
            let oneDish = Dish(context: context)
            oneDish.title = menuItem.title
            oneDish.price = menuItem.price
            oneDish.desc = menuItem.desc
            oneDish.image = menuItem.image
            oneDish.category = menuItem.category
            if let imageUrl = URL(string: menuItem.image) {
                let cache = URLCache.shared
                let request = URLRequest(url: imageUrl)
                if let cachedData = cache.cachedResponse(for: request)?.data {
                    oneDish.imageData = cachedData
                } else {
                    URLSession.shared.dataTask(with: request) { data, response, error in
                        if let imageData = data {
                            cache.storeCachedResponse(CachedURLResponse(response: response!, data: imageData), for: request)
                            DispatchQueue.main.async {
                                oneDish.imageData = imageData
                            }
                        }
                    }.resume()
                }
            }
        }
    }
    
    
    static func exists(title: String,
                       _ context:NSManagedObjectContext) -> Bool? {
        let request = Dish.request()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", title)
        request.predicate = predicate
        
        do {
            guard let results = try context.fetch(request) as? [Dish]
                    
            else {
                return nil
            }
            print("results",results)
            return results.count > 0
        } catch (let error){
            print(error.localizedDescription)
            return false
        }
    }
    func saveImage(_ image: UIImage) {
            self.imageData = image.jpegData(compressionQuality: 1.0)
        }
        
        func getImage() -> UIImage? {
            guard let imageData = self.imageData else {
                return nil
            }
            return UIImage(data: imageData)
        }
}
