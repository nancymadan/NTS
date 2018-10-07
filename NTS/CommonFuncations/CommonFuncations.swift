 //
//  CommonFuncations.swift
//  Tul
//
//  Created by dev on 26/09/17.
//  Copyright © 2017 dev. All rights reserved.
//

import UIKit
import CoreTelephony
import CoreData
 
 class CommonFuncations: NSObject {
 static func showAlertWithTitle(title : String,message : String) {
    let alertVc = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    alertVc.addAction(UIAlertAction.init(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
        let currentVc = self.fetchCurrentViewController()
        currentVc.present(alertVc, animated: true, completion: nil)
        
    }
    static func fetchCurrentViewController()->UIViewController{
        let navCntrl = APPDELEGATE?.window?.rootViewController as! UINavigationController
        let currentVc = navCntrl.viewControllers.last!
        return currentVc
    }
}
