//
//  LogoutViewController.swift
//  Timing Me
//
//  Created by Abraham Rubio on 5/29/18.
//  Copyright © 2018 Abraham Rubio. All rights reserved.
//

import UIKit

class LogoutViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func logoutButton(_ sender: Any) {
        self.performSegue(withIdentifier: "bioTouchMain", sender: nil)
    }
    
    
}
