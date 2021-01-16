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
    
    var backCardViews: [UIView?] = []
    var faceCardViews: [UIView?] = []
    
    var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pairs.shuffle()
        used_pairs = pairs
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = pairs.count * 2
        pairschain = repeatElement("0", count: count).map( { String($0) })
        backCardViews = repeatElement(nil, count: count).map({ $0 })
        faceCardViews = repeatElement(nil, count: count).map({ $0 })
        return count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Card", for: indexPath) as! CardCellView
        
        guard var pair = used_pairs.randomElement() else {
            fatalError("random dropped nil")
        }
        used_pairs.removeAll(where: { $0.capital == pair.capital })
        
        let labelView = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        labelView.textAlignment = .center
        
        if pair.status == 0 {
            // cell.label.text = pair.capital
            labelView.text = pair.capital
            // we need save same value to check correct
            pairschain[indexPath.item] = pair.capital //country
        } else {
            labelView.text = pair.country
            //cell.label.text = pair.country
            pairschain[indexPath.item] = pair.capital
        }
        pair.status += 1
        
        labelView.isHidden = true
        faceCardViews.insert(labelView, at: indexPath.item)
        
        
        if pair.status != 2 {
            used_pairs.append(pair)
        }
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        imageView.image = UIImage(named: "card")
        imageView.backgroundColor = UIColor.gray
        
        backCardViews.insert(imageView, at: indexPath.item)
        
        //faceCardView.addSubview(imageView)
        //cell.addSubview(faceCardView)
        
        cell.addSubview(imageView)
        
        cell.addSubview(labelView)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.item
        
        let cell = collectionView.cellForItem(at: indexPath) as! CardCellView
        
        self.flip(index: index)
        
        if currentlySelectedItem == nil {
            currentlySelectedItem = index
            // animate here
            
            /*
            let seceondView = UIView()  // UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
            seceondView.backgroundColor = UIColor.red
            secondView.isHidden = true
            */
            //flip(firstView: self.firstView, secondView: self.secondView)
            return
        }
        
        
        if pairschain[indexPath.item] == pairschain[currentlySelectedItem!] {
            print("You're right!")
        } else {
            print("No!")
        }
        currentlySelectedItem = nil
        
        
    }

    
    @objc func flip (index: Int) {
        let transitionOptions: UIView.AnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]

        UIView.transition(from: self.backCardViews[index]!, to: self.faceCardViews[index]!, duration: 1.0, options: transitionOptions, completion: nil)
        
       /* UIView.transition(with: self.backCardViews[self.index]!, duration: 1.0, options: transitionOptions, animations: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.backCardViews[self.index]!.isHidden = true
            }
        }) */

        /*
         
        UIView.transition(with: self.faceCardViews[self.index]!, duration: 1.0, options: transitionOptions, animations: {
            self.faceCardViews[self.index]!.isHidden = false
        })
         */
        
        /*
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            UIView.animate(withDuration: 1.0) {
                self.backCardViews[self.index]!.isHidden = true
            }
        } */
        
    }
}

