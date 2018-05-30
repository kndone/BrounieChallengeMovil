//
//  BioTouchViewController.swift
//  Timing Me
//
//  Created by Abraham Rubio on 5/29/18.
//  Copyright © 2018 Abraham Rubio. All rights reserved.
//

import UIKit
import LocalAuthentication

class BioTouchViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func authWithTouchID(_ sender: Any) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // 3
            let reason = "Authenticate with Touch ID"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply:
                {(succes, error) in
                    // 4
                    if succes {
                        self.showAlertController("Touch ID Authentication Succeeded")
                    }
                    else {
                        self.showAlertController("Touch ID Authentication Failed")
                    }
                    } as! (Bool, Error?) -> Void)
        }
            // 5
        else {
            showAlertController("Touch ID not available")
        }
    }
    func showAlertController(_ message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
}
