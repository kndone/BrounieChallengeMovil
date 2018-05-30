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
        let contexto = LAContext()
        var error: NSError?
        
        if contexto.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "¡Por favor identificate!"
            
            contexto.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [unowned self] success, authenticationError in
                
                DispatchQueue.main.async {
                    if success {
                        self.performSegue(withIdentifier: "scanner", sender: nil)
                    } else {
                        let ac = UIAlertController(title: "La autenticación ha fallado", message: "¡Opps!", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(ac, animated: true)
                    }
                }
            }
        } else {
            let ac = UIAlertController(title: "El Touch ID no está disponible", message: "Tu dispositivo no está configurado con Touch ID.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    func mostrarAlertaExito(_ message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
        
    }
    
}
