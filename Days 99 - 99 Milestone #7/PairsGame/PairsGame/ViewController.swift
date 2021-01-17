//
//  ViewController.swift
//  PairsGame
//
//  Created by Vlad Vrublevsky on 14.01.2021.
//

import UIKit

class ViewController: UICollectionViewController {
    var pairs: [Pair] = [] {
        didSet {
            self.used_pairs = pairs
        }
    }
    var used_pairs: [Pair] = []
    
    var pairschain: [String] = []
    var currentlySelectedCard: Int?
    var answeredCards: [Int] = []
    
    var backCardViews: [UIView?] = []
    var faceCardViews: [UIView?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "PairsGame"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(pushToSelectPairsView))
        
        let pathToFile = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Pairs")
        if let loaded = try? Data(contentsOf: pathToFile) {
            if let decoded = try? JSONDecoder().decode([Pair].self, from: loaded) {
                if decoded.count != 0 {
                    self.pairs = decoded.shuffled()
                    self.collectionView.reloadData()
                    return
                }
            }
        } else {
            let pairs = Pair.getExample().shuffled()
            self.pairs = pairs
            self.collectionView.reloadData()
            if let encoded = try? JSONEncoder().encode(pairs) {
                try? encoded.write(to: pathToFile)
                print("Saved first time")
            }
        }
            
        
        
    }
    
    @objc func pushToSelectPairsView() {
        guard let selectViewController = self.storyboard?.instantiateViewController(withIdentifier: "SelectPairsViewController") as? SelectPairsViewController else {
            fatalError("Cannot find SelectPairsViewController")
        }
        selectViewController.secureAlreadyExistPairs = self.pairs
        selectViewController.onCompletion = updatePairs
        self.navigationController?.pushViewController(selectViewController, animated: true)
    }

    func updatePairs(_ pairs: [Pair]) -> Void {
        self.pairs = pairs.shuffled()
        self.collectionView.reloadData()
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
        
        /// check if we already solve this card
        guard !answeredCards.contains(index) else { return }
        
        /// showing first card
        guard let currentlySelectedCard = currentlySelectedCard else {
            self.currentlySelectedCard = index
            flipToFace(index: index)
            return
        }
        
        /// if selected same card - just flip this
        if currentlySelectedCard == index {
            flipToBack(index: index)
            self.currentlySelectedCard = nil
            return
        }
        
        /// showing second card
        flipToFace(index: index)
        
        if pairschain[indexPath.item] == pairschain[currentlySelectedCard] {
            print("You're right!")
            self.answeredCards.append(currentlySelectedCard)
            self.answeredCards.append(index)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                
                let transitionOptions: UIView.AnimationOptions = [.allowAnimatedContent, .transitionFlipFromTop]
                UIView.transition(with: self.faceCardViews[currentlySelectedCard]!, duration: 1.0, options: transitionOptions) {
                    self.faceCardViews[currentlySelectedCard]!.alpha = 0
                }
                UIView.transition(with: self.faceCardViews[index]!, duration: 1.0, options: transitionOptions) {
                    self.faceCardViews[index]!.alpha = 0
                }
            }
            
            checkEndGame()
            
        } else {
            print("No!")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.flipToBack(index: currentlySelectedCard)
                self.flipToBack(index: index)
            }
        }
        self.currentlySelectedCard = nil
    }
    
    func checkEndGame() {
        if answeredCards.count == pairs.count * 2 {
            let ac = UIAlertController(title: "You won!", message: "You found all the matches", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
        }
    }
    
    func flipToFace(index: Int) {
        let transitionOptions: UIView.AnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]

        UIView.transition(from: self.backCardViews[index]!, to: self.faceCardViews[index]!, duration: 1.0, options: transitionOptions, completion: nil)
    }
    
    func flipToBack(index: Int) {
        let transitionOptions: UIView.AnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]

        UIView.transition(from: self.faceCardViews[index]!, to: self.backCardViews[index]!, duration: 1.0, options: transitionOptions, completion: nil)
    }
}

