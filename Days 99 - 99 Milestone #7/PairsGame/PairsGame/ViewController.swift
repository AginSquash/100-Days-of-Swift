//
//  ViewController.swift
//  PairsGame
//
//  Created by Vlad Vrublevsky on 14.01.2021.
//

import UIKit

class ViewController: UICollectionViewController {
    var pairs: [Pair] = Pair.getExample()
    var used_pairs: [Pair] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        pairs.shuffle()
        used_pairs = pairs
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pairs.count * 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Card", for: indexPath) as! CardCellView
        
        guard var pair = used_pairs.randomElement() else {
            fatalError("random dropped nil")
        }
        used_pairs.removeAll(where: { $0.capital == pair.capital })
        
        if pair.status == 0 {
            cell.label.text = pair.capital
        } else {
            cell.label.text = pair.country
        }
        pair.status += 1
        
        if pair.status != 2 {
            used_pairs.append(pair)
        }
        
        return cell
    }

}

