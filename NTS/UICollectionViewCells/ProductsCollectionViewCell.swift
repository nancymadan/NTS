    //
    //  ProductsCollectionViewCell.swift
    //  NTS
    //
    //  Created by Abhishek Rana on 30/09/18.
    //  Copyright © 2018 NancyM. All rights reserved.
    //
    
    import UIKit
    import LoadingPlaceholderView
    protocol ProductsDelegate {
        func ProductAddedToCart(atIndexPath indexPath:IndexPath)
    }
    class ProductsCollectionViewCell: UICollectionViewCell {
        var indexPath:IndexPath? = nil
        var delegate:ProductsDelegate? = nil
        
        @IBOutlet var btnStars: [UIButton]!
        @IBOutlet weak var lblPrice: UILabel!
        @IBOutlet weak var lblTitle: UILabel!
        @IBOutlet weak var viewBack: UIView!
        @IBOutlet weak var imgPoster: UIImageView!
        
        //MARK:-actions
        @IBAction func actionAddToCart(_ sender: Any) {
            if indexPath != nil && self.delegate != nil{
                self.delegate?.ProductAddedToCart(atIndexPath: self.indexPath!)
            }
        }
    }
