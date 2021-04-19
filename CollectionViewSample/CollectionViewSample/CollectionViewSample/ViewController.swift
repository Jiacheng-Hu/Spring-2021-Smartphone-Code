//
//  ViewController.swift
//  CollectionViewSample
//
//  Created by 胡嘉诚 on 2021/4/19.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    var arr = [UIImage(named: "Beauty"),
               UIImage(named: "Beverages"),
               UIImage(named: "Breakfast"),
               UIImage(named: "Cooking"),
               UIImage(named: "Dairy"),
               UIImage(named: "Deserts"),
               UIImage(named: "Fruits"),
               UIImage(named: "Household"),
               UIImage(named: "Jams"),
               UIImage(named: "Mixes"),
               UIImage(named: "Snacks"),
               UIImage(named: "Vegetables"),
               
    ]

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCollectionViewCell
        cell.imgCell.image = arr[indexPath.row]
        return cell
    }

}

