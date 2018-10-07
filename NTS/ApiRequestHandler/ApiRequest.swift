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
    private let manager: SessionManager
    init(manager: SessionManager) {
        self.manager = manager
    }
    func callApiWithParameters(url: String,onView:UIView)  -> Observable<[Product]>{
        
        return Observable<[Product]>.create { observer in
         //   if onView != nil{
                self.loadingPlaceholderView.cover(onView)
           // }
           
            self.manager.request(url ,method : .get,parameters:[:],encoding:URLEncoding.httpBody ,headers: [:]).responseJSON { response
                in
                let statusCode = response.response?.statusCode
                switch response.result{
                   
                case .success(_):
                   // if onView != nil{
                     self.loadingPlaceholderView.uncover()
                    //}
                    if(statusCode==200){
                        
                        if let data = response.data{
                            do{
                                let json = try JSONDecoder().decode(Response.self, from: data)
                             
                                observer.onNext(json.products)
                            }
                            catch let error as NSError {
                                observer.onError(error)
                            }
                        }
                    }
                    else{
                        if let error = response.result.error{
                            observer.onError(error)
                        }
                        else{
                            let error1 = NSError(domain:"", code:404, userInfo:[NSLocalizedDescriptionKey:"No Result Found"])
                            observer.onError(error1)
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
