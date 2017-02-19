//
//  ViewController.swift
//  ScientificCalculator
//
//  Created by Maria Bartoszuk on 14/02/2017.
//  Copyright © 2017 Maria Bartoszuk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var labelDisplay: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    var userHasStartedTyping = false
    
    @IBAction func digitPressed(_ sender: UIButton) {
        
        let digit = sender.currentTitle!
        print("digit pressed = \(digit)")
        if userHasStartedTyping {
            labelDisplay.text = labelDisplay.text! + "\(digit)"
        } else {
            labelDisplay.text = digit
            userHasStartedTyping = true
        }
    }
    
    @IBAction func operation(_ sender: UIButton) {
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

