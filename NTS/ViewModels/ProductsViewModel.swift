//
//  ProductsViewModel.swift
//  NTS
//
//  Created by Abhishek Rana on 02/10/18.
//  Copyright © 2018 NancyM. All rights reserved.
//

import UIKit

struct ProductsViewModel {
    let name, price: String
    let imageURL: String
    let rating: Int
    /**
     init:- product to productViewModel to get calculated data
 */
    init(model:Product) {
        self.name = model.name
        self.imageURL = model.imageURL
        self.price = "INR " + model.price
        self.rating = model.rating
    }
    
//    /**
//     getTheList:-get the list from server
// */
//    static func getTheList(success:@escaping ([ProductsViewModel])->()){
//        ApiRequest.callApiWithParameters(url: KBaseURL, withParameters: [:], success: { (arrProducts) in
//            var arrProductsModel = [ProductsViewModel]()
//            for product in arrProducts{
//                arrProductsModel.append(ProductsViewModel.init(model: product))
//            }
//            
//            success(arrProductsModel)
//        }, failure: { (error) in
//            CommonFuncations.showAlertWithTitle(title: "Error", message: error as String)
//            
//        }, method: .GET, img: nil, imageParamater: "", headers: [:])
//    }
}
