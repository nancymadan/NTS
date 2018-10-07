//
//  HistoryListViewController.swift
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

class HistoryListViewController: UIViewController {
     var collList: UICollectionView!
    var managedObjectContext = APPDELEGATE?.persistentContainer.viewContext
    private let disposeBag = DisposeBag()
    
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
          self.navigationItem.title = "HISTORY"
        self.configureCollectionView()
      
    }
    
    /**
     configureCollectionView:- set collection view with data from local DB
     */
    func configureCollectionView(){
        self.managedObjectContext?.rx.entities(ProductHistoryViewModel.self, sortDescriptors: [NSSortDescriptor(key: KCoreDataOrderedDate, ascending: false)]).bind(to: self.collList.rx.items(cellIdentifier: "ProductCollectionViewCell",cellType:ProductCollectionViewCell.self)){index, model,cell in
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

    

}
