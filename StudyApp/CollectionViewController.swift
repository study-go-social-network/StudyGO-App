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

struct MyStruct {
    var title: String
    var description: String
}

struct SectionOfCustomStruct {
    var header: String
    var items: [Item]
}

extension SectionOfCustomStruct: SectionModelType {
    
    typealias Item = MyStruct
    
    init(original: SectionOfCustomStruct, items: [Item]) {
        self = original
        self.items = items
    }
}

class CardPartCollectionViewCardController: CardPartsViewController {
    
    @IBOutlet var coordinateView: UIView!
    
    //let cardPartTextView = CardPartTextView(type: .normal)
    lazy var collectionViewCardPart = CardPartCollectionView(collectionViewLayout: self.collectionViewLayout)
    
    var collectionViewLayout: UICollectionViewFlowLayout = {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 20
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 300, height: 200)
        return layout
    }()
    let viewModel = CardPartCollectionViewModel()
    
    func reload(){
        self.viewDidLoad()
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        collectionViewLayout.itemSize = CGSize(width: coordinateView.frame.width-120, height:coordinateView.frame.height*0.35)
        //coordinateView.frame.height-coordinateView.frame.width - 120
        
        //cardPartTextView.text = "This is a CardPartCollectionView"
        
        
        collectionViewCardPart.collectionView.register(MyCustomCollectionViewCell.self, forCellWithReuseIdentifier: "MyCustomCollectionViewCell")
        collectionViewCardPart.collectionView.backgroundColor = .white
        collectionViewCardPart.collectionView.showsHorizontalScrollIndicator = false
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionOfCustomStruct>(configureCell: { (_, collectionView, indexPath, data) -> UICollectionViewCell in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCustomCollectionViewCell", for: indexPath) as? MyCustomCollectionViewCell else { return UICollectionViewCell() }
            
            cell.setData(data)
            
            cell.backgroundColor = UIColor.lightGray
            cell.layer.cornerRadius = 40
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor(red: 0.93, green: 0.93, blue: 0.95, alpha: 1.0).cgColor
            cell.backgroundColor = UIColor(red: 69/255, green: 130/255, blue: 247/255, alpha: 1)
            
            
            return cell
        })
        
        viewModel.data.asObservable().bind(to: collectionViewCardPart.collectionView.rx.items(dataSource: dataSource)).disposed(by: bag)
        
        //collectionViewCardPart.collectionView.frame = CGRect(x: 0, y: 0, width: coordinateView.frame.width, height: coordinateView.frame.height)
        //cardPartTextView.removeConstraints(cardPartTextView.constraints)
        collectionViewCardPart.collectionView.frame = coordinateView.frame
        coordinateView.addSubview(collectionViewCardPart)
        collectionViewCardPart.translatesAutoresizingMaskIntoConstraints = false
        
        let attributes: [NSLayoutConstraint.Attribute] = [.top, .bottom, .leading, .trailing]
        NSLayoutConstraint.activate(attributes.map {
            NSLayoutConstraint(item: collectionViewCardPart, attribute: $0, relatedBy: .equal, toItem: collectionViewCardPart.superview, attribute: $0, multiplier: 1, constant: 0)
        })
        
        
        // setupCardParts([cardPartTextView, collectionViewCardPart])
    }
}

class CardPartCollectionViewModel {
    
    typealias ReactiveSection = BehaviorRelay<[SectionOfCustomStruct]>
    var data = ReactiveSection(value: [])
    
    let emojis: [String] = ["😎", "🤪", "🤩", "👻", "🤟🏽", "💋", "💃🏽"]
    
    init() {
        
        var temp: [MyStruct] = []
//
//        let like = MyStruct(title: "Like", description: "23")
//        let follow = MyStruct(title: "Follow", description: "24")
//        let studyScore = MyStruct(title: "Study Hour", description: "1.6 h")
//        let totalRate = MyStruct(title: "Total Rate", description: "84")
//        let rank = MyStruct(title: "Rank", description: "1/24")
//        let studySuccessfullTime = MyStruct(title: "Successfull Times", description: "20")
//        temp.append(like)
//        temp.append(follow)
//        temp.append(studyScore)
//        temp.append(totalRate)
//        temp.append(rank)
//        temp.append(studySuccessfullTime)
        temp = connector.fetchProfileData()
//        for i in 0...10 {
//
//            temp.append(MyStruct(title: "Level", description: "fsdfklasjfklsfjklsfjslkfjsklfjsklfjsdlkfjklsfjksdlfjksldfjksldjfksljfksl"))
//        }
        
        data.accept([SectionOfCustomStruct(header: "", items: temp)])
    }
}

class MyCustomCollectionViewCell: CardPartCollectionViewCardPartsCell {
    let bag = DisposeBag()
    
    let titleCP = CardPartTextView(type: .title)
    let descriptionCP = CardPartTextView(type: .normal)
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        
        titleCP.margins = .init(top: 20, left: 0, bottom: 0, right: 0)
        descriptionCP.margins = .init(top: 60, left: 50, bottom: 0, right: 50)
        // descriptionCP.margins = .init(top: 0, left: 0, bottom: 0, right: 0)
        setupCardParts([titleCP, descriptionCP])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(_ data: MyStruct) {
        
        titleCP.text = data.title
        titleCP.textAlignment = .center
        titleCP.textColor = .white
        titleCP.font = .systemFont(ofSize: 20, weight: .regular)
        
        descriptionCP.text = data.description
        descriptionCP.font = .systemFont(ofSize: 50, weight: .bold)
        descriptionCP.textAlignment = .center
        descriptionCP.verticalAlignment = .center
        descriptionCP.textColor = .white
    }
}


