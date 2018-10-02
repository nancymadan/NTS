//
//  ApiRequest.swift
//  Tul
//
//  Created by dev on 25/09/17.
//  Copyright © 2017 dev. All rights reserved.
//

import UIKit
import Alamofire


enum ApiMethod {
    case GET
    case POST
}
class ApiRequest: NSObject {
    
    
    static func callApiWithParameters(url: String , withParameters parameters:[String:AnyObject], success:@escaping (AnyClass)->(), failure: @escaping (NSString)->(), method: ApiMethod, img: UIImage? , imageParamater: String,headers: [String:String]){
        let manager = Alamofire.SessionManager.default
        // manager.session.configuration.timeoutIntervalForRequest = 30
        manager.request(url ,method : .get,parameters:parameters,encoding:URLEncoding.httpBody ,headers: headers).responseJSON { response
            in
            let statusCode = response.response?.statusCode
            switch response.result{
                
            case .success(_):
                if(statusCode==200){
                    
                    if response.data != nil{
                        do{
                            //                         let json = try JSONDecoder().decode(Welcome.self, from: data)
                            //                            success(json.search)
                            //                            }
                            //                            catch let error as NSError {
                            //                                print("Could not save\(error),\(error.userInfo)")
                            //                            }
                        }
                    }
                    else{
                        if let data = response.result.value{
                            let dict=data as! NSDictionary
                            failure(dict.value(forKey: "error_description") as! NSString)
                        }
                        else if let error = response.result.error{
                            failure(error.localizedDescription as NSString)
                        }
                    }
                    break
                }
                
            case .failure(_):
                if let error = response.result.error{
                    let str = error.localizedDescription as NSString
                    if str.isEqual(to: "JSON could not be serialized because of error:\nThe data couldn’t be read because it isn’t in the correct format."){
                        return
                    }
                    
                    failure(error.localizedDescription as NSString)
                }
                break
            }
        }
    }
}
