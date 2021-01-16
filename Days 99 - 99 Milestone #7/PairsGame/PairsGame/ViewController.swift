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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        pairs.shuffle()
        used_pairs = pairs
    
        //faceCardView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))

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
        
        let labelView = UILabel(frame: CGRect(x: 25, y: 0, width: 120, height: 120))
        
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
        
        cell.addSubview(labelView)
        faceCardViews.insert(labelView, at: indexPath.item)
        
        if pair.status != 2 {
            used_pairs.append(pair)
        }
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        imageView.image = UIImage(named: "card")
        backCardViews.insert(imageView, at: indexPath.item)
        
        //faceCardView.addSubview(imageView)
        //cell.addSubview(faceCardView)
        
        cell.addSubview(imageView)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.item
        
        let cell = collectionView.cellForItem(at: indexPath) as! CardCellView
        
        
        //firstView = UIView(frame: CGRect(x: 0, y: 0, width: 128, height: 128))
       // secondView = UIView(frame: CGRect(x: 0, y: 0, width: 128, height: 128))

        //firstView.backgroundColor = UIColor.red
        //secondView.backgroundColor = UIColor.blue
        
        //secondView.isHidden = true
        
       // cell.addSubview(firstView)
        //cell.addSubview(secondView)
        
        UIView.animate(withDuration: 1) {
        //    self.flip(index: index)
        }
        perform(#selector(flip), with: [index], afterDelay: 0)
        
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

        UIView.transition(with: self.backCardViews[index]!, duration: 1.0, options: transitionOptions, animations: {
            self.backCardViews[index]!.isHidden = true
        })

        UIView.transition(with: self.faceCardViews[index]!, duration: 1.0, options: transitionOptions, animations: {
            self.faceCardViews[index]!.isHidden = false
        })
    }
}

