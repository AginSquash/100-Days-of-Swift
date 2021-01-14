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
    
    
    var pairschain: [String] = []
    var currentlySelectedItem: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        pairs.shuffle()
        used_pairs = pairs
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = pairs.count * 2
        pairschain = repeatElement("0", count: count).map( { String($0) })
        return count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Card", for: indexPath) as! CardCellView
        
        guard var pair = used_pairs.randomElement() else {
            fatalError("random dropped nil")
        }
        used_pairs.removeAll(where: { $0.capital == pair.capital })
        
        if pair.status == 0 {
            cell.label.text = pair.capital
            pairschain[indexPath.item] = pair.country
        } else {
            cell.label.text = pair.country
            pairschain[indexPath.item] = pair.capital
        }
        pair.status += 1
        
        if pair.status != 2 {
            used_pairs.append(pair)
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("user selected: \(indexPath.item)")
        let index = indexPath.item
        
        if currentlySelectedItem == nil {
            currentlySelectedItem = index
            print(pairschain[index])
            // animate here
            return
        }
        
        let cell = collectionView.cellForItem(at: indexPath) as! CardCellView
        if cell.label.text == pairschain[currentlySelectedItem!] {
            print("You're right!")
        } else {
            print("No!")
        }
        print(pairschain[index])
        currentlySelectedItem = nil
    }

}

