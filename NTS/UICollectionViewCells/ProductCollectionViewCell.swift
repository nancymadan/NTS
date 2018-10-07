//
//  ProductCollectionViewCell.swift
//  NTS
//
//  Created by Abhishek Rana on 07/10/18.
//  Copyright © 2018 NancyM. All rights reserved.
//

import UIKit
import LoadingPlaceholderView
import RxSwift
import RxCocoa

protocol ProductsTapDelegate : class{
    func productAddedToCart(forCell:ProductCollectionViewCell)
}

class ProductCollectionViewCell: UICollectionViewCell {

    var model : ProductsViewModel? = nil
    weak var delegate:ProductsTapDelegate?
    var managedObjectContext = APPDELEGATE?.persistentContainer.viewContext
    @IBOutlet var btnStars: [UIButton]!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var imgPoster: UIImageView!
    
    @IBOutlet weak var btnAddToCart: UIButton!
    
    public var celldisposeBag = DisposeBag()
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        
        
    }
    override func prepareForReuse(){
        super.prepareForReuse()
        celldisposeBag = DisposeBag()
    }
    func setBinding(){
        self.btnAddToCart.rx.tap
            .map { _ in
                ProductsViewModel(name :self.model!.name,price:self.model!.price, imageURL:self.model!.imageURL, rating:self.model!.rating,isAddedToCart:self.model!.isAddedToCart == 1 ? 0 :1)
                
            }.subscribe(onNext: { [weak self] (event) in
                _ = try? self?.managedObjectContext?.rx.update(event)
                if self?.delegate != nil && self != nil && !(self?.btnAddToCart.isSelected)! {
                    self!.delegate!.productAddedToCart(forCell:self!)
                }
            })
            .disposed(by: self.celldisposeBag)
    }

}
