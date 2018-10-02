//
//  ApiRequest.swift
//  Tul
//
//  Created by dev on 25/09/17.
//  Copyright © 2017 dev. All rights reserved.
//

import UIKit
import Alamofire
import RxSwift
import LoadingPlaceholderView
class ApiRequest {
     private var loadingPlaceholderView = LoadingPlaceholderView()
    
    func callApiWithParameters(url: String,onView:UIView)  -> Observable<[ProductsViewModel]>{
        
        return Observable<[ProductsViewModel]>.create { observer in
            self.loadingPlaceholderView.cover(onView)
            let manager = Alamofire.SessionManager.default
            // manager.session.configuration.timeoutIntervalForRequest = 30
            manager.request(url ,method : .get,parameters:[:],encoding:URLEncoding.httpBody ,headers: [:]).responseJSON { response
                in
                let statusCode = response.response?.statusCode
                switch response.result{
                   
                case .success(_):
                     self.loadingPlaceholderView.uncover()
                    if(statusCode==200){
                        
                        if let data = response.data{
                            do{
                                let json = try JSONDecoder().decode(Response.self, from: data)
                                var arrM : [ProductsViewModel] = []
                                for product in json.products{
                                    arrM.append(ProductsViewModel.init(model: product))
                                }
                                observer.onNext(arrM)
                            }
                            catch let error as NSError {
                                observer.onError(error)
                            }
                        }
                    }
                    else{
                        if let data = response.result.value{
                            let dict=data as! NSDictionary
                            observer.onError((dict.value(forKey: "error_description") as! NSString) as! Error)
                        }
                        else if let error = response.result.error{
                            observer.onError(error)
                        }
                    }
                    break
                case .failure(_):
                     self.loadingPlaceholderView.uncover()
                    if let error = response.result.error{
                        let str = error.localizedDescription as NSString
                        if str.isEqual(to: "JSON could not be serialized because of error:\nThe data couldn’t be read because it isn’t in the correct format."){
                            
                        }
                        
                        observer.onError(error)
                    }
                    observer.onCompleted()
                }
              
            }
            return Disposables.create {
            }
        }
    }
}
