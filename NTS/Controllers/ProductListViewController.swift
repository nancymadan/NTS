//
//  ProductListViewController.swift
//  NTS
//
//  Created by Abhishek Rana on 02/10/18.
//  Copyright © 2018 NancyM. All rights reserved.
//

import UIKit
import Alamofire
import  AlamofireImage
import RxSwift
import RxCocoa
import RxDataSources
import RxCoreData
import CoreData

class ProductListViewController: UIViewController  {
private let CheckOutButtonFrame = CGRect.init(x: ScreenWidth-72, y:-56, width: 24, height: 24)
    var managedObjectContext = APPDELEGATE?.persistentContainer.viewContext
    private let apiClient = ApiRequest(manager:Alamofire.SessionManager.default)
    private let disposeBag = DisposeBag()
    var btnCheckOut = UIBarButtonItem.init(image: UIImage.init(named: "ic_checkout_large"), style: .plain, target: self, action: nil)
     var collList: UICollectionView!
    
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
     */
    func setUp(){
        self.view.backgroundColor = .groupTableViewBackground
        self.setUpCollectionView()
        self.setUpNavigationBar()
        self.configureReactiveBinding()
        self.configureCollectionView()
    }
    /**
     setUpNavigationBar:- set up the navigation bar items
     */
    func setUpNavigationBar(){
       self.navigationItem.title = "PRODUCTS"
         let button1 = UIBarButtonItem.init(image: UIImage.init(named: "ic_history"), style: .plain, target: self, action: nil)
        
       
        button1.rx.tap.subscribe(onNext: { [weak self] _ in
             let vc = HistoryListViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            
        }).disposed(by: disposeBag)
        btnCheckOut.rx.tap.subscribe(onNext: { [weak self] _ in
             let vc =  CheckOutViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            
        }).disposed(by: disposeBag)
        self.navigationItem.rightBarButtonItems  = [button1,btnCheckOut]
    }
    
    func setUpCollectionView(){
        let flowLayout = UICollectionViewFlowLayout.init()
        let viewSize = self.view.frame.size
        
        let collFrame = CGRect.init(x: 20, y: 80, width: viewSize.width - 40, height: viewSize.height - 80)
       let width = collFrame.width/2-10
        let height = collFrame.width/2-10 + 3*21 + 3*8 + 20 + 48
        flowLayout.itemSize = CGSize.init(width:width, height: height);
        flowLayout.scrollDirection = .vertical
      self.collList = UICollectionView.init(frame: collFrame, collectionViewLayout: flowLayout)
        self.view.addSubview(self.collList)
        self.collList.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: "ProductCollectionViewCell")
        self.collList.register(UINib.init(nibName: "ProductCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "ProductCollectionViewCell")
        self.collList.backgroundColor = .groupTableViewBackground

        
    }
    /**
     configureReactiveBinding:- get data from server and saved in local Db
     */
    func configureReactiveBinding(){
        self.apiClient.callApiWithParameters(url: KBaseURL, onView: self.collList).subscribe(onNext: { (products) in
           self.SaveInDB(products: products)
        }, onError: { (error) in
            CommonFuncations.showAlertWithTitle(title: "Error", message: error.localizedDescription)
        }, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
       
        
    }
    func SaveInDB(products:[Product]){
        for product1 in products{
            let pm =  ProductsViewModel(name :product1.name,price:product1.price, imageURL:product1.imageURL, rating:product1.rating,isAddedToCart:-1)
            _ = try? self.managedObjectContext?.rx.update(pm)
        }
    }
    /**
     configureCollectionView:- set collection view data from local DB
     */
    func configureCollectionView(){
        self.managedObjectContext?.rx.entities(ProductsViewModel.self, sortDescriptors: [NSSortDescriptor(key: "rating", ascending: false)]).bind(to: self.collList.rx.items(cellIdentifier: "ProductCollectionViewCell",cellType:ProductCollectionViewCell.self)){index, model,cell in
            cell.lblPrice.text = model.price
            for btn in cell.btnStars{
                btn.isSelected = cell.btnStars.index(of:btn)! < model.rating ? true : false
                
            }
            
            cell.model = model
            cell.lblTitle.text = model.name
                        guard let url = URL.init(string:model.imageURL)else {
                            return
                        }
            cell.delegate = self
            
            cell.imgPoster.af_setImage(withURL: url)
            cell.btnAddToCart.isSelected = model.isAddedToCart == 1 ? true : false
            cell.setBinding()
            }.disposed(by: disposeBag)
    }
    
    
}

extension ProductListViewController:ProductsTapDelegate{
    func productAddedToCart(forCell: ProductCollectionViewCell) {
        let rect = forCell.convert(forCell.bounds, to: self.view)
        let imageV = UIImageView.init(frame: rect)
        
       imageV.image = self.takeScreenshot(forFrame: rect, cell: forCell)
        imageV.backgroundColor = .darkGray
        imageV.layer.cornerRadius = 8
        self.view.addSubview(imageV)
        UIView.animate(withDuration: 0.8, animations: {
            imageV.frame = self.CheckOutButtonFrame
        }) { (_) in
            imageV.removeFromSuperview()
        }
    }
    /**
     takeScreenshot:- take screenshot of cell 
     */
    func takeScreenshot(forFrame rect :CGRect,cell:ProductCollectionViewCell) -> UIImage {
        
        let renderer = UIGraphicsImageRenderer(size: cell.bounds.size)
        let image = renderer.image { ctx in
            cell.drawHierarchy(in: cell.bounds, afterScreenUpdates: true)
        }
        
            return image
      
    }
}
