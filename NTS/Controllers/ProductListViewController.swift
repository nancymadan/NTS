//
//  ProductListViewController.swift
//  NTS
//
//  Created by Abhishek Rana on 02/10/18.
//  Copyright © 2018 NancyM. All rights reserved.
//

import UIKit
import  AlamofireImage
import RxSwift
import RxCocoa

class ProductListViewController: UIViewController,UICollectionViewDelegateFlowLayout  {
    
    
    private let apiClient = ApiRequest()
    private let disposeBag = DisposeBag()
    @IBOutlet weak var collList: UICollectionView!
    
    //MARK:-override funcations
    /**override funcations
     viewDidLoad:- overriding view didload funcation
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setUp()
    }
    
    //MARK:-Helper funcations
    /**Helper funcations
     setUp:- intial set up
     getData:-get products listing
     */
    func setUp(){
        self.configureReactiveBinding()
        // add this line you can provide the cell size from delegate method
        self.collList.rx.setDelegate(self).disposed(by: disposeBag)
    }
    func configureReactiveBinding(){
        self.apiClient.callApiWithParameters(url: KBaseURL, onView: self.collList).bind(to: self.collList.rx.items(cellIdentifier: "ProductsCollectionViewCell",cellType:ProductsCollectionViewCell.self)){index, model,cell in
            cell.lblPrice.text = model.price
            for btn in cell.btnStars{
                btn.isSelected = cell.btnStars.index(of:btn)! < model.rating ? true : false
                
            }
            cell.lblTitle.text = model.name
            guard let url = URL.init(string:model.imageURL)else {
                return
            }
            cell.imgPoster.af_setImage(withURL: url)
            
            }.disposed(by: disposeBag)
        
    }
    
    //MARK:-UICollectionView funcations
    /**UICollectionview data source and delegate
     */
    //    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    //        return  arrList.count
    //    }
    //    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    //        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductsCollectionViewCell", for: indexPath) as! ProductsCollectionViewCell
    //
    //        return cell
    //    }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let collSize = self.collList.frame.size
    
            let width = collSize.width/2-10
            let height = collSize.width/2-10 + 3*21 + 3*8 + 20
            return CGSize.init(width:width, height: height+32)
    
        }
    
}

