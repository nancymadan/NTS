//
//  CheckOutViewController.swift
//  NTS
//
//  Created by Abhishek Rana on 02/10/18.
//  Copyright © 2018 NancyM. All rights reserved.
//

import UIKit
import  AlamofireImage
import RxSwift
import RxCocoa
import RxDataSources
import RxCoreData
import CoreData
import Alamofire

class CheckOutViewController: UIViewController {
    var managedObjectContext = APPDELEGATE?.persistentContainer.viewContext
    private let disposeBag = DisposeBag()
    
     var collList: UICollectionView!
     var btnCheckOut: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setUp()
        self.navigationItem.title = "CHECK OUT"
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.resetFrames()
    }
    //MARK:-Helper funcations
    /**Helper funcations
     setUp:- intial set up
     */
    func setUp(){
        self.view.backgroundColor = .groupTableViewBackground
        self.setUpUI()
        self.configureCollectionView()
        self.setCheckOutButton()
    }
    func setUpUI(){
        let flowLayout = UICollectionViewFlowLayout.init()
        let viewSize = self.view.frame.size
        
        let collFrame = CGRect.init(x: 20, y: 80, width: viewSize.width - 40, height: viewSize.height - 40)
        let width = collFrame.width/2-10
        let height = collFrame.width/2-10 + 3*21 + 3*8 + 20 + 48
        flowLayout.itemSize = CGSize.init(width:width, height: height);
        flowLayout.scrollDirection = .vertical
        self.collList = UICollectionView.init(frame: collFrame, collectionViewLayout: flowLayout)
        self.view.addSubview(self.collList)
        self.collList.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: "ProductCollectionViewCell")
        self.collList.register(UINib.init(nibName: "ProductCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "ProductCollectionViewCell")
        self.collList.backgroundColor = .groupTableViewBackground
        
        btnCheckOut = UIButton.init(frame: CGRect.init(x: 20, y: ScreenHeight-20-56, width: ScreenWidth-40, height: 56))
        btnCheckOut.backgroundColor = AppThemeColor
        btnCheckOut.setTitleColor(.black, for: .normal)
        btnCheckOut.setTitle("CHECK OUT", for: .normal)
        btnCheckOut.layer.cornerRadius = 8
        self.view.addSubview(btnCheckOut)
    }
    func resetFrames(){
        let viewSize = self.view.frame.size
        let btnCheckOutHt : CGFloat = 56.0
        let btnCheckoutBtm : CGFloat = 40.0
         self.collList.frame = CGRect.init(x: 20, y: 80, width: viewSize.width - 40, height: (viewSize.height - 40.0 - btnCheckOutHt - 2*btnCheckoutBtm))
         btnCheckOut.frame = CGRect.init(x: 20, y: (ScreenHeight - btnCheckoutBtm - btnCheckOutHt), width: ScreenWidth-40, height: btnCheckOutHt)
    }
    /**
     configureCollectionView:- set collection view with data from local DB
     */
    func configureCollectionView(){
        self.managedObjectContext?.rx.entities(ProductsViewModel.self,predicate : NSPredicate(format: "isAddedToCart == 1"), sortDescriptors: [NSSortDescriptor(key: "rating", ascending: false)]).bind(to: self.collList.rx.items(cellIdentifier: "ProductCollectionViewCell",cellType:ProductCollectionViewCell.self)){index, model,cell in
            cell.lblPrice.text = model.price
            for btn in cell.btnStars{
                btn.isSelected = cell.btnStars.index(of:btn)! < model.rating ? true : false
                
            }
            cell.model = model
            cell.lblTitle.text = model.name
            guard let url = URL.init(string:model.imageURL)else {
                return
            }
            cell.btnAddToCart.isSelected = model.isAddedToCart == 1 ? true : false
            cell.imgPoster.af_setImage(withURL: url)
            cell.setBinding()
            }.disposed(by: disposeBag)
    }
    
    /**
     setCheckOutButton:- set CheckOutButton to subscribe on tap
     */
    func setCheckOutButton(){
        self.btnCheckOut.rx.tap.subscribe(onNext: { [weak self] _ in
            if self?.collList.visibleCells.count == 0 {
                CommonFuncations.showAlertWithTitle(title: "Error", message: "Your cart is empty")
                return
            };
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: KCoreDataEntityProductList)
            request.predicate = NSPredicate(format: "isAddedToCart == 1")
            request.returnsObjectsAsFaults = false
            do {
                let result = try self?.managedObjectContext?.fetch(request)
                for data in result as! [NSManagedObject] {
                    print(data.value(forKey: KCoreDataName) as! String)
                    let pm =  ProductsViewModel(name :data.value(forKey: KCoreDataName) as! String,price:data.value(forKey: KCoreDataPrice) as! String, imageURL:data.value(forKey: KCoreDataImage) as! String, rating:data.value(forKey: KCoreDataRating) as! Int,isAddedToCart:0)
                    _ = try? self?.managedObjectContext?.rx.update(pm)
                    let pHm =  ProductHistoryViewModel(name :pm.name,price:pm.price, imageURL:pm.imageURL, rating:pm.rating,orderedDate:Date());
                    _ = try? self?.managedObjectContext?.rx.update(pHm)
                }
                
            } catch {
                
                print("Failed")
            }
            

            
            
            
            
            let alertVc = UIAlertController.init(title: "Congrats!", message: "Your order has been placed successfully", preferredStyle: .alert)
            alertVc.addAction(UIAlertAction.init(title: "Ok", style: .default
                , handler: { (_) in
                     let vc =  HistoryListViewController()
                        self?.navigationController?.pushViewController(vc, animated: true)
                    
            }))
            self?.present(alertVc, animated: true, completion: nil)
            
        }).disposed(by: disposeBag)
    }
    
    
}
