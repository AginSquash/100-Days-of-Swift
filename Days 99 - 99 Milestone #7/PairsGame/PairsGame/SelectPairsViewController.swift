//
//  SelectPairsViewController.swift
//  PairsGame
//
//  Created by Vlad Vrublevsky on 17.01.2021.
//

import UIKit
import LocalAuthentication

class SelectPairsViewController: UITableViewController {

    var isUnlocked: Bool = false
    var secureAlreadyExistPairs: [Pair] = []
    var onCompletion: (([Pair])->Void)? = nil
    
    private var unlockedExistPairs: [Pair] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        title = "Locked!"
        //navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPair))
        
        auth()
    }
    
    @objc func auth() {
        let context = LAContext()
        var error: NSError? = nil
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] (success, error) in
                
                DispatchQueue.main.async {
                    if success {
                        self?.unlock()
                        print("auth succefull")
                    } else {
                        let ac = UIAlertController(title: "Error!", message: error?.localizedDescription, preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self?.present(ac, animated: true, completion: nil)
                    }
                }
            }
        } else {
            let ac = UIAlertController(title: "Biometry unavailable", message: "Your device is not configured for biometric authentication.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
    }

    private func unlock() {
        isUnlocked = true
        title = "Unlocked"
        unlockedExistPairs = secureAlreadyExistPairs
        tableView.reloadData()
    }
    
    @objc func addNewPair() {
        guard isUnlocked else {
            let ac = UIAlertController(title: "Error", message: "Authorize first", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
            return
        }
        
        let ac = UIAlertController(title: "Enter new pair", message: nil, preferredStyle: .alert)
        ac.addTextField(configurationHandler: nil)
        ac.addTextField(configurationHandler: nil)
        
        let AddButton = UIAlertAction(title: "Add", style: .default) { [weak self, weak ac] _ in
            guard let element0 = ac?.textFields?[0].text else { return }
            guard let element1 = ac?.textFields?[1].text else { return }
            
            guard !element0.isEmpty else { print("Field 0 empety"); return }
            guard !element1.isEmpty else { print("Field 1 empety"); return }
            
            let newPair = Pair(element1: element0, element2: element1)
            self?.unlockedExistPairs.append(newPair)
            self?.tableView.reloadData()
        }
        
        ac.addAction(AddButton)
        present(ac, animated: true, completion: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        print("Save here!")
        
        if self.unlockedExistPairs == self.secureAlreadyExistPairs {
            print("No changes here")
            return
        }
        
        (self.onCompletion ?? { _ in })(self.unlockedExistPairs)
        
        if let encoded = try? JSONEncoder().encode(self.unlockedExistPairs) {
            let pathToFile = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Pairs")
            try? encoded.write(to: pathToFile)
        }
        
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return unlockedExistPairs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SelectPairsCell", for: indexPath) as? SelectPairsCell else {
            fatalError("Cannot load SelectPairsCell")
        }

        cell.element1.text = unlockedExistPairs[indexPath.item].element1
        cell.element2.text = unlockedExistPairs[indexPath.item].element2
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.item
        
        let name = "\(unlockedExistPairs[index].element1) : \(unlockedExistPairs[index].element2)"
        let ac = UIAlertController(title: "Delete", message: "Do you want to delete \(name)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self, index] _ in
            self?.unlockedExistPairs.remove(at: index)
            self?.tableView.reloadData()
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        present(ac, animated: true, completion: nil)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
