//
//  RankViewController.swift
//  AlertTest
//
//  Created by Alexander on 26/04/2019.
//  Copyright © 2019 sgqyang4. All rights reserved.
//

import UIKit


//
//  CardPartCollectionViewCardController.swift
//  CardParts_Example
//
//  Created by Roossin, Chase on 5/23/18.
//  Copyright © 2018 Intuit. All rights reserved.
//

import Foundation
import CardParts
import RxSwift
import RxDataSources
import RxCocoa



class RankCardPartCollectionViewCardController: CardPartsViewController {
    
    let cardPartTextView = CardPartTextView(type: .normal)
    lazy var collectionViewCardPart = CardPartCollectionView(collectionViewLayout: self.collectionViewLayout)
    var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        layout.scrollDirection = .vertical
        
        layout.itemSize = CGSize(width: 310, height: 100)
        return layout
    }()
    let viewModel = RankCardPartCollectionViewModel()
    func reload(){
        self.viewDidLoad()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardPartTextView.text = "This is a CardPartCollectionView"
        
        collectionViewCardPart.collectionView.register(RankCustomCollectionViewCell.self, forCellWithReuseIdentifier: "MyCustomCollectionViewCell")
        collectionViewCardPart.collectionView.backgroundColor = .clear
        collectionViewCardPart.collectionView.showsHorizontalScrollIndicator = false
        collectionViewCardPart.collectionView.showsVerticalScrollIndicator = false
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionOfCustomStruct>(configureCell: { (_, collectionView, indexPath, data) -> UICollectionViewCell in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCustomCollectionViewCell", for: indexPath) as? RankCustomCollectionViewCell else { return UICollectionViewCell() }
            
            cell.setData(data)
            
            
            cell.layer.cornerRadius = 20
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor(red: 0.93, green: 0.93, blue: 0.95, alpha: 1.0).cgColor
            if (data.title.lowercased().range(of: currentUser!.name.lowercased()) != nil){
                print("contains name")
                cell.backgroundColor = .init(red: 1, green: 38/255, blue: 33/255, alpha: 1)
                
            }else{
                cell.backgroundColor = .init(red: 134/255, green: 179/255, blue: 249/255, alpha: 1)
            }
            
            return cell
        })
        
        viewModel.data.asObservable().bind(to: collectionViewCardPart.collectionView.rx.items(dataSource: dataSource)).disposed(by: bag)
        
        collectionViewCardPart.collectionView.frame = CGRect(x: 0, y: 0, width: 500, height: 1000)
        
        setupCardParts([cardPartTextView, collectionViewCardPart])
    }
}

class RankCardPartCollectionViewModel {
    
    typealias ReactiveSection = BehaviorRelay<[SectionOfCustomStruct]>
    var data = ReactiveSection(value: [])
    
    let emojis: [String] = ["😎", "🤪", "🤩", "👻", "🤟🏽", "💋", "💃🏽"]
    
    init() {
        
        var temp: [MyStruct] = []
        temp = connector.fetchRankInfo()
//        for i in 0...10 {
//
//            temp.append(MyStruct(title: "Rank 1: Alexander", description: "33023"))
//        }
//
        data.accept([SectionOfCustomStruct(header: "", items: temp)])
    }
}

class RankCustomCollectionViewCell: CardPartCollectionViewCardPartsCell {
    let bag = DisposeBag()
    
    let titleCP = CardPartTextView(type: .title)
    let descriptionCP = CardPartTextView(type: .normal)
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        titleCP.margins = .init(top: 20, left: 60, bottom: 5, right: 30)
        descriptionCP.margins = .init(top: 0, left: 0, bottom: 30, right: 60)
        setupCardParts([titleCP, descriptionCP])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(_ data: MyStruct) {
        print("data title: ")
        print(data.title.contains(currentUser!.name))
        
        
        titleCP.text = data.title
        // titleCP.textAlignment = .left
        titleCP.textColor = .white
        titleCP.font = .systemFont(ofSize: 17, weight: .bold)
        descriptionCP.text = data.description
        descriptionCP.textAlignment = .right
        descriptionCP.textColor = .white
        descriptionCP.font = .systemFont(ofSize: 30, weight: .bold)
       
    }
}
