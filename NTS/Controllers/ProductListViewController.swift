//
//  ProductListViewController.swift
//  NTS
//
//  Created by Abhishek Rana on 02/10/18.
//  Copyright © 2018 NancyM. All rights reserved.
//

import UIKit
import LoadingPlaceholderView
import  AlamofireImage
class ProductListViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout  {
    private var loadingPlaceholderView = LoadingPlaceholderView()
    var page = 1
    var arrList = [ProductsViewModel]()
    
    @IBOutlet weak var collList: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setUp()
    }
    func setUp(){
        
        self.getData()
        
    }
    func getData(){
        //        loadingPlaceholderView.gradientColor = .darkGray
        //        loadingPlaceholderView.backgroundColor = .lightGray
        loadingPlaceholderView.cover(self.collList)
        
    }
    @objc func delay(){
        self.loadingPlaceholderView.uncover()
        
        self.collList.reloadData()
    }
    
    
    /**UICollectionview data source and delegate
     */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  arrList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductsCollectionViewCell", for: indexPath) as! ProductsCollectionViewCell
        
        //            let mm = arrList[indexPath.row]
        //            cell.imgPoster.sd_setImage(with: URL.init(string: mm.poster)) { (image, error, type, url) in
        //
        //            }
        //            cell.lblDate.text = CommonFuncations.getCurrentYearAndFindDifference(strDate:mm.year)
        //            cell.lblTitle.text = mm.title
        //            cell.lblType.text = mm.type.rawValue
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collSize = self.collList.frame.size
        
        let width = collSize.width/2-10
        let height = collSize.width/2-10 + 3*21 + 3*8 + 20
        return CGSize.init(width:width, height: height+32)
        
    }
    
}
