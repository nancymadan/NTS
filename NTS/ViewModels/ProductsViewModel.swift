//
//  ProductsViewModel.swift
//  NTS
//
//  Created by Abhishek Rana on 02/10/18.
//  Copyright © 2018 NancyM. All rights reserved.
//

import UIKit
import CoreData
import RxCoreData
import RxSwift
import RxCocoa

struct ProductsViewModel  {
    var name, price: String
    var imageURL: String
    var rating: Int
    var isAddedToCart: Int
}


extension ProductsViewModel : Persistable {
    
    typealias T = NSManagedObject
    
    static var entityName: String{
        return KCoreDataEntityProductList
    }
    
    static var primaryAttributeName: String{
        return KCoreDataName
    }
    
    var identity: String{
        return name
    }
    /**
     init:- productViewModel to entity to get calculated data
     */
    init(entity: T) {
        name = entity.value(forKey: KCoreDataName) as! String
        imageURL = entity.value(forKey: KCoreDataImage) as! String
        
        
        if (entity.value(forKey: KCoreDataPrice) as! String).contains("INR") {
            self.price = (entity.value(forKey: KCoreDataPrice) as! String)
        }
        else{
            self.price = "INR " + (entity.value(forKey: KCoreDataPrice) as! String)
        }
        rating = entity.value(forKey: KCoreDataRating) as! Int
        isAddedToCart = entity.value(forKey: KCoreDataIsAddedToCart) as? Int ?? 0
    }
    func update(_ entity: T) {
        entity.setValue(name, forKey:  KCoreDataName)
        entity.setValue(imageURL, forKey: KCoreDataImage)
        entity.setValue(price, forKey:  KCoreDataPrice)
        entity.setValue(rating, forKey: KCoreDataRating)
        if isAddedToCart != -1{
            entity.setValue(isAddedToCart, forKey: KCoreDataIsAddedToCart)
        }
        do {
            try entity.managedObjectContext?.save()
        } catch let e {
            print(e)
        }
    }
    
}
