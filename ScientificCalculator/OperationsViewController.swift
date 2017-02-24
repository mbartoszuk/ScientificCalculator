//
//  OperationsViewController.swift
//  ScientificCalculator
//
//  Created by Maria Bartoszuk on 24/02/2017.
//  Copyright © 2017 Maria Bartoszuk. All rights reserved.
//

import UIKit

class OperationsViewController: UIViewController {
    
    var operations:[String]=[]
    @IBOutlet weak var labelOperations: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        labelOperations.text = self.operations.joined(separator: " ")
    }
    
    // Clears all the data from the local copy of the operations and from the label.
    @IBAction func clearAllData(_ sender: UIButton) {
        operations.removeAll()
        labelOperations.text = ""
        
        // Saves the local copy of the operations to the database.
        let defaults = UserDefaults.standard
        print("Saving operations: \(operations)")
        defaults.set(self.operations, forKey: "operationsData")
    }
    
    // Updates the operations data from this view (after clearing) with the other view.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let operationsViewController = segue.destination as! ViewController
        operationsViewController.operations = self.operations
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
